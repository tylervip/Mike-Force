/*
    Medical Display UI
    Author: Tylervip
    Credit: Medical system concept inspired by Savage Game Design.
*/

// Source cutout sizes used to keep each body part proportional.
#define VN_MF_MED_PX_HEAD_W 74
#define VN_MF_MED_PX_HEAD_H 78
#define VN_MF_MED_PX_TORSO_W 111
#define VN_MF_MED_PX_TORSO_H 177
#define VN_MF_MED_PX_ARM_W 32
#define VN_MF_MED_PX_ARM_H 208
#define VN_MF_MED_PX_LEG_L_W 64
#define VN_MF_MED_PX_LEG_L_H 243
#define VN_MF_MED_PX_LEG_R_W 64
#define VN_MF_MED_PX_LEG_R_H 256

// To adjust for stretching, the width of a part is calculated relative to the head.
#define VN_MF_MED_HEAD_W 3.0
#define VN_MF_MED_HEAD_H (VN_MF_MED_PX_HEAD_H / VN_MF_MED_PX_HEAD_W * VN_MF_MED_HEAD_W)
#define VN_MF_MED_TORSO_W (VN_MF_MED_PX_TORSO_W / VN_MF_MED_PX_HEAD_W * VN_MF_MED_HEAD_W)
#define VN_MF_MED_TORSO_H (VN_MF_MED_PX_TORSO_H / VN_MF_MED_PX_TORSO_W * VN_MF_MED_TORSO_W)
#define VN_MF_MED_ARM_W (VN_MF_MED_PX_ARM_W / VN_MF_MED_PX_HEAD_W * VN_MF_MED_HEAD_W)
#define VN_MF_MED_ARM_H (VN_MF_MED_PX_ARM_H / VN_MF_MED_PX_ARM_W * VN_MF_MED_ARM_W)
#define VN_MF_MED_LEG_L_W (VN_MF_MED_PX_LEG_L_W / VN_MF_MED_PX_HEAD_W * VN_MF_MED_HEAD_W)
#define VN_MF_MED_LEG_L_H (VN_MF_MED_PX_LEG_L_H / VN_MF_MED_PX_LEG_L_W * VN_MF_MED_LEG_L_W)
#define VN_MF_MED_LEG_R_W (VN_MF_MED_PX_LEG_R_W / VN_MF_MED_PX_HEAD_W * VN_MF_MED_HEAD_W)
#define VN_MF_MED_LEG_R_H (VN_MF_MED_PX_LEG_R_H / VN_MF_MED_PX_LEG_R_W * VN_MF_MED_LEG_R_W)

// Torso is the anchor for the silhouette.
// Positive offsets move parts UP; negative moves them DOWN.
// For side distance from torso, both left and right use the same rule: lower = closer in, higher = farther out.
#define VN_MF_MED_CENTER_X 4.725
#define VN_MF_MED_TORSO_Y 5.0
#define VN_MF_MED_HEAD_OFFSET_Y -3.15     // Head vertical offset from torso. Higher = closer to top, lower = farther down.
#define VN_MF_MED_ARM_OFFSET_Y  0.2      // Arm vertical offset from torso. Higher = up, lower = down.
#define VN_MF_MED_LEG_OFFSET_Y 7.15     // Leg vertical offset from torso. Higher = up, lower = down.
#define VN_MF_MED_ARM_INSET 0.0          // Arm distance from torso. Lower = closer in, higher = farther out.
#define VN_MF_MED_LEG_INSET 0.0          // Leg distance from torso. Lower = closer in, higher = farther out.

#define VN_MF_MED_HEAD_Y (VN_MF_MED_TORSO_Y - VN_MF_MED_HEAD_OFFSET_Y)
#define VN_MF_MED_ARM_Y (VN_MF_MED_TORSO_Y - VN_MF_MED_ARM_OFFSET_Y)
#define VN_MF_MED_LEG_Y (VN_MF_MED_TORSO_Y - VN_MF_MED_LEG_OFFSET_Y)

// Derived X positions from torso centerline. The legs should sit directly left/right of the torso anchor.
#define VN_MF_MED_HEAD_X (VN_MF_MED_CENTER_X - 0.5 * VN_MF_MED_HEAD_W)
#define VN_MF_MED_TORSO_X (VN_MF_MED_CENTER_X - 0.5 * VN_MF_MED_TORSO_W)
#define VN_MF_MED_ARM_L_X (VN_MF_MED_CENTER_X - 0.5 * VN_MF_MED_TORSO_W - VN_MF_MED_ARM_W - VN_MF_MED_ARM_INSET)
#define VN_MF_MED_ARM_R_X (VN_MF_MED_CENTER_X + 0.5 * VN_MF_MED_TORSO_W + VN_MF_MED_ARM_INSET)
#define VN_MF_MED_LEG_L_X (VN_MF_MED_CENTER_X - VN_MF_MED_LEG_L_W - VN_MF_MED_LEG_INSET)
#define VN_MF_MED_LEG_R_X (VN_MF_MED_CENTER_X + VN_MF_MED_LEG_INSET)

class vn_mf_RscDisplayMedical
{
    idd = VN_MF_IDD_RSCDISPLAY_MEDICAL;
    movingEnable = 0;
    enableSimulation = 1;
    onLoad = "_this call vn_mf_fnc_medical_dialog_onload;";
    onUnload = "uiNamespace setVariable ['vn_mf_RscDisplayMedical', displayNull];";

    class objects {};

    class controlsBackground
    {
        class Backdrop: vn_mf_RscText
        {
            idc = -1;
            colorBackground[] = {0, 0, 0, 0.82};
            x = UIX_CL(12);
            y = UIY_CU(11);
            w = UIW(24);
            h = UIH(27);
        };

        class Header: vn_mf_RscText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TITLE;
            style = ST_CENTER;
            text = "Medical";
            colorBackground[] = {0.1, 0.1, 0.1, 0.95};
            x = UIX_CL(12);
            y = UIY_CU(11);
            w = UIW(24);
            h = UIH(1.4);
        };

        class Panel: vn_mf_RscText
        {
            idc = -1;
            colorBackground[] = {0.05, 0.05, 0.05, 0.92};
            x = UIX_CL(11.5);
            y = UIY_CU(8.5);
            w = UIW(10);
            h = UIH(13.5);
        };

        class TreatmentFirstAidBackground: vn_mf_RscText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_FAK_BG;
            colorBackground[] = {0.15, 0.15, 0.15, 0.95};
            x = UIX_CL(11.3);
            y = UIY_CU(-0.85);
            w = UIW(9.6);
            h = UIH(1.1);
        };

        class TreatmentMedkitBackground: vn_mf_RscText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_MEDKIT_BG;
            colorBackground[] = {0.15, 0.15, 0.15, 0.95};
            x = UIX_CL(11.3);
            y = UIY_CU(-2.1);
            w = UIW(9.6);
            h = UIH(1.1);
        };
    };

    class controls
    {
        class MedicalPartImage: vn_mf_RscPicture
        {
            colorText[] = {1, 1, 1, 0.6};
        };

        class MedicalPartHitbox: vn_mf_RscButton
        {
            text = "";
            colorBackground[] = {0, 0, 0, 0};
            colorBackgroundActive[] = {0, 0, 0, 0};
            colorFocused[] = {0, 0, 0, 0};
            colorShadow[] = {0, 0, 0, 0};
            soundClick[] = {"", 0, 1};
            soundEnter[] = {"", 0, 1};
            soundEscape[] = {"", 0, 1};
            soundPush[] = {"", 0, 1};
        };

        class SelectedLabel: vn_mf_RscText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_SELECTED_LABEL;
            style = ST_CENTER;
            text = "Selected: -";
            x = UIX_CL(11.5);
            y = UIY_CU(9.6);
            w = UIW(10);
            h = UIH(1.1);
        };

        class WoundsText: vn_mf_RscStructuredText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_WOUNDS_TEXT;
            x = UIX_CL(11.3);
            y = UIY_CU(8.3);
            w = UIW(9.6);
            h = UIH(7.8);
            class Attributes
            {
                align = "left";
                color = "#FFFFFF";
                colorLink = "#6EE7F8";
                font = USEDFONT;
                size = 0.85;
                shadow = 0;
            };
        };

        class PartHead: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_HEAD;
            text = "functions\systems\medical\textures\soldier_head.paa";
            x = UIX_CR(VN_MF_MED_HEAD_X);
            y = UIY_CU(VN_MF_MED_HEAD_Y);
            w = UIW(VN_MF_MED_HEAD_W);
            h = UIH(VN_MF_MED_HEAD_H);
        };

        class PartHeadHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_HEAD;
            tooltip = "Treat Head";
            onButtonClick = "['head'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_HEAD_X);
            y = UIY_CU(VN_MF_MED_HEAD_Y);
            w = UIW(VN_MF_MED_HEAD_W);
            h = UIH(VN_MF_MED_HEAD_H);
        };

        class TreatmentLabel: vn_mf_RscText
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_LABEL;
            text = "Treatment item";
            x = UIX_CL(11.3);
            y = UIY_CU(0);
            w = UIW(9.6);
            h = UIH(0.8);
        };

        class TreatmentFirstAid: vn_mf_RscButton
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_FAK;
            text = "First Aid Kit (0)";
            onButtonClick = "uiNamespace setVariable ['vn_mf_medical_ui_selectedTreatment', 'fak']; [] spawn { uiSleep 0; [] call vn_mf_fnc_medical_dialog_refresh; };";
            onMouseExit = "[] call vn_mf_fnc_medical_dialog_refresh;";
            colorBackground[] = {0, 0, 0, 0};
            colorBackgroundActive[] = {0.08, 0.48, 0.16, 0.95};
            x = UIX_CL(11.3);
            y = UIY_CU(-0.85);
            w = UIW(9.6);
            h = UIH(1.1);
        };

        class TreatmentMedkit: vn_mf_RscButton
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_MEDKIT;
            text = "Medkit (0)";
            onButtonClick = "uiNamespace setVariable ['vn_mf_medical_ui_selectedTreatment', 'medkit']; [] spawn { uiSleep 0; [] call vn_mf_fnc_medical_dialog_refresh; };";
            onMouseExit = "[] call vn_mf_fnc_medical_dialog_refresh;";
            colorBackground[] = {0, 0, 0, 0};
            colorBackgroundActive[] = {0.08, 0.48, 0.16, 0.95};
            x = UIX_CL(11.3);
            y = UIY_CU(-2.1);
            w = UIW(9.6);
            h = UIH(1.1);
        };

        class StartTreatment: vn_mf_RscButton
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_TREATMENT_START;
            text = "Start Treatment";
            onButtonClick = "[uiNamespace getVariable ['vn_mf_medical_ui_selectedTreatment', '']] call vn_mf_fnc_medical_dialog_treat_selected;";
            colorBackground[] = {0.08, 0.38, 0.18, 0.95};
            colorBackgroundActive[] = {0.12, 0.52, 0.24, 1};
            x = UIX_CL(11.3);
            y = UIY_CU(-3.35);
            w = UIW(9.6);
            h = UIH(1.1);
        };

        class PartTorso: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_TORSO;
            text = "functions\systems\medical\textures\soldier_torso.paa";
            x = UIX_CR(VN_MF_MED_TORSO_X);
            y = UIY_CU(VN_MF_MED_TORSO_Y);
            w = UIW(VN_MF_MED_TORSO_W);
            h = UIH(VN_MF_MED_TORSO_H);
        };

        class PartTorsoHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_TORSO;
            tooltip = "Treat Torso";
            onButtonClick = "['torso'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_TORSO_X);
            y = UIY_CU(VN_MF_MED_TORSO_Y);
            w = UIW(VN_MF_MED_TORSO_W);
            h = UIH(VN_MF_MED_TORSO_H);
        };

        class PartArmL: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_ARM_L;
            text = "functions\systems\medical\textures\soldier_arm_l.paa";
            x = UIX_CR(VN_MF_MED_ARM_L_X);
            y = UIY_CU(VN_MF_MED_ARM_Y);
            w = UIW(VN_MF_MED_ARM_W);
            h = UIH(VN_MF_MED_ARM_H);
        };

        class PartArmLHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_ARM_L;
            tooltip = "Treat Left Arm";
            onButtonClick = "['arm_l'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_ARM_L_X);
            y = UIY_CU(VN_MF_MED_ARM_Y);
            w = UIW(VN_MF_MED_ARM_W);
            h = UIH(VN_MF_MED_ARM_H);
        };

        class PartArmR: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_ARM_R;
            text = "functions\systems\medical\textures\soldier_arm_r.paa";
            x = UIX_CR(VN_MF_MED_ARM_R_X);
            y = UIY_CU(VN_MF_MED_ARM_Y);
            w = UIW(VN_MF_MED_ARM_W);
            h = UIH(VN_MF_MED_ARM_H);
        };

        class PartArmRHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_ARM_R;
            tooltip = "Treat Right Arm";
            onButtonClick = "['arm_r'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_ARM_R_X);
            y = UIY_CU(VN_MF_MED_ARM_Y);
            w = UIW(VN_MF_MED_ARM_W);
            h = UIH(VN_MF_MED_ARM_H);
        };

        class PartLegL: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_LEG_L;
            text = "functions\systems\medical\textures\soldier_leg_l.paa";
            x = UIX_CR(VN_MF_MED_LEG_L_X);
            y = UIY_CU(VN_MF_MED_LEG_Y);
            w = UIW(VN_MF_MED_LEG_L_W);
            h = UIH(VN_MF_MED_LEG_L_H);
        };

        class PartLegLHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_LEG_L;
            tooltip = "Treat Left Leg";
            onButtonClick = "['leg_l'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_LEG_L_X);
            y = UIY_CU(VN_MF_MED_LEG_Y);
            w = UIW(VN_MF_MED_LEG_L_W);
            h = UIH(VN_MF_MED_LEG_L_H);
        };

        class PartLegR: MedicalPartImage
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_PART_LEG_R;
            text = "functions\systems\medical\textures\soldier_leg_r.paa";
            x = UIX_CR(VN_MF_MED_LEG_R_X);
            y = UIY_CU(VN_MF_MED_LEG_Y);
            w = UIW(VN_MF_MED_LEG_R_W);
            h = UIH(VN_MF_MED_LEG_R_H);
        };

        class PartLegRHitbox: MedicalPartHitbox
        {
            idc = VN_MF_RSCDISPLAY_MEDICAL_HITBOX_LEG_R;
            tooltip = "Treat Right Leg";
            onButtonClick = "['leg_r'] call vn_mf_fnc_medical_dialog_select_part;";
            x = UIX_CR(VN_MF_MED_LEG_R_X);
            y = UIY_CU(VN_MF_MED_LEG_Y);
            w = UIW(VN_MF_MED_LEG_R_W);
            h = UIH(VN_MF_MED_LEG_R_H);
        };

    };
};
