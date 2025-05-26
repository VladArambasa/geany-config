#include "master.h"

#define Switch_Comp 3 // change this to 0, 1, 2, or 3 to test

#if Switch_Comp == 1 || Switch_Comp == 3
#include <wx/wx.h>

class MyFrame : public wxFrame {
public:
    wxTextCtrl* inputText;

    MyFrame() : wxFrame(NULL, wxID_ANY, "Text Processor", wxDefaultPosition, wxSize(300, 150)) {
        wxPanel* panel = new wxPanel(this);

        inputText = new wxTextCtrl(panel, wxID_ANY, "", wxPoint(10, 10), wxSize(260, 25));
        wxButton* btn = new wxButton(panel, wxID_ANY, "Show Transform", wxPoint(10, 50), wxSize(260, 30));

        btn->Bind(wxEVT_BUTTON, &MyFrame::OnShow, this);
    }

    void OnShow(wxCommandEvent&) {
        wxString text = inputText->GetValue();
        wxString lower = text.Lower();
        wxString upper = text.Upper();

        wxString message = lower + "\n" + upper;

        wxFrame* result = new wxFrame(NULL, wxID_ANY, "Result", wxDefaultPosition, wxSize(300, 100));
        new wxStaticText(result, wxID_ANY, message, wxPoint(10, 10));
        result->Show();
    }
};

class MyApp : public wxApp {
public:
    virtual bool OnInit() override {
        MyFrame* frame = new MyFrame();
        frame->Show();
        return true;
    }
};

wxIMPLEMENT_APP_NO_MAIN(MyApp);
#endif


#if Switch_Comp == 2 || Switch_Comp == 3
#include <GL/glut.h>
void display() {
    glClearColor(0.07f, 0.34f, 0.53f, 1.0f); // Lochmara blue background
    glClear(GL_COLOR_BUFFER_BIT);

    // Outer circle - lochmara blue
    glColor3f(0.07f, 0.34f, 0.53f); 
    glBegin(GL_TRIANGLE_FAN);
    glVertex2f(0.0f, 0.0f); 
    for (int i = 0; i <= 100; i++) {
        float angle = 2.0f * 3.14159f * i / 100;
        glVertex2f(cos(angle), sin(angle));
    }
    glEnd();

    // Inner circle - golden yellow
    glColor3f(1.0f, 0.84f, 0.0f); 
    glBegin(GL_TRIANGLE_FAN);
    glVertex2f(0.0f, 0.0f); 
    for (int i = 0; i <= 100; i++) {
        float angle = 2.0f * 3.14159f * i / 100;
        glVertex2f(0.5f * cos(angle), 0.5f * sin(angle));
    }
    glEnd();

    glFlush();
}

#endif

int main(int argc, char** argv) {
    printf("Running main program with Switch_Comp = %d\n", Switch_Comp);

    lib1_hello();
    lib2_hello();
    utilib1_test();
    utilib2_test();

#if Switch_Comp == 1 || Switch_Comp == 3
    wxEntry(argc, argv);
#endif

#if Switch_Comp == 2 || Switch_Comp == 3
    glutInit(&argc, argv);
    glutCreateWindow("GLUT Test");
    glutDisplayFunc(display);
    glutMainLoop();
#endif

    return 0;
}
