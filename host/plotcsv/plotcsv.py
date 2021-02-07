from __future__ import print_function
import sys
import datetime
import logging
import numpy as np
from StringIO import StringIO

DEF_VERSION = '1.2.2.7-dev'     # x.y.z.* to match RASDRviewer version
DEF_DELIM   = ','
DEF_AVERAGE = 1
DEF_CALIB   = 0.0           # Paul uses (0.73278^2)/2000 as Qstep^2/ADC impedance
DEF_DT_VAR  = 0.1           # percentage of avg frame time to trap 'SKIPPED' frames

# support for statistics gathering/output
DEF_STATS_FORMAT=['%.6f','%.3f','%.4f','%.4f','%.4f','%.6f','%.6f',]
DEF_STATS_DELIM=','
DEF_STATS_HEADER='timestamp,deltaT (sec),minimum,maximum,average,standard-deviation,variance'

# http://stackoverflow.com/questions/16867347/step-by-step-debugging-with-ipython
# https://github.com/ipython/ipython/wiki/Cookbook%3a-Updating-code-for-use-with-IPython-0.11-and-later
def ipsh():
    from IPython.frontend.terminal.embed import InteractiveShellEmbed
    from IPython.config.loader import Config
    import inspect
    ipshell = InteractiveShellEmbed(config=Config(), 
        banner1='*** STOP\nCTRL-D to exit', exit_msg='Resume...')
    frame = inspect.currentframe().f_back
    msg   = 'Stopped at {0.f_code.co_filename} at line {0.f_lineno}'.format(frame)
    # Go back one level! 
    # This is needed because the call to ipshell is inside the function ipsh()
    ipshell(msg,stack_depth=2)

def excel2dt(et):
    # http://stackoverflow.com/questions/1703505/excel-date-to-unix-timestamp
    # http://stackoverflow.com/questions/3682748/converting-unix-timestamp-string-to-readable-date-in-python
    ts = (et - 25569)*86400 # 25569 is days since 1900-01-01
    ts = ts + (4*60*60)     # timezone EST5EDT return
    return datetime.datetime.fromtimestamp(float(ts))

def dt2excel(dt,tz=None):
    import pytz
    # http://stackoverflow.com/questions/9574793/how-to-convert-a-python-datetime-datetime-to-excel-serial-date-number
    # http://stackoverflow.com/questions/4530069/python-how-to-get-a-value-of-datetime-today-that-is-timezone-aware
    dte = datetime.datetime(1899, 12, 30, tzinfo=pytz.timezone(tz)) if tz else datetime.datetime(1899, 12, 29)
    delta = dt - dte    # set w/r/t excel2dt() date; NB: do not know why this must be set 3 days earlier
    return float(delta.days) + (float(delta.seconds) / 86400)

def translate_tz(tz):
    # Paul uses some wierd strings in RASDRviewer to represent timezones
    # FIXME: I am still unhappy with this...  But I need this to make the plots we took in June-July 2014
    tzo=''
    if tz.startswith('UT20'):
        tzo='-0500'
        tz=tz.replace('UT20','UTC')
    elif tz.startswith('US/Eastern'):
        tzo='-0500'
        tz=tz.replace('US/Eastern','UTC')
    elif not tz.startswith('UTC'):  # FIXME: weak...
        tz=tz.replace('UT','UTC')
    return tz, tzo

def open_spectrum_file(filename,opts):
    obj = {}
    if opts.localtime:
        # this is Paul's "Localtime" .csv format
        # http://stackoverflow.com/questions/13311471/skip-a-specified-number-of-columns-with-numpy-genfromtxt
        # http://stackoverflow.com/questions/466345/converting-string-into-datetime
        # http://stackoverflow.com/questions/698223/how-can-i-parse-a-time-string-containing-milliseconds-in-it-with-python

        f=open(filename,'r')
        key=np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='str')
        if len(np.atleast_1d(key)) < 2:
            raise Exception('unable to parse %s -- check first line'%filename)
        ds=key[4].replace('"','') if len(key) > 4 else '00/00/00'
        tz=key[6].replace('"','') if len(key) > 7 else 'UTC'
        # translate strange labels from RASDRviewer_W_1_0_5
        tz=translate_tz(tz)
        dumplines = 1
        fscale = 1.0
        ## RASDRviewer 1.2.2, Paul "adds" a line with a ',' in it - just kill it
        ## RASDRviewer 1.2.2.1, we negotiate that this line will be '*** BEGIN DATA COLLECTION ***'
        if opts.format.startswith('1.2.2'):
            dumplines = dumplines + 1
            tag = f.readline()
        ## RASDRViewer 1.1.1, Paul "adds" a specifier to the 2nd line and moves the rest of the lines down
        if opts.format.startswith('1.1.') or opts.format.startswith('1.2.'):
            dumplines = dumplines + 1
            key=np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='str')
            if len(np.atleast_1d(key)) < 2:
                tag = str(key).lower()
            else:
                tag = str(key[0]).lower()
            if tag.find('hz')>0:
                if tag.startswith('khz'):
                    fscale = 0.001
                elif tag.startswith('ghz'):
                    fscale = 1000.0
        ## second/third/fourth line: frequency bin information
        dumplines = dumplines + 1
        freq=np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='float')
        if len(np.atleast_1d(freq)) < 2:
            raise Exception('unable to parse %s -- check frequency plan'%filename)
        freq=freq[1:]           # remove the 1st column, as it is a 'nan' when interpreted as a 'float'
        ## third/fourth/fifth line-to-end: extract first *column* as text
        t=np.genfromtxt(f,delimiter=opts.delimiter,usecols=[0],dtype='str')
        if len(np.atleast_1d(t)) < 2:                                                      # BUG: I need at least two data records
            raise Exception('unable to parse %s -- check data after frequency plan'%filename)
        time = []
        for i in range(1,len(np.atleast_1d(t))):
            # translate HH:MM:SS:ms into HH:MM:SS.ms
            if t[i].count(':') > 2:
                a,x,b = t[i].rpartition(':')
            else:
                a = t[i]
                b = '0'
            ts=a+'.'+b
            time.append(datetime.datetime.strptime(ds+'T'+ts, '%m/%d/%yT%H:%M:%S.%f'))
        f.seek(0)
        for i in range(dumplines):  # dump lines so we are at beginning of data collected
            f.readline()
        # update the object to return
        obj['file'] = f
        obj['freq'] = freq
        obj['time'] = time
        obj['opts'] = opts
##    elif opts.datetime:
##        # this is the "Excel-datetime" .csv format (proposed for RASDRviewer_W_1_0_4, but not implemented)
##        f=open(filename,'r')
##        freq = np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='float')
##        t=np.genfromtxt(f,delimiter=opts.delimiter,usecols=[0],dtype='float')
##        time = []
##        for i in range(len(t)):
##            time.append(excel2dt(t[i]))
##        f.seek(0)               # start over
##        f.readline()            # dump the first line
##        f.readline()            # dump the second line
##        # update the object to return
##        obj['file'] = f
##        obj['freq'] = freq
##        obj['time'] = time
##        obj['opts'] = opts
    else:
        # this is the "Extended" .csv format produced by RASDRviewer_W_1_2_1
        from dateutil import parser

        f=open(filename,'r')
        ## first line: key-value pairs
        buf = f.readline()
        key=np.genfromtxt(StringIO(buf.replace('\\','/')),delimiter=opts.delimiter,dtype='str',comments='\\')
        if len(np.atleast_1d(key)) < 2:
            raise Exception('unable to parse %s -- check first line'%filename)
        ds=key[4].replace('"','') if len(key) > 4 else '00/00/00'
        tz=key[6].replace('"','') if len(key) > 7 else 'UTC'
        # translate strange labels from RASDRviewer_W_1_0_5
        tz,tzo=translate_tz(tz)
        dumplines = 1
        fscale = 1.0
        ## RASDRviewer 1.2.2, Paul "adds" a line with a ',' in it - just kill it
        ## RASDRviewer 1.2.2.1, we negotiate that this line will be '*** BEGIN DATA COLLECTION ***'
        if opts.format.startswith('1.2.2'):
            dumplines = dumplines + 1
            f.readline()
        ## RASDRViewer 1.1.1, Paul "adds" a specifier to the 2nd line and moves the rest of the lines down
        if opts.format.startswith('1.1.') or opts.format.startswith('1.2.'):
            dumplines = dumplines + 1
            key=np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='str')
            if len(np.atleast_1d(key)) < 2:
                tag = str(key).lower()
            else:
                tag = str(key[0]).lower()
            if tag.find('hz')>0:
                if tag.startswith('khz'):
                    fscale = 0.001
                elif tag.startswith('ghz'):
                    fscale = 1000.0
        ## second/third/fourth line: frequency bin information
        dumplines = dumplines + 1
        freq=np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,dtype='float')
        if len(np.atleast_1d(freq)) < 2:
            raise Exception('unable to parse %s -- check frequency plan'%filename)
        freq=freq[1:]           # remove the 1st column, as it is a 'nan' when interpreted as a 'float'
        ## third/fourth/fifth line-to-end: extract first *column* as text
        t=np.genfromtxt(f,delimiter=opts.delimiter,usecols=[0],dtype='str')                # 1st column are *almost* ISO-8601 datetime strings
        if len(np.atleast_1d(t)) < 2:                                                      # BUG: I need at least two data records
            raise Exception('unable to parse %s -- check data after frequency plan'%filename)
        time = []
        for i in range(1,len(np.atleast_1d(t))):
            try:
                time.append(parser.parse(t[i]))
            except ValueError:
                a,x,b = t[i].rpartition(':')  # deal with Paul's 'YYYY-MM-DDTHH:MM:SS:sssZ' format in RASDRviewer_W_1_0_5
                if a.find('T')>0:
                    time.append(parser.parse(a+'.'+b+tzo))
                else:
                    time.append(parser.parse(ds+'T'+a+'.'+b+tzo))
        f.seek(0)
        for i in range(dumplines):  # dump lines so we are at beginning of data collected
            f.readline()
        # update the object to return
        obj['file'] = f
        obj['freq'] = freq*fscale
        obj['time'] = time
        obj['opts'] = opts
    
    if opts.verbose:
        log = logging.getLogger(__name__)
        x,y,name = f.name.replace('\\','/').rpartition('/')
        log.info('%s.date=%s (%s)'%(name,ds+' '+str(tz),str(obj['time'][0])))
        log.info('%s.time=%d'%(name,len(obj['time'])))
        log.info('%s.freq=%s (scale=%f)'%(name,str(obj['freq'].shape),fscale))
    return obj

def read_spectrum_line(obj):
    opts = obj['opts']
    f    = obj['file']
##    if opts.datetime:
##        data = np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter)
##        data = data[1:]
##    else:
    freq = obj['freq']
    data = np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,usecols=range(1,freq.shape[0]+1),dtype='float')
    return data         # spectral information in colums 1..N-2 (last column is junk)

def read_spectrum_array(obj):
    opts = obj['opts']
    f    = obj['file']
##    if opts.datetime:
##        data = np.genfromtxt(f,delimiter=opts.delimiter)
##        data = data[1:,1:]
##    else:
    freq = obj['freq']
    try:
        plumb = f.tell()
        data = np.genfromtxt(f,delimiter=opts.delimiter,usecols=range(1,freq.shape[0]+1),dtype='float')
    except ValueError, e:
        # oops, malformed file may contain 'garbage' lines at the end...
        log = logging.getLogger(__name__)
        log.warning('Malformed file that may contain extra lines at the end.  Recovering...')
        f.seek(plumb)
##        if opts.debug:
##            ipsh()
        data = np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,usecols=range(1,freq.shape[0]+1),dtype='float')
        for i in range(len(obj['time'])-1):
            data = np.vstack((data,np.genfromtxt(StringIO(f.readline()),delimiter=opts.delimiter,usecols=range(1,freq.shape[0]+1),dtype='float')))
    return data         # spectral information in colums 1..N-2 (last column is junk)

def generate_spectrum_plots(filename,opts):
    log = logging.getLogger(__name__)
    if len(opts.background) > 0:
        if opts.background.lower() == 'automatic':
            bg = open_spectrum_file(filename,opts)
        else:
            bg = open_spectrum_file(opts.background,opts)
        lastrow = len(bg['time'])-1
        bkg = np.zeros(len(bg['freq']))
        acc = np.zeros(len(bg['freq']))
        n   = 0
        log.info('loading %s...'%bg['file'].name)
        if not opts.line:
            s = read_spectrum_array(bg)
        for fr in range(len(bg['time'])):
            n = n+1
            if opts.line:
                s = read_spectrum_line(bg)
                log.debug('bg %d/%d mean=%f dB'%(fr,len(bg['time']),s.mean()))
                if opts.atype.lower().startswith('linear'):
                    acc += np.power(10,s/10)
                else:
                    acc += s
            else:
                if opts.atype.lower().startswith('linear'):
                    acc += np.power(10,s[fr]/10)
                else:
                    acc += s[fr]
        bkg += acc / float(n)
        log.info('background %d samples=[%f,%f] mean=%f',n,bkg.min(),bkg.max(),bkg.mean())
        if opts.background.lower() == 'automatic':
            # distribute mean value of to all frequency bins to construct a total average over all samples
            # this is needed if doing a 'self' background correction
            bkg = np.ones(len(bg['freq'])) * bkg.mean()
        if not opts.line:
            del s
        fg = open_spectrum_file(filename,opts)
        if not len(fg['freq'])==len(bg['freq']):
            raise Exception('background file must have same number of frequency bins as the foreground file')
        if not np.array_equal(fg['freq'],bg['freq']):
            log.warn('background file does not specify the same frequency bins as the foreground file')
        del bg
    else:
        fg = open_spectrum_file(filename,opts)
        bkg = np.zeros(len(fg['freq']))

    ts_a = fg['time']
    fMHz = fg['freq']+opts.fc
    zidx = np.searchsorted(fMHz,0)
    nbin = len(fMHz)
    lastrow = len(ts_a)-1
    bw   = (fMHz.max() - fMHz.min())*1e6/nbin
    if opts.calibration > 0.0:
        dbm = 10.0 * np.log10( opts.calibration * bw * 0.001 )  # power referenced to 1mW
        if opts.atype.lower().startswith('linear'):
            dbm = np.power(10,dbm/10)
    else:
        dbm = 0.0

    log.info('range (MHz)=[%f,%f]',fMHz.min(),fMHz.max())
    log.info('zero index=%d',zidx)
    log.info('frequency bins=%d',nbin)
    log.info('bandwidth/bin (Hz)=%f',bw)
    if lastrow > 0:
        delta = ts_a[lastrow] - ts_a[lastrow-1]
        log.info('start=%s',str(ts_a[0]))
        log.info('end  =%s',str(ts_a[lastrow]))
        s = (float(delta.seconds)+(float(delta.microseconds)/1e6))
        if s > 0.0:
            if s < 10.0:
                log.info('inter-frame period=%.3f sec (%.0f fr/s)',s,1.0/float(s))
            else:
                log.info('inter-frame period=%.3f sec (%.3f fr/s)',s,1.0/float(s))

    log.info('averaging=%s',str(opts.average))

    if not opts.line:
        log.info('loading %s...',fg['file'].name)
        s_a = read_spectrum_array(fg)
    acc = np.zeros(nbin)
    hold = np.zeros(nbin)
    n   = 0
    for fr in range(len(ts_a)):
        dt = ts_a[fr]
        if opts.line:
            s = read_spectrum_line(fg)
        else:
            s = s_a[fr]
        if opts.atype.lower().startswith('linear'):
            s = np.power(10,s/10)
        s = s - bkg
        if opts.canceldc:
            log.debug('Cancel DC: frq %s',str(fMHz[zidx-4:zidx+5]))
            log.debug('Cancel DC: b4 %s',str(s[zidx-4:zidx+5]))
            a = (s[zidx-1] + s[zidx+1])/2.0
            if a < s[zidx]:
                s[zidx] = a
            log.debug('Cancel DC: ftr %s',str(s[zidx-4:zidx+5]))
        log.debug('line %d/%d max@%d val=%f',fr,len(ts_a),s.argmax(),s.max())
        if opts.hold:
            hold = np.maximum(s,hold)
        if n == 0:
            tstart = dt.strftime('%Y-%m-%dT%H:%M:%S%z')
        n    = n+1
        acc += s
        if n >= opts.average or fr == lastrow:
            s   = acc / float(n)    # vector/scalar
            s   = s - dbm           # vector-scalar

            ###
            ### Scaling and determination of min/max range
            ###
            offsets_applied = ''
            if opts.ptype.lower().startswith('linear'):
                if opts.atype.lower().startswith('log'):
                    s = np.power(10,s/10)
                std = np.std(s)
                if std < s.mean()/100.0:
                    log.warning('-> signal stdev<1%% mean; applying offset of %g to scale linear plot on screen',s.mean())
                    s = s - s.mean()
                    offsets_applied += ',%+g signal'%-s.mean()
                min = s.mean() - std*4
                max = s.mean() + std*4
                log.debug('-> plot mean=%f, stdev=%g, min=%f max=%f',s.mean(),std,min,max)
                if opts.hold:
                    std = np.std(hold)
                    if std < hold.mean()/100.0:
                        log.warning('-> hold stdev<1%% mean; applying offset of %g to scale linear plot on screen',hold.mean())
                        hold = hold - hold.mean()
                        offsets_applied += ',-%g hold'%hold.mean()
                    hmin = hold.mean() - std*4
                    hmax = hold.mean() + std*4
                    log.debug('-> hold mean=%f, stdev=%g, min=%f max=%f',hold.mean(),std,hmin,hmax)
                    min = hmin if hmin < min else min
                    max = hmax if hmax > max else max
            else:
                if opts.atype.lower().startswith('linear'):
                    delta = 0.0
                    if s.min() <= 0.0:
                        delta = 0.0 - s.min()
                        log.warning('-> applying fixed offset of %g to prevent logarithm underflow',delta)
                        s += delta
                        offsets_applied += ',%+g signal'%delta
                    s = 10 * np.log10(s)
                    if delta > 0.0:
                        # it is possible that we generated some -inf values, so raise them (see np.select())
                        # NB: -323dB was empirically determined to be the limit before -inf
                        DB_LIMIT = -323.0
                        condlist = [s<DB_LIMIT,s>=DB_LIMIT]
                        choicelist = [np.ones(len(s))*DB_LIMIT,s]
                        s = np.select(condlist,choicelist)
                        offsets_applied += ',%.0f dB limit'%DB_LIMIT
                    log.debug('-> s[] median=%f, mean=%f, stdev=%g, min=%f max=%f',s[s.argsort()[len(s)/2]],s.mean(),np.std(s),s.min(),s.max())
                std = np.std(s)
                if std == 0.0:
                    log.warning('-> signal stdev is 0dB; did you subtract the signal from itself?')
                    median = s[s.argsort()[len(s)/2]]
                    min = median - 1.0
                    max = median + 1.0
                elif std < 1.0:
                    log.warning('-> signal stdev<1.0 dB; scaling signal plot about the mean value (%g)',s.mean())
                    min = s.mean() - std*4
                    max = s.mean() + std*4
                else:
                    min = np.floor(s.min())-1.0
                    max = np.ceil(s.max())+1.0
                log.debug('-> plot mean=%f, stdev=%g, min=%f max=%f',s.mean(),std,min,max)
                if opts.hold:
                    std = np.std(hold)
                    if std == 0.0:
                        log.warning('-> hold stdev is 0dB; did you subtract the signal from itself?')
                        median = hold[hold.argsort()[len(hold)/2]]
                        hmin = median - 1.0
                        hmax = median + 1.0
                    elif std < 1.0:
                        log.warning('-> hold stdev<1.0 dB; scaling hold plot about the mean value (%g)',hold.mean())
                        hmin = hold.mean() - std*4
                        hmax = hold.mean() + std*4
                    else:
                        hmin = np.floor(hold.min())-1.0
                        hmax = np.ceil(hold.max())+1.0
                    log.debug('-> hold mean=%f, stdev=%g, min=%f max=%f',hold.mean(),std,hmin,hmax)
                    min = hmin if hmin < min else min
                    max = hmax if hmax > max else max
            log.debug('-> plot scale min=%g max=%g',min,max)

            ###
            ### Determination of Graph Title and Annotations
            ###
            tstop = dt.strftime('%Y-%m-%dT%H:%M:%S%z')
            if n > 1:
                title = 'Collected between %s and %s\n'%(tstart,tstop)
                if opts.atype.lower().startswith('linear'):
                    title += 'Linear averaged'
                else:
                    title += 'Logarithm averaged'
                title += ' over %d frames'%n
            else:
                title = 'Collected at %s'%tstart
            if len(opts.background) > 0:
                title = title + ', with background subtraction'
            if opts.background.lower() == 'automatic':
                m = bkg.mean()
                if opts.atype.lower().startswith('linear'):
                    if m <= 0.0:
                        title = title + ' (automatic, zero mean)'
                    else:
                        m = 10 * np.log10(m)
                        title = title + ' (automatic, %.2f dB)'%m
                else:
                    title = title + ' (automatic, %.2f dB)'%m
            else:
                title = title + ' (file)'
            if opts.calibration:
                title = title + ', cal=%.1f'%opts.calibration
            if opts.smooth > 0:
                title = title + ' and %d point smoothing'%opts.smooth
                ll = len(s)
                hh = opts.smooth/2
                ss = np.zeros(ll)
                for xx in range(hh):
                    ss[xx]      = s[xx]
                    ss[ll-xx-1] = s[ll-xx-1]
                for xx in range(ll-opts.smooth+1):
                    ss[hh+xx] = np.mean(s[xx:xx+opts.smooth])
                s = ss
                if opts.hold:
                    ll = len(hold)
                    hh = opts.smooth/2
                    ss = np.zeros(ll)
                    for xx in range(hh):
                        ss[xx]      = hold[xx]
                        ss[ll-xx-1] = hold[ll-xx-1]
                    for xx in range(ll-opts.smooth+1):
                        ss[hh+xx] = np.mean(hold[xx:xx+opts.smooth])
                    hold = ss

            # http://stackoverflow.com/questions/6352740/matplotlib-label-each-bin
            from matplotlib.pyplot import figure, plot, axis, xlabel, ylabel, savefig, subplots
            from matplotlib.pyplot import title as _title
            from matplotlib.ticker import FormatStrFormatter

            fig, ax = subplots()
            plot(fMHz,s,hold=True,color='b',label='foreground')
            if opts.hold:
                plot(fMHz,hold,hold=True,color='g',label='hold')
            axis([fMHz[0],fMHz[nbin-1],min,max])
            ax.xaxis.set_major_formatter(FormatStrFormatter('%4.1f'))
            xlabel('frequency (MHz)')
            txt = 'spectral power'
            if dbm != 0.0:
                if opts.ptype.lower().startswith('linear'):
                    txt += ' (amplitude relative to 1dBm/Hz)'
                else:
                    txt += ' (dBm/Hz)'
            elif len(opts.background) > 0:
                if opts.ptype.lower().startswith('linear'):
                    txt += ' (amplitude relative to background)'
                else:
                    txt += ' (dB relative to background)'
                if opts.bplot and not opts.background.lower() == 'automatic':
                    # when doing an 'automatic', we used a mean value, so there isnt any point in plotting a straight line
                    plot(fMHz,bkg,color='r',hold=True,label='background')
            else:
                txt += ' (arbitrary unit)'
            txt += offsets_applied
            ylabel(txt)
            _title(title)

            name = 'spectrum-%s.png'%dt.strftime('%Y_%b_%d_%H_%M_%S')
            savefig(name)
            log.info('Saved '+name)

            acc = np.zeros(nbin)
            n   = 0
            del fig, ax

def dump_spectrum_info(filename,opts):
    log = logging.getLogger(__name__)
    fg = open_spectrum_file(filename,opts)
    ts_a = fg['time']
    fMHz = fg['freq']
    zidx = np.searchsorted(fMHz,0)
    nbin = len(fMHz)
    lastrow = len(ts_a)-1
    bw   = (fMHz.max() - fMHz.min())*1e6/nbin

    log.info('range (MHz)=[%f,%f]',fMHz.min(),fMHz.max())
    log.info('zero index=%d',zidx)
    log.info('frequency bins=%d',nbin)
    log.info('bandwidth/bin (Hz)=%f',bw)

    tstart = ts_a[0].strftime('%Y-%m-%dT%H:%M:%S')
    if lastrow > 0:
        delta = ts_a[lastrow] - ts_a[lastrow-1]
        log.info('start=%s',str(ts_a[0]))
        log.info('end  =%s',str(ts_a[lastrow]))
        deltaT = dt = float(delta.seconds)+(float(delta.microseconds)/1e6)
        if len(ts_a) > 0:
            deltaT = ts_a[lastrow] - ts_a[0]
            deltaT = float(deltaT.seconds)+(float(deltaT.microseconds)/1e6)
            deltaT = deltaT / len(ts_a)
        tstop  = ts_a[lastrow].strftime('%Y-%m-%dT%H:%M:%S')
        log.info('seconds between records=%f (avg=%f)',dt,deltaT)
        title  = 'Collected between %s and %s'%(tstart,tstop)
        deltaT = min(dt,deltaT)
    else:
        title  = 'Collected at %s'%tstart
        deltaT = 0.0

    log.info('Analyzing records...  acceptable inter-frame time is [%f,%f] sec',deltaT-(deltaT*DEF_DT_VAR),deltaT+(deltaT*DEF_DT_VAR))
    if opts.statistics:
        sts = np.zeros((len(ts_a),7)).astype(np.float)
        if not opts.line:
            s_a = read_spectrum_array(fg)
    dt  = np.zeros(len(ts_a)).astype(np.float)
    d0  = ts_a[0]
    dX  = 0.0
    for fr in range(len(ts_a)):
        if fr == 0:
            if opts.statistics:
                if opts.line:
                    s = read_spectrum_line(fg)
                else:
                    s = s_a[fr]
                # http://stackoverflow.com/questions/796008/cant-subtract-offset-naive-and-offset-aware-datetimes
                sts[fr,0] = dt2excel(ts_a[fr].replace(tzinfo=None))
                sts[fr,1] = 0.0
                sts[fr,2] = s.min()
                sts[fr,3] = s.max()
                sts[fr,4] = s.mean()
                sts[fr,5] = s.std()
                sts[fr,6] = s.var()
            dt[fr] = deltaT
            continue
        log.debug('  d0=%s ts_a[%d]=%s',str(d0),fr,str(ts_a[fr]))
        _dt0 = ts_a[fr] - d0
        dt[fr] = float(_dt0.seconds)+(float(_dt0.microseconds)/1e6)
        log.debug('    dt=%.6f abs(dt - deltaT)=%.6f',dt[fr],abs(dt[fr] - deltaT))
        if dt[fr] < 1e-6:
            log.info('*** DUPLICATE: frame %d -> %d delta %f sec, expected %f+/-%f (@%s)',fr-1,fr,dt[fr],deltaT,(deltaT*DEF_DT_VAR),d0.strftime('%Y-%m-%dT%H:%M:%S.%f'))
        elif ts_a[fr] < d0:
            log.info('*** REGRESSION: frame %d -> %d has earlier timestamp (%s) than (@%s)',fr-1,fr,ts_a[fr].strftime('%Y-%m-%dT%H:%M:%S.%f'),d0.strftime('%Y-%m-%dT%H:%M:%S.%f'))
        elif abs(dt[fr] - deltaT) > (deltaT*DEF_DT_VAR):
            log.info('*** SKIP: frame %d -> %d delta %f sec, expected %f+/-%f (@%s)',fr-1,fr,dt[fr],deltaT,(deltaT*DEF_DT_VAR),d0.strftime('%Y-%m-%dT%H:%M:%S.%f'))
            dX = dX + (dt[fr] - deltaT)
        d0 = ts_a[fr]
        if opts.statistics:
            if opts.line:
                s = read_spectrum_line(fg)
            else:
                s = s_a[fr]
            sts[fr,0] = dt2excel(ts_a[fr].replace(tzinfo=None))
            sts[fr,1] = dt[fr]
            sts[fr,2] = s.min()
            sts[fr,3] = s.max()
            sts[fr,4] = s.mean()
            sts[fr,5] = s.std()
            sts[fr,6] = s.var()
    if dX > 0.0:
        d0 = ts_a[0]
        dN = ts_a[-1]
        _dt0 = dN - d0
        capture_length = float(_dt0.seconds)+(float(_dt0.microseconds)/1e6)
        if capture_length > 0.0:
            log.info('*** %f sec unaccounted for in %f sec capture (%.3f%%)',dX,capture_length,(dX*100.0/capture_length))
        elif capture_length < 0.0:
            log.info('*** %f sec unaccounted for but total capture length appears to be less than 0.0 (%.3f sec)',dX,capture_length)
        else:
            log.info('*** %f sec unaccounted for but total capture length appears to be 0.0',dX)
    log.info('*** inter-frame min=%.3f,max=%.3f,mean=%.3f (sec)'%(dt.min(),dt.max(),dt.mean()))
    if opts.statistics:
        np.savetxt(opts.statistics,sts,fmt=DEF_STATS_FORMAT,delimiter=DEF_STATS_DELIM,header=DEF_STATS_HEADER,comments='')

# Refactored to make argument parsing separate so as to provide a GUI option
def execute(opts):
    args = opts.file

    logging.basicConfig(format='%(message)s',level=logging.DEBUG)
    if args==[]:
        logging.getLogger(__name__).critical('Please specify a filename. Run with the -h flag to see all options.')
    else:
        # logging boilerplate (screen+log file)
        logger = logging.getLogger(__name__)
        x,y,name = args[0].replace('\\','/').rpartition('/')
        name,x,ext = name.rpartition('.')
        handler = logging.FileHandler(name+'.log')
        formatter = logging.Formatter('%(levelname)s:%(message)s')
        handler.setFormatter(formatter)
        logger.addHandler(handler)
        logger.setLevel(logging.DEBUG if opts.verbose else logging.INFO)
        try:
            if opts.gui:
                from platform import system
                if not opts.matplotlib_use and system().startswith('Windows'):
                    from matplotlib import use
                    use('wxagg')
                    opts.matplotlib_use = True
            if opts.info:
                dump_spectrum_info(args[0],opts)
            else:
                generate_spectrum_plots(args[0],opts)
            if opts.gui:
                from pylab import show
                print('=== Display interactive graphs ===')
                show()
        except Exception, e:
            logger.error('generate_spectrum_plots', exc_info=True)
            exit(1)

if __name__ == '__main__':
    import argparse
    p = argparse.ArgumentParser(
        description='Post-Process RASDRviewer/RASDRproc spectrum data output files')
    p.add_argument(      "--version", action='version', version='%(prog)s '+DEF_VERSION)
    g = p.add_mutually_exclusive_group()
    g.add_argument("-v", "--verbose", default=False, help="Turn on verbose output", action="store_true")
    g.add_argument("-q", "--quiet", default=False, help='Suppress progress messages', action="store_true")
    # call matplotlib.use() only once
    p.set_defaults(matplotlib_use = False)
    p.add_argument('-a', '--average', type=int, metavar='N', default=DEF_AVERAGE,
        help='Specify the number of spectra to average for each plot')
    p.add_argument('-b', '--background', type=str, metavar='PATH', default='',
        help='Specify how to perform background subtraction;'+
             'if the word automatic is used, then the background will be taken'+
             'from the average of all lines in the file.  Otherwise, it is taken'+
             'as a file to process.  The file must have the same frequency plan as the foreground file.')
    p.add_argument('-c', '--cancel-dc', dest='canceldc', action='store_true', default=False,
        help='Cancel out component at frequency bin for 0Hz')
    p.add_argument('-d', '--delimiter', type=str, metavar='CHAR', default=DEF_DELIM,
        help='Specify the delimiter character to use"')
    p.add_argument('-e', '--localtime', action='store_true', default=False,
        help='Indicate that .csv file has timestamps in RASDRviewer\'s "LocalTime" format')
    p.add_argument('-k', '--calibration', type=float, metavar='CONST', default=DEF_CALIB,
        help='Specify the calibration constant for the system; 0.0=uncal')    #default=%f'%DEF_CALIB)
    p.add_argument('-l', '--line', action='store_true', default=False,
        help='Perform line-by-line processing instead of loading entire file(s); NOTE: much slower but tolerates low memory better.')
##    p.add_argument('-m', '--milliwatt', dest='dbm', action='store_true', default=False,
##        help='Plot in decibels referenced to 1mW (dBm/Hz)')
##    p.add_argument('-t', '--datetime', action='store_true', default=False,
##        help='Indicate that timestamps in the .csv file are in Excel\'s datetime format')
    p.add_argument('-i', '--info', action='store_true', default=False,
        help='Produce information about a file only; do not generate any plots')
    p.add_argument('--statistics', type=str, metavar='PATH', default=None,
        help='Dump statistical information to a file in comma-separated-values format')
    p.add_argument('--debug', action='store_true', default=False,
        help='Drop into ipython shell at predefined point(s) to debug the script')
    p.add_argument('-g', '--gui', action='store_true', default=False,
        help='Create interactive PLOTS')
    p.add_argument('-s', '--smooth', type=int, metavar='N', default=0,
        help='Smooth final plot using a sliding window of N points')
    p.add_argument('--fcenter', dest='fc', type=float, default=0.0,
        help='Define the offset for the center frequency in Hz')  #default=%f'%0.0)
    p.add_argument('--hold', action='store_true', default=False,
        help='Perform a maximum value HOLD during averaging and plot it as a second line')
    p.add_argument('--bplot', action='store_true', default=False,
        help='If using background file, choose whether to plot the background reference in a difffert color')
    p.add_argument('--ptype', type=str, metavar='TYPE', default='log',
        help='Control plot vertical scale (linear or log)')
    p.add_argument('--atype', type=str, metavar='TYPE', default='log',
        help='Control averaging method (linear or log)')
        # http://www.dtic.mil/dtic/tr/fulltext/u2/657404.pdf
    ## for handling RASDRviewer versions
    v = DEF_VERSION.split('.')
    ver = v[0]+'.'+v[1]+'.'+v[2]
    p.add_argument('--format', type=str, metavar='X.Y.Z', default=ver,
        help='Specify the RASDRviewer .csv output format to interpret')
    # http://stackoverflow.com/questions/20165843/argparse-how-to-handle-variable-number-of-arguments-nargs
    p.add_argument(      "file", nargs='*')

    opts = p.parse_args(sys.argv[1:])
    execute(opts)
