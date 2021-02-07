#pragma once
#include "CyAPI.h"
#include <dbt.h>
#include <stdio.h>
#undef MessageBox

#define SOFTWAREVERSION     "0.2.2.3"
#define MAX_QUEUE_SZ        512
#define ATTEMPT_TO_REINIT   1

namespace Streams
{
    using namespace System;
    using namespace System::ComponentModel;
    using namespace System::Collections;
    using namespace System::Windows::Forms;
    using namespace System::Data;
    using namespace System::Drawing;
    using namespace System::Threading;
    using namespace System::Diagnostics;
    using namespace System::Reflection;
    using namespace System::Collections::Concurrent;

    struct _buffers {
        // Allocate the arrays needed for queueing
        PUCHAR			*buffers;
        CCyIsoPktInfo	**isoPktInfos;
        PUCHAR			*contexts;
        OVERLAPPED		inOvLap[MAX_QUEUE_SZ];
    };

    public __gc class Form1 : public System::Windows::Forms::Form
    {	

    private: System::Windows::Forms::TextBox *  TimeOutBox;
    private: System::Windows::Forms::CheckBox *  ShowDataBox;


    private: System::Windows::Forms::Label *  label1;
    private: System::Windows::Forms::Label *  label2;
    private: System::Windows::Forms::ComboBox *  SamplesPerFrameBox;
    private: System::Windows::Forms::Label *  label4;
    private: System::Windows::Forms::Label *  label5;
    private: System::Windows::Forms::Button *  StartBtn;
    private: System::Windows::Forms::ComboBox *  EndPointsBox;

    private: System::Windows::Forms::ComboBox *  SampleRateBox;
    private: System::Windows::Forms::TextBox *  DataTextBox;
    private: System::Windows::Forms::Label *  RateLabel;
    private: System::Windows::Forms::ProgressBar *  RateProgressBar;
    private: System::Windows::Forms::TextBox *  SuccessesBox;
    private: System::Windows::Forms::TextBox *  FailuresBox;
    private: System::Windows::Forms::Label *  SuccessLabel;
    private: System::Windows::Forms::GroupBox *  RateGroupBox;
    private: System::Windows::Forms::Label*  label15;
    private: System::Windows::Forms::ComboBox*  DeviceComboBox;






    private: System::Windows::Forms::Label *  FailureLabel;

    private: System::Windows::Forms::Timer* displayTimer;

#ifdef ATTEMPT_TO_REINIT
    private: System::Windows::Forms::Timer* reInitTimer;
#endif

    public:	

        Form1(void)
        {
            InitializeComponent();

            USBDevice           = NULL;
            _EndPtAddr          = (UCHAR)255;

            bPnP_Arrival		= false;
            bPnP_Removal		= false;
            bPnP_DevNodeChange	= false;
            bAppQuiting         = false;
            bDeviceRefreshNeeded = false;

            qDisplay = new ConcurrentQueue<System::String*>();
            displayTimer = new System::Windows::Forms::Timer;
            displayTimer->Tick += new System::EventHandler(this, &Streams::Form1::DisplayEventProcessor);
            displayTimer->Interval = 250;   // 250ms latency
            displayTimer->Start();

            Successes = 0;
            Failures = 0;
            pFile = NULL;

#ifdef ATTEMPT_TO_REINIT
            hRestartReq = CreateEvent(NULL, true, false, NULL);        // manual-reset, non-signalled
            hRestartAck = CreateEvent(NULL, true, true, NULL);         // manual-reset, signalled
            hRestartMod = CreateEvent(NULL, true, false, NULL);        // manual-reset, non-signalled
            reInitCount = 0;
            reInitExit  = false;
            reInitTimer = new System::Windows::Forms::Timer;
            reInitTimer->Tick += new System::EventHandler(this, &Streams::Form1::TimerEventProcessor);
#endif
        }


    /* *** BEWARE: if you change the form via the UI designer
       *** this next section can get re-written.  In my experience,
       *** I added the vertical scrollbar option, and the tool
       *** switched to managed heap, started using gcnew everywhere
       *** and caused a build failure.
       ***
       *** http://stackoverflow.com/questions/202459/what-is-gcnew
    */ 
    private:

        System::ComponentModel::IContainer *  components;

        void InitializeComponent(void)
        {
            System::ComponentModel::ComponentResourceManager*  resources = (new System::ComponentModel::ComponentResourceManager(__typeof(Form1)));
            this->EndPointsBox = (new System::Windows::Forms::ComboBox());
            this->label1 = (new System::Windows::Forms::Label());
            this->label2 = (new System::Windows::Forms::Label());
            this->SamplesPerFrameBox = (new System::Windows::Forms::ComboBox());
            this->label4 = (new System::Windows::Forms::Label());
            this->TimeOutBox = (new System::Windows::Forms::TextBox());
            this->label5 = (new System::Windows::Forms::Label());
            this->StartBtn = (new System::Windows::Forms::Button());
            this->DataTextBox = (new System::Windows::Forms::TextBox());
            this->ShowDataBox = (new System::Windows::Forms::CheckBox());
            this->RateGroupBox = (new System::Windows::Forms::GroupBox());
            this->RateLabel = (new System::Windows::Forms::Label());
            this->RateProgressBar = (new System::Windows::Forms::ProgressBar());
            this->SampleRateBox = (new System::Windows::Forms::ComboBox());
            this->SuccessesBox = (new System::Windows::Forms::TextBox());
            this->FailuresBox = (new System::Windows::Forms::TextBox());
            this->SuccessLabel = (new System::Windows::Forms::Label());
            this->FailureLabel = (new System::Windows::Forms::Label());
            this->label15 = (new System::Windows::Forms::Label());
            this->DeviceComboBox = (new System::Windows::Forms::ComboBox());
            this->RateGroupBox->SuspendLayout();
            this->SuspendLayout();
            // 
            // EndPointsBox
            // 
            this->EndPointsBox->DropDownStyle = System::Windows::Forms::ComboBoxStyle::DropDownList;
            this->EndPointsBox->Location = System::Drawing::Point(136, 53);
            this->EndPointsBox->MaxDropDownItems = 16;
            this->EndPointsBox->Name = S"EndPointsBox";
            this->EndPointsBox->Size = System::Drawing::Size(270, 21);
            this->EndPointsBox->Sorted = true;
            this->EndPointsBox->TabIndex = 3;
            this->EndPointsBox->SelectionChangeCommitted += new System::EventHandler(this, &Form1::EndPointsBox_SelectedIndexChanged);
            // 
            // label1
            // 
            this->label1->Location = System::Drawing::Point(17, 58);
            this->label1->Name = S"label1";
            this->label1->Size = System::Drawing::Size(100, 16);
            this->label1->TabIndex = 2;
            this->label1->Text = S"Endpoint . . . . . ";
            this->label1->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // label2
            // 
            this->label2->Location = System::Drawing::Point(17, 91);
            this->label2->Name = S"label2";
            this->label2->Size = System::Drawing::Size(100, 16);
            this->label2->TabIndex = 4;
            this->label2->Text = S"Samples/Frame";
            this->label2->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // SamplesPerFrameBox
            // 
            this->SamplesPerFrameBox->DropDownStyle = System::Windows::Forms::ComboBoxStyle::DropDownList;
            System::Object* __mcTemp__1[] = new System::Object*[11];
            __mcTemp__1[0] = S"16";
            __mcTemp__1[1] = S"32";
            __mcTemp__1[2] = S"64";
            __mcTemp__1[3] = S"128";
            __mcTemp__1[4] = S"256";
            __mcTemp__1[5] = S"512";
            __mcTemp__1[6] = S"1024";
            __mcTemp__1[7] = S"2048";
            __mcTemp__1[8] = S"4096";
            __mcTemp__1[9] = S"8192";
            __mcTemp__1[10] = S"16384";
            this->SamplesPerFrameBox->Items->AddRange(__mcTemp__1);
            this->SamplesPerFrameBox->Location = System::Drawing::Point(136, 86);
            this->SamplesPerFrameBox->Name = S"SamplesPerFrameBox";
            this->SamplesPerFrameBox->Size = System::Drawing::Size(76, 21);
            this->SamplesPerFrameBox->TabIndex = 7;
            // 
            // label4
            // 
            this->label4->Location = System::Drawing::Point(17, 123);
            this->label4->Name = S"label4";
            this->label4->Size = System::Drawing::Size(88, 16);
            this->label4->TabIndex = 6;
            this->label4->Text = S"Rate (MHz)";
            this->label4->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // TimeOutBox
            // 
            this->TimeOutBox->Location = System::Drawing::Point(136, 154);
            this->TimeOutBox->Name = S"TimeOutBox";
            this->TimeOutBox->Size = System::Drawing::Size(76, 20);
            this->TimeOutBox->TabIndex = 9;
            this->TimeOutBox->Text = S"";
            this->TimeOutBox->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
            // 
            // label5
            // 
            this->label5->Location = System::Drawing::Point(17, 154);
            this->label5->Name = S"label5";
            this->label5->Size = System::Drawing::Size(115, 16);
            this->label5->TabIndex = 8;
            this->label5->Text = S"Integration Time (ms)";
            this->label5->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // StartBtn
            // 
            this->StartBtn->BackColor = System::Drawing::Color::Aquamarine;
            this->StartBtn->Location = System::Drawing::Point(226, 149);
            this->StartBtn->Name = S"StartBtn";
            this->StartBtn->Size = System::Drawing::Size(180, 28);
            this->StartBtn->TabIndex = 10;
            this->StartBtn->Text = S"Start";
            this->StartBtn->UseVisualStyleBackColor = false;
            this->StartBtn->Click += new System::EventHandler(this, &Form1::StartBtn_Click);
            // 
            // DataTextBox
            // 
            this->DataTextBox->Font = (new System::Drawing::Font(S"Courier New", 8.25F, System::Drawing::FontStyle::Regular, System::Drawing::GraphicsUnit::Point, 
                (System::Byte)0));
            this->DataTextBox->Location = System::Drawing::Point(17, 295);
            this->DataTextBox->Multiline = true;
            this->DataTextBox->Name = S"DataTextBox";
            this->DataTextBox->ScrollBars = System::Windows::Forms::ScrollBars::Vertical;
            this->DataTextBox->Size = System::Drawing::Size(389, 112);
            this->DataTextBox->TabIndex = 18;
            this->DataTextBox->TabStop = false;
            // 
            // ShowDataBox
            // 
            this->ShowDataBox->Location = System::Drawing::Point(17, 271);
            this->ShowDataBox->Name = S"ShowDataBox";
            this->ShowDataBox->Size = System::Drawing::Size(389, 16);
            this->ShowDataBox->TabIndex = 17;
			this->ShowDataBox->Text = S"Save RAW Data [always RASDRstreamer(#nnn).raw) in same folder]";
            // 
            // RateGroupBox
            // 
            this->RateGroupBox->Controls->Add(this->RateLabel);
            this->RateGroupBox->Controls->Add(this->RateProgressBar);
            this->RateGroupBox->Location = System::Drawing::Point(17, 182);
            this->RateGroupBox->Name = S"RateGroupBox";
            this->RateGroupBox->Size = System::Drawing::Size(389, 72);
            this->RateGroupBox->TabIndex = 15;
            this->RateGroupBox->TabStop = false;
            this->RateGroupBox->Text = S" Transfer Rate (KiB/s) ";
            // 
            // RateLabel
            // 
            this->RateLabel->Font = (new System::Drawing::Font(S"Microsoft Sans Serif", 8.25F, System::Drawing::FontStyle::Bold, System::Drawing::GraphicsUnit::Point, 
                (System::Byte)0));
            this->RateLabel->Location = System::Drawing::Point(155, 48);
            this->RateLabel->Name = S"RateLabel";
            this->RateLabel->Size = System::Drawing::Size(74, 16);
            this->RateLabel->TabIndex = 1;
            this->RateLabel->Text = S"0";
            this->RateLabel->TextAlign = System::Drawing::ContentAlignment::BottomCenter;
            // 
            // RateProgressBar
            // 
            this->RateProgressBar->Location = System::Drawing::Point(18, 24);
            this->RateProgressBar->Maximum = 800000;
            this->RateProgressBar->Name = S"RateProgressBar";
            this->RateProgressBar->Size = System::Drawing::Size(350, 16);
            this->RateProgressBar->TabIndex = 0;
            this->RateProgressBar->BackColor = System::Drawing::Color::White;

            // 
            // SampleRateBox
            // 
            this->SampleRateBox->DropDownStyle = System::Windows::Forms::ComboBoxStyle::DropDownList;
            System::Object* __mcTemp__2[] = new System::Object*[32];
            __mcTemp__2[0] = S"1";
            __mcTemp__2[1] = S"2";
            __mcTemp__2[2] = S"3";
            __mcTemp__2[3] = S"4";
            __mcTemp__2[4] = S"5";
            __mcTemp__2[5] = S"6";
            __mcTemp__2[6] = S"7";
			__mcTemp__2[7] = S"8";
			__mcTemp__2[8] = S"9";
			__mcTemp__2[9] = S"10";
            __mcTemp__2[10] = S"11";
            __mcTemp__2[11] = S"12";
            __mcTemp__2[12] = S"13";
            __mcTemp__2[13] = S"14";
            __mcTemp__2[14] = S"15";
            __mcTemp__2[15] = S"16";
            __mcTemp__2[16] = S"17";
			__mcTemp__2[17] = S"18";
			__mcTemp__2[18] = S"19";
			__mcTemp__2[19] = S"20";
            __mcTemp__2[20] = S"21";
            __mcTemp__2[21] = S"22";
            __mcTemp__2[22] = S"23";
            __mcTemp__2[23] = S"24";
            __mcTemp__2[24] = S"25";
            __mcTemp__2[25] = S"26";
            __mcTemp__2[26] = S"27";
			__mcTemp__2[27] = S"28";
			__mcTemp__2[28] = S"29";
			__mcTemp__2[29] = S"30";
            __mcTemp__2[30] = S"31";
            __mcTemp__2[31] = S"32";
            this->SampleRateBox->Items->AddRange(__mcTemp__2);
            this->SampleRateBox->Location = System::Drawing::Point(136, 118);
            this->SampleRateBox->Name = S"SampleRateBox";
            this->SampleRateBox->Size = System::Drawing::Size(76, 21);
            this->SampleRateBox->TabIndex = 1;
            // 
            // SuccessesBox
            // 
            this->SuccessesBox->Location = System::Drawing::Point(298, 87);
            this->SuccessesBox->Name = S"SuccessesBox";
            this->SuccessesBox->Size = System::Drawing::Size(108, 20);
            this->SuccessesBox->TabIndex = 12;
            this->SuccessesBox->Text = S"0";
            this->SuccessesBox->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
            // 
            // FailuresBox
            // 
            this->FailuresBox->Location = System::Drawing::Point(298, 119);
            this->FailuresBox->Name = S"FailuresBox";
            this->FailuresBox->Size = System::Drawing::Size(108, 20);
            this->FailuresBox->TabIndex = 14;
            this->FailuresBox->Text = S"0";
            this->FailuresBox->TextAlign = System::Windows::Forms::HorizontalAlignment::Right;
            // 
            // SuccessLabel
            // 
            this->SuccessLabel->Location = System::Drawing::Point(223, 90);
            this->SuccessLabel->Name = S"SuccessLabel";
            this->SuccessLabel->Size = System::Drawing::Size(64, 16);
            this->SuccessLabel->TabIndex = 11;
            this->SuccessLabel->Text = S"Successes";
            this->SuccessLabel->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // FailureLabel
            // 
            this->FailureLabel->Location = System::Drawing::Point(223, 123);
            this->FailureLabel->Name = S"FailureLabel";
            this->FailureLabel->Size = System::Drawing::Size(64, 16);
            this->FailureLabel->TabIndex = 13;
            this->FailureLabel->Text = S"Failures";
            this->FailureLabel->TextAlign = System::Drawing::ContentAlignment::BottomLeft;
            // 
            // label15
            // 
            this->label15->AutoSize = true;
            this->label15->Location = System::Drawing::Point(17, 24);
            this->label15->Name = S"label15";
            this->label15->Size = System::Drawing::Size(101, 13);
            this->label15->TabIndex = 0;
            this->label15->Text = S"Connected Devices";
            // 
            // DeviceComboBox
            // 
            this->DeviceComboBox->DropDownStyle = System::Windows::Forms::ComboBoxStyle::DropDownList;
            this->DeviceComboBox->FormattingEnabled = true;
            this->DeviceComboBox->Location = System::Drawing::Point(136, 19);
            this->DeviceComboBox->Name = S"DeviceComboBox";
            this->DeviceComboBox->Size = System::Drawing::Size(270, 21);
            this->DeviceComboBox->TabIndex = 1;
            this->DeviceComboBox->SelectionChangeCommitted += new System::EventHandler(this, &Form1::DeviceComboBox_SelectedIndexChanged);
            // 
            // Form1
            // 
            this->AutoScaleBaseSize = System::Drawing::Size(5, 13);
            this->ClientSize = System::Drawing::Size(416, 426);
            this->Controls->Add(this->DeviceComboBox);
            this->Controls->Add(this->label15);
            this->Controls->Add(this->FailureLabel);
            this->Controls->Add(this->SuccessLabel);
            this->Controls->Add(this->FailuresBox);
            this->Controls->Add(this->SuccessesBox);
            this->Controls->Add(this->SampleRateBox);
            this->Controls->Add(this->RateGroupBox);
            this->Controls->Add(this->DataTextBox);
            this->Controls->Add(this->ShowDataBox);
            this->Controls->Add(this->StartBtn);
            this->Controls->Add(this->label5);
            this->Controls->Add(this->TimeOutBox);
            this->Controls->Add(this->label4);
            this->Controls->Add(this->SamplesPerFrameBox);
            this->Controls->Add(this->label2);
            this->Controls->Add(this->label1);
            this->Controls->Add(this->EndPointsBox);
            this->Icon = (__try_cast<System::Drawing::Icon*  >(resources->GetObject(S"$this.Icon")));
            this->Name = S"Form1";
            this->StartPosition = System::Windows::Forms::FormStartPosition::CenterScreen;
            this->Text = String::Concat(S"RASDRstreamer", " v", SOFTWAREVERSION);
#ifdef ATTEMPT_TO_REINIT
            this->Text = String::Concat(this->Text, " - ReInit @stall");
#endif
            this->Load += new System::EventHandler(this, &Form1::Form1_Load);
            this->Closed += new System::EventHandler(this, &Form1::Form1_Closed);
            this->RateGroupBox->ResumeLayout(false);
            this->ResumeLayout(false);
            this->PerformLayout();

        }	

        /* *** End of section that changed (see note above) */
     
        Thread						*XferThread;

        static CCyUSBDevice			*USBDevice;

        static const int			VENDOR_ID	= 0x1D50;
        static const int			PRODUCT_ID	= 0x6099; 

        // These declared static because accessed from the static XferLoop method
        // XferLoop is static because it is used as a separate thread.

        static UCHAR                _EndPtAddr;
        static int					PPX;
        static int					QueueSize;
        static int					TimeOut;
        static bool					bShowData;
        static bool					bStreaming;
        static bool                 bDeviceRefreshNeeded;   // TODO: this doesnt make too much sense...
        static bool                 bAppQuiting;
        static bool					bHighSpeedDevice;
        static bool					bSuperSpeedDevice;

        static ProgressBar			*XferRateBar;
        static Label				*XferRateLabel;
        static long				    XferRateExpected;
        static TextBox				*DataBox;
        static TextBox				*SuccessBox;
        static TextBox				*FailureBox;

        static ComboBox				*EptsBox;
        static ComboBox				*PpxBox;
        static ComboBox				*QueueBox;
        static Button				*StartButton;
        static TextBox				*TimeoutBox;
        static CheckBox				*ShowBox;
        static ComboBox             *DevCmboBox;

        bool						bPnP_Arrival;
        bool						bPnP_Removal;
        bool						bPnP_DevNodeChange;

        static ConcurrentQueue<System::String*> *qDisplay;

        static unsigned long        Successes;
        static unsigned long        Failures;
        // http://stackoverflow.com/questions/11563963/writing-a-binary-file-in-c-very-fast
        static FILE                 *pFile;    // good ol' FILE is still the fastest way cross-platform...

#ifdef ATTEMPT_TO_REINIT
        static HANDLE               hRestartReq;
        static HANDLE               hRestartAck;
        static HANDLE               hRestartMod;
        static int                  reInitCount;
        static bool                 reInitExit;

        void TimerEventProcessor(System::Object *  sender, System::EventArgs *  e)
        {
            reInitTimer->Stop();

            if (WaitForSingleObject(hRestartReq,0) == WAIT_OBJECT_0)
            {
                // Restarts the timer and increments the counter.
                reInitCount += 1;
                StartBtn_Click(sender,e);
            }
            reInitTimer->Enabled = true;
        }
#endif

        void GetStreamerDevice()
        {
            StartBtn->Enabled = false;  // TODO: No, no, no...

            EndPointsBox->Items->Clear();
            EndPointsBox->Text = "";

            // NOTE: release references to the device
            if (USBDevice != NULL) delete USBDevice;
            USBDevice = new CCyUSBDevice((HANDLE)this->Handle,CYUSBDRV_GUID,true);
            // NOTE: EndPt should be obtained by a call to EndPointsBox_SelectedIndexChanged()
            // which can only be made after we have constructed the list below.

            if (USBDevice == NULL) return;

            int n = USBDevice->DeviceCount();
            DeviceComboBox->Items->Clear();

            /////////////////////////////////////////////////////////////////
            // Walk through all devices looking for VENDOR_ID/PRODUCT_ID
            // Check for vendor ID and product ID is discontinued.
            ///////////////////////////////////////////////////////////////////
            for (int i=0; i<n; i++)
            {
                //if ((USBDevice->VendorID == VENDOR_ID) && (USBDevice->ProductID == PRODUCT_ID)) 
                //    break;
                USBDevice->Open(i);
                String *strDeviceData = "";
                strDeviceData = String::Concat(strDeviceData, "(0x");
                strDeviceData = String::Concat(strDeviceData, USBDevice->VendorID.ToString("X4"));
                strDeviceData = String::Concat(strDeviceData, " - 0x");
                strDeviceData = String::Concat(strDeviceData, USBDevice->ProductID.ToString("X4"));
                strDeviceData = String::Concat(strDeviceData, ") ");
                strDeviceData = String::Concat(strDeviceData, USBDevice->FriendlyName);
                
                DeviceComboBox->Items->Add(strDeviceData);      
                DeviceComboBox->Enabled = true;
            }
            if (n > 0 ) {
                DeviceComboBox->SelectedIndex = 0;
                USBDevice->Open(0);
            }


            //if ((USBDevice->VendorID == VENDOR_ID) && (USBDevice->ProductID == PRODUCT_ID)) 
            {
                StartBtn->Enabled = true;

                int interfaces = USBDevice->AltIntfcCount() + 1;

                bHighSpeedDevice = USBDevice->bHighSpeed;
                bSuperSpeedDevice = USBDevice->bSuperSpeed;

                for (int i=0; i< interfaces; i++)
                {
                    if (USBDevice->SetAltIntfc(i) == true)
                    {

                        int eptCnt = USBDevice->EndPointCount();

                        // Fill the EndPointsBox
                        for (int e=1; e<eptCnt; e++)
                        {
                            CCyUSBEndPoint *ept = USBDevice->EndPoints[e];
                            // INTR, BULK and ISO endpoints are supported.
                            if ((ept->Attributes >= 1) && (ept->Attributes <= 3))
                            {
                                String *s = "";
                                s = String::Concat(s, ((ept->Attributes == 1) ? "ISOC " :
                                       ((ept->Attributes == 2) ? "BULK " : "INTR ")));
                                s = String::Concat(s, ept->bIn ? "IN,       " : "OUT,   ");
                                s = String::Concat(s, ept->MaxPktSize.ToString(), " Bytes,");
                                if (USBDevice->BcdUSB == USB30MAJORVER)
                                    s = String::Concat(s, ept->ssmaxburst.ToString(), " MaxBurst,");

                                s = String::Concat(s, "   (", i.ToString(), " - ");
                                s = String::Concat(s, "0x", ept->Address.ToString("X02"), ")");
                                EndPointsBox->Items->Add(s);
                            }
                        }
                    }
                }
                if (EndPointsBox->Items->Count > 0 )
                    EndPointsBox->SelectedIndex = 0;
                else
                    StartBtn->Enabled = false;
            }
            // NOTE: EndPt could be obtained by a call to EndPointsBox_SelectedIndexChanged()
            // but the existing code deferred this choice until the user selected it or the
            // thread started and made the call itself.
            //
            // I've added a GetEndpoint() accessor to get the private EndPt, so we don't need
            // to call EndPointsBox_SelectedIndexChanged() to create the endpoint
        }



        void Form1_Load(System::Object *  sender, System::EventArgs *  e)
        {
            XferRateBar		= RateProgressBar;
            XferRateLabel	= RateLabel;
            DataBox			= DataTextBox;
            SuccessBox		= SuccessesBox;
            FailureBox		= FailuresBox;

            EptsBox			= EndPointsBox;
            PpxBox			= SamplesPerFrameBox;
            QueueBox		= SampleRateBox;
            StartButton		= StartBtn;
            TimeoutBox		= TimeOutBox;
            ShowBox			= ShowDataBox;
            DevCmboBox      = DeviceComboBox;
            bDeviceRefreshNeeded = false;

            if (SamplesPerFrameBox->SelectedIndex == -1 ) SamplesPerFrameBox->SelectedIndex = 7;
            if (SampleRateBox->SelectedIndex == -1 ) SampleRateBox->SelectedIndex = 1;

            GetStreamerDevice();

            XferThread = new Thread(new ThreadStart(0,&XferLoop));
        }


        void Form1_Closed(System::Object *  sender, System::EventArgs *  e)
        {
            //if (XferThread->ThreadState == System::Threading::ThreadState::Suspended)
            //XferThread->Resume();

            bAppQuiting = true;
            bStreaming = false;  // Stop the thread's xfer loop     
            bDeviceRefreshNeeded = false;

            if (XferThread->ThreadState == System::Threading::ThreadState::Running)
                XferThread->Join(10);

#ifdef ATTEMPT_TO_REINIT
            reInitTimer->Stop();
            reInitTimer->Enabled = false;
            if (pFile != NULL) fclose(pFile);
#endif

            displayTimer->Stop();
            displayTimer->Enabled = false;
        }


        void StartBtn_Click(System::Object *  sender, System::EventArgs *  e)
        {
            Decimal db;
            int ab;
            CCyUSBEndPoint *EndPt = NULL;
            DWORD wfso;

            if (XferThread) {
                switch (XferThread->ThreadState)
                {
                case System::Threading::ThreadState::Stopped:
                case System::Threading::ThreadState::Unstarted:

					if (!Decimal::TryParse(this->TimeOutBox->Text, &db))
					{
						::MessageBox(NULL, "Invalid Input : Integration Time (ms)", "RASDRstreamer", 0);
						this->TimeOutBox->Text = "";
						return;
					}
					if (!Int32::TryParse(this->TimeOutBox->Text, &ab))
					{
						::MessageBox(NULL, "Invalid Input : Integration Time (ms)", "RASDRstreamer", 0);
						this->TimeOutBox->Text = "";
						return;
					}

					PPX = 32;			// default, will override in EnforceValidPPX()
					QueueSize = 16;		// default

                    if (_EndPtAddr == 255) EndPointsBox_SelectedIndexChanged(NULL, NULL);   // call at least once
                    else                   EnforceValidPPX();                               // otherwise call this

                    StartBtn->Text = "Stop";
                    SuccessBox->Text = "";
                    FailureBox->Text = "";
                    StartBtn->BackColor = Color::MistyRose;
                    StartBtn->Refresh();

                    bStreaming = true;

                    // Start-over, initializing counters, etc.
                    if ((XferThread->ThreadState) == System::Threading::ThreadState::Stopped)
                        XferThread = new Thread(new ThreadStart(0,&XferLoop));

                    bShowData = ShowDataBox->Checked;

                    EndPointsBox->Enabled		= false;
                    SamplesPerFrameBox->Enabled	= false;
                    SampleRateBox->Enabled		= false;
                    TimeOutBox->Enabled			= false;
                    ShowDataBox->Enabled		= false;
                    DeviceComboBox->Enabled     = false;

#ifdef ATTEMPT_TO_REINIT
                    EndPt = GetEndpoint();
                    if (EndPt == NULL)
                    {
                        Display(String::Concat("@Start, No Endpoint - trying again",""));
                        // TODO: once in a while, restart will get a NULL response from GetEndpoint()
                        // inside the XferThread, causing it to abort and not restart.  There isnt
                        // a good reason for this as far as I can tell.  I don't want to keep patching
                        // this thing, but it seems reasonable if we are working around things anyway
                        // to give it another shot.
                        StartBtn->Text = "Cancel Restart";
                        StartBtn->Refresh();

                        // Just leave the Restart event signalled and not start the thread
                        reInitTimer->Interval = 5000;
                        reInitTimer->Start();
                        break;
                    }
                    wfso = WaitForSingleObject( hRestartMod, 0 ); // test hRestartMod
                    if (wfso == WAIT_OBJECT_0 )
                    {
                        // http://www.cypress.com/file/74566/download
                        // https://msdn.microsoft.com/en-us/library/windows/hardware/hh968307(v=vs.85).aspx
                        StartBtn->Text = "Restart Cancel";
                        StartBtn->Refresh();
                        bool bStatus = EndPt->Reset();
                        Display(String::Concat("@Start, EndPt->Reset()=",bStatus.ToString()));
                        if (!bStatus)
                        {
                            // this is what gave me the idea to do a Reset(), followed by a ReConnect()
                            // http://www.ibm.com/support/knowledgecenter/ssw_aix_71/com.ibm.aix.kernextc/USB_er_recov.htm
                            EndPt = NULL;
                            bStatus = USBDevice->Reset();
                            Display(String::Concat("@Start, USBDevice->Reset()=", bStatus.ToString()));
                            if (bStatus)
                            {
                                // success, maybe it works now?
                                StartBtn->Text = "Stop";
                            } else {
                                bStatus = USBDevice->ReConnect();
                                Display(String::Concat("@Start, USBDevice->ReConnect()=", bStatus.ToString()));
                                if (bStatus)
                                {
                                    // success, maybe it works now?
                                    StartBtn->Text = "Stop";
                                } else {
                                    Display(String::Concat("@Start, Reset Failed - Must Unplug USB", ""));
                                    ResetEvent(hRestartReq);
                                    reInitTimer->Enabled = false;
                                    StartBtn->Text = "Restart Failed";
                                    StartBtn->Refresh();
                                    StartBtn->Enabled = false;
                                    break;
                                    // this will stop trying
                                }
                            }
                        }
                        ResetEvent(hRestartMod);
                        // this will keep trying to start the XferThread()
                    }
                    ResetEvent(hRestartReq);
                    SetEvent(hRestartAck);
                    reInitTimer->Interval = 5000;
                    //reInitTimer->Enabled = true;
                    reInitTimer->Start();
#endif

                    XferThread->Start();
                    break;
                case System::Threading::ThreadState::Running:
                    StartBtn->Text = "Start";
                    StartBtn->BackColor = Color::Aquamarine;
                    StartBtn->Refresh();

#ifdef ATTEMPT_TO_REINIT
                    reInitTimer->Stop();
                    reInitTimer->Enabled = false;
#endif

                    bStreaming = false;  // Stop the thread's xfer loop
                    XferThread->Join(10);

                    EndPointsBox->Enabled		= true;
                    SamplesPerFrameBox->Enabled	= true;
                    SampleRateBox->Enabled		= true;
                    TimeOutBox->Enabled			= true;
                    ShowDataBox->Enabled		= true;
                    DeviceComboBox->Enabled     = true;

                    // TODO: this doesnt make too much sense...
                    if (bDeviceRefreshNeeded == true )
                    {
                        bDeviceRefreshNeeded = false;
                        GetStreamerDevice();                        
                    }

                    break;
                }

            } 

        }
        
        void DeviceComboBox_SelectedIndexChanged(System::Object *  sender, System::EventArgs *  e)
        {
            if (DeviceComboBox->SelectedIndex == -1 ) return;

            if (USBDevice->IsOpen() == true) USBDevice->Close();
            USBDevice->Open(DeviceComboBox->SelectedIndex);

            int interfaces = USBDevice->AltIntfcCount() + 1;

            bHighSpeedDevice = USBDevice->bHighSpeed;
            bSuperSpeedDevice = USBDevice->bSuperSpeed;

            EndPointsBox->Items->Clear();

            for (int i=0; i< interfaces; i++)
            {
                if (USBDevice->SetAltIntfc(i) == true )
                {

                    int eptCnt = USBDevice->EndPointCount();

                    // Fill the EndPointsBox
                    for (int e=1; e<eptCnt; e++)
                    {
                        CCyUSBEndPoint *ept = USBDevice->EndPoints[e];
                        // INTR, BULK and ISO endpoints are supported.
                        if ((ept->Attributes >= 1) && (ept->Attributes <= 3))
                        {
                            String *s = "";
                            s = String::Concat(s, ((ept->Attributes == 1) ? "ISOC " :
                                   ((ept->Attributes == 2) ? "BULK " : "INTR ")));
                            s = String::Concat(s, ept->bIn ? "IN,       " : "OUT,   ");
                            s = String::Concat(s, ept->MaxPktSize.ToString(), " Bytes,");
                            if(USBDevice->BcdUSB == USB30MAJORVER)
                                s = String::Concat(s, ept->ssmaxburst.ToString(), " MaxBurst,");

                            s = String::Concat(s, "   (", i.ToString(), " - ");
                            s = String::Concat(s, "0x", ept->Address.ToString("X02"), ")");
                            EndPointsBox->Items->Add(s);
                        }
                    }
                }
            }
            if (EndPointsBox->Items->Count > 0 )
            {
                EndPointsBox->SelectedIndex = 0;
                EndPointsBox_SelectedIndexChanged(NULL, NULL);
                StartBtn->Enabled = true;
            }
            else
                StartBtn->Enabled = false;
        }

        static CCyUSBEndPoint *GetEndpoint(void)
        {
            if (USBDevice == NULL) return NULL;
            return USBDevice->EndPointOf(_EndPtAddr);
        }

        void EndPointsBox_SelectedIndexChanged(System::Object *  sender, System::EventArgs *  e)
        {
            // Parse the alt setting and endpoint address from the EndPointsBox->Text
            String *tmp = EndPointsBox->Text->Substring(EndPointsBox->Text->IndexOf("("),10);
            int  alt = Convert::ToInt32(tmp->Substring(1,1));

            String *addr = tmp->Substring(7,2);
            //changed int to __int64 to avoid data loss
            __int64 eptAddr = HexToInt(addr);

            int clrAlt = (USBDevice->AltIntfc() == 0) ? 1 : 0;

            // Attempt to set the selected Alt setting and get the endpoint
            if (! USBDevice->SetAltIntfc(alt))
            {
                MessageBox::Show("Alt interface could not be selected.","USB Exception",MessageBoxButtons::OK,MessageBoxIcon::Hand);
                StartBtn->Enabled = false;
                USBDevice->SetAltIntfc(clrAlt); // Cleans-up
                return;
            }

            _EndPtAddr = (UCHAR)eptAddr;

            StartBtn->Enabled = true;   // TODO: this so doesnt belong here...

            if (GetEndpoint()->Attributes == 1)
            {
                SuccessLabel->Text = "Good Pkts";
                FailureLabel->Text = "Bad Pkts";
            }
            else
            {
                SuccessLabel->Text = "Successes";
                FailureLabel->Text = "Failures";
            }

            EnforceValidPPX();
        }


        void EnforceValidPPX()
        {
            CCyUSBEndPoint *EndPt = GetEndpoint();
            Decimal db;

            // Defaults
            if (SamplesPerFrameBox->SelectedIndex == -1 ) SamplesPerFrameBox->SelectedIndex = 7;
            if (SampleRateBox->SelectedIndex == -1 ) SampleRateBox->SelectedIndex = 1;
            if (!EndPt || EndPt->MaxPktSize == 0)
				return;

			int BPS = 2 * 2;												// bytes/sample
			int SPF = Convert::ToInt32(SamplesPerFrameBox->Text);			// samples/frame
			int SPS = Convert::ToInt32(SampleRateBox->Text) * 1000 * 1000;	// samples/sec
            int INTEG = 1;
            if (Decimal::TryParse(TimeOutBox->Text, &db)) INTEG = Convert::ToInt32(db); // ms of integration time
			int bytes_per_sec = (SPS * BPS);
			double bytes_per_transfer = double(bytes_per_sec) * double(INTEG) / 1000.0;
			int _ppx = int(bytes_per_transfer / double(EndPt->MaxPktSize));	// packets per transfer

			PPX = (_ppx >= 8) ? _ppx : 8;									// minimum is 8 packets/transfer
			if ((PPX % 8) != 0) {
				PPX -= (PPX % 8);
				PPX += 8;	// round-up
			}

            // Limit total transfer length to 4MByte
            int len = ((EndPt->MaxPktSize) * PPX);

            int maxLen = 0x400000;  //4MByte
            if (len > maxLen)
            {
                PPX = maxLen / (EndPt->MaxPktSize);
                if((PPX%8)!=0)
                    PPX -= (PPX%8);

				Display("4Mbyte chunks; limits integration time @rate");
            }

            if ((bSuperSpeedDevice || bHighSpeedDevice) && (EndPt->Attributes == 1))  // HS/SS ISOC Xfers must use PPX >= 8
            {
                if (PPX < 8)
                {
                    PPX = 8;
                    Display("ISOC xfers require at least 8 Packets per Xfer.");
                    Display("Packets per Xfer has been adjusted.");
                }

                PPX = (PPX / 8) * 8;

                if(bHighSpeedDevice)
                {
                    if(PPX >128)
                    {					
                        PPX = 128;
                        Display("High Speed ISOC xfers does not support more than 128 Packets per transfer");						
                    }
                }
            }

			String *tmp = "PPX=";
			double transfers_per_sec = double(bytes_per_sec) / double(PPX * EndPt->MaxPktSize);
			double sec_per_transfer = (transfers_per_sec > 0) ? 1.0 / transfers_per_sec : -1.0;
			double ms_per_transfer = sec_per_transfer * 1000.0;

			this->TimeOutBox->Text = ms_per_transfer.ToString("0");
			TimeOut = (ms_per_transfer > 0) ? int(ms_per_transfer * 2.0) : 1500;

			tmp = String::Concat(tmp, PPX.ToString(), "*");
            tmp = String::Concat(tmp, QueueSize.ToString(), ", rate=");
			Double rate = (Double)bytes_per_sec / (1024.0);		// convert to KiB/sec
			tmp = String::Concat(tmp, rate.ToString("0"), " KiB/s, timeout=");
			tmp = String::Concat(tmp, TimeOut.ToString("0"), " ms");
#ifdef ATTEMPT_TO_REINIT
            if (reInitCount>0) tmp = String::Concat(tmp, ", re=", reInitCount.ToString());
#endif
			Display(tmp);

			XferRateExpected = (long)rate;
            //SamplesPerFrameBox->Text = PPX.ToString();
        }


        static UInt64 HexToInt(String *hexString)
        {
            String *HexChars = "0123456789abcdef";

            String *s = hexString->ToLower();

            // Trim off the 0x prefix
            if (s->Length > 2)
                if (s->Substring(0,2)->Equals("0x"))
                    s = s->Substring(2,s->Length-2);


            String *_s = "";
            int len = s->Length;

            // Reverse the digits
            for (int i=len-1; i>=0; i--) _s  = String::Concat(_s,s->Substring(i,1));

            UInt64 sum = 0;
            UInt64 pwrF = 1;
            for (int i=0; i<len; i++)
            {
                UInt32 ordinal = (UInt32) HexChars->IndexOf(_s->Substring(i,1));
                sum += (i==0) ? ordinal : pwrF*ordinal;
                pwrF *= 16;
            }


            return sum;
        }

        static void Display(String *s)
        {
            qDisplay->Enqueue(String::Concat(s,""));
        }

        void DisplayEventProcessor(System::Object *  sender, System::EventArgs *  e)
        {
            String *s;
            displayTimer->Stop();
            while (qDisplay->TryDequeue(&s))
            {
                DataBox->Text = String::Concat(DataBox->Text, s, "\r\n");
                DataBox->SelectionStart = DataBox->Text->Length;
                DataBox->ScrollToCaret();
            }
            displayTimer->Enabled = true;
        }

        static void Display16Bytes(PUCHAR data)
        {
            String *xData = "";

            for (int i=0; i<16; i++) 
                xData = String::Concat(xData,data[i].ToString("X02"), " ");

            Display(xData);
        } 




        // This method executes in it's own thread.  The thread gets re-launched each time the
        // Start button is clicked (and the thread isn't already running).
        static void XferLoop()
        {
            long BytesXferred = 0;
            unsigned long FailuresSinceLastSuccess = 0;
#ifdef ATTEMPT_TO_REINIT
            unsigned long FailuresToInitiateRequeue = (unsigned long)3;
            bool bAttemptRestart = false;
#endif
            int i = 0;
            FILE *fp = pFile;

            // Allocate the arrays needed for queueing
            struct _buffers s;

            CCyUSBEndPoint *EndPt = GetEndpoint();

            if (EndPt == NULL || EndPt->MaxPktSize == 0)
            {
                Display("No Endpoint Configured");
                ExitXferLoop("Start");
                return;
            }

            long len = EndPt->MaxPktSize * PPX; // Each xfer request will get PPX isoc packets

#ifdef ATTEMPT_TO_REINIT
            DWORD wfso = WaitForSingleObject(hRestartAck,INFINITE);
            if (wfso != WAIT_OBJECT_0) return;
            ResetEvent(hRestartAck);
#endif
            EndPt->SetXferSize(len);
            CreateBuffers(s);

            DateTime t1 = DateTime::Now;	// For calculating xfer rate

            i = QueueXferLoop(QueueSize, s);
            if (i < QueueSize)
            {
                if(i>0) FlushXferLoop(i+1, s);
                DestroyBuffers(s);
                // This fault did not appear to be recoverable in tests...
                wfso = WaitForSingleObject(hRestartReq, 0);
                ExitXferLoop(wfso == WAIT_OBJECT_0?"Restart Cancel":"Start");
                return;
            }

			if (bShowData && fp==NULL)
			{
				// Do not overwrite existing file and make #1, #2, etc. variants.
				// http://stackoverflow.com/questions/230062/whats-the-best-way-to-check-if-a-file-exists-in-c-cross-platform
				char fname[] = "RASDRstreamer.raw\0\0\0\0";		// space for RASDRstreamer#999.raw
				errno_t e = fopen_s(&fp,fname,"rb");			// try opening (for existence)
				i = 1;
				while( e==0 && i < 1000 ) {
					fclose(fp);
					sprintf_s(fname, sizeof(fname), "RASDRstreamer#%03d.raw", i++);
					e = fopen_s(&fp, fname, "r");
				}
				if (!e) fclose(fp);
				e = fopen_s(&fp, fname, "wb");
				if (e == 0) Display(String::Concat("Opened ", fname));
				else      { Display(String::Concat("Did not open ", fname)); fp = NULL; }
                pFile = fp;
			}

            // The infinite xfer loop.
			i = 0;
            FailuresSinceLastSuccess = 0;
			for (; bStreaming;)
            {
                long rLen = len;	// Reset this each time through because
                // FinishDataXfer may modify it

                if (!EndPt->WaitForXfer(&s.inOvLap[i], TimeOut))
                {
                    // DEBUG
                    String *tag = String::Concat("@", i.ToString());
                    Display(String::Concat(tag, " WaitForXfer(,",TimeOut.ToString(),") faults"));

                    //int TimeOut2 = TimeOut * 100;
                    //if (!EndPt->WaitForXfer(&s.inOvLap[i], TimeOut2))
                    //{
                    //    Display(String::Concat(tag, " WaitForXfer(,", TimeOut2.ToString(), ") faults"));

                        EndPt->Abort();
                        if (EndPt->LastError == ERROR_IO_PENDING)
                        {
                            DWORD wfso = WaitForSingleObject(s.inOvLap[i].hEvent,2000);
                            if (wfso != WAIT_OBJECT_0) Display(String::Concat(tag, "  WFSO=", wfso.ToString("x")));
                        }
                    //}
                }

                if (EndPt->Attributes == 1) // ISOC Endpoint
                {	
                    if (EndPt->FinishDataXfer(s.buffers[i], rLen, &s.inOvLap[i], s.contexts[i], s.isoPktInfos[i]))
                    {			
                        CCyIsoPktInfo *pkts = s.isoPktInfos[i];
                        unsigned char *p = s.buffers[i];
						size_t offset = 0;
						size_t rc;

                        for (int j=0; j< PPX; j++) 
                        {
							if ((pkts[j].Status == 0) && (pkts[j].Length<=EndPt->MaxPktSize)) 
                            {
                                BytesXferred += pkts[j].Length;

								if (fp != NULL)
								{
									//Display16Bytes(buffers[i]);
									rc = fwrite(&p[offset], pkts[j].Length, 1, fp);
									if (rc != 1)
									{
										String *tmp = "Writing stopped, code=";
										Display(String::Concat(tmp, errno.ToString()));
										fclose(fp);
										fp = NULL;
                                        pFile = NULL;
									}
								}
								offset += pkts[j].Length;
                                Successes++;
                                FailuresSinceLastSuccess = 0;
                            }
							else
							{
								Failures++;
                                FailuresSinceLastSuccess++;
								offset += pkts[j].Length;
							}

                            pkts[j].Length = 0;	// Reset to zero for re-use.
							pkts[j].Status = 0;
                        }

                    } 
                    else {
                        Failures++; 
                        FailuresSinceLastSuccess++;
                    }

                } 

                else // BULK Endpoint
                {
                    if (EndPt->FinishDataXfer(s.buffers[i], rLen, &s.inOvLap[i], s.contexts[i]))
                    {			
                        Successes++;
                        FailuresSinceLastSuccess = 0;
                        BytesXferred += len;

						if (fp != NULL)
						{
							//Display16Bytes(buffers[i]);
                            size_t rc = fwrite(s.buffers[i], len, 1, fp);
							if (rc != 1)
							{
								String *tmp = "Writing stopped, code=";
								Display(String::Concat(tmp, errno.ToString()));
								fclose(fp);
								fp = NULL;
                                pFile = NULL;
							}
						}
					}
                    else {
                        Failures++; 
                        FailuresSinceLastSuccess++;
                    }
                }


                if (BytesXferred < 0) // Rollover - reset counters
                {
                    BytesXferred = 0;
                    t1 = DateTime::Now;
                }

                // Re-submit this queue element to keep the queue full
                if (!BeginOneTransfer(i, s))
                {
                    // a restart may be possible here
                    // but it requires a close/open of the USB driver
#ifdef ATTEMPT_TO_REINIT
                    bAttemptRestart = true;
#endif
                    break;
                }

                i++;

                if (i == QueueSize) //Only update the display once each time through the Queue
                {
                    i=0;
                    ShowStats(t1, BytesXferred, Successes, Failures);					
                }

                // RASDR2 firmware has issues with USB3 requiring flush and re-queue of transfers
#ifdef ATTEMPT_TO_REINIT
                if (FailuresSinceLastSuccess >= FailuresToInitiateRequeue)
                {
                    bAttemptRestart = true;
                    break;
                }
#endif

            }  // End of the infinite loop

            // Memory clean-up
            FlushXferLoop(QueueSize, s);
            DestroyBuffers(s);
#ifdef ATTEMPT_TO_REINIT
            // If we attempt to restart, we exit the thread but
            // leave the file open; a successful restart will continue to add data.
            // Timestamping (when implemented) will track the time gap.
            if (bAttemptRestart)
            {
                SetEvent(hRestartReq);
                ExitXferLoop("Restart Cancel");
                return;
            }
#endif
			if (fp != NULL)
			{
				Display(String::Concat("File closed at end of data collection", ""));
				fclose(fp);
                pFile = NULL;   // somehow declaring FILE * in the class alters its convention
            }
            ExitXferLoop("Start");
        }

        // Buffer Management Methods (allow parts to called without exiting the thread)
        static void CreateBuffers(struct _buffers &s)
        {
            long len = GetEndpoint()->MaxPktSize * PPX;

            s.buffers = new PUCHAR[QueueSize];
            s.isoPktInfos = new CCyIsoPktInfo*[QueueSize];
            s.contexts = new PUCHAR[QueueSize];

            // Allocate all the buffers for the queues
            for (int i = 0; i< QueueSize; i++)
            {
                s.buffers[i] = new UCHAR[len];
                s.isoPktInfos[i] = new CCyIsoPktInfo[PPX];
                s.inOvLap[i].hEvent = CreateEvent(NULL, false, false, NULL);    // auto-reset, non-signalled
                memset(s.buffers[i], 0xEF, len);
            }
        }

        static void DestroyBuffers(struct _buffers &s)
        {
            for (int j = 0; j< QueueSize; j++)
            {
                CloseHandle(s.inOvLap[j].hEvent);
                delete[] s.isoPktInfos[j];
                delete[] s.buffers[j];
            }

            delete[] s.buffers;
            delete[] s.isoPktInfos;
            delete[] s.contexts;
        }

        static bool BeginOneTransfer(int j, struct _buffers &s)
        {
            CCyUSBEndPoint *EndPt = GetEndpoint();

            if (EndPt == NULL || EndPt->MaxPktSize == 0) return false;

            long len = EndPt->MaxPktSize * PPX;
            //ResetEvent(s.inOvLap[j])
            s.contexts[j] = EndPt->BeginDataXfer(s.buffers[j], len, &s.inOvLap[j]);
            if (EndPt->NtStatus || EndPt->UsbdStatus) // BeginDataXfer failed
            {
                String *tmp = String::Concat("Begin @", j.ToString());
                tmp = String::Concat(tmp, ", NtStatus=", EndPt->NtStatus.ToString("x"));
                tmp = String::Concat(tmp, ", UsbdStatus=", EndPt->UsbdStatus.ToString("x"));
                Display(tmp);

                // http://www.cypress.com/file/74566/download
                // https://msdn.microsoft.com/en-us/library/windows/hardware/ff539136(v=vs.85).aspx
                if (EndPt->NtStatus == 0xC0000001) switch(EndPt->UsbdStatus) {
                case 0xC0000030:    // USBD_STATUS_ENDPOINT_HALTED
                    tmp = String::Concat("USBD_STATUS_ENDPOINT_HALTED"," -> ","Reset Endpoint");
                    Display(tmp);
                    SetEvent(hRestartMod);
                    SetEvent(hRestartReq);
                    // all of the recovery methods require calls that are only available in the WDMF
                    break;
                default:
                    break;
                }
                return false;
            }
            return true;
        }

        static bool FinishOneTransfer(int j, struct _buffers &s, bool aborted)
        { 
            CCyUSBEndPoint *EndPt = GetEndpoint();

            if (EndPt == NULL || EndPt->MaxPktSize == 0) return false;

            long expected, len = EndPt->MaxPktSize * PPX;
            bool status;
            expected = len;
            if (!EndPt->WaitForXfer(&s.inOvLap[j], TimeOut))
            {
                if (EndPt->LastError == ERROR_IO_PENDING)
                {
                    DWORD wfso = WaitForSingleObject(s.inOvLap[j].hEvent, 10000/*INFINITE*/);
                    if (wfso != WAIT_OBJECT_0) Display(String::Concat("@", j.ToString(), " WFSO=", wfso.ToString("x")));
                } else
                    Display(String::Concat("@", j.ToString(), " LastError=", EndPt->LastError.ToString()));
            }
            if (EndPt->Attributes == 1) // ISOC Endpoint
                status = EndPt->FinishDataXfer(s.buffers[j], len, &s.inOvLap[j], s.contexts[j], s.isoPktInfos[j]);
            else
                status = EndPt->FinishDataXfer(s.buffers[j], len, &s.inOvLap[j], s.contexts[j]);
            if (!aborted)
            {
                if (!status) Display(String::Concat("@", j.ToString(), " FinishDataXfer() faults"));
                if (len != EndPt->MaxPktSize * PPX)
                {
                    // DEBUG
                    String *tmp = String::Concat("@", j.ToString());
                    tmp = String::Concat(tmp, " FinishDataXfer(,", len.ToString(), ",,,)");
                    tmp = String::Concat(tmp, " !=", expected.ToString());
                    Display(tmp);
                }
                return status;
            }
            return true;
        }

        static int QueueXferLoop(int pending, struct _buffers &s)
        {
            for (int j = 0; j<pending; j++)
            {
                if (!BeginOneTransfer(j, s)) return j;
            }
            return pending;
        }

        static void FlushXferLoop(int pending, struct _buffers &s)
        {
            GetEndpoint()->Abort();     // TODO: does Abort() kill one or all of them?
            for (int j = 0; j<pending; j++)
            {
                if (j<pending) (void)FinishOneTransfer(j, s, true);
            }
        }

        // Call before exit of XferLoop thread
        static void ExitXferLoop(const char *tag)
        {
            bStreaming = false;

            if (bAppQuiting == false )
            {
                // TODO: until we figure out how to do this better
                CheckForIllegalCrossThreadCalls = false;

                StartButton->Text   = tag;
                StartButton->BackColor = Color::Aquamarine;
                StartButton->Refresh();

                EptsBox->Enabled	= true;
                PpxBox->Enabled		= true;
                QueueBox->Enabled	= true;
                TimeoutBox->Enabled	= true;
                ShowBox->Enabled	= true;
                DevCmboBox->Enabled = true;
            }
        }



        static void ShowStats(DateTime t, long bytesXferred, unsigned long successes, unsigned long failures)
        {
            TimeSpan elapsed = DateTime::Now.Subtract(t);

            long totMS = (long)elapsed.TotalMilliseconds;
            if (totMS <= 0)	return;

            long XferRate = bytesXferred / totMS;
            long XferRateRounded;

            // Convert to KiB/s
            XferRate = XferRate * 1000 / 1024;

            // Truncate last 1 or 2 digits
            int rounder = (XferRate > 2000) ? 100 : 10;
            XferRateRounded = XferRate / rounder * rounder;

            // Prevent out-of-bounds exceptions
            if (XferRate>625000) XferRate = 625000;
            if (XferRate<0) XferRate = 0;
            if (XferRateRounded>625000) XferRateRounded = 625000;
            if (XferRateRounded<0) XferRateRounded = 0;

            //thread safe-commented (needs to be here to prevent assertions in debugger)
            CheckForIllegalCrossThreadCalls = false;

            if (abs(XferRateExpected - XferRateRounded) > (10 * XferRateExpected / 100))
                XferRateBar->BackColor = System::Drawing::Color::Red;		// >10%
            else if (abs(XferRateExpected - XferRateRounded) > (3 * XferRateExpected / 100))
                XferRateBar->BackColor = System::Drawing::Color::Orange;	// 3>10%
            else
                XferRateBar->BackColor = System::Drawing::Color::White;		// <3%

			XferRateBar->Value = XferRateRounded;
            XferRateLabel->Text = XferRate.ToString("0");

            SuccessBox->Text = successes.ToString();
            FailureBox->Text = failures.ToString();

        }




    protected:	

        [System::Security::Permissions::PermissionSet(System::Security::Permissions::SecurityAction::Demand, Name="FullTrust")]
        virtual void WndProc(Message *m)
        {	
            if (m->Msg == WM_DEVICECHANGE) 
            {
                // Tracks DBT_DEVNODES_CHANGED followed by DBT_DEVICEREMOVECOMPLETE
                if (m->WParam == DBT_DEVNODES_CHANGED) 
                {
                    bPnP_DevNodeChange = true;
                    bPnP_Removal = false;
                }

                // Tracks DBT_DEVICEARRIVAL followed by DBT_DEVNODES_CHANGED
                if (m->WParam == DBT_DEVICEARRIVAL) 
                {
                    bPnP_Arrival = true;
                    bPnP_DevNodeChange = false;
                }

                if (m->WParam == DBT_DEVICEREMOVECOMPLETE) 
                    bPnP_Removal = true;

                // If DBT_DEVICEARRIVAL followed by DBT_DEVNODES_CHANGED
                if (bPnP_DevNodeChange && bPnP_Removal) 
                {
                    bPnP_Removal = false;
                    bPnP_DevNodeChange = false;
                    bDeviceRefreshNeeded = XferThread->IsAlive;
                    
                    if (XferThread->IsAlive == false) 
                    {
                        bStreaming = false;                        
                        GetStreamerDevice();
                    }
                    //bDeviceRefreshNeeded = XferThread->IsAlive;
                }

                // If DBT_DEVICEARRIVAL followed by DBT_DEVNODES_CHANGED
                if (bPnP_DevNodeChange && bPnP_Arrival) 
                {
                    bPnP_Arrival = false;
                    bPnP_DevNodeChange = false;
                    bDeviceRefreshNeeded = XferThread->IsAlive;
                    if (XferThread->IsAlive == false) 
                    {
                        GetStreamerDevice();
                    }
                }

            }

            Form::WndProc(m);
        }







        void Dispose(Boolean disposing)
        {
            if (disposing && components)
            {
                components->Dispose();
            }
            __super::Dispose(disposing);
        }


    };

}


