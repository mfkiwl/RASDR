// -----------------------------------------------------------------------------
// FILE:        "Setup_Simulator.h"
// DESCRIPTION: "Header File"
// DATE:        "05/09/2015 06:44 AM "
// AUTHOR(s):   Lime Microsystems, Paul L. Oxley
// Copyright:   Society of Amateur Radio Astronomers (2014-2015)
//
// Based on original work from Zydrunas Tamosevicius (Lime Microsystems, Ltd.)
// and distributed under the Apache License 2.0 at:
// https://github.com/myriadrf/myriadrf-utils
//
// The RASDRviewer version has been specifically modified for Radio Astronomy
// by Paul L. Oxley for the Society of Amateur Radio Astronomers.  These
// modifications are provided to you under the Gnu Public License version 2.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// REVISIONS:   as appropriate
// -----------------------------------------------------------------------------
#ifndef SETUP_SIMULATOR_H
#define SETUP_SIMULATOR_H

//(*Headers(Setup_Simulator)
#include <wx/sizer.h>
#include <wx/stattext.h>
#include <wx/statbox.h>
#include <wx/panel.h>
#include <wx/button.h>
#include <wx/dialog.h>
#include <wx/combobox.h>
//*)

class Setup_Simulator: public wxDialog
{
	public:

		Setup_Simulator(wxWindow* parent,wxWindowID id=wxID_ANY,const wxPoint& pos=wxDefaultPosition,const wxSize& size=wxDefaultSize);
		virtual ~Setup_Simulator();

		//(*Declarations(Setup_Simulator)
		wxComboBox* DM_Box;
		wxComboBox* Period_Box;
		wxStaticText* StaticText2;
		wxPanel* Panel1;
		wxStaticText* StaticText1;
		wxComboBox* Duty_Box;
		wxStaticText* StaticText3;
		wxStaticBox* StaticBox1;
		wxButton* Cancel_Btn;
		wxComboBox* Factor_Box;
		wxStaticText* StaticText4;
		wxButton* OKbtn;
		//*)

	protected:

		//(*Identifiers(Setup_Simulator)
		static const long ID_STATICTEXT4;
		static const long ID_STATICTEXT1;
		static const long ID_COMBOBOX1;
		static const long ID_STATICTEXT2;
		static const long ID_COMBOBOX2;
		static const long ID_STATICBOX1;
		static const long ID_COMBOBOX3;
		static const long ID_STATICTEXT3;
		static const long ID_COMBOBOX4;
		static const long ID_BUTTON1;
		static const long ID_BUTTON2;
		static const long ID_PANEL1;
		//*)

	private:

		//(*Handlers(Setup_Simulator)
		void OnOKbtnClick(wxCommandEvent& event);
		void OnCancel_BtnClick(wxCommandEvent& event);
		//*)

		DECLARE_EVENT_TABLE()
};

#endif
