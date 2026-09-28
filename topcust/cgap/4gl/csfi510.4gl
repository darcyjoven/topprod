# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: asfi510.4gl
# Descriptions...: WO ISSUE
# Date & Author..: 97/06/20 By Roger
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
TYPE type_tc_sff RECORD    #程式變數(Prinram Variables)
        tc_sff02     LIKE tc_sff_file.tc_sff02,
        tc_sff26     LIKE tc_sff_file.tc_sff26,
        tc_sff28     LIKE tc_sff_file.tc_sff28,
        tc_sff014    LIKE tc_sff_file.tc_sff014,    #FUN-C70014 add
        tc_sff03     LIKE tc_sff_file.tc_sff03,
        tc_sff27     LIKE tc_sff_file.tc_sff27,
        tc_sff04     LIKE tc_sff_file.tc_sff04,
        ima02        LIKE ima_file.ima02,
        ima021       LIKE ima_file.ima021,
        tc_sff012    LIKE tc_sff_file.tc_sff012,
        ecu014       LIKE ecu_file.ecu014,
        tc_sff013    LIKE tc_sff_file.tc_sff013,                 
        tc_sff06     LIKE tc_sff_file.tc_sff06,
        tc_sff07     LIKE tc_sff_file.tc_sff07,
        sfa05        LIKE sfa_file.sfa05,                    
        sfa06        LIKE sfa_file.sfa06,
        short_qty    LIKE sfa_file.sfa07,     #FUN-940039 add
        tc_sff05     LIKE tc_sff_file.tc_sff05,
        tc_sff08     LIKE tc_sff_file.tc_sff08,
        img10        LIKE img_file.img10,
        img10_alo    LIKE img_file.img10,
        tc_sff09     LIKE tc_sff_file.tc_sff09, #FUN-670103
        azf03_1      LIKE azf_file.azf03   #FUN-CB0087 add
        ,tc_sffud01  LIKE tc_sff_file.tc_sffud01,
        tc_sffud02   LIKE tc_sff_file.tc_sffud02,
        tc_sffud03   LIKE tc_sff_file.tc_sffud03,
        tc_sffud04   LIKE tc_sff_file.tc_sffud04,
        tc_sffud05   LIKE tc_sff_file.tc_sffud05,
        tc_sffud06   LIKE tc_sff_file.tc_sffud06,
        tc_sffud07   LIKE tc_sff_file.tc_sffud07,
        tc_sffud08   LIKE tc_sff_file.tc_sffud08,
        tc_sffud09   LIKE tc_sff_file.tc_sffud09,
        tc_sffud10   LIKE tc_sff_file.tc_sffud10,
        tc_sffud11   LIKE tc_sff_file.tc_sffud11,
        tc_sffud12   LIKE tc_sff_file.tc_sffud12,
        tc_sffud13   LIKE tc_sff_file.tc_sffud13,
        tc_sffud14   LIKE tc_sff_file.tc_sffud14,
        tc_sffud15   LIKE tc_sff_file.tc_sffud15
                    END RECORD
TYPE type_tc_sff_2 RECORD    #程式變數(Prinram Variables)
        tc_sff02_2     LIKE tc_sff_file.tc_sff02,
        tc_sff26_2     LIKE tc_sff_file.tc_sff26,
        tc_sff28_2     LIKE tc_sff_file.tc_sff28,
        tc_sff014_2    LIKE tc_sff_file.tc_sff014,    #FUN-C70014 add
        tc_sff03_2     LIKE tc_sff_file.tc_sff03,
        tc_sff27_2     LIKE tc_sff_file.tc_sff27,
        tc_sff04_2     LIKE tc_sff_file.tc_sff04,
        ima02_2        LIKE ima_file.ima02,
        ima021_2       LIKE ima_file.ima021,
        tc_sff012_2    LIKE tc_sff_file.tc_sff012,
        ecu014_2       LIKE ecu_file.ecu014,
        tc_sff013_2    LIKE tc_sff_file.tc_sff013,                 
        tc_sff06_2     LIKE tc_sff_file.tc_sff06,
        tc_sff07_2     LIKE tc_sff_file.tc_sff07,
        sfa05_2        LIKE sfa_file.sfa05,                    
        sfa06_2        LIKE sfa_file.sfa06,
        short_qty_2    LIKE sfa_file.sfa07,     #FUN-940039 add
        tc_sfe03_2     LIKE tc_sfe_file.tc_sfe03,       
        tc_sff05_2     LIKE tc_sff_file.tc_sff05,
        tc_sff08_2     LIKE tc_sff_file.tc_sff08,
        img10_2        LIKE img_file.img10,
        img10_alo_2    LIKE img_file.img10,
        tc_sff09_2     LIKE tc_sff_file.tc_sff09, #FUN-670103
        azf03_1_2      LIKE azf_file.azf03   #FUN-CB0087 add
        ,tc_sffud01_2  LIKE tc_sff_file.tc_sffud01,
        tc_sffud02_2   LIKE tc_sff_file.tc_sffud02,
        tc_sffud03_2   LIKE tc_sff_file.tc_sffud03,
        tc_sffud04_2   LIKE tc_sff_file.tc_sffud04,
        tc_sffud05_2   LIKE tc_sff_file.tc_sffud05,
        tc_sffud06_2   LIKE tc_sff_file.tc_sffud06,
        tc_sffud07_2   LIKE tc_sff_file.tc_sffud07,
        tc_sffud08_2   LIKE tc_sff_file.tc_sffud08,
        tc_sffud09_2   LIKE tc_sff_file.tc_sffud09,
        tc_sffud10_2   LIKE tc_sff_file.tc_sffud10,
        tc_sffud11_2   LIKE tc_sff_file.tc_sffud11,
        tc_sffud12_2   LIKE tc_sff_file.tc_sffud12,
        tc_sffud13_2   LIKE tc_sff_file.tc_sffud13,
        tc_sffud14_2   LIKE tc_sff_file.tc_sffud14,
        tc_sffud15_2   LIKE tc_sff_file.tc_sffud15
                    END RECORD
DEFINE
   g_tc_sfd   RECORD LIKE tc_sfd_file.*,
   g_tc_sfd_t RECORD LIKE tc_sfd_file.*,
   g_tc_sfd_o RECORD LIKE tc_sfd_file.*,
   g_yy,g_mm	    LIKE type_file.num5,    #No.FUN-680121	SMALLINT,              #
   b_tc_sfe   RECORD LIKE tc_sfe_file.*,
   b_tc_sff   RECORD LIKE tc_sff_file.*,
   g_sfa   RECORD LIKE sfa_file.*,
   g_sfa2  RECORD LIKE sfa_file.*,
   g_sfb   RECORD LIKE sfb_file.*,
   g_img   RECORD LIKE img_file.*,
   g_ima108 LIKE ima_file.ima108,
   g_img09  LIKE img_file.img09,
   g_img10  LIKE img_file.img10,
   g_tc_sfe         DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
        tc_sfe014    LIKE tc_sfe_file.tc_sfe014,    #FUN-C70014
        tc_sfe02     LIKE tc_sfe_file.tc_sfe02,
        tc_sfe012    LIKE tc_sfe_file.tc_sfe012,    #FUN-B20095 
        ecm014       LIKE ecm_file.ecm014,    #FUN-B20095
        tc_sfe04     LIKE tc_sfe_file.tc_sfe04,
        sfb05        LIKE sfb_file.sfb05,
        ima02_a      LIKE ima_file.ima02,
        ima021_a     LIKE ima_file.ima021,
        tc_sfe05     LIKE tc_sfe_file.tc_sfe05, #FUN-5C0114
        tc_sfe06     LIKE tc_sfe_file.tc_sfe06, #FUN-5C0114
        tc_sfe07     LIKE tc_sfe_file.tc_sfe07, #FUN-870097
        tc_sfe03     LIKE tc_sfe_file.tc_sfe03
        ,tc_sfeud01  LIKE tc_sfe_file.tc_sfeud01,
        tc_sfeud02   LIKE tc_sfe_file.tc_sfeud02,
        tc_sfeud03   LIKE tc_sfe_file.tc_sfeud03,
        tc_sfeud04   LIKE tc_sfe_file.tc_sfeud04,
        tc_sfeud05   LIKE tc_sfe_file.tc_sfeud05,
        tc_sfeud06   LIKE tc_sfe_file.tc_sfeud06,
        tc_sfeud07   LIKE tc_sfe_file.tc_sfeud07,
        tc_sfeud08   LIKE tc_sfe_file.tc_sfeud08,
        tc_sfeud09   LIKE tc_sfe_file.tc_sfeud09,
        tc_sfeud10   LIKE tc_sfe_file.tc_sfeud10,
        tc_sfeud11   LIKE tc_sfe_file.tc_sfeud11,
        tc_sfeud12   LIKE tc_sfe_file.tc_sfeud12,
        tc_sfeud13   LIKE tc_sfe_file.tc_sfeud13,
        tc_sfeud14   LIKE tc_sfe_file.tc_sfeud14,
        tc_sfeud15   LIKE tc_sfe_file.tc_sfeud15
    END RECORD,
    g_tc_sff        DYNAMIC ARRAY OF type_tc_sff ,
    g_tc_sff_t      type_tc_sff,
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_sw                LIKE type_file.num5,    
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,    
    g_ima55             LIKE ima_file.ima55,
    g_ima31             LIKE ima_file.ima31,
    g_short_qty         LIKE sfa_file.sfa07,
    g_sfa26		        LIKE sfa_file.sfa26,    
    g_ask_post          LIKE type_file.chr1,    #No.FUN-680121 CHAR(1), #扣帳時,是否詢問使用者(for asfp510)
    g_wc,g_wc2,g_wc3	STRING,  #No:FUN-580092 HCN
    g_wc4               STRING,  #FUN-940039 add
    g_wc5               STRING,                 #MOD-A50110 add
    gen_no              LIKE gen_file.gen01,    #FUN-940039 add
    g_sql    		    STRING,  #No:FUN-580092 HCN
    g_t1                LIKE oay_file.oayslip,           #No.FUN-550052  #No.FUN-680121 CHAR(05)
    g_t2                like oay_file.oayslip,           #No.FUN-870117
    g_buf               LIKE type_file.chr1000, #No.FUN-680121 CHAR(20)
    tot1,tot2,tot3      LIKE ima_file.ima26,    #No.FUN-680121 DECIMAL(12,3),
    issue_type          LIKE type_file.chr1,    #No.FUN-680121 CHAR(1),
    short_data          LIKE type_file.chr1,    #No.FUN-680121 CHAR(1),
    b_part,e_part       LIKE ima_file.ima01, #MOD-580001
    part_type           LIKE type_file.chr1,    #No.FUN-680121 CHAR(1),
    noqty               LIKE type_file.chr1,    #No.FUN-680121 CHAR(1),#庫存不足時,是否產生
    gen_all             LIKE type_file.chr1,    #NO.FUN-A20048 
    sel_all             LIKE type_file.chr1,    #No.FUN-A20048 add
    issue_qty,issue_qty1,issue_qty2  LIKE sfb_file.sfb08,  #No.FUN-680121 DEC(15,3),
    img_qty             LIKE sfb_file.sfb08,  #No.FUN-680121 DEC(15,3),
    qty_alo             LIKE sfb_file.sfb08,  #No.FUN-680121 DEC(15,3),
    ware_no             LIKE img_file.img02, #MOD-580001
    loc_no              LIKE img_file.img03, #MOD-580001
    lot_no              LIKE img_file.img04, #MOD-580001
    g_rec_d             LIKE type_file.num5,              #No.FUN-680121 SMALLINT,#單頭array筆數
    g_rec_b             LIKE type_file.num5,              #單身筆數  #No.FUN-680121 SMALLINT
    g_rec_b1            LIKE type_file.num5,              #單身筆數  #No.FUN-A20048 SMALLINT
    l_ecm               record like ecm_file.*,     #No.FUN-870117
    l_ac,l_ac2          LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_ac1               LIKE type_file.num5,              #目前處理的ARRAY CNT  #No.FUN-A20048 add
    g_pno               LIKE type_file.num5               #No.FUN-680121 SMALLINT #print page
DEFINE g_argv1          LIKE type_file.chr1    #No.FUN-680121 CHAR(1)              #1.發料 2.退料
DEFINE g_argv2          LIKE type_file.chr1    #No.FUN-680121 CHAR(1)              #1:成套發料 2:超領 3:補料   4.領料
                                             #6:成套退料        8:一般退 9.耗材退
DEFINE g_argv3          LIKE sfp_file.sfp01  #發料單號 #MOD-580252
DEFINE g_argv4          STRING               #功能 No:FUN-660166
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_dash_1        LIKE type_file.chr1000  #No.FUN-680121 CHAR(400)   #Dash line
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-680121 CHAR(120)  #TQC-630013
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-680121 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE g_confirm       LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_approve       LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_post          LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_close         LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_void          LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_valid         LIKE type_file.chr1    #No.FUN-680121 CHAR(1)
DEFINE g_cmd           LIKE type_file.chr1000  #FUN-610042  #No.FUN-680121 CHAR(100)
DEFINE g_flag_tc_sfe03    LIKE type_file.chr1    #CHI-6C0005 add#No.FUN-680121 CHAR(1)
define g_eno,g_bno     LIKE type_file.chr20   #No.FUN-870117
DEFINE g_flag_sie01    LIKE type_file.chr1    #No.FUN-A40053 add
DEFINE g_tc_sfd06      LIKE type_file.chr1
DEFINE g_action_flag   STRING 
DEFINE g_tc_sfd_l DYNAMIC ARRAY OF RECORD
                  tc_sfd01   LIKE tc_sfd_file.tc_sfd01,
                  tc_sfd02   LIKE tc_sfd_file.tc_sfd02,
                  tc_sfd03   LIKE tc_sfd_file.tc_sfd03,
                  tc_sfd06   LIKE tc_sfd_file.tc_sfd06,
                  gem02      LIKE gem_file.gem02,
                  tc_sfd07   LIKE tc_sfd_file.tc_sfd07,
                  tc_sfdud02 LIKE tc_sfd_file.tc_sfdud02,
                  gen02      LIKE gen_file.gen02,
                  tc_sfd04   LIKE tc_sfd_file.tc_sfd04,
                  tc_sfd05   LIKE tc_sfd_file.tc_sfd05,
                  tc_sfd08   LIKE tc_sfd_file.tc_sfd08,
                  tc_sfd09   LIKE tc_sfd_file.tc_sfd09,
                  gen02_1    LIKE gen_file.gen02
               END RECORD
DEFINE g_rec_b2 LIKE type_file.num5 
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
DEFINE g_multi_tc_sfe014 DYNAMIC ARRAY OF RECORD
         shm01    LIKE shm_file.shm01,
         shm012   LIKE shm_file.shm012,
         sgm04    LIKE sgm_file.sgm04,
         shm05    LIKE shm_file.shm05
         END RECORD
DEFINE g_tc_sfe02 LIKE tc_sfe_file.tc_sfe02
DEFINE li_where     LIKE type_file.chr1000
DEFINE g_tc_sff06_t LIKE tc_sff_file.tc_sff06 
DEFINE g_tc_sff27   LIKE tc_sff_file.tc_sff27
DEFINE g_imd23      LIKE imd_file.imd23
DEFINE g_ima918     LIKE ima_file.ima918
DEFINE g_ima921     LIKE ima_file.ima921       #No.FUN-810036
DEFINE g_ima930     LIKE ima_file.ima930 
DEFINE l_r          LIKE type_file.chr1
DEFINE g_x          LIKE type_file.num5



MAIN

    DEFINE p_row,p_col     LIKE type_file.num5
    IF FGL_GETENV("FGLGUI") <> "0" THEN       #FUN-AB0001  
       OPTIONS                                #改變一些系統預設值
          INPUT NO WRAP  #,                  #FUN-A60028 mark ,
   #      FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075  #FUN-A60028
    END IF                                    #FUN-AB0001 add
    DEFER INTERRUPT
    

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("CSF")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0090
 
    LET p_row = 2 LET p_col = 2
 
    OPEN WINDOW i510_w_1 AT p_row,p_col WITH FORM "csf/42f/csfi511"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_set_locale_frm_name("csfi511")
    CALL cl_ui_init()
    CALL cl_set_comp_visible("tc_sff014,tc_sfe014",FALSE)
    IF g_sma.sma541 = 'Y'  THEN
       CALL cl_set_comp_visible("tc_sfe012,ecm014",TRUE)  
    ELSE
       CALL cl_set_comp_visible("tc_sfe012,ecm014",FALSE)   
    END IF 
    IF g_sma.sma541 = 'Y' THEN 
       CALL cl_set_comp_visible("tc_sff012,tc_sff013,ecu014",TRUE)
    ELSE
       CALL cl_set_comp_visible("tc_sff012,tc_sff013,ecu014",FALSE)   
    END IF 
    #add by darcy 2022年3月4日 s---
    IF g_user <> 'tiptop' THEN
       CALL cl_set_act_visible("alteration2",FALSE) 
    END IF 
    #add by darcy 2022年3月4日 e---
    IF g_sma.sma129='N' THEN
       CALL cl_set_comp_visible("tc_sfe07",TRUE)
    ELSE 
       CALL cl_set_comp_visible("tc_sfe07",FALSE)
    END IF
    LET g_argv1 = '1'
    LET g_argv2 = '1'
    LET g_tc_sfd06 = '1'
    CALL i510()          #No.FUN-660166
    CLOSE WINDOW i510_w_1                              #結束畫面
END MAIN 

FUNCTION i510()

   INITIALIZE g_tc_sfd.* TO NULL
   INITIALIZE g_tc_sfd_t.* TO NULL
   INITIALIZE g_tc_sfd_o.* TO NULL

   LET g_forupd_sql = "SELECT * FROM tc_sfd_file WHERE tc_sfd01 = ? FOR UPDATE"           #09/10/21 xiaofeizhu Add
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i510_cl CURSOR FROM g_forupd_sql

   CALL i510_menu()

END FUNCTION

FUNCTION i510_cs()
DEFINE l_buf   LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
DEFINE l_length,l_i LIKE type_file.num5    #No.FUN-680121 SMALLINT
DEFINE lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
DEFINE l_buf_rpl    STRING    #FUN-B70061        
 
    CLEAR FORM                             #清除畫面
    CALL g_tc_sfe.clear()
    CALL g_tc_sff.clear()
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INITIALIZE g_tc_sfd.* TO NULL    #No.FUN-750051
    DIALOG ATTRIBUTES(UNBUFFERED)
    CONSTRUCT BY NAME g_wc ON                                 # 螢幕上取單頭條件
       tc_sfd01,tc_sfd02,tc_sfd03,tc_sfd06,tc_sfd07,tc_sfdud02,tc_sfd04,
       tc_sfd05,tc_sfd08,tc_sfd10,tc_sfd09,
       tc_sfduser,tc_sfdgrup,tc_sfdoriu,tc_sfdorig,tc_sfdmodu,tc_sfddate,
       tc_sfdud01,tc_sfdud03,tc_sfdud04,tc_sfdud05,
       tc_sfdud06,tc_sfdud07,tc_sfdud08,tc_sfdud09,tc_sfdud10,
       tc_sfdud11,tc_sfdud12,tc_sfdud13,tc_sfdud14,tc_sfdud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
    END CONSTRUCT

    ##組合拆解的工單發料不顯示出來! 
    CONSTRUCT g_wc2 ON tc_sfe014,tc_sfe02,tc_sfe012,tc_sfe04,tc_sfe05,tc_sfe06,tc_sfe07,tc_sfe03  
              ,tc_sfeud01,tc_sfeud02,tc_sfeud03,tc_sfeud04,tc_sfeud05,
              tc_sfeud06,tc_sfeud07,tc_sfeud08,tc_sfeud09,tc_sfeud10,
              tc_sfeud11,tc_sfeud12,tc_sfeud13,tc_sfeud14,tc_sfeud15
         FROM s_tc_sfe[1].tc_sfe014,s_tc_sfe[1].tc_sfe02,s_tc_sfe[1].tc_sfe012,s_tc_sfe[1].tc_sfe04,s_tc_sfe[1].tc_sfe05,s_tc_sfe[1].tc_sfe06,s_tc_sfe[1].tc_sfe07,s_tc_sfe[1].tc_sfe03 
              ,s_tc_sfe[1].tc_sfeud01,s_tc_sfe[1].tc_sfeud02,s_tc_sfe[1].tc_sfeud03,s_tc_sfe[1].tc_sfeud04,s_tc_sfe[1].tc_sfeud05,
              s_tc_sfe[1].tc_sfeud06,s_tc_sfe[1].tc_sfeud07,s_tc_sfe[1].tc_sfeud08,s_tc_sfe[1].tc_sfeud09,s_tc_sfe[1].tc_sfeud10,
              s_tc_sfe[1].tc_sfeud11,s_tc_sfe[1].tc_sfeud12,s_tc_sfe[1].tc_sfeud13,s_tc_sfe[1].tc_sfeud14,s_tc_sfe[1].tc_sfeud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		   
    END CONSTRUCT
    CONSTRUCT g_wc3 ON tc_sff02,tc_sff014,tc_sff03,tc_sff04,tc_sff012,tc_sff013,tc_sff06,  
                       tc_sff07,tc_sff05,tc_sff08,tc_sff09
                       ,tc_sffud01,tc_sffud02,tc_sffud03,tc_sffud04,tc_sffud05,
                       tc_sffud06,tc_sffud07,tc_sffud08,tc_sffud09,tc_sffud10,
                       tc_sffud11,tc_sffud12,tc_sffud13,tc_sffud14,tc_sffud15
                  FROM s_tc_sff[1].tc_sff02,s_tc_sff[1].tc_sff014,s_tc_sff[1].tc_sff03,s_tc_sff[1].tc_sff04,
                       s_tc_sff[1].tc_sff012,s_tc_sff[1].tc_sff013,s_tc_sff[1].tc_sff06,s_tc_sff[1].tc_sff07,
                       s_tc_sff[1].tc_sff05,s_tc_sff[1].tc_sff08,s_tc_sff[1].tc_sff09
                       ,s_tc_sff[1].tc_sffud01,s_tc_sff[1].tc_sffud02,s_tc_sff[1].tc_sffud03,s_tc_sff[1].tc_sffud04,s_tc_sff[1].tc_sffud05,
                       s_tc_sff[1].tc_sffud06,s_tc_sff[1].tc_sffud07,s_tc_sff[1].tc_sffud08,s_tc_sff[1].tc_sffud09,s_tc_sff[1].tc_sffud10,
                       s_tc_sff[1].tc_sffud11,s_tc_sff[1].tc_sffud12,s_tc_sff[1].tc_sffud13,s_tc_sff[1].tc_sffud14,s_tc_sff[1].tc_sffud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
     
       ON ACTION controlp
          CASE WHEN INFIELD(tc_sfd01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form   = "cq_tc_sfd"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tc_sfd01
                    NEXT FIELD tc_sfd01
               WHEN INFIELD(tc_sfd06)
                    CALL q_gem_pmc(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tc_sfd06
                    NEXT FIELD tc_sfd06
               WHEN INFIELD(tc_sfd07)   #料表批號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state  = "c"
                    LET g_qryparam.form ="q_sfc"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO tc_sfd07
                    NEXT FIELD tc_sfd07
               WHEN INFIELD(tc_sfd10)
                    IF g_sma.sma79='Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf"
                       LET g_qryparam.default1 = g_tc_sfd.tc_sfd10,'A'
                       LET g_qryparam.arg1 = "A"
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf01a"                      #No.FUN-930106
                       LET g_qryparam.default1 = g_tc_sfd.tc_sfd10,'2'
                       IF g_argv1='1' THEN 
                          LET g_qryparam.arg1 = "C"
                       ELSE
                          LET g_qryparam.arg1 = "E"
                       END IF 
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                    END IF
                    DISPLAY g_qryparam.multiret TO tc_sfd10
                    NEXT FIELD tc_sfd10
            END CASE        
              CASE WHEN INFIELD(tc_sfe02)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state    = "c"
                        LET g_qryparam.form = "q_sfb03"
                        LET g_qryparam.arg1 = '1'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_sfe02
                        NEXT FIELD tc_sfe02
          #FUN-B20095 ---------------Begin-------------------
                   WHEN INFIELD(tc_sfe012)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state  = "c"
                        LET g_qryparam.form = "q_tc_sfe012" 
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO tc_sfe012 
                        NEXT FIELD tc_sfe012
          #FUN-B20095 ---------------End---------------------                          
              END CASE
            CASE WHEN INFIELD(tc_sff04)
#FUN-AA0059---------mod------------str-----------------
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.state  = "c"
#                    LET g_qryparam.form ="q_ima"
#                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------

                     DISPLAY g_qryparam.multiret TO tc_sff04
                     NEXT FIELD tc_sff04
#FUN-A60028 --begin--
                WHEN INFIELD(tc_sff012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_tc_sff012"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_sff012
                     NEXT FIELD tc_sff012
                     
                WHEN INFIELD(tc_sff013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_tc_sff013"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_sff013
                     NEXT FIELD tc_sff013                
#FUN-A60028 --end--                     
                #FUN-CB0087--add--str--
                WHEN INFIELD(tc_sff09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_azf41"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_sff09
                     NEXT FIELD tc_sff09
                #FUN-CB0087--add--end--
                WHEN INFIELD(tc_sff03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_sfb02"
                     LET g_qryparam.arg1 = 2345678
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_sff03
                     NEXT FIELD tc_sff03
                WHEN INFIELD(tc_sff06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state  = "c"
                     LET g_qryparam.form ="q_gfe"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO tc_sff06
                     NEXT FIELD tc_sff06
               WHEN INFIELD(tc_sff07)
                  CALL q_ecd(TRUE,TRUE,g_tc_sff[1].tc_sff07)
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sff07
                  NEXT FIELD tc_sff07
              #FUN-AB0001 add str ----
               WHEN INFIELD(tc_sfdud02) #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO tc_sfdud02
                  NEXT FIELD tc_sfdud02
              #FUN-AB0001 add end ---
              #FUN-C70014 add begin----------------
              WHEN INFIELD(tc_sfe014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm4"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_sfe014
                 NEXT FIELD tc_sfe014
                
              WHEN INFIELD(tc_sff014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_shm4"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO tc_sff014
                 NEXT FIELD tc_sff014
              #FUN-C70014 add end------------------ 
           END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DIALOG
           
           ON ACTION qbe_select
		          CALL cl_qbe_list() RETURNING lc_qbe_sn
		          CALL cl_qbe_display_condition(lc_qbe_sn)
		           
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION accept
         EXIT DIALOG

      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG 
          
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG      		          
    END DIALOG 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('tc_sfduser', 'tc_sfdgrup') 
    IF INT_FLAG THEN RETURN END IF                     #TQC-D70005 add
  #ELSE
  #  LET g_wc = " tc_sfd01 = '",g_argv3,"'"
  #  LET g_wc2 = " 1=1"
  #  LET g_wc3 = " 1=1"
  #  LET g_wc5 = " 1=1"   #MOD-A50110 add
  #END IF
  CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT tc_sfd01 FROM tc_sfd_file",                        
                          " WHERE ", g_wc CLIPPED,
                          " ORDER BY tc_sfd01"
         WHEN g_wc2 <> " 1=1" AND g_wc3 = " 1=1"
              LET g_sql = "SELECT UNIQUE tc_sfd01 ",                             
                          "  FROM tc_sfd_file, tc_sfe_file",
                          " WHERE tc_sfd01 = tc_sfe01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                          " ORDER BY tc_sfd01"
         WHEN g_wc2 = " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE tc_sfd01 ",                             
                          "  FROM tc_sfd_file, tc_sff_file",
                          " WHERE tc_sfd01 = tc_sff01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                          " ORDER BY tc_sfd01 "
                          #--
         WHEN g_wc2 <> " 1=1" AND g_wc3 <> " 1=1"
              LET g_sql = "SELECT UNIQUE tc_sfd01 ",                              #09/10/21 xiaofeizhu Add
                          "  FROM tc_sfd_file, tc_sff_file, tc_sfe_file",
                          " WHERE tc_sfd01 = tc_sff01 AND tc_sfd01=tc_sfe01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED,
                          " UNION",
                          " ORDER BY tc_sfd01 "
    END CASE
    PREPARE i510_prepare FROM g_sql
    DECLARE i510_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i510_prepare
    DECLARE i510_fill_cs CURSOR FOR i510_prepare    #FUN-CB0014 add
    DISPLAY "g_sql",g_sql
    CASE WHEN g_wc2 = " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE tc_sfd01 FROM tc_sfd_file WHERE ",g_wc CLIPPED
         WHEN g_wc2 != " 1=1" AND g_wc3 = " 1=1"
              LET g_sql="SELECT UNIQUE tc_sfd01 FROM tc_sfd_file,tc_sfe_file WHERE ",
                        "tc_sfe01=tc_sfd01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
         WHEN g_wc2 = " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE tc_sfd01 ",
                          "  FROM tc_sfd_file, tc_sff_file",
                          " WHERE tc_sfd01 = tc_sff01",
                          "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED
                          #--
         WHEN g_wc2 != " 1=1" AND g_wc3 != " 1=1"
              LET g_sql = "SELECT UNIQUE tc_sfd01 ",
                          "  FROM tc_sfd_file, tc_sff_file, tc_sfe_file ",
                          " WHERE tc_sfd01 = tc_sff01 AND tc_sfd01=tc_sfe01",
                          "   AND ", g_wc CLIPPED,
                          "   AND ", g_wc2 CLIPPED, " AND ",g_wc3 CLIPPED
        OTHERWISE
              LET g_sql="SELECT UNIQUE tc_sfd01 FROM tc_sfd_file WHERE ",g_wc CLIPPED
        EXIT CASE
    END CASE
    PREPARE i510_precount FROM g_sql
    DECLARE i510_count CURSOR FOR i510_precount
END FUNCTION

FUNCTION i510_menu()
   DEFINE l_i     LIKE type_file.num5
   DEFINE l_fac   LIKE ima_file.ima31_fac  #TQC-7B0065
   DEFINE l_creator    LIKE type_file.chr1      #FUN-AB0001 add
   DEFINE l_flowuser   LIKE type_file.chr1      #FUN-AB0001 add
   DEFINE l_cnt        LIKE type_file.num5      #FUN-B40082
   DEFINE l_att        LIKE rvbs_file.rvbs09    #No.TQC-B90236 add
   DEFINE l_tc_sfd01_doc  LIKE tc_sfd_file.tc_sfd01      #TQC-C50227
   DEFINE l_ima931     LIKE ima_file.ima931     #DEV-D30026 add
   DEFINE l_ima930     LIKE ima_file.ima930     #DEV-D30026 add
   DEFINE l_mod_flag   LIKE type_file.chr1      #DEV-D30026 add
   DEFINE l_wc     LIKE type_file.chr1000

   LET l_flowuser = "N"                         #FUN-AB0001 add

   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
         CALL i510_bp("G")
      ELSE                           
         CALL i510_list_fill()
         CALL i510_bp3("G")           
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT tc_sfd_file.* INTO g_tc_sfd.*
              FROM tc_sfd_file
             WHERE tc_sfd01=g_tc_sfd_l[l_ac2].tc_sfd01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL i510_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info,userdefined_field", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("info,userdefined_field", TRUE)
          END IF               
      END IF  
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i510_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i510_q()
            END IF
         WHEN "delete"   #NO:6908
            IF cl_chk_act_auth() THEN
               CALL i510_r()
            END IF
         WHEN "modify"   #NO:6908
            IF cl_chk_act_auth() THEN
               CALL i510_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i510_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "output"
           # IF cl_chk_act_auth() THEN
        #str---add by huanglf160905
             LET l_wc='tc_sfd01="',g_tc_sfd.tc_sfd01,'"'
                LET g_msg = "csfr012", #FUN-C30085 add
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' '",g_bgjob CLIPPED,"'  '' '1'",
                   " '",l_wc CLIPPED,"' "
                CALL cl_cmdrun(g_msg)
       #str----add by huanglf160905
            #END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "sets"   #NO:6908
            IF cl_chk_act_auth() THEN
               CALL i510_d()
               IF g_success='Y' THEN #TQC-DB0051
                 CALL i510_b()
               END IF #TQC-DB0051 
            END IF
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i510_y_chk()
               IF g_success = "Y" THEN
                  CALL i510_y_upd()
                  IF g_tc_sfd.tc_sfd04='X' THEN  #FUN-840012
                     LET g_chr='Y' 
                  ELSE 
                     LET g_chr='N' 
                  END IF  
                  DISPLAY BY NAME g_tc_sfd.tc_sfd04
                  CALL i510_pic() #圖形顯示
                  #FUN-AB0001---add----str--
                  CALL i510_sub_refresh(g_tc_sfd.tc_sfd01) RETURNING g_tc_sfd.*
                  CALL i510_show()
                  #FUN-AB0001---add----end--
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               #TQC-C50227 add begin---- 拆解組合工單不能取消審核
               LET l_cnt=0
               LET l_tc_sfd01_doc = g_tc_sfd.tc_sfd01[1,g_doc_len]
               SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy70 = l_tc_sfd01_doc
               IF l_cnt > 0 THEN 
                  CALL cl_err('','asf-599',1)
               ELSE    
                  #TQC-C50227 add  end------            
                 #CALL i510_w() #FUN-920175
                  CALL i510_sub_w(g_tc_sfd.tc_sfd01,g_action_choice,TRUE)   #FUN-920175
                  CALL i510_sub_refresh(g_tc_sfd.tc_sfd01) RETURNING g_tc_sfd.*  #FUN-920175
                  CALL i510_show()  #FUN-920175
               END IF ##TQC-C50227
            END IF

         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL i510sub_x(g_tc_sfd.tc_sfd01,g_action_choice,TRUE)   #FUN-920175       #CHI-D20010
               --CALL i510sub_x(g_tc_sfd.tc_sfd01,g_action_choice,TRUE,1)                   #CHI-D20010
               --CALL i510sub_refresh(g_tc_sfd.tc_sfd01) RETURNING g_tc_sfd.*  #FUN-920175
               --CALL i510_show()  #FUN-920175
            END IF
         #CHI-D20010---add--str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
              #CALL i510sub_x(g_tc_sfd.tc_sfd01,g_action_choice,TRUE)   #FUN-920175       #CHI-D20010
               --CALL i510sub_x(g_tc_sfd.tc_sfd01,g_action_choice,TRUE,2)                   #CHI-D20010
               --CALL i510sub_refresh(g_tc_sfd.tc_sfd01) RETURNING g_tc_sfd.*  #FUN-920175
               --CALL i510_show()  #FUN-920175
            END IF
         #add by darcy 2022年3月4日 s---
         WHEN "alteration"
            IF cl_chk_act_auth() THEN
               CALL i510_2()
            END IF
         #add by darcy 2022年3月4日 e---
         #add by darcy: 2022-03-14 14:31:14 s---
         WHEN "alteration2"
            IF cl_chk_act_auth() THEN
               CALL i510_2()
            END IF
         #add by darcy: 2022-03-14 14:31:14 e---
 
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sfe),base.TypeInfo.create(g_tc_sff),'')
               END IF
            #FUN-CB0014---add---str---
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_tc_sfd_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---
         
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_tc_sfd.tc_sfd01 IS NOT NULL THEN
                 LET g_doc.column1 = "tc_sfd01"
                 LET g_doc.value1 = g_tc_sfd.tc_sfd01
                 CALL cl_doc()
               END IF
         END IF
                           
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_sfe),base.TypeInfo.create(g_tc_sff),'')
            END IF

         #FUN-AB0001---add----str---
         WHEN "approval_status"               #簽核狀況
           IF cl_chk_act_auth() THEN          #DISPLAY ONLY
              #IF aws_condition2() THEN
                 #CALL aws_efstat2()
              #END IF
           END IF

         WHEN "easyflow_approval"             #EasyFlow送簽
           IF cl_chk_act_auth() THEN
             #FUN-C20027 add str---
              SELECT * INTO g_tc_sfd.* FROM tc_sfd_file
               WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
              CALL i510_show()
              CALL i510_b_fill(' 1=1')
             #FUN-C20027 add end---
              #CALL i510_ef()
              CALL i510_show()  #FUN-C20027 add
           END IF
         #@WHEN "准"
         WHEN "agree"
              --IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                 --CALL i510sub_y_upd(g_tc_sfd.tc_sfd01,g_action_choice,FALSE) #CALL 原確認的 update 段
                      --RETURNING g_tc_sfd.*
                 --CALL i510sub_refresh(g_tc_sfd.tc_sfd01) RETURNING g_tc_sfd.*
                 --CALL i510_show()
              --ELSE
                 --LET g_success = "Y"
                 --IF NOT aws_efapp_formapproval() THEN #執行 EF 簽核
                    --LET g_success = "N"
                 --END IF
              --END IF
              --IF g_success = 'Y' THEN
                 --IF cl_confirm('aws-081') THEN    #詢問是否繼續下一筆資料的簽核
                    --IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       --LET l_flowuser = 'N'
                       --LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                       --IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                             --CALL i510_q()
                             #傳入簽核模式時不應執行的 action 清單
                             --CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,    #CHI-D20010 add--undo_void                                                        confirm, undo_confirm, stock_post, undo_post, easyflow_approval,                                                         sets, gen_transfer_note, reproduce, regen_detail, s_icdout, exporttoexcel, modi_lot, warahouse_modify, barcode_qty_allot")  #DEV-D30026 add barcode_qty_allot   
                                  --RETURNING g_laststage
                       --ELSE
                           --EXIT WHILE
                       --END IF
                     --ELSE
                           --EXIT WHILE
                     --END IF
                 --ELSE
                    --EXIT WHILE
                 --END IF
              --END IF

         #@WHEN "不准"
         WHEN "deny"
             --IF (l_creator := aws_efapp_backflow()) IS NOT NULL THEN #退回關卡
                --IF aws_efapp_formapproval() THEN   #執行 EF 簽核
                   --IF l_creator = "Y" THEN         #當退回填表人時
                      --LET g_tc_sfd.tc_sfd15 = 'R'        #顯示狀態碼為 'R' 送簽退回
                      --DISPLAY BY NAME g_tc_sfd.tc_sfd15
                   --END IF
                   --IF cl_confirm('aws-081') THEN #詢問是否繼續下一筆資料的簽核
                      --IF aws_efapp_getnextforminfo() THEN   #取得下一筆簽核單號
                          --LET l_flowuser = 'N'
                          --LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                          --IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                                --CALL i510_q()
                                #傳入簽核模式時不應執行的 action 清單
                                --CALL aws_efapp_flowaction("insert, modify, delete, detail, query, locale, void, undo_void,    #CHI-D20010--ADD--undo_void                                                           confirm, undo_confirm, stock_post, undo_post, easyflow_approval,                                                            sets, gen_transfer_note, reproduce, regen_detail, s_icdout, exporttoexcel, modi_lot, warahouse_modify, barcode_qty_allot")  #DEV-D30026 add barcode_qty_allot  
                                     --RETURNING g_laststage
                          --ELSE
                                --EXIT WHILE
                          --END IF
                      --ELSE
                            --EXIT WHILE
                      --END IF
                   --ELSE
                      --EXIT WHILE
                   --END IF
                --END IF
              --END IF

         #@WHEN "加簽"
         WHEN "modify_flow"
              --IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                 --LET l_flowuser = 'Y'
              --ELSE
                 --LET l_flowuser = 'N'
              --END IF

         #@WHEN "撤簽"
         WHEN "withdraw"
              --IF cl_confirm("aws-080") THEN
                 --IF aws_efapp_formapproval() THEN
                    --EXIT WHILE
                 --END IF
              --END IF

         #@WHEN "抽單"
         WHEN "org_withdraw"
              --IF cl_confirm("aws-079") THEN
                 --IF aws_efapp_formapproval() THEN
                    --EXIT WHILE
                 --END IF
              --END IF
    
        #@WHEN "簽核意見"
         WHEN "phrase"
              --CALL aws_efapp_phrase()
         #FUN-AB0001---add----end---
      END CASE
 
 END WHILE
 CLOSE i510_cs
 
END FUNCTION

FUNCTION i510_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550052  #No.FUN-680121 SMALLINT
    DEFINE l_cnt1      LIKE type_file.num5   #TQC-9B0134 add
    DEFINE l_y         LIKE type_file.chr20
    DEFINE l_m         LIKE type_file.chr20
    DEFINE l_str       LIKE type_file.chr20
    DEFINE l_tmp       LIKE type_file.chr20
    IF s_shut(0) THEN RETURN END IF
 
    MESSAGE ""
    CLEAR FORM
    CALL g_tc_sfe.clear()
    CALL g_tc_sff.clear()
    INITIALIZE g_tc_sfd.* TO NULL
    LET g_tc_sfd_o.* = g_tc_sfd.*
    LET g_tc_sfd_t.* = g_tc_sfd.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_tc_sfd.tc_sfd02  =g_today
        LET g_tc_sfd.tc_sfd03  =g_today   #No.B182 010502 add
        LET g_tc_sfd.tc_sfd04  ='N'
        LET g_tc_sfd.tc_sfd05  ='N'
        LET g_tc_sfd.tc_sfduser=g_user  #NO:6908
        LET g_tc_sfd.tc_sfdoriu = g_user #FUN-980030
        LET g_tc_sfd.tc_sfdorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_tc_sfd.tc_sfdgrup=g_grup  #NO:6908
        LET g_tc_sfd.tc_sfddate=g_today #NO:6908
        LET g_tc_sfd.tc_sfd06  =g_grup  #FUN-670103
        LET g_tc_sfd.tc_sfdud02 = g_user
        CALL i510_tc_sfdud02('d')
        LET g_tc_sfd.tc_sfdplant = g_plant #FUN-980008 add
        LET g_tc_sfd.tc_sfdlegal = g_legal #FUN-980008 add
        
        CALL i510_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_tc_sfd.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF

        LET l_y =YEAR(g_today)
        LET l_y = l_y USING '&&&&' 
        LET l_y = l_y[3,4]
        LET l_m =MONTH(g_today)
        LET l_m = l_m USING '&&' 
        LET l_str='SQA-' CLIPPED,l_y clipped,l_m CLIPPED
        SELECT max(substr(tc_sfd01,9,4)) INTO l_tmp FROM tc_sfd_file
         WHERE substr(tc_sfd01,1,8)=l_str
        IF cl_null(l_tmp) THEN 
           LET l_tmp = '0001' 
        ELSE 
           LET l_tmp = l_tmp + 1
           LET l_tmp = l_tmp USING '&&&&'     
        END IF 
        LET g_tc_sfd.tc_sfd01 = l_str clipped,l_tmp
        
        IF g_tc_sfd.tc_sfd01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK     #No:7829
        DISPLAY BY NAME g_tc_sfd.tc_sfd01,g_tc_sfd.tc_sfd07 #FUN-670103 
 
        IF cl_null(g_tc_sfd.tc_sfd03) THEN
           LET g_tc_sfd.tc_sfd03  =g_today   #No.B182 010502 add
           DISPLAY BY NAME g_tc_sfd.tc_sfd03
        END IF
        INSERT INTO tc_sfd_file VALUES (g_tc_sfd.*)
        IF STATUS THEN
           CALL cl_err3("ins","tc_sfd_file",g_tc_sfd.tc_sfd01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_tc_sfd.tc_sfd01,'I')
 
        LET g_tc_sfd_t.* = g_tc_sfd.*
        LET g_rec_d = 0
        CALL g_tc_sfe.clear()
        CALL i510_d()                   #輸入單身-tc_sfe
 
        IF g_success = "N" THEN
           EXIT WHILE
        END IF
 
        LET g_rec_b =0
        CALL g_tc_sff.clear()
        SELECT COUNT(*) INTO l_cnt1 FROM tc_sff_file
         WHERE tc_sff01 = g_tc_sfd.tc_sfd01
        CALL i510_g_b()
        CALL i510_b_fill(" 1=1")
   #FUN-A20048 --begin #其他發料時，按以下處理
        IF g_tc_sfd06 MATCHES '[24]' AND l_cnt1 = 0 THEN 
           #CALL i510_g_b_1()
        ELSE 
           #CALL i510_b()  #輸入單身-tc_sff
        END IF 
   #FUN-A20048  --end 
        #IF g_cnt>0 AND g_smy.smyprint='Y' THEN CALL i510_out() END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i510_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfd.tc_sfd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01=g_tc_sfd.tc_sfd01
    IF g_tc_sfd.tc_sfd04 = 'Y' THEN CALL cl_err('','9023',1) RETURN END IF #FUN-660106
    IF g_tc_sfd.tc_sfd04 = 'X'   THEN CALL cl_err('','9024',1) RETURN END IF #FUN-660106
    #FUN-AB0001  add str ---
    IF g_tc_sfd.tc_sfd04='Y' THEN
       CALL cl_err('','mfg3168',0)   #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-AB0001  add end ---

    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_tc_sfd_o.* = g_tc_sfd.*
 
    BEGIN WORK
 
    OPEN i510_cl USING g_tc_sfd.tc_sfd01                 #09/10/21 xiaofeizhu Add
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i510_cl INTO g_tc_sfd.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE i510_cl ROLLBACK WORK RETURN
    END IF
    CALL i510_show()
    WHILE TRUE
        LET g_tc_sfd.tc_sfdmodu=g_user              #NO:6908
        LET g_tc_sfd.tc_sfddate=g_today             #NO:6908
        CALL i510_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_tc_sfd.*=g_tc_sfd_t.*
            CALL i510_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF

        UPDATE tc_sfd_file SET * = g_tc_sfd.* WHERE tc_sfd01 = g_tc_sfd_o.tc_sfd01      #09/10/21 xiaofeizhu Add #No.TQC-9A0130 mod
        IF STATUS THEN 
           CALL cl_err3("upd","tc_sfd_file",g_tc_sfd_t.tc_sfd01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE END IF
        IF g_tc_sfd.tc_sfd01 != g_tc_sfd_t.tc_sfd01 THEN CALL i510_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i510_cl
    COMMIT WORK
    CALL i510_show()                          #顯示最新資料   #FUN-AB0001 add
    CALL cl_flow_notify(g_tc_sfd.tc_sfd01,'U')
 
END FUNCTION

FUNCTION i510_chkkey()
    UPDATE tc_sff_file SET tc_sff01=g_tc_sfd.tc_sfd01 WHERE tc_sff01=g_tc_sfd_t.tc_sfd01
    IF STATUS THEN
       CALL cl_err3("upd","tc_sff_file",g_tc_sfd_t.tc_sfd01,"",STATUS,"","upd tc_sff01",1)  #No.FUN-660128
       LET g_tc_sfd.*=g_tc_sfd_t.* CALL i510_show() ROLLBACK WORK RETURN
    END IF
    UPDATE tc_sfe_file SET tc_sfe01=g_tc_sfd.tc_sfd01 WHERE tc_sfe01=g_tc_sfd_t.tc_sfd01
    IF STATUS THEN
       CALL cl_err3("upd","tc_sfe_file",g_tc_sfd_t.tc_sfd01,"",STATUS,"","upd tc_sfe01",1)  #No.FUN-660128
       LET g_tc_sfd.*=g_tc_sfd_t.* CALL i510_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION

FUNCTION i510_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)
  DEFINE li_result       LIKE type_file.num5                #No.FUN-550052  #No.FUN-680121 SMALLINT
  DEFINE l_azf03         LIKE azf_file.azf03   #FUN-630084
  DEFINE l_azfacti       LIKE azf_file.azfacti #FUN-630084
  DEFINE l_n             LIKE type_file.num5   #No.FUN-870117
  DEFINE l_azf09         LIKE azf_file.azf09   #No.FUN-930106
  DEFINE l_slip          LIKE smy_file.smyslip #No.FUN-980038
  DEFINE l_tc_sfd06         LIKE tc_sfd_file.tc_sfd06   #No.FUN-980038
  DEFINE l_smy72         LIKE smy_file.smy72   #No.MOD-9C0180
  DEFINE l_count         LIKE type_file.num5   #No.FUN-A90035 
 
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_tc_sfd.tc_sfdoriu,g_tc_sfd.tc_sfdorig,
        g_tc_sfd.tc_sfd02,g_tc_sfd.tc_sfd03,g_tc_sfd.tc_sfd06,g_tc_sfd.tc_sfd07,
        g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfd04,g_tc_sfd.tc_sfd05,g_tc_sfd.tc_sfd08,
        g_tc_sfd.tc_sfd10,g_tc_sfd.tc_sfd09,
        g_tc_sfd.tc_sfduser,g_tc_sfd.tc_sfdgrup,
        g_tc_sfd.tc_sfdmodu,g_tc_sfd.tc_sfddate    
        ,g_tc_sfd.tc_sfdud01,g_tc_sfd.tc_sfdud03,g_tc_sfd.tc_sfdud04,
        g_tc_sfd.tc_sfdud05,g_tc_sfd.tc_sfdud06,g_tc_sfd.tc_sfdud07,g_tc_sfd.tc_sfdud08,
        g_tc_sfd.tc_sfdud09,g_tc_sfd.tc_sfdud10,g_tc_sfd.tc_sfdud11,g_tc_sfd.tc_sfdud12,
        g_tc_sfd.tc_sfdud13,g_tc_sfd.tc_sfdud14,g_tc_sfd.tc_sfdud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i510_set_entry(p_cmd)
            CALL i510_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("tc_sfd01")
            CALL cl_set_comp_entry("tc_sfd07",TRUE)
 
        AFTER FIELD tc_sfd02
            IF NOT cl_null(g_tc_sfd.tc_sfd02) THEN
              #日期的控管由扣帳日期處理
	       IF g_tc_sfd.tc_sfd03 IS NULL THEN
                  LET g_tc_sfd.tc_sfd03 = g_tc_sfd.tc_sfd02
                  DISPLAY By NAME g_tc_sfd.tc_sfd03
               END IF
            END IF
 
        AFTER FIELD tc_sfd03
            IF NOT cl_null(g_tc_sfd.tc_sfd03) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_tc_sfd.tc_sfd03 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD tc_sfd03
	       END IF
               CALL s_yp(g_tc_sfd.tc_sfd03) RETURNING g_yy,g_mm
               IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD tc_sfd03
               END IF
            END IF
 
        AFTER FIELD tc_sfd06
           IF NOT cl_null(g_tc_sfd.tc_sfd06) THEN
              LET g_buf=''
              SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_tc_sfd.tc_sfd06
                 AND gemacti='Y'   #NO:6950
              IF STATUS THEN
                 SELECT pmc03 INTO g_buf FROM pmc_file 
                  WHERE pmc01= g_tc_sfd.tc_sfd06 AND pmcacti='Y'
                 IF STATUS THEN
                    CALL cl_err(g_tc_sfd.tc_sfd06,'asf-683',1)  #No.TQC-A50033
                    LET g_tc_sfd.tc_sfd06=g_tc_sfd_t.tc_sfd06         #No.TQC-A50033 
                    NEXT FIELD tc_sfd06
                 END IF #CHI-680019
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT i510_tc_sff09_chkall() THEN 
                  LET g_tc_sfd.tc_sfd06 = g_tc_sfd_t.tc_sfd06
                  NEXT FIELD tc_sfd06 
               END IF  
               #FUN-CB0087--add--end--
               DISPLAY g_buf TO gem02  #MOD-480346
            END IF

        AFTER FIELD tc_sfd07
            IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
               SELECT COUNT(*) INTO l_count FROM shm_file WHERE ta_shm05 = g_tc_sfd.tc_sfd07
               IF cl_null(l_count) OR l_count = 0  THEN
                  CALL cl_err('','csf-074',0)
                  NEXT FIELD tc_sfd07
               END IF  
            END IF

        #FUN-AB0001 add str ------
        AFTER FIELD tc_sfdud02  #申請人
            IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN
               CALL i510_tc_sfdud02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_sfd.tc_sfdud02,g_errno,0)
                  LET g_tc_sfd.tc_sfdud02 = g_tc_sfd_t.tc_sfdud02
                  DISPLAY BY NAME g_tc_sfd.tc_sfdud02
                  NEXT FIELD tc_sfdud02
               END IF
               #FUN-CB0087--add--str-- 
               IF NOT i510_tc_sff09_chkall() THEN 
                  LET g_tc_sfd.tc_sfdud02 = g_tc_sfd_t.tc_sfdud02
                  NEXT FIELD tc_sfdud02
               END IF  
               #FUN-CB0087--add--end--
            END IF
            LET g_tc_sfd_o.tc_sfdud02 = g_tc_sfd.tc_sfdud02
        #FUN-AB0001 add end ---
 
        AFTER INPUT 
           LET g_tc_sfd.tc_sfduser = s_get_data_owner("tc_sfd_file") #FUN-C10039
           LET g_tc_sfd.tc_sfdgrup = s_get_data_group("tc_sfd_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT      
         END IF
          #日期的控管由扣帳日期處理
           
           IF NOT cl_null(g_tc_sfd.tc_sfd03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_tc_sfd.tc_sfd03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD tc_sfd03
              END IF
              CALL s_yp(g_tc_sfd.tc_sfd03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD tc_sfd03
              END IF
           END IF
           #TQC-B60034--add--add--  
           #申請人
           IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN
               CALL i510_tc_sfdud02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_tc_sfd.tc_sfdud02,g_errno,0)
                  NEXT FIELD tc_sfdud02
               END IF
            END IF
            #TQC-B60034--add--end--

       AFTER FIELD tc_sfd10
          LET l_azf03=''
          IF NOT cl_null(g_tc_sfd.tc_sfd10) THEN
             IF g_sma.sma79='Y' THEN       #使用保稅系統
                SELECT azf03 INTO l_azf03 FROM azf_file
                    WHERE azf01=g_tc_sfd.tc_sfd10 AND azf02='A'
                 IF STATUS THEN
                   CALL cl_err3("sel","azf_file",g_tc_sfd.tc_sfd10,"",STATUS,"","select azf",1)  #No.FUN-660128
                   NEXT FIELD tc_sfd10
                 END IF
             ELSE
                 SELECT azf03 INTO l_azf03 FROM azf_file
                    WHERE azf01=g_tc_sfd.tc_sfd10 AND azf02='2'
                 IF STATUS THEN
                    CALL cl_err3("sel","azf_file",g_tc_sfd.tc_sfd10,"",STATUS,"","select azf",1)  #No.FUN-660128
                    NEXT FIELD tc_sfd10
                 END IF                                                                                                  
                 SELECT azf09 INTO l_azf09 FROM azf_file                                                                             
                  WHERE azf01 = g_tc_sfd.tc_sfd10                                                                                          
                    AND azf02 ='2'                                                                                                   
                 IF l_azf09 !='C' THEN                                                                                               
                    CALL cl_err('','aoo-411',1)                                                                                      
                    NEXT FIELD tc_sfd10                                                                                                 
                 END IF                               
             END IF
             SELECT azfacti INTO l_azfacti FROM azf_file 
                 WHERE azf01 = g_tc_sfd.tc_sfd10
                   AND azf02 ='2'                         #No.FUN-930106
             IF l_azfacti <> 'Y' THEN
                CALL cl_err('','aim-163',1)      #CHI-B40058
                NEXT FIELD tc_sfd10
             END IF
          END IF
          DISPLAY l_azf03 TO FORMONLY.azf03
        AFTER FIELD tc_sfdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        --AFTER FIELD tc_sfdud02
           --IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sfdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840042     ----end----
 
        ON ACTION controlp
          CASE
               WHEN INFIELD(tc_sfd06)
                    CALL q_gem_pmc(FALSE,TRUE,g_tc_sfd.tc_sfd06) RETURNING g_tc_sfd.tc_sfd06
                    DISPLAY BY NAME g_tc_sfd.tc_sfd06
                    NEXT FIELD tc_sfd06
               WHEN INFIELD(tc_sfd07)   #料表批號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="cq_ta_shm05"    #FUN-A90035
                    LET g_qryparam.default1 = g_tc_sfd.tc_sfd07
                    CALL cl_create_qry() RETURNING g_tc_sfd.tc_sfd07
                    DISPLAY BY NAME g_tc_sfd.tc_sfd07
                    NEXT FIELD tc_sfd07
               WHEN INFIELD(tc_sfd10)  #理由
                    IF g_sma.sma79='Y' THEN
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf"
                       LET g_qryparam.default1 = g_tc_sfd.tc_sfd10
                       LET g_qryparam.arg1 = "A"
                       CALL cl_create_qry() RETURNING g_tc_sfd.tc_sfd10
                    ELSE
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_azf01a"                #No.FUN-930106
                       LET g_qryparam.default1 = g_tc_sfd.tc_sfd10
                       LET g_qryparam.arg1 = "C"  
                       CALL cl_create_qry() RETURNING g_tc_sfd.tc_sfd10
                    END IF
                     DISPLAY BY NAME g_tc_sfd.tc_sfd10
                    NEXT FIELD tc_sfd10

               #FUN-AB0001 add str ----
               WHEN INFIELD(tc_sfdud02) #申請人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_tc_sfd.tc_sfdud02
                  DISPLAY BY NAME g_tc_sfd.tc_sfdud02
                  NEXT FIELD tc_sfdud02
               #FUN-AB0001 add end ----
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
END FUNCTION
 
FUNCTION i510_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    #IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    #   CALL cl_set_comp_entry("tc_sfd01",TRUE)
    #END IF
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("tc_sfd07",TRUE)
    END IF
END FUNCTION
 
FUNCTION i510_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    #IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    #CALL cl_set_comp_entry("tc_sfd01",FALSE)
    #END IF
 
    IF INFIELD(tc_sfd06) OR (NOT g_before_input_done) THEN
       IF p_cmd = 'u' THEN
          CALL cl_set_comp_entry("tc_sfd07",FALSE)
       END IF
    END IF
 
END FUNCTION


FUNCTION i510_q()
  DEFINE  l_tc_sfd01     LIKE tc_sfd_file.tc_sfd01


    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_tc_sfd.* to NULL              #No.FUN-6A0166
   #MESSAGE ""                              #FUN-AB0001 mark
    CALL cl_msg("")                         #FUN-AB0001 add

    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    INITIALIZE g_tc_sfd.* to NULL              #No:9485
    CALL i510_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_tc_sfd.* TO NULL RETURN
    END IF
    
   #MESSAGE " SEARCHING ! "                 #FUN-AB0001 mark
    CALL cl_msg(" SEARCHING ! ")            #FUN-AB0001 add

    OPEN i510_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_tc_sfd.* TO NULL
    ELSE
        LET g_row_count=0
        FOREACH i510_count INTO l_tc_sfd01
            LET g_row_count=g_row_count +1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
 
        CALL i510_fetch('F')                 # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE " SEARCHING ! "                  #FUN-AB0001 mark
    CALL cl_msg(" SEARCHING ! ")             #FUN-AB0001 add
END FUNCTION
 
FUNCTION i510_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i510_cs INTO g_tc_sfd.tc_sfd01                 #09/10/21 xiaofeizhu Add 
        WHEN 'P' FETCH PREVIOUS i510_cs INTO g_tc_sfd.tc_sfd01                 #09/10/21 xiaofeizhu Add
        WHEN 'F' FETCH FIRST    i510_cs INTO g_tc_sfd.tc_sfd01                 #09/10/21 xiaofeizhu Add
        WHEN 'L' FETCH LAST     i510_cs INTO g_tc_sfd.tc_sfd01                 #09/10/21 xiaofeizhu Add
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i510_cs INTO g_tc_sfd.tc_sfd01               #09/10/21 xiaofeizhu Add
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        INITIALIZE g_tc_sfd.* TO NULL
        CALL cl_err(g_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01           #09/10/21 xiaofeizhu Add

    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","tc_sfd_file",g_tc_sfd.tc_sfd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_tc_sfd.* TO NULL
    ELSE
       LET g_data_owner = g_tc_sfd.tc_sfduser      #FUN-4C0035
       LET g_data_group = g_tc_sfd.tc_sfdgrup      #FUN-4C0035
       LET g_data_plant = g_tc_sfd.tc_sfdplant #FUN-980030
       CALL i510_show()
    END IF
 
END FUNCTION
 
FUNCTION i510_show()
    DEFINE l_gem02 LIKE gem_file.gem02
    DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
    DEFINE l_azf03 LIKE azf_file.azf03 #FUN-630084
 
    LET g_tc_sfd_t.* = g_tc_sfd.*                #保存單頭舊值
    DISPLAY BY NAME g_tc_sfd.tc_sfdoriu,g_tc_sfd.tc_sfdorig,
        g_tc_sfd.tc_sfd01,g_tc_sfd.tc_sfd02,
        g_tc_sfd.tc_sfd03,g_tc_sfd.tc_sfd05,g_tc_sfd.tc_sfd06,
        g_tc_sfd.tc_sfd07,g_tc_sfd.tc_sfd08,
        g_tc_sfd.tc_sfd04,                                       
        g_tc_sfd.tc_sfd09,g_tc_sfd.tc_sfd10,g_tc_sfd.tc_sfd10,               #FUN-630084 add tc_sfd10
        g_tc_sfd.tc_sfduser,g_tc_sfd.tc_sfdgrup,                       #NO:6908
        g_tc_sfd.tc_sfdmodu,g_tc_sfd.tc_sfddate                        #NO:6908
        ,g_tc_sfd.tc_sfdud01,g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfdud03,g_tc_sfd.tc_sfdud04,
        g_tc_sfd.tc_sfdud05,g_tc_sfd.tc_sfdud06,g_tc_sfd.tc_sfdud07,g_tc_sfd.tc_sfdud08,
        g_tc_sfd.tc_sfdud09,g_tc_sfd.tc_sfdud10,g_tc_sfd.tc_sfdud11,g_tc_sfd.tc_sfdud12,
        g_tc_sfd.tc_sfdud13,g_tc_sfd.tc_sfdud14,g_tc_sfd.tc_sfdud15 

    CALL i510_tc_sfdud02('d')                      #FUN-AB0001 add
 
    LET g_buf = s_get_doc_no(g_tc_sfd.tc_sfd01)     #No.FUN-550052
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=g_tc_sfd.tc_sfd06
    DISPLAY l_gem02 TO FORMONLY.gem02
    CALL i510_pic() #圖形顯示
    CALL i510_d_fill(g_wc2)
 
   #str MOD-A50110 mod
   #CALL i510_b_fill(g_wc3)

    CALL i510_b_fill(g_wc3)
   #end MOD-A50110 mod
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i510_r()
  DEFINE l_chr,l_sure LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
         l_tc_sff        RECORD LIKE tc_sff_file.*
  DEFINE l_imm03  LIKE imm_file.imm03
  DEFINE l_tc_sfd01  LIKE tc_sfd_file.tc_sfd01,
         l_cnt    LIKE type_file.num10        #No.FUN-680121 INTEGER #FUN-5C0114
  DEFINE l_i      LIKE type_file.num5         #no.CHI-860008
 
    IF s_shut(0) THEN RETURN END IF
    IF g_tc_sfd.tc_sfd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01=g_tc_sfd.tc_sfd01
    IF g_tc_sfd.tc_sfd04 = 'Y'   THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660106
    IF g_tc_sfd.tc_sfd04 = 'X'   THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660106

 
    BEGIN WORK
 
    OPEN i510_cl USING g_tc_sfd.tc_sfd01                     #09/10/21 xiaofeizhu Add
    IF STATUS THEN
       CALL cl_err("OPEN i510_cl:", STATUS, 1)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i510_cl INTO g_tc_sfd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)
       CLOSE i510_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i510_show()
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "tc_sfd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_tc_sfd.tc_sfd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete tc_sfd,tc_sff!"
#MOD-D90093 add begin--------------------------- 
        FOR l_i = 1 TO g_rec_b
           IF NOT s_lot_del(g_prog,g_tc_sfd.tc_sfd01,'',0,g_tc_sff[l_i].tc_sff04,'DEL')  THEN
              ROLLBACK WORK
              RETURN
           END IF
        END FOR
#MOD-D90093 add end-----------------------------

        DELETE FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","tc_sfd_file",g_tc_sfd.tc_sfd01,"",SQLCA.SQLCODE,"","No tc_sfd deleted",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
 
        DELETE FROM tc_sfe_file WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","tc_sfe_file",g_tc_sfd.tc_sfd01,"",STATUS,"","del tc_sfe",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
 
# 當有耗材產生時,應將asft620之耗材單號清為NULL
        IF g_tc_sfd06 = '4' THEN
           SELECT COUNT(*) INTO g_cnt FROM sfu_file
            WHERE sfu09 = g_tc_sfd.tc_sfd01
           IF g_cnt > 0 THEN
              UPDATE sfu_file SET sfu09 = NULL
               WHERE sfu09 = g_tc_sfd.tc_sfd01
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","sfu_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd sfu",1)  #No.FUN-660128
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           # 當有耗材產生時,應將apmt730之耗材單號清為NULL                                                     
           SELECT COUNT(*) INTO g_cnt FROM rvu_file                                                                                 
            WHERE rvu16 = g_tc_sfd.tc_sfd01                                                                                               
           IF g_cnt > 0 THEN                                                                                                        
              UPDATE rvu_file SET rvu16 = NULL                                                                                      
               WHERE rvu16 = g_tc_sfd.tc_sfd01                                                                                            
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                  
                 CALL cl_err3("upd","rvu_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd rvu",1)                                                
                 ROLLBACK WORK                                                                                                      
                 RETURN                                                                                                             
              END IF                                                                                                                
           END IF                                                                                                                   
           SELECT COUNT(*) INTO g_cnt FROM srf_file
            WHERE srf06 = g_tc_sfd.tc_sfd01
           IF g_cnt > 0 THEN
              UPDATE srf_file SET srf06 = NULL
               WHERE srf06 = g_tc_sfd.tc_sfd01
              IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                 CALL cl_err3("upd","srf_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd srf",1)  #No.FUN-660128
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
        END IF
        IF g_tc_sfd06='C' THEN #由asrt300產生
           UPDATE srf_file set srf06=null WHERE srf06=g_tc_sfd.tc_sfd01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","srf_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd srf",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
        END IF
        IF g_tc_sfd06 MATCHES '[BC]' THEN #由asrt340產生
           UPDATE sro_file set sro13=null,sro14=null WHERE sro13=g_tc_sfd.tc_sfd01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","sro_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd sro",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
           DELETE FROM srp_file WHERE srp13=g_tc_sfd.tc_sfd01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","srp_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd srp",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
        END IF
        IF (g_tc_sfd06 MATCHES '[1234567]') AND (g_tc_sfd06 <> '8') THEN         #No.MOD-570241 add tc_sfd06的判斷  #FUN-5C0114
           DECLARE i510_upd_sfb CURSOR FOR
             SELECT * FROM tc_sff_file WHERE tc_sff01 = g_tc_sfd.tc_sfd01
           FOREACH i510_upd_sfb INTO l_tc_sff.*
             IF STATUS THEN CALL cl_err('foreach tc_sff',STATUS,0) EXIT FOREACH END IF
             SELECT COUNT(*) INTO g_cnt FROM sfa_file
              WHERE sfa01 = l_tc_sff.tc_sff03
                AND sfa06 > 0
             IF g_cnt > 0 THEN CONTINUE FOREACH END IF
             SELECT COUNT(*) INTO g_cnt FROM sfb_file                                                                               
              WHERE sfb01 = l_tc_sff.tc_sff03                                                                                             
                AND sfb081> 0                                                                                                       
             IF g_cnt > 0 THEN CONTINUE FOREACH END IF                                                                              
             SELECT COUNT(*) INTO g_cnt FROM sfu_file,sfv_file
               WHERE sfv11 = l_tc_sff.tc_sff03
                 AND sfv01 = sfu01
                 AND sfupost = 'Y'

             IF g_cnt > 0 THEN CONTINUE FOREACH END IF
             UPDATE sfb_file SET sfb04 = '2' WHERE sfb01 = l_tc_sff.tc_sff03
             IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                CALL cl_err3("upd","sfb_file",l_tc_sff.tc_sff03,"",STATUS,"","upd sfb",1)  #No.FUN-660128
                ROLLBACK WORK
                RETURN
             END IF
           END FOREACH
        END IF             #No.MOD-570241
        DELETE FROM tc_sff_file WHERE tc_sff01 = g_tc_sfd.tc_sfd01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","tc_sff_file",g_tc_sfd.tc_sfd01,"",STATUS,"","del tc_sff",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
 
        LET l_imm03=''
        SELECT imm03 INTO l_imm03 FROM imm_file
         WHERE imm01 = g_tc_sfd.tc_sfd08 AND imm09=g_tc_sfd.tc_sfd01
           AND immconf != 'X' #FUN-660029
        IF SQLCA.SQLCODE = 0  THEN
           IF l_imm03='N' THEN
             DELETE FROM imm_file WHERE imm01=g_tc_sfd.tc_sfd08
                                    AND imm09=g_tc_sfd.tc_sfd01
             IF STATUS THEN
                CALL cl_err3("del","imm_file",g_tc_sfd.tc_sfd01,g_tc_sfd.tc_sfd08,STATUS,"","del imm",1)  #No.FUN-660128
                ROLLBACK WORK RETURN
             END IF
             DELETE FROM imn_file WHERE imn01=g_tc_sfd.tc_sfd08
             IF STATUS THEN
                CALL cl_err3("del","imn_file",g_tc_sfd.tc_sfd08,"",STATUS,"","del imm",1)  #No.FUN-660128
                ROLLBACK WORK RETURN
             END IF
           END IF
       END IF
 
       #delete時
       #因挪料作業產生的發/退料單tc_sfd10 IS NOT NULL
       #發料單=> UPDATE sfm09 = NULL
       #退料單=> UPDATE sfm07 = NULL
        IF NOT cl_null(g_tc_sfd.tc_sfd10) THEN
            IF g_tc_sfd06 = '6' OR g_tc_sfd06 = '8' THEN #退料
                UPDATE sfm_file
                   SET sfm07 = NULL
                 WHERE sfm00 = g_tc_sfd.tc_sfd10
            END IF
            IF g_tc_sfd06 = '1' OR g_tc_sfd06 = '3' THEN #發料
                UPDATE sfm_file
                   SET sfm09 = NULL
                 WHERE sfm00 = g_tc_sfd.tc_sfd10
            END IF
            IF STATUS THEN
               CALL cl_err3("upd","sfm_file",g_tc_sfd.tc_sfd10,"",STATUS,"","UPDATE sfm",1)  #No.FUN-660128
               ROLLBACK WORK RETURN
            END IF
        END IF

#MOD-D90093 mark begin----------------------- 
##TQC-C10033 --unmark
#  #MOD-C10100 --begin--
#          FOR l_i = 1 TO g_rec_b 
#  #            IF NOT s_del_rvbs("1",g_tc_sfd.tc_sfd01,g_tc_sff[l_i].tc_sff02,0)  THEN        #FUN-880129  #MOD-890271 modify 2->1 #No.TQC-B90236 mark
#              IF NOT s_lot_del(g_prog,g_tc_sfd.tc_sfd01,'',0,g_tc_sff[l_i].tc_sff04,'DEL')  THEN #No.TQC-B90236 add
#                 ROLLBACK WORK
#                 RETURN
#              END IF
#          END FOR
#  #MOD-C10100 --end--
##TQC-C10033 --unmark
#MOD-D90093 mark end-------------------------
 
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
           VALUES (g_prog,g_user,g_today,g_msg,g_tc_sfd.tc_sfd01,'delete',g_plant,g_legal) #FUN-980008 add
 
        CLEAR FORM
        CALL g_tc_sfe.clear()
        CALL g_tc_sff.clear()
 
    	INITIALIZE g_tc_sfd.* TO NULL
        MESSAGE ""
        LET g_row_count=0
        FOREACH i510_count INTO l_tc_sfd01
            LET g_row_count=g_row_count +1
        END FOREACH
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE i510_cs
           CLOSE i510_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt  #ATTRIBUTE(MAGENTA)
        OPEN i510_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i510_fetch('L')
        ELSE
           IF g_curs_index>0 THEN #MOD-840301
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL i510_fetch('/')
           ELSE
              CALL cl_err('','asf-079',0) #MOD-840301
           END IF
        END IF
 
    END IF
 
    CLOSE i510_cl
    COMMIT WORK
    CALL cl_flow_notify(g_tc_sfd.tc_sfd01,'D')
 
END FUNCTION
 
FUNCTION i510_d()
 DEFINE l_cnt,l_cnt_1  LIKE type_file.num5    #No.FUN-680121 SMALLINT
 
   IF  cl_null(g_tc_sfd.tc_sfd01) THEN RETURN END IF   #No:9485
   LET g_success = 'Y'  #No:7792,7867
   IF g_tc_sfd.tc_sfd04 = 'Y' THEN 
      CALL cl_err('','9023',1) 
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF #FUN-660106
   IF g_tc_sfd.tc_sfd04 = 'X' THEN 
      CALL cl_err('','9024',1) 
      LET g_success = 'N' #TQC-DB0051
      RETURN 
   END IF #FUN-660106
   IF g_tc_sfd.tc_sfd04='Y' THEN
      CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
      LET g_success = 'N' #TQC-DB0051
      RETURN
   END IF
   #FUN-AB0001  add end ---

   WHILE TRUE
      CALL i510_d_i()
      CALL i510_d_fill(' 1=1')
      
      LET l_cnt = 0
      LET l_cnt_1 = 0
      SELECT COUNT(*) INTO l_cnt FROM tc_sfe_file
       WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
      SELECT COUNT(*) INTO l_cnt_1 FROM tc_sff_file
       WHERE tc_sff01 = g_tc_sfd.tc_sfd01
      IF g_argv2 = '1' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-362') THEN
            #未輸入單身資料,則取消單頭資料
            IF g_argv2 = '1' AND l_cnt=0 AND l_cnt_1 = 0 THEN
               IF cl_confirm('9042') THEN
                  DELETE FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
                  LET g_cnt=0
                  CLEAR FORM
                  CALL g_tc_sfe.clear()
                  CALL g_tc_sff.clear()
                  INITIALIZE g_tc_sfd.* TO NULL    #TQC-C40150
                  LET g_success = 'N'
               END IF
            END IF
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF
#MOD-D60042 add begin---------------------------
      IF g_argv2 = '3' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-687') THEN
            #未輸入單身資料,則取消單頭資料
            IF g_argv2 = '3' AND l_cnt=0 AND l_cnt_1 = 0 THEN
               IF cl_confirm('9042') THEN
                  DELETE FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
                  LET g_cnt=0
                  CLEAR FORM
                  CALL g_tc_sfe.clear()
                  CALL g_tc_sff.clear()
                  INITIALIZE g_tc_sfd.* TO NULL    #TQC-C40150
                  LET g_success = 'N'
               END IF
            END IF
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF
      IF g_argv2 = '6' AND l_cnt=0 THEN
         IF NOT cl_confirm('asf-688') THEN
            #未輸入單身資料,則取消單頭資料
            IF g_argv2 = '6' AND l_cnt=0 AND l_cnt_1 = 0 THEN
               IF cl_confirm('9042') THEN
                  DELETE FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
                  LET g_cnt=0
                  CLEAR FORM
                  CALL g_tc_sfe.clear()
                  CALL g_tc_sff.clear()
                  INITIALIZE g_tc_sfd.* TO NULL    #TQC-C40150
                  LET g_success = 'N'
               END IF
            END IF
            LET g_success = 'N'
            EXIT WHILE
         END IF
         CONTINUE WHILE
      END IF
#MOD-D60042 add end-----------------------------
      EXIT WHILE
  END WHILE
 
END FUNCTION
 
FUNCTION i510_d_i()
   DEFINE i,j           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE qty1,qty2	LIKE tc_sfe_file.tc_sfe03    #No.FUN-680121 DEC(15,3)
   DEFINE unissue_qty	LIKE sfb_file.sfb08,   #No.FUN-680121 DEC(15,3),
          l_qty         LIKE sre_file.sre07,   #No.FUN-680121 DEC(15,3),
          l_tot         LIKE img_file.img10    #No.FUN-680121 DEC(15,3)
   DEFINE l_sfb08 	LIKE sfb_file.sfb08    #No.FUN-680121 DEC(15,3)
   DEFINE l_sfb23 	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_sfb04	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_sfb02	LIKE sfb_file.sfb02
   DEFINE l_sfb06	LIKE sfb_file.sfb06,
          l_sfb09       LIKE sfb_file.sfb09,
          l_sfb81       LIKE sfb_file.sfb81,
          l_tc_sfe03       LIKE tc_sfe_file.tc_sfe03,
          l_tc_sfe02_t     LIKE tc_sfe_file.tc_sfe02,
          l_tc_sfe03_t     LIKE tc_sfe_file.tc_sfe03,
          l_tc_sfe03_o     LIKE tc_sfe_file.tc_sfe03,   #No.MOD-860012 
          l_tc_sfe03_r     LIKE tc_sfe_file.tc_sfe03,
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
   DEFINE l_str         STRING #FUN-5C0114
   DEFINE l_sfa062      LIKE sfa_file.sfa062 #TQC-670083
   DEFINE l_sfa03       LIKE sfa_file.sfa03
   DEFINE l_sfa08       LIKE sfa_file.sfa08
   DEFINE l_sfa12       LIKE sfa_file.sfa12
   DEFINE l_sfa27       LIKE sfa_file.sfa27
   DEFINE l_sfa05       LIKE sfa_file.sfa05   #TQC-980097 add
   DEFINE l_pmm01       LIKE pmm_file.pmm01    #TQC-990060
   DEFINE l_ima56       LIKE ima_file.ima56   #TQC-9B0061
   DEFINE l_faqty       LIKE ima_file.ima56   #TQC-9B0061
#  DEFINE l_per         LIKE type_file.num5   #TQC-9B0061         #MOD-AB0047
#  DEFINE l_per         LIKE tc_sfe_file.tc_sfe03   #MOD-B70193         #MOD-AB0047
   DEFINE l_per         LIKE type_file.num10  #MOD-B70193
   DEFINE l_qty1        LIKE tc_sfe_file.tc_sfe03   #TQC-9C0035
   DEFINE l_qty2        LIKE tc_sfe_file.tc_sfe03   #TQC-9C0035
   DEFINE l_sfb081 	    LIKE sfb_file.sfb081  #MOD-9C0240
   DEFINE l_sfa012       LIKE sfa_file.sfa012  #TQC-B30021
   DEFINE l_sfa013       LIKE sfa_file.sfa013  #TQC-B30021
   DEFINE l_tc_sfe03_flag   LIKE type_file.chr1   #FUN-B20095
   #MOD-BA0078 -- begin --
   DEFINE l_ima153      LIKE ima_file.ima153
   DEFINE l_allowqty    LIKE tc_sfe_file.tc_sfe03
   #MOD-BA0078 -- end --
  #DEFINE a_qty1        LIKE tc_sfe_file.tc_sfe03 #TQC-BC0130   #MOD-C80256 mark 
  #DEFINE a_qty2        LIKE tc_sfe_file.tc_sfe03 #TQC-BC0130   #MOD-C80256 mark
   DEFINE l_row         LIKE type_file.num10 #FUN-C70014  #总行数
   DEFINE l_shm08 	    LIKE shm_file.shm08
   DEFINE l_cmd         LIKE type_file.chr1   #FUN-C70014
   DEFINE l_count       LIKE type_file.num5   #FUN-C70014
   DEFINE l_n           LIKE type_file.num5   #FUN-C70014
   DEFINE l_tc_sfe014_t    LIKE tc_sfe_file.tc_sfe014  #FUN-C70014
   DEFINE l_shm08_sum   LIKE shm_file.shm08   #add by jixf 160809
   DEFINE l_tc_sfe03_sum   LIKE tc_sfe_file.tc_sfe03
   
   LET g_flag_tc_sfe03=0     #CHI-6C0005 add
 
   SELECT COUNT(*) INTO i FROM tc_sfe_file WHERE tc_sfe01=g_tc_sfd.tc_sfd01
   IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
      IF i=0 THEN
         DECLARE i501_s_sfq_c CURSOR FOR         
           SELECT shm012,'',shm05,'','',0,0,SUM(shm08),SUM(shm09),'Y'   #FUN-870097 add sfb95 #FUN-5C0114 add sfq05    #FUN-A70095 add 0
              FROM shm_file,sfb_file
             WHERE ta_shm05=g_tc_sfd.tc_sfd07 AND sfb01 =shm012
              AND sfb87 = 'Y'           #No.FUN-870117
             GROUP BY shm012,shm05
             ORDER BY shm012,shm05
         CALL g_tc_sfe.clear()
         LET i=1
        FOREACH i501_s_sfq_c INTO g_tc_sfe[i].tc_sfe02,
                                  g_tc_sfe[i].tc_sfe04,
                                  g_tc_sfe[i].sfb05,
                                  g_tc_sfe[i].ima02_a,
                                  g_tc_sfe[i].ima021_a,
                                  g_tc_sfe[i].tc_sfe07,   #NO.FUN-940008 add
                                  g_tc_sfe[i].tc_sfe03,
                                  qty1, qty2,
                                  g_tc_sfe[i].tc_sfeud02
           IF STATUS THEN
             CALL cl_err('fore sfd:',STATUS,1)  
              EXIT FOREACH
           END IF
           SELECT ima02,ima021 INTO g_tc_sfe[i].ima02_a, g_tc_sfe[i].ima021_a
             FROM ima_file WHERE ima01=g_tc_sfe[i].sfb05
           LET g_tc_sfe[i].tc_sfe03=qty1-qty2 
           IF g_tc_sfe[i].tc_sfe03<0 THEN LET g_tc_sfe[i].tc_sfe03=0 END IF
           LET i=i+1
         END FOREACH
         CALL g_tc_sfe.deleteElement(i)
         LET i = i - 1
      END IF
   END IF
 
   BEGIN WORK
 
   OPEN i510_cl USING g_tc_sfd.tc_sfd01                     #09/10/21 xiaofeizhu Add
   IF STATUS THEN
      CALL cl_err("OPEN i510_cl:", STATUS, 1)
      CLOSE i510_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i510_cl INTO g_tc_sfd.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i510_cl ROLLBACK WORK RETURN
   END IF
 
   LET g_tc_sfd.tc_sfdmodu=g_user              #NO:6908
   LET g_tc_sfd.tc_sfddate=g_today             #NO:6908
   DISPLAY BY NAME g_tc_sfd.tc_sfdmodu         #NO:6908
   DISPLAY BY NAME g_tc_sfd.tc_sfddate         #NO:6908
 
 
   LET g_success='Y'
   LET l_tc_sfe02_t = NULL
   LET l_tc_sfe03_t = NULL
   LET l_tc_sfe03_o = NULL      #No.MOD-860012 
 
   DISPLAY ARRAY g_tc_sfe TO s_tc_sfe.* ATTRIBUTE(COUNT=i,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
   END DISPLAY
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
   LET l_count = g_tc_sfe.getLength()     #FUN-C70014
   INPUT ARRAY g_tc_sfe WITHOUT DEFAULTS FROM s_tc_sfe.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         CALL i510_set_entry_d('a')
         CALL i510_set_no_entry_d('a')

      BEFORE INSERT
         INITIALIZE g_tc_sff[i].* TO NULL 
         LET g_tc_sfe[i].tc_sfeud02 = 'Y'
         NEXT FIELD tc_sfe02
         
      BEFORE ROW
         LET i = ARR_CURR()
         LET l_tc_sfe03_t = g_tc_sfe[i].tc_sfe03
         LET l_tc_sfe03_o = g_tc_sfe[i].tc_sfe03   #No.MOD-860012 
         LET l_tc_sfe02_t = g_tc_sfe[i].tc_sfe02   #FUN-940039 add
         LET l_tc_sfe03_flag = 'N'           #FUN-B20095
         #FUN-C70014 add begin-----------
         LET l_tc_sfe014_t = g_tc_sfe[i].tc_sfe014
         IF i > l_count THEN 
             LET l_cmd = 'a'
         ELSE 
             LET l_cmd = 'u'
         END IF 
         NEXT FIELD tc_sfe02
 
      BEFORE DELETE
        LET l_cnt = 0 
        SELECT COUNT(*) INTO l_cnt FROM tc_sff_file  
               WHERE tc_sff01 = g_tc_sfd.tc_sfd01
                 AND tc_sff03 = g_tc_sfe[i].tc_sfe02
 
       IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
       IF l_cnt > 0 THEN
          CALL cl_err (g_tc_sfe[i].tc_sfe02,'asf-795',1)
          CANCEL DELETE
          NEXT FIELD tc_sfe02
       END IF

      #FUN-C70014 add begin-------------
      AFTER FIELD tc_sfe014
         IF NOT cl_null(g_tc_sfe[i].tc_sfe014) THEN
            SELECT COUNT(*) INTO l_cnt FROM shm_file
             WHERE shm01 = g_tc_sfe[i].tc_sfe014
               AND shm28 = 'N'
            IF l_cnt = 0 THEN
               CALL cl_err('','asf-910',1)
               LET g_tc_sfe[i].tc_sfe014 = l_tc_sfe014_t
               NEXT FIELD tc_sfe014
            END IF
          
            SELECT shm012 INTO g_tc_sfe[i].tc_sfe02 FROM shm_file
             WHERE shm01 = g_tc_sfe[i].tc_sfe014 
               AND shm28 = 'N'
            DISPLAY BY NAME g_tc_sfe[i].tc_sfe02 
         END IF
         IF g_tc_sfd06 = 'D' THEN #FUN-C70014 add
            IF NOT i510_chk_tc_sfe(i,'1') THEN NEXT FIELD tc_sfe014 END IF  #FUN-C70014 add
         END IF 
      AFTER FIELD tc_sfe02
         LET g_tc_sfe02 = g_tc_sfe[i].tc_sfe02      #TQC-A30108
         IF (NOT cl_null(g_tc_sfe[i].tc_sfe02)) THEN #FUN-5C0114
            CALL i510_sfb01(g_tc_sfe[i].tc_sfe02)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tc_sfe[i].tc_sfe02,g_errno,0)
               NEXT FIELD tc_sfe02
            END IF
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01=g_tc_sfe[i].tc_sfe02
            IF l_sfb02 = '15' THEN
               CALL cl_err(g_tc_sfe[i].tc_sfe02,'asr-047',1)   #所輸入之工單型態
               NEXT FIELD tc_sfe02
            END IF
 
            SELECT COUNT(*) INTO l_cnt FROM snb_file
             WHERE snb01 = g_tc_sfe[i].tc_sfe02
               AND snbconf != 'X'   #MOD-B60143 add
               AND snb99 != '2'     #MOD-B60143 add
            IF l_cnt > 0 THEN
               CALL cl_err('sel-snb','asf-068',0)
               NEXT FIELD tc_sfe02
            END IF
            SELECT sfb02 INTO l_sfb02 FROM sfb_file
             WHERE sfb01 = g_tc_sfe[i].tc_sfe02
            IF l_sfb02 = '7' OR l_sfb02 = '8' THEN 

               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM pmm_file,pmn_file
                WHERE pmm01 = pmn01
                  AND pmn41 = g_tc_sfe[i].tc_sfe02
                  AND pmm18 = 'Y'
                  AND (pmm25 != '6' OR pmm25 != '9')
               IF cl_null(l_cnt)  OR l_cnt = 0 THEN 
                  CALL cl_err('','asf-117',0)
                  NEXT FIELD tc_sfe02
               END IF    
            END IF 
            #str---add by jixf 160810 若单头输入了投产批次号，那需要管控工单必须是当前批次号
            IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
               LET l_count=0
               SELECT COUNT(*) INTO l_count FROM shm_file 
                  WHERE shm012=g_tc_sfe[i].tc_sfe02 AND ta_shm05=g_tc_sfd.tc_sfd07
               IF l_count=0 OR cl_null(l_count) THEN 
                  CALL cl_err(g_tc_sfe[i].tc_sfe02,'csf-315',1)
                  NEXT FIELD tc_sfe02
               END IF 
            END IF 
            #end---add by jixf 160810 
            SELECT sfb05,sfb04,sfb23,sfb08,sfb06,sfb81,sfb02
              INTO g_tc_sfe[i].sfb05, l_sfb04, l_sfb23, l_sfb08,
                   l_sfb06,l_sfb81,l_sfb02
              FROM sfb_file
             WHERE sfb01 = g_tc_sfe[i].tc_sfe02
               AND sfb87 ='Y'
 
            IF STATUS THEN
               CALL cl_err3("sel","sfb_file",g_tc_sfe[i].tc_sfe02,"",STATUS,"","sel sfb",1)  #No.FUN-660128
               NEXT FIELD tc_sfe02
            END IF
            IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
               SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                WHERE shm012 = g_tc_sfe[i].tc_sfe02 
                  AND ta_shm05 = g_tc_sfd.tc_sfd07
            END IF 
 
            IF l_sfb04='1' THEN
               CALL cl_err('sfb04=1','asf-381',0) NEXT FIELD tc_sfe02
            END IF
 
            IF l_sfb04='8' THEN
               CALL cl_err('sfb04=8','asf-345',0) NEXT FIELD tc_sfe02
            END IF
 
            IF l_sfb81 > g_tc_sfd.tc_sfd02 THEN      #-->NO:0813
               CALL cl_err(g_tc_sfe[i].tc_sfe02,'asf-819',0) NEXT FIELD tc_sfe02
            END IF                             #----------
 
            IF l_sfb02=13 THEN  #bugno:4863
               CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD tc_sfe02
            END IF
 
            SELECT ima02,ima021 INTO g_tc_sfe[i].ima02_a, g_tc_sfe[i].ima021_a
              FROM ima_file
             WHERE ima01=g_tc_sfe[i].sfb05

         END IF

#FUN-B20095 ---------------------Begin-------------------------
      AFTER FIELD tc_sfe012 
         IF cl_null(g_tc_sfe[i].tc_sfe012) THEN
            LET g_tc_sfe[i].tc_sfe012 = ' '
         ELSE 
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM sfa_file
             WHERE sfa01 = g_tc_sfe[i].tc_sfe02 
               AND sfa012 = g_tc_sfe[i].tc_sfe012
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
            IF l_cnt < 1 THEN
               LET g_tc_sfe[i].tc_sfe012 = ' '
               NEXT FIELD tc_sfe012
            END IF
            CALL s_schdat_ecm014(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe012)  
               RETURNING g_tc_sfe[i].ecm014   
            DISPLAY BY NAME g_tc_sfe[i].ecm014       

               #IF g_sma.sma129='N' THEN  #FUN-C70014 mark
               IF g_sma.sma129='N' THEN 
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=g_tc_sfe[i].tc_sfe02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET qty1=l_sfb081
                  LET qty2=0
                  LET unissue_qty = l_sfb08 - l_sfb081 
               ELSE
                  LET qty1 = 0
                  LET qty2 = 0
                 #CALL i510_tc_sfe03_chk1(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012) #只选过账的,用于预设值
                  CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  #FUN-BC0060 mod   #FUN-C70014 add tc_sfe014
                       RETURNING qty1,qty2
                  IF qty1 IS NULL THEN LET qty1=0 END IF
                  IF qty2 IS NULL THEN LET qty2=0 END IF
                  
                  LET unissue_qty = l_sfb08-(qty1-qty2)
               END IF
               IF (g_tc_sfe[i].tc_sfe03 IS NULL OR
                  (l_tc_sfe02_t IS NULL OR l_tc_sfe02_t != g_tc_sfe[i].tc_sfe02)) AND 
                  l_tc_sfe03_flag = 'N' THEN   #FUN-B20095 add l_tc_sfe03_flag
                  IF g_argv1='1' THEN
                     LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                  ELSE
                     LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
                  END IF
               END IF
               IF g_tc_sfe[i].tc_sfe03 = 0 THEN
                  IF g_argv1='1' THEN 
                     IF g_sma.sma129 = 'Y' THEN
                        LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                     END IF
                  ELSE
                     LET g_tc_sfe[i].tc_sfe03 = qty1-qty2 
                  END IF
               END IF 
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = g_tc_sfe[i].tc_sfe02
               LET l_tc_sfe03 = 0
               LET l_tc_sfe03_r = 0
               IF cl_null(g_tc_sfe[i].tc_sfe04) THEN
                  LET g_tc_sfe[i].tc_sfe04 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理 
              #CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod #FUN-C70014 add tc_sfe014
               LET l_tc_sfe03 = l_qty1 - l_qty2
              #IF g_sma.sma129='N' THEN
               IF g_sma.sma129='N' THEN   #FUN-C70014 add g_tc_sfd06 <> 'D' 
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081
                                      FROM sfb_file
                                     WHERE sfb01=g_tc_sfe[i].tc_sfe02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_tc_sfe03 = l_sfb081
               END IF
               IF cl_null(l_tc_sfe03_o) THEN
                  LET l_tc_sfe03_o =0
               END IF
               IF l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_sfb08 OR 
                  (g_tc_sfd06 = 'D' AND l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_shm08) THEN  #FUN-C70014 add  
                  CALL cl_err(g_tc_sfe[i].tc_sfe02,'asf-704',0)
                  NEXT FIELD tc_sfe03       
               END IF
 
            LET g_tc_sfe[i].tc_sfe06=g_tc_sfe[i].tc_sfe03
            DISPLAY g_tc_sfe[i].tc_sfe07 TO tc_sfe0
               IF g_tc_sfe[i].tc_sfe03 <=0 THEN
                  CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-706',0)
                  NEXT FIELD tc_sfe03 
               END IF
         END IF   
#FUN-B20095 ---------------------End---------------------------         
      AFTER FIELD tc_sfe04
 
         IF cl_null(g_tc_sfe[i].tc_sfe04) THEN
            LET g_tc_sfe[i].tc_sfe04 = ' '
         ELSE                                      
            CALL i510_tc_sfe04(g_tc_sfe[i].tc_sfe04) RETURNING g_errno
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_tc_sfe[i].tc_sfe04,g_errno,1)
               NEXT FIELD tc_sfe04
            END IF
         END IF

            IF g_sma.sma129='N' THEN #FUN-C70014 add g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                   FROM sfb_file 
                                  WHERE sfb01=g_tc_sfe[i].tc_sfe02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET qty1=l_sfb081
               LET qty2=0
               LET unissue_qty = l_sfb08 - l_sfb081
            ELSE
               LET qty1 = 0
               LET qty2 = 0

            #將撈取qty1,qty2的部分整理到函數 i510_tc_sfe03_chk1()處理
             # CALL i510_tc_sfe03_chk1(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  #FUN-A70095  #只选过账的,用于预设值
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  #FUN-A70095  #FUN-BC0060 mod  #FUN-C70014 add tc_sfe014
                    RETURNING qty1,qty2        #FUN-A70095
         #此段功能由i510_tc_sfe03_chk1()代替
         #FUN-A70095 ---------------Begin----------------------
         #     IF g_tc_sfe[i].tc_sfe04 != ' ' THEN             #MOD-A30070               
         #       SELECT SUM(tc_sfe03) INTO qty1 FROM tc_sfe_file, tc_sfd_file
         #        WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #       #  AND tc_sfe04=g_tc_sfe[i].tc_sfe04                   #MOD-A30070
         #          AND (tc_sfe04=g_tc_sfe[i].tc_sfe04 OR tc_sfe04 = ' ')  #MOD-A30070  #FUN-AC0074 #TQC-B60349 restore
         #          AND tc_sfe01=tc_sfd01 AND tc_sfd06='1' AND tc_sfd04='Y'
         #       #  AND tc_sfe04=g_tc_sfe[i].tc_sfe04   #FUN-AC0074 TQC-B60349 mark
         #       
         #       SELECT SUM(tc_sfe03) INTO qty2 FROM tc_sfe_file, tc_sfd_file
         #        WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #       #  AND tc_sfe04=g_tc_sfe[i].tc_sfe04                   #MOD-A30070
         #          AND (tc_sfe04=g_tc_sfe[i].tc_sfe04 OR tc_sfe04 = ' ')  #MOD-A30070 #FUN-AC0074  #TQC-B60349 restore
         #          AND tc_sfe01=tc_sfd01 AND tc_sfd06='6' AND tc_sfd04='Y'
         #       #  AND tc_sfe04=g_tc_sfe[i].tc_sfe04   #FUN-AC0074  #TQC-B60349 mark
         #     #MOD-A30070 --BEGIN--
         #     ELSE
         #       SELECT SUM(tc_sfe03) INTO qty1 FROM tc_sfe_file, tc_sfd_file
         #        WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #          AND tc_sfe01=tc_sfd01 AND tc_sfd06='1' AND tc_sfd04='Y'
         #        # AND tc_sfe04=' ' #FUN-AC0074 #TQC-B60349  mark
         #     
         #       SELECT SUM(tc_sfe03) INTO qty2 FROM tc_sfe_file, tc_sfd_file
         #        WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #          AND tc_sfe01=tc_sfd01 AND tc_sfd06='6' AND tc_sfd04='Y' 
         #      #   AND tc_sfe04=' ' #FUN-AC0074  #TQC-B60349 mark
         #     END IF  
         #     #MOD-A30070 --END
         #FUN-A70095 ---------------End-----------------------
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)
            END IF
 
            IF (g_tc_sfe[i].tc_sfe03 IS NULL OR
               (l_tc_sfe02_t IS NULL OR l_tc_sfe02_t != g_tc_sfe[i].tc_sfe02)) AND
               l_tc_sfe03_flag = 'N' THEN   #FUN-B20095 add l_tc_sfe03_flag
               IF g_argv1='1' THEN
                  LET g_tc_sfe[i].tc_sfe03 = unissue_qty
               ELSE
                  LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
               END IF
            END IF
            IF g_tc_sfe[i].tc_sfe03 = 0 THEN
               IF g_argv1='1' THEN 
                  IF g_sma.sma129 = 'Y' THEN
                     LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                  END IF
               ELSE
                  LET g_tc_sfe[i].tc_sfe03 = qty1-qty2 
               END IF
            END IF   
            #---Add No.MOD-AB0071  将AFTER FIELD tc_sfe03的逻辑复制过来
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = g_tc_sfe[i].tc_sfe02
            #str------add by guanyao160824
            IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
               SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                WHERE shm012 = g_tc_sfe[i].tc_sfe02 
                  AND ta_shm05 = g_tc_sfd.tc_sfd07
            END IF
            #end------add by guanyao160824
            LET l_tc_sfe03 = 0
            LET l_tc_sfe03_r = 0
            IF cl_null(g_tc_sfe[i].tc_sfe04) THEN
               LET g_tc_sfe[i].tc_sfe04 = ' '
            END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理        #FUN-B20095
              #CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  RETURNING l_qty1,l_qty2    #FUN-B20095 #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  RETURNING l_qty1,l_qty2    
            LET l_tc_sfe03 = l_qty1 - l_qty2
           #IF g_sma.sma129='N' THEN    #FUN-C70014 mark
            IF g_sma.sma129='N' THEN   #FUN-C70014 add g_tc_sfd06 <> 'D' 
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081
                                   FROM sfb_file
                                  WHERE sfb01=g_tc_sfe[i].tc_sfe02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET l_tc_sfe03 = l_sfb081
            END IF
            IF cl_null(l_tc_sfe03_o) THEN
               LET l_tc_sfe03_o =0
            END IF
            IF l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_sfb08 OR     #No.MOD-860012
              (g_tc_sfd06 = 'D' AND l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_shm08) THEN  #FUN-C70014 add  
               CALL cl_err(g_tc_sfe[i].tc_sfe02,'asf-704',0)
               NEXT FIELD tc_sfe03                          #No.MOD-860012
            END IF
            #End Add No.MOD-AB0071
 
         LET g_tc_sfe[i].tc_sfe07=g_tc_sfe[i].tc_sfe03
         DISPLAY g_tc_sfe[i].tc_sfe07 TO tc_sfe07
        #MOD-AA0123---add---start---
            IF g_tc_sfe[i].tc_sfe03 <=0 THEN
               CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-706',0)
               NEXT FIELD tc_sfe03 
            END IF
 
      AFTER FIELD tc_sfe05
         IF (NOT g_tc_sfe[i].tc_sfe05 IS NULL) AND (g_tc_sfd06 MATCHES '[ABC]') THEN
            LET l_cnt=0
            SELECT COUNT(*) INTO l_cnt FROM sre_file
                                              WHERE sre03=g_tc_sfe[i].tc_sfe04
                                                AND sre04=g_tc_sfe[i].tc_sfe02
                                                AND sre06=g_tc_sfe[i].tc_sfe05
            IF l_cnt=0 THEN
               CALL cl_err('chk sre',100,1)
               LET g_tc_sfe[i].tc_sfe05=''
               DISPLAY g_tc_sfe[i].tc_sfe05 TO tc_sfe05
               NEXT FIELD tc_sfe05
            END IF
            SELECT sre051 INTO g_tc_sfe[i].tc_sfe06 FROM sre_file
             WHERE sre01 =  YEAR(g_tc_sfe[i].tc_sfe05)
               AND sre02 =  MONTH(g_tc_sfe[i].tc_sfe05)
               AND sre03 =  g_tc_sfe[i].tc_sfe04
               AND sre04 =  g_tc_sfe[i].tc_sfe02
               AND sre06 =  g_tc_sfe[i].tc_sfe05 
            IF SQLCA.sqlcode THEN
               LET g_tc_sfe[i].tc_sfe06 = ' '
            END IF
            DISPLAY BY NAME g_tc_sfe[i].tc_sfe06      
         END IF
      
      AFTER FIELD tc_sfe06
        IF NOT cl_null(g_tc_sfe[i].tc_sfe06) THEN
           SELECT COUNT(*) INTO g_cnt FROM bma_file
            WHERE bma06 = g_tc_sfe[i].tc_sfe06
              AND bma01 = g_tc_sfe[i].tc_sfe02
           IF g_cnt = 0 THEN
              CALL cl_err(g_tc_sfe[i].tc_sfe06,"abm-618",0)
              NEXT FIELD tc_sfe06
           END IF
        END IF
                       
 
      BEFORE FIELD tc_sfe03
        #IF g_tc_sfd06 MATCHES '[1]' THEN 
         IF g_tc_sfd06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D' 
            LET qty1 = 0
            LET qty2 = 0
            IF cl_null(g_tc_sfe[i].tc_sfe04) THEN
               LET g_tc_sfe[i].tc_sfe04 = ' '
            END IF
        #FUN-A70095 --------Begin----------   
            IF cl_null(g_tc_sfe[i].tc_sfe012) THEN
               LET g_tc_sfe[i].tc_sfe012 = ' ' 
            END IF
        #FUN-A70095 --------End------------
            #FUN-C70014 add begin-----------
            IF g_tc_sfd06 = 'D' THEN
               #取得Run Card生產數量 
               SELECT shm08 INTO l_shm08 FROM shm_file 
                WHERE shm01 = g_tc_sfe[i].tc_sfe014 
               IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
            END IF 
            #FUN-C70014 add end-------------
           #IF g_sma.sma129='N' THEN
            IF g_sma.sma129='N' AND g_tc_sfd06 <> 'D' THEN #FUN-C70014 g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
               LET l_sfb08 =NULL
               LET l_sfb081=NULL
               SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                   FROM sfb_file 
                                  WHERE sfb01=g_tc_sfe[i].tc_sfe02
               IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
               IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
               LET qty1=l_sfb081
               LET qty2=0
               LET unissue_qty = l_sfb08 - l_sfb081
            ELSE
            #將撈取qty1,qty2的部分整理到函數 i510_tc_sfe03_chk1()處理  
              #CALL i510_tc_sfe03_chk1(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  #FUN-A70095  #只选过账的,用于预设值
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'1')  #FUN-A70095  #FUN-BC0060 mod  #FUN-C70014 add tc_sfe014
                    RETURNING qty1,qty2        #FUN-A70095              
         #此段功能由i510_tc_sfe03_chk1()代替
         #FUN-A70095 ----------------Begin----------------------   
         #    IF g_tc_sfe[i].tc_sfe04 != ' ' THEN  #MOD-A30070
         #     SELECT SUM(tc_sfe03) INTO qty1 FROM tc_sfe_file, tc_sfd_file
         #      WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #    #   AND tc_sfe04=g_tc_sfe[i].tc_sfe04                   #MOD-A30070
         #        AND (tc_sfe04=g_tc_sfe[i].tc_sfe04 OR tc_sfe04 = ' ')  #MOD-A30070  #FUN-AC0074  #TQC-B60349 restore
         #        AND tc_sfe01=tc_sfd01 AND tc_sfd06='1' AND tc_sfd04='Y'
         #    #    AND tc_sfe04=g_tc_sfe[i].tc_sfe04   #FUN-AC0074  #TQC-B60349 mark
         #     SELECT SUM(tc_sfe03) INTO qty2 FROM tc_sfe_file, tc_sfd_file
         #      WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 
         #    #   AND tc_sfe04=g_tc_sfe[i].tc_sfe04                   #MOD-A30070
         #        AND (tc_sfe04=g_tc_sfe[i].tc_sfe04 OR tc_sfe04 = ' ')  #MOD-A30070  #FUN-AC0074 #TQC-B60349 restore
         #        AND tc_sfe01=tc_sfd01 AND tc_sfd06='6' AND tc_sfd04='Y'
         #     #   AND tc_sfe04=g_tc_sfe[i].tc_sfe04   #FUN-AC0074   #TQC-B60349 mark
#MOD-A30070 --BEGIN--
         #   ELSE
         #     SELECT SUM(tc_sfe03) INTO qty1 FROM tc_sfe_file, tc_sfd_file
         #      WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02
         #        AND tc_sfe01=tc_sfd01 AND tc_sfd06='1' AND tc_sfd04='Y'
         #    #    AND tc_sfe04=' ' #FUN-AC0074  #TQC-B60349 mark

         #     SELECT SUM(tc_sfe03) INTO qty2 FROM tc_sfe_file, tc_sfd_file
         #      WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02
         #        AND tc_sfe01=tc_sfd01 AND tc_sfd06='6' AND tc_sfd04='Y'
         #    #    AND tc_sfe04=' ' #FUN-AC0074  #TQC-B60349 mark
         #   END IF 
#MOD-A30070 --END--
         #FUN-A70095 ----------------End----------------------
               
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
               
               LET unissue_qty = l_sfb08-(qty1-qty2)
               IF g_tc_sfd06 = 'D' THEN LET unissue_qty = l_shm08-(qty1-qty2) END IF  #FUN-C70014 add 
            END IF
            IF (g_tc_sfe[i].tc_sfe03 IS NULL OR
               (l_tc_sfe02_t IS NULL OR l_tc_sfe02_t != g_tc_sfe[i].tc_sfe02)) AND 
               l_tc_sfe03_flag = 'N' THEN    #FUN-B20095 add l_tc_sfe03_flag
               IF g_argv1='1' THEN  
                  LET g_tc_sfe[i].tc_sfe03 = unissue_qty
               ELSE
                  LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
               END IF
            END IF
            IF g_tc_sfe[i].tc_sfe03 = 0 THEN
               IF g_argv1='1' THEN
                  IF g_sma.sma129 = 'Y' THEN
                     LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                  END IF   
               ELSE  
                  LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
               END IF
            END IF
         END IF
         #MOD-BA0017 -- begin --
         IF g_tc_sfd06 = '6' THEN
            LET l_tc_sfe03_t = g_tc_sfe[i].tc_sfe03
         END IF
         #MOD-BA0017 -- end --
         IF cl_null(l_tc_sfe03_o) THEN     
            LET l_tc_sfe03_o =0
         ELSE           #TQC-B70170 
            LET l_tc_sfe03_o = l_tc_sfe03_t   #TQC-B70170
         END IF
 
 
      AFTER FIELD tc_sfe03
         IF NOT cl_null(g_tc_sfe[i].tc_sfe03) THEN
            IF g_tc_sfd06 MATCHES '[ABC]' THEN
               LET l_qty=0
               IF NOT cl_null(g_tc_sfe[i].tc_sfe05) THEN
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=g_tc_sfe[i].tc_sfe04
                                                 AND sre04=g_tc_sfe[i].tc_sfe02
                                                 AND sre06=g_tc_sfe[i].tc_sfe05
                                                 AND sre07 IS NOT NULL
               ELSE
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=g_tc_sfe[i].tc_sfe04
                                                 AND sre04=g_tc_sfe[i].tc_sfe02
                                                 AND sre07 IS NOT NULL
               END IF
               IF g_tc_sfe[i].tc_sfe03>l_qty THEN
                  LET l_str="tot:",l_qty
                  CALL cl_err(l_str,"asr-008",1)
               END IF
            END IF
 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = g_tc_sfe[i].sfb05
            IF l_ima56 <> 1 THEN
               #MOD-D40218---begin
               #LET l_faqty = g_tc_sfe[i].tc_sfe03 MOD l_ima56
               LET l_qty1 = g_tc_sfe[i].tc_sfe03 * 1000
               LET l_qty2 = l_ima56 * 1000
               LET l_faqty = l_qty1 MOD l_qty2
               #MOD-D40218---end
               IF  l_faqty <> 0 THEN
                   CALL CL_err(g_tc_sfe[i].tc_sfe03,'asf-898',0)
                   NEXT FIELD tc_sfe03
               END IF
            ELSE
               LET l_per = g_tc_sfe[i].tc_sfe03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> g_tc_sfe[i].tc_sfe03 THEN
                  CALL CL_err(g_tc_sfe[i].tc_sfe03,'asf-898',0)
                   NEXT FIELD tc_sfe03
               END IF
            END IF
  
            IF g_tc_sfd06 ='1' AND g_tc_sfe[i].tc_sfe03 > unissue_qty THEN
               CALL cl_err('tc_sfe03>un_issue:','asf-351',0) NEXT FIELD tc_sfe03
            END IF
    
           #str MOD-A30065 add
           #新增時不在此段自動產生單身
            IF g_action_choice="insert" THEN
               LET g_flag_tc_sfe03 = 0
            ELSE
           #end MOD-A30065 add
               IF cl_null(g_tc_sfe[i].tc_sfe03) THEN LET g_tc_sfe[i].tc_sfe03 = 0 END IF #TQC-990094
               IF cl_null(l_tc_sfe03_t) THEN LET l_tc_sfe03_t = 0 END IF           #TQC-990094           
              #IF g_tc_sfd06 ='1' AND g_tc_sfe[i].tc_sfe03 <> l_tc_sfe03_t THEN                #MOD-C50095 mark
              #IF g_tc_sfd06 MATCHES '[16]' AND g_tc_sfe[i].tc_sfe03 <> l_tc_sfe03_t THEN      #MOD-C50095 add   
               IF g_tc_sfd06 MATCHES '[16D]' AND g_tc_sfe[i].tc_sfe03 <> l_tc_sfe03_t THEN      #MOD-C50095 add   #TQC-CA0045 add
                  LET g_flag_tc_sfe03 = 1 
               END IF
            END IF   #MOD-A30065 add
 
           #IF g_tc_sfd06 ='6' AND g_tc_sfe[i].tc_sfe03 > (qty1-qty2) THEN    #MOD-BA0078 mark
            #MOD-BA0078 -- begin --
            LET l_ima153 = 0
            LET l_sfb08 = 0
            CALL s_get_ima153(g_tc_sfe[i].sfb05) RETURNING l_ima153
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = g_tc_sfe[i].tc_sfe02
            #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = g_tc_sfe[i].tc_sfe02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
            #end------add by guanyao160920
            LET l_allowqty = (qty1-qty2) + l_sfb08 * (l_ima153/100)
            IF g_tc_sfd06 ='6' AND g_tc_sfe[i].tc_sfe03 > l_allowqty THEN
            #MOD-BA0078 -- end --
              #CALL cl_err('tc_sfe03>issued:','asf-086',0) NEXT FIELD tc_sfe03 #MOD-640419
              #MOD-B30647---modify---start---
              #CALL cl_err('tc_sfe03>issued:','asf-086',0) NEXT FIELD tc_sfe03 #MOD-640419
               CALL cl_err('tc_sfe03>issued:','asf-086',0)
               LET g_tc_sfe[i].tc_sfe03 = l_tc_sfe03_t
               NEXT FIELD tc_sfe03
              #MOD-B30647---modify---end---
            END IF
 
            IF g_tc_sfd06='3' THEN
               LET g_tc_sfe[i].tc_sfe03=0
            END IF
 
            IF g_tc_sfd06 = '6' THEN    #成套退料
              #IF g_tc_sfe[i].tc_sfe03 <= 0 THEN NEXT FIELD tc_sfe03 END IF   #MOD-BA0017 mark
#MOD-BA0017 -- begin --
               IF g_tc_sfe[i].tc_sfe03 <= 0 THEN
                  CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-685',0)
                  LET g_tc_sfe[i].tc_sfe03 = l_tc_sfe03_t
                  NEXT FIELD tc_sfe03
               END IF
#MOD-BA0017 -- end --
              #MOD-BA0078 -- mark begin 上面註記處已有判斷 --
              #SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
              # WHERE sfb01 = g_tc_sfe[i].tc_sfe02
              #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              #IF g_tc_sfe[i].tc_sfe03 > l_qty THEN
              #   CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-705',0)
              #   NEXT FIELD tc_sfe03
              #END IF
              #MOD-BA0078 -- mark end --
            END IF
 
           #IF g_tc_sfd06 = '1' THEN    #成套發料
            IF g_tc_sfd06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'  新增Run Card成套發料
               #FUN-C70014 add begin-----------
               IF g_tc_sfd06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = g_tc_sfe[i].tc_sfe014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = g_tc_sfe[i].tc_sfe02
               #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = g_tc_sfe[i].tc_sfe02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
               #end------add by guanyao160920
               LET l_tc_sfe03 = 0
               LET l_tc_sfe03_r = 0

               IF cl_null(g_tc_sfe[i].tc_sfe04) THEN 
                  LET g_tc_sfe[i].tc_sfe04 = ' ' 
               END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(g_tc_sfe[i].tc_sfe012) THEN
                  LET g_tc_sfe[i].tc_sfe012 = ' '
               END IF 
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理
              #CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  RETURNING l_qty1,l_qty2    #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfe014
           #FUN-B20095 --------End--------------
    #此段功能由i510_tc_sfe03_chk()代替
               LET l_tc_sfe03 = l_qty1 - l_qty2   
              #end MOD-A70046 mod
 
#MOD-A30070 --BEGIN--
              IF cl_null(g_tc_sfe[i].tc_sfe04) THEN 
                 LET g_tc_sfe[i].tc_sfe04 = ' ' 
              END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(g_tc_sfe[i].tc_sfe012) THEN
                  LET g_tc_sfe[i].tc_sfe012 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理    
              #CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,g_tc_sfe[i].tc_sfe014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfe014
           #FUN-B20095 --------End--------------
              #IF g_tc_sfe[i].tc_sfe04 IS NOT NULL THEN
#此段功能由i510_tc_sfe03_chk()代替
                  LET l_tc_sfe03 = l_qty1 - l_qty2
              #END IF   #MOD-A70046 mark
              #IF g_sma.sma129='N' THEN   #FUN-C70014 mark
               IF g_sma.sma129='N' AND g_tc_sfd06 <> 'D' THEN #FUN-C70014 g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=g_tc_sfe[i].tc_sfe02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_tc_sfe03 = l_sfb081
               END IF
               IF cl_null(l_tc_sfe03_o) THEN LET l_tc_sfe03_o = 0 END IF    #FUN-B20095
               IF l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_sfb08 OR      #No.MOD-860012
                  (g_tc_sfd06 = 'D' AND l_tc_sfe03+g_tc_sfe[i].tc_sfe03-l_tc_sfe03_o > l_shm08) THEN #FUN-C70014 add 
                  CALL cl_err(g_tc_sfe[i].tc_sfe02,'asf-704',0)
                  NEXT FIELD tc_sfe03                          #No.MOD-860012 
               END IF
 
               IF g_sma.sma129 = 'N' THEN    #發料不控管套數
                  IF g_tc_sfe[i].tc_sfe03 < 0 THEN
                     CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-387',0)
                     NEXT FIELD tc_sfe03
                  END IF
               ELSE                          #發料控管套數
                  IF g_tc_sfe[i].tc_sfe03 <=0 THEN
                     CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-706',0)
                     NEXT FIELD tc_sfe03
                  END IF
               END IF                        #FUN-940039 add
            END IF

            #str---add by jixf 160809
            IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN 
                SELECT SUM(shm08) INTO l_shm08_sum FROM shm_file 
                   WHERE ta_shm05=g_tc_sfd.tc_sfdud02 AND shm012=g_tc_sfe[i].tc_sfe02
                SELECT SUM(tc_sfe03) INTO l_tc_sfe03_sum FROM tc_sfe_file,tc_sfd_file 
                  WHERE tc_sfe01=tc_sfd01 AND tc_sfe02=g_tc_sfe[i].tc_sfe02 AND tc_sfdud02=g_tc_sfd.tc_sfdud02 AND tc_sfe01<>g_tc_sfd.tc_sfd01 AND tc_sfd04<>'X'

                IF l_shm08_sum-l_tc_sfe03_sum < g_tc_sfe[i].tc_sfe03 THEN 
                   CALL cl_err(g_tc_sfe[i].tc_sfe03,'csf-324',1)
                   NEXT FIELD tc_sfe03
                END IF
            END IF 
            
            #end---add by jixf 160809
            LET g_tc_sfe[i].tc_sfe07 = g_tc_sfe[i].tc_sfe03   #FUN-940008 add
            #若tc_sfe03有值且该值合理，则返回tc_sfe012/tc_sfe04/tc_sfe03时不须重给该栏位的预设值
            LET l_tc_sfe03_flag = 'Y'     #FUN-B20095
         END IF
      AFTER FIELD tc_sfeud01
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud02
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud03
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud04
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud05
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud06
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud07
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud08
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud09
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud10
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud11
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud12
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud13
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud14
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
      AFTER FIELD tc_sfeud15
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INSERT
         IF INT_FLAG THEN
            CANCEL INSERT
            CALL g_tc_sfe.deleteElement(i)
            EXIT INPUT
         END IF
      AFTER ROW    #FUN-C70014 add
         LET l_count = g_tc_sfe.getLength()    #FUN-C70014  add
 
      AFTER INPUT
         LET l_tc_sfe02_t = g_tc_sfe[i].tc_sfe02
         #FUN-C70014 add begin-------------------
         IF g_tc_sfd06 = 'D' THEN 
            LET g_success = 'Y'
            CALL s_showmsg_init()
            FOR l_n = 1 TO g_tc_sfe.getLength()
               IF NOT i510_chk_tc_sfe(l_n,'2') THEN 
                  LET g_success = 'N' 
               END IF   
            END FOR 
            IF g_success = 'N' THEN 
               CALL s_showmsg()
               NEXT FIELD tc_sfe014
            END IF 
         END IF 
         #FUN-C70014 add end---------------------

         #str---add by jixf 160809
         IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN 
             FOR l_n = 1 TO g_tc_sfe.getLength()
                SELECT sum(shm08) INTO l_shm08_sum FROM shm_file    #tianry add 161118  shm08->sum(shm08)
                   WHERE ta_shm05=g_tc_sfd.tc_sfd07 AND shm012=g_tc_sfe[l_n].tc_sfe02
                SELECT SUM(tc_sfe03) INTO l_tc_sfe03_sum FROM tc_sfe_file,tc_sfd_file 
                  WHERE tc_sfe01=tc_sfd01 AND tc_sfe02=g_tc_sfe[l_n].tc_sfe02 AND
                        tc_sfd07=g_tc_sfd.tc_sfd07 AND tc_sfe01<>g_tc_sfd.tc_sfd01 AND tc_sfd04<>'X'

                IF l_shm08_sum-l_tc_sfe03_sum < g_tc_sfe[l_n].tc_sfe03 THEN  #tianry add 161118
                   CALL cl_err(g_tc_sfe[l_n].tc_sfe03,'csf-324',1)
                   NEXT FIELD tc_sfe03
                END IF 
             END FOR
         END IF 
         #end---add by jixf 160809
         IF INT_FLAG THEN
            LET INT_FLAG=0
            ROLLBACK WORK           #MOD-B30647 取消mark
            EXIT INPUT              #No.MOD-5A0010
         END IF
 
         IF (g_tc_sfe[i].tc_sfe02 IS NOT NULL) AND (NOT g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114
           #IF g_tc_sfd06 = '1' THEN   #成套發料    #MOD-BA0017 mark
            IF g_tc_sfd06 MATCHES '[16D]' THEN       #MOD-BA0017  #FUN-C70014 add 'D'
               IF g_sma.sma129 = 'Y' THEN
                  IF g_tc_sfe[i].tc_sfe03 = 0 THEN
                     IF g_tc_sfd06 = '1' OR g_tc_sfd06 ='D' THEN   #MOD-BA0017 add  #TQC-CA0035 add OR g_tc_sfd06 ='D'
                        CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-706',0)
                     #MOD-BA0017 -- begin --
                     ELSE
                        CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-685',0)
                        LET g_tc_sfe[i].tc_sfe03 = l_tc_sfe03_t
                     END IF
                     #MOD-BA0017 -- end --
                     NEXT FIELD tc_sfe03
                  END IF
               END IF
            END IF
        
            IF g_tc_sfd06 MATCHES '[16D]' THEN   #FUN-C70014 add 'D'
               SELECT SUM(tc_sfe03) INTO qty1 FROM tc_sfe_file, tc_sfd_file
                 WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 AND tc_sfe04=g_tc_sfe[i].tc_sfe04
                   AND tc_sfe01=tc_sfd01 AND tc_sfd06='1' AND tc_sfd04='Y'
 
                SELECT SUM(tc_sfe03) INTO qty2 FROM tc_sfe_file, tc_sfd_file
                 WHERE tc_sfe02=g_tc_sfe[i].tc_sfe02 AND tc_sfe04=g_tc_sfe[i].tc_sfe04
                   AND tc_sfe01=tc_sfd01 AND tc_sfd06='6' AND tc_sfd04='Y'
 
               IF qty1 IS NULL THEN LET qty1=0 END IF
               IF qty2 IS NULL THEN LET qty2=0 END IF
 
               LET unissue_qty = l_sfb08-(qty1-qty2)
               IF g_tc_sfe[i].tc_sfe03 IS NULL THEN
                  IF g_argv1='1' THEN
                     LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                  ELSE LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
                  END IF
               END IF
               IF g_tc_sfe[i].tc_sfe03 = 0 THEN
                  IF g_argv1 ='1' THEN
                     IF g_sma.sma129 = 'Y' THEN	
                        LET g_tc_sfe[i].tc_sfe03 = unissue_qty
                     END IF 
                  ELSE
                     LET g_tc_sfe[i].tc_sfe03 = qty1-qty2
                  END IF 
               END IF
            END IF
 
            IF g_tc_sfd06 NOT MATCHES '[16D]' THEN  #FUN-C70014 add 'D'
               LET g_tc_sfe[i].tc_sfe03=0
            END IF
 
            IF g_tc_sfd06 = '1' THEN   #成套發料
               LET l_tc_sfe03 = 0
               DECLARE i510_cs3 CURSOR FOR
                SELECT SUM(tc_sfe03) FROM tc_sfd_file,tc_sfe_file
                 WHERE tc_sfd06='1'
                   AND tc_sfd01=tc_sfe01
                   AND tc_sfe02=g_tc_sfe[i].tc_sfe02
                   AND tc_sfd04 !='X' #FUN-660106
                 GROUP BY tc_sfe04
                 ORDER BY tc_sfe03 DESC
 
               FOREACH i510_cs3 INTO l_tc_sfe03
                 IF STATUS THEN LET l_tc_sfe03=0 END IF
                 EXIT FOREACH
               END FOREACH
 
               IF cl_null(l_tc_sfe03) THEN LET l_tc_sfe03 = 0 END IF
               IF g_tc_sfe[i].tc_sfe03 > l_sfb08 THEN
                  CALL cl_err(g_tc_sfe[i].tc_sfe02,'asf-704',0)
                  IF FGL_LASTKEY() = 2016 THEN    #ESC
                     LET g_tc_sfe[i].tc_sfe03 = null
                  END IF
                  NEXT FIELD tc_sfe02
               END IF
            END IF
 
            IF g_tc_sfd06 = '6' THEN    #成套退料
             #MOD-D30125---begin
               IF NOT cl_null(g_tc_sfe[i].tc_sfe04) AND g_tc_sfe[i].tc_sfe04 <> ' ' AND g_sma.sma73 = 'Y' THEN
                  IF cl_null(g_tc_sfe[i].tc_sfe012) THEN LET g_tc_sfe[i].tc_sfe012 = ' ' END IF 
                  SELECT MIN(sfa013) INTO l_sfa013
                    FROM sfa_file
                   WHERE sfa01 = g_tc_sfe[i].tc_sfe02
                     AND sfa08 = g_tc_sfe[i].tc_sfe04
                     AND sfa012 = g_tc_sfe[i].tc_sfe012
                  IF cl_null(l_sfa013) THEN LET l_sfa013 = 0 END IF 
                  LET l_cnt=0  
                  CALL s_minp_routing(g_tc_sfe[i].tc_sfe02,g_sma.sma73,0,g_tc_sfe[i].tc_sfe04,g_tc_sfe[i].tc_sfe012,l_sfa013)
                       RETURNING l_cnt,l_qty1

                  SELECT ecm311+ecm312+ecm313+ecm314+ecm316+ecm321-ecm322 INTO l_qty2
                    FROM ecm_file
                   WHERE ecm01 = g_tc_sfe[i].tc_sfe02
                     AND ecm04 = g_tc_sfe[i].tc_sfe04
                     AND ecm012 = l_tc_sfe012
                  IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF 
                  LET l_qty = l_qty1 - l_qty2
               ELSE  
               #MOD-D30125---end  
                  SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
                  WHERE sfb01 = g_tc_sfe[i].tc_sfe02
               END IF  #MOD-D30125
               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               IF g_tc_sfe[i].tc_sfe03 > l_qty THEN
                  CALL cl_err(g_tc_sfe[i].tc_sfe03,'asf-705',0)
                  NEXT FIELD tc_sfe03
               END IF
 
            END IF
         END IF
 
      ON ACTION controlp
         CASE WHEN INFIELD(tc_sfe02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.where =' 1=1 '  #TQC-CA0045 add
                   LET g_qryparam.form = "q_sfb20"       #MOD-930181 add
                   LET g_qryparam.arg1 = 234567
                   LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe02
                   IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN 
                      LET g_qryparam.where = g_qryparam.where," AND ta_shm05 = '",g_tc_sfd.tc_sfd07,"' ",
                                                              " AND sfb01 IN (SELECT shm012 FROM shm_file WHERE shm01='",g_tc_sfe[i].tc_sfe014,"')"
                   END IF 
                   #FUN-C70014 add end -------------
                   CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe02
                   DISPLAY BY NAME g_tc_sfe[i].tc_sfe02  
                   NEXT FIELD tc_sfe02
          #FUN-B20095 ---------------Begin-------------------
             WHEN INFIELD(tc_sfe012)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_tc_sfe012" 
                   LET g_qryparam.where = " sfa01 = '",g_tc_sfe[i].tc_sfe02,"'"  
                   LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe012
                   CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe012
                   DISPLAY BY NAME g_tc_sfe[i].tc_sfe012 
                   NEXT FIELD tc_sfe012                      
          #FUN-B20095 ---------------End---------------------             
             WHEN INFIELD(tc_sfe04)
                   IF g_tc_sfd06 MATCHES '[ABC]' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_eci"
                     LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe04
                     CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe04
                     DISPLAY BY NAME g_tc_sfe[i].tc_sfe04
                   ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfa15"   
                     LET g_qryparam.arg1= g_tc_sfe[i].tc_sfe02  
                     LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe04
                     CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe04
                      DISPLAY BY NAME g_tc_sfe[i].tc_sfe04    #No.MOD-490371
                     NEXT FIELD tc_sfe04
                   END IF
            WHEN INFIELD(tc_sfe06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_bma7"
                   LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe06
                   LET g_qryparam.arg1 = g_tc_sfe[i].tc_sfe02
                   CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe06
                   DISPLAY  BY NAME g_tc_sfe[i].tc_sfe06
                   NEXT FIELD tc_sfe06
            #FUN-C70014 add begin-------------------
            WHEN INFIELD(tc_sfe014)
                 IF l_cmd = 'a' THEN
                    CALL g_multi_tc_sfe014.clear()
                    CALL q_shm4(TRUE,TRUE,NULL,g_multi_tc_sfe014[1].*) RETURNING g_multi_tc_sfe014
                    IF g_multi_tc_sfe014.getLength() > 0 AND NOT cl_null(g_multi_tc_sfe014[1].shm01) THEN 
                       CALL i510_multi_tc_sfe014(i)
                       LET l_count = g_tc_sfe.getLength()    #FUN-C70014  add
                       #FUN-C70014 add begin-----------
                       IF i > l_count THEN 
                          LET l_cmd = 'a'
                       ELSE 
                          LET l_cmd = 'u'
                       END IF 
                       #FUN-C70014 add end-------------
                    ELSE 
                       NEXT FIELD tc_sfe014
                    END IF 
                 ELSE 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_shm4"
                    IF NOT cl_null(g_tc_sfe[i].tc_sfe02) THEN 
                       LET g_qryparam.where = " shm012 = '",g_tc_sfe[i].tc_sfe02,"'"
                    END IF 
                    LET g_qryparam.default1 = g_tc_sfe[i].tc_sfe014
                    LET g_qryparam.default2 = g_tc_sfe[i].tc_sfe02
                    LET g_qryparam.default3 = g_tc_sfe[i].tc_sfe04
                    CALL cl_create_qry() RETURNING g_tc_sfe[i].tc_sfe014,g_tc_sfe[i].tc_sfe02,g_tc_sfe[i].tc_sfe04
                    DISPLAY BY NAME g_tc_sfe[i].tc_sfe014
                    DISPLAY BY NAME g_tc_sfe[i].tc_sfe02
                    DISPLAY BY NAME g_tc_sfe[i].tc_sfe04
                    NEXT FIELD tc_sfe014
                 END IF
            #FUN-C70014 add end --------------------
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION CONTROLG     #TQC-CA0045
         CALL cl_cmdask()    #TQC-CA0045
   END INPUT
 
    LET g_tc_sfd.tc_sfdmodu = g_user
    LET g_tc_sfd.tc_sfddate = g_today
    UPDATE tc_sfd_file SET tc_sfdmodu = g_tc_sfd.tc_sfdmodu,tc_sfddate = g_tc_sfd.tc_sfddate
     WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","tc_sfd_file",g_tc_sfd.tc_sfd01,"",SQLCA.SQLCODE,"","upd tc_sfd",1)  #No.FUN-660128
    END IF
    DISPLAY BY NAME g_tc_sfd.tc_sfdmodu,g_tc_sfd.tc_sfddate
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
   END IF
 
   UPDATE tc_sfd_file SET tc_sfdmodu=g_tc_sfd.tc_sfdmodu,
                       tc_sfddate=g_tc_sfd.tc_sfddate
    WHERE tc_sfd01=g_tc_sfd.tc_sfd01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tc_sfd_file",g_tc_sfd.tc_sfd01,"",SQLCA.sqlcode,"","upd tc_sfdmodu",1)  #No.FUN-660128
       LET g_tc_sfd.tc_sfdmodu=g_tc_sfd_t.tc_sfdmodu
       LET g_tc_sfd.tc_sfddate=g_tc_sfd_t.tc_sfddate
       DISPLAY BY NAME g_tc_sfd.tc_sfdmodu
       DISPLAY BY NAME g_tc_sfd.tc_sfddate
       ROLLBACK WORK
   END IF
 
   DELETE FROM tc_sfe_file WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","tc_sfe_file",g_tc_sfd.tc_sfd01,"",SQLCA.sqlcode,"","del tc_sfe",1)  #No.FUN-660128
      ROLLBACK WORK
      RETURN
   END IF
 
   FOR i = 1 TO g_tc_sfe.getLength()
       IF g_tc_sfe[i].tc_sfe02 IS NULL THEN CONTINUE FOR END IF
       IF g_tc_sfe[i].tc_sfe04 IS NULL THEN LET g_tc_sfe[i].tc_sfe04=' ' END IF
       CALL i510_b_i_move_back(i) #FUN-730075  
       IF g_sma.sma118 = 'N' THEN LET b_tc_sfe.tc_sfe06 = ' ' END IF  #No.FUN-870097      
       IF b_tc_sfe.tc_sfe014 IS NULL THEN LET b_tc_sfe.tc_sfe014=' ' END IF  #FUN-C70014 add 
       INSERT INTO tc_sfe_file VALUES (b_tc_sfe.*)
       IF STATUS THEN
          CALL cl_err3("ins","tc_sfe_file",g_tc_sfd.tc_sfd01,g_tc_sfe[i].tc_sfe02,STATUS,"","ins tc_sfe",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
   END FOR
 
    IF g_flag_tc_sfe03=1 THEN
       IF cl_confirm('asf-919') THEN
          CALL i510_g_b()
          CALL i510_b_fill(" 1=1")
       END IF 
    END IF 
   COMMIT WORK
 
END FUNCTION
FUNCTION i510_tc_sfe03_chk(p_tc_sfe02,p_tc_sfe04,p_tc_sfe012,p_tc_sfe014,p_flag)   #FUN-C70014 add p_tc_sfe014
DEFINE p_tc_sfe02       LIKE tc_sfe_file.tc_sfe02
DEFINE p_tc_sfe04       LIKE tc_sfe_file.tc_sfe04
DEFINE p_tc_sfe012      LIKE tc_sfe_file.tc_sfe012
DEFINE p_tc_sfe014      LIKE tc_sfe_file.tc_sfe014      #FUN-C70014 add
DEFINE p_flag        LIKE type_file.chr1                 #抓取的數據來源
DEFINE l_qty1        LIKE tc_sfe_file.tc_sfe03
DEFINE l_qty2        LIKE tc_sfe_file.tc_sfe03
DEFINE l_sql                  STRING
DEFINE l_sql_1,l_sql_2        STRING
DEFINE l_sql_3,l_sql_4        STRING
DEFINE l_sql1                   STRING
DEFINE l_sql1_1,l_sql1_2        STRING
DEFINE l_sql1_3,l_sql1_4        STRING
DEFINE l_sql2                   STRING
DEFINE l_sql2_1,l_sql2_2        STRING
DEFINE l_sql2_3,l_sql2_4        STRING
DEFINE qty1_1,qty1_2  LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty1_3,qty1_4  LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_1,qty2_2  LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE qty2_3,qty2_4  LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE ls_qty1        LIKE tc_sfe_file.tc_sfe03
DEFINE ls_sql                  STRING
DEFINE ls_sql_1,ls_sql_2        STRING
DEFINE ls_sql_3,ls_sql_4        STRING
DEFINE ls_sql1_1,ls_sql1_2        STRING
DEFINE ls_sql1_3,ls_sql1_4        STRING
DEFINE l_qty1_1         LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE l_qty1_2         LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE l_qty1_3         LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE l_qty1_4         LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
#str----add by guanyao160818
DEFINE l_c_sql                  STRING
DEFINE l_c_sql_1,l_c_sql_2        STRING
DEFINE l_c_sql_3,l_c_sql_4        STRING
DEFINE l_c_sql1_1,l_c_sql1_2        STRING
DEFINE l_c_sql1_3,l_c_sql1_4        STRING
DEFINE c_qty1_1         LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE c_qty1_2         LIKE tc_sfe_file.tc_sfe03   #已發按作業編號的套數和已發不按作業編號的套數
DEFINE c_qty1_3         LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE c_qty1_4         LIKE tc_sfe_file.tc_sfe03   #已退按作業編號的套數和已發不按作業編號的套數
DEFINE l_sfb08_1        LIKE sfb_file.sfb08
DEFINE l_sfb08          LIKE sfb_file.sfb08
DEFINE l_qty1_a         LIKE tc_sfe_file.tc_sfe03
#end----add by guanyao160818
#str----add by guanyao160822
DEFINE ls_sql_a         STRING  
DEFINE ls_sql_1_a,ls_sql_2_a,ls_sql_3_a,ls_sql_4_a  STRING 
DEFINE ls_sql1_1_a,ls_sql1_2_a,ls_sql1_3_a,ls_sql1_4_a   STRING 
DEFINE l_qty1_1_a,l_qty1_2_a,l_qty1_3_a,l_qty1_4_a  LIKE tc_sfe_file.tc_sfe03 
#end----add by guanyao160822

   IF cl_null(p_tc_sfe04) THEN
      LET p_tc_sfe04 = ' '
   END IF
   IF cl_null(p_tc_sfe012) THEN
      LET p_tc_sfe012 = ' '
   END IF
   LET l_sql = " SELECT SUM(tc_sfe03) FROM tc_sfe_file, tc_sfd_file ",
               "  WHERE tc_sfe02 = '",p_tc_sfe02,"'",
               "    AND tc_sfe01 = tc_sfd01 "
   CASE p_flag
       WHEN '1'              #只計算已過帳的
          LET l_sql = l_sql CLIPPED,
                      "    AND tc_sfd04 ='Y'"
       WHEN '2'   #只要有效存在於發料當中的都計算進去
          LET l_sql = l_sql CLIPPED,
                      "    AND tc_sfd04 !='X'"
       OTHERWISE   #只要有效存在於發料當中的都計算進去
          LET l_sql = l_sql CLIPPED,
                      "    AND tc_sfd04 !='X'"
   END CASE
   #str----add by guanyao160818#申请单数量不能大于工单批号的数量
   IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
      LET l_sql = l_sql CLIPPED," AND (tc_sfd07 != '",g_tc_sfd.tc_sfd07,"' OR tc_sfd07 IS NULL )" 
   END IF 

   #FUN-C70014 add begin------Run Card發料時，計算已發和未發套數需要根據Run Card單號查詢
   IF g_argv2 = 'D' AND NOT cl_null(p_tc_sfe014) THEN 
      LET l_sql = l_sql CLIPPED," AND tc_sfe014 = '",p_tc_sfe014,"'"
   END IF 
   #FUN-C70014 add end--------
   
   #工藝段與作業編號都有輸入
   IF NOT cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = l_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' ",
                                  " AND tc_sfe012= '",p_tc_sfe012,"'"
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' ",
                                  " AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
      #按作業編號空格+工藝段值
      LET l_sql_3 = l_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')",
                                  " AND tc_sfe012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')",
                                  " AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
   END IF
   #只輸入了作業編號——可以不考慮工藝段了
   IF NOT cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' "
      #按作業編號空格+工藝段值
      LET l_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')"
   END IF
   #只輸入了工藝段——可以不考慮作業編號了
   IF cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段值
      LET l_sql_3 = l_sql CLIPPED," AND tc_sfe012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
   END IF
   #作業編號和工藝段均未輸入——以作業編號為依據來計算（以工藝段為依據也可以，此處以作業編號）
   IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET l_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET l_sql_2 = l_sql CLIPPED," AND tc_sfe04 IS NOT NULL AND tc_sfe04 != ' ' "
      #按作業編號空格+工藝段值
      LET l_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET l_sql_4 = l_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')"
   END IF

   
   ##-------------計算已發-------------##begin
   LET qty1_1 = 0
   LET qty1_2 = 0
   LET qty1_3 = 0
   LET qty1_4 = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(l_sql_1) THEN
     #LET l_sql1_1 = l_sql_1 CLIPPED," AND tc_sfd06 = '1'"
      LET l_sql1_1 = l_sql_1 CLIPPED
      PREPARE i510_tc_sfe03_pre1_1 FROM l_sql1_1
      DECLARE i510_tc_sfe03_curs1_1 CURSOR FOR i510_tc_sfe03_pre1_1
      FOREACH i510_tc_sfe03_curs1_1 INTO qty1_1
           IF STATUS THEN LET qty1_1=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
     #LET l_sql1_2 = l_sql_2 CLIPPED," AND tc_sfd06 = '1'"
      LET l_sql1_2 = l_sql_2 CLIPPED
      IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         LET l_sql1_2 = l_sql1_2 CLIPPED,
                        " GROUP BY tc_sfe04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i510_tc_sfe03_pre1_2 FROM l_sql1_2
      DECLARE i510_tc_sfe03_curs1_2 CURSOR FOR i510_tc_sfe03_pre1_2
      FOREACH i510_tc_sfe03_curs1_2 INTO qty1_2
           IF STATUS THEN LET qty1_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(l_sql_3) THEN
     #LET l_sql1_3 = l_sql_3 CLIPPED," AND tc_sfd06 = '1'"
      LET l_sql1_3 = l_sql_3 CLIPPED
      PREPARE i510_tc_sfe03_pre1_3 FROM l_sql1_3
      DECLARE i510_tc_sfe03_curs1_3 CURSOR FOR i510_tc_sfe03_pre1_3
      FOREACH i510_tc_sfe03_curs1_3 INTO qty1_3
           IF STATUS THEN LET qty1_3=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
     #LET l_sql1_4 = l_sql_4 CLIPPED," AND tc_sfd06 = '1'"
      LET l_sql1_4 = l_sql_4 CLIPPED
      PREPARE i510_tc_sfe03_pre1_4 FROM l_sql1_4
      DECLARE i510_tc_sfe03_curs1_4 CURSOR FOR i510_tc_sfe03_pre1_4
      FOREACH i510_tc_sfe03_curs1_4 INTO qty1_4
           IF STATUS THEN LET qty1_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty1_1) THEN LET qty1_1=0 END IF
   IF cl_null(qty1_2) THEN LET qty1_2=0 END IF
   IF cl_null(qty1_3) THEN LET qty1_3=0 END IF
   IF cl_null(qty1_4) THEN LET qty1_4=0 END IF
   LET l_qty1 = qty1_1 + qty1_2 + qty1_3 + qty1_4
   ##-------------計算已發-------------##end
   #str-----add by guanyao160922#######非此申请单已经发料的数量
   LET ls_sql_a = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
               "  WHERE sfq02 = '",p_tc_sfe02,"'",
               "    AND sfq01 = sfp01 ",
               "    AND sfpud02 <>'",g_tc_sfd.tc_sfd01,"'"
   CASE p_flag
       WHEN '1'              #只計算已過帳的
          LET ls_sql_a = ls_sql_a CLIPPED,
                      "    AND sfp04 ='Y'"
       WHEN '2'   #只要有效存在於發料當中的都計算進去
          LET ls_sql_a = ls_sql_a CLIPPED,
                      "    AND sfpconf !='X'"
       OTHERWISE   #只要有效存在於發料當中的都計算進去
          LET ls_sql_a = ls_sql_a CLIPPED,
                      "    AND sfpconf !='X'"
   END CASE

   #FUN-C70014 add begin------Run Card發料時，計算已發和未發套數需要根據Run Card單號查詢
   IF g_argv2 = 'D' AND NOT cl_null(p_tc_sfe014) THEN 
      LET ls_sql_a = ls_sql_a CLIPPED," AND sfq014 = '",p_tc_sfe014,"'"
   END IF 
   #FUN-C70014 add end--------
   
   #工藝段與作業編號都有輸入
   IF NOT cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1_a = ls_sql_a CLIPPED," AND sfq04 = '",p_tc_sfe04,"' ",
                                  " AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號值+工藝段空格
      LET ls_sql_2_a = ls_sql_a CLIPPED," AND sfq04 = '",p_tc_sfe04,"' ",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
      #按作業編號空格+工藝段值
      LET ls_sql_3_a = ls_sql_a CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET ls_sql_4_a = ls_sql_a CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #只輸入了作業編號——可以不考慮工藝段了
   IF NOT cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1_a = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2_a = ls_sql_a CLIPPED," AND sfq04 = '",p_tc_sfe04,"' "
      #按作業編號空格+工藝段值
      LET ls_sql_3_a = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET ls_sql_4_a = ls_sql_a CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF
   #只輸入了工藝段——可以不考慮作業編號了
   IF cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1_a = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2_a = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段值
      LET ls_sql_3_a = ls_sql_a CLIPPED," AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET ls_sql_4_a = ls_sql_a CLIPPED," AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #作業編號和工藝段均未輸入——以作業編號為依據來計算（以工藝段為依據也可以，此處以作業編號）
   IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1_a = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2_a = ls_sql_a CLIPPED," AND sfq04 IS NOT NULL AND sfq04 != ' ' "
      #按作業編號空格+工藝段值
      LET ls_sql_3_a = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET ls_sql_4_a = ls_sql_a CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF

   ##-------------計算已發-------------##begin
   LET l_qty1_1_a = 0
   LET l_qty1_2_a = 0
   LET l_qty1_3_a = 0
   LET l_qty1_4_a = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(ls_sql_1_a) THEN
     #LET l_sql1_1 = l_sql_1 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_1_a = ls_sql_1_a CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_1_a FROM ls_sql1_1_a
      DECLARE i510_sfq03_curs1_1_a CURSOR FOR i510_sfq03_pre1_1_a
      FOREACH i510_sfq03_curs1_1_a INTO l_qty1_1_a
           IF STATUS THEN LET l_qty1_1_a=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(ls_sql_2_a) THEN
     #LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_2_a = ls_sql_2_a CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         LET ls_sql1_2_a = ls_sql1_2_a CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i510_sfq03_pre1_2_a FROM ls_sql1_2_a
      DECLARE i510_sfq03_curs1_2_a CURSOR FOR i510_sfq03_pre1_2_a
      FOREACH i510_sfq03_curs1_2_a INTO l_qty1_2_a
           IF STATUS THEN LET l_qty1_2_a=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(ls_sql_3_a) THEN
     #LET l_sql1_3 = l_sql_3 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_3_a = ls_sql_3_a CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_3_a FROM ls_sql1_3_a
      DECLARE i510_sfq03_curs1_3_a CURSOR FOR i510_sfq03_pre1_3_a
      FOREACH i510_sfq03_curs1_3_a INTO l_qty1_3_a
           IF STATUS THEN LET l_qty1_3_a=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(ls_sql_4_a) THEN
     #LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_4_a = ls_sql_4_a CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_4_a FROM ls_sql1_4_a
      DECLARE i510_sfq03_curs1_4_a CURSOR FOR i510_sfq03_pre1_4_a
      FOREACH i510_sfq03_curs1_4_a INTO l_qty1_4_a
           IF STATUS THEN LET l_qty1_4_a=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(l_qty1_1_a) THEN LET l_qty1_1_a=0 END IF
   IF cl_null(l_qty1_2_a) THEN LET l_qty1_2_a=0 END IF
   IF cl_null(l_qty1_3_a) THEN LET l_qty1_3_a=0 END IF
   IF cl_null(l_qty1_4_a) THEN LET l_qty1_4_a=0 END IF
   IF l_qty1< l_qty1_1_a + l_qty1_2_a + l_qty1_3_a + l_qty1_4_a THEN 
      LET l_qty1 = l_qty1_1_a + l_qty1_2_a + l_qty1_3_a + l_qty1_4_a
   END IF 
   #end-----add by guanyao160922
   #str-----mark by guanyao160919
   ##-------------計算已退-------------##begin
   --LET qty2_1 = 0
   --LET qty2_2 = 0
   --LET qty2_3 = 0
   --LET qty2_4 = 0
   #按作業編號值+工藝段值
   --IF NOT cl_null(l_sql_1) THEN
      --LET l_sql2_1 = l_sql_1 CLIPPED
      --PREPARE i510_tc_sfe03_pre2_1 FROM l_sql2_1
      --DECLARE i510_tc_sfe03_curs2_1 CURSOR FOR i510_tc_sfe03_pre2_1
      --FOREACH i510_tc_sfe03_curs2_1 INTO qty2_1
           --IF STATUS THEN LET qty2_1=0 END IF
           --EXIT FOREACH
      --END FOREACH
   --END IF
   #按作業編號值+工藝段空格
   --IF NOT cl_null(l_sql_2) THEN
      --LET l_sql2_2 = l_sql_2 CLIPPED," AND tc_sfd01 <> '",g_tc_sfd.tc_sfd01,"' "      #TQC-C20473  AND tc_sfd01 <> '",g_tc_sfd.tc_sfd01,"'
      --IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         --LET l_sql2_2 = l_sql2_2 CLIPPED,
                        --" GROUP BY tc_sfe04 ",
                        --" ORDER BY 1 DESC "
      --END IF
      --PREPARE i510_tc_sfe03_pre2_2 FROM l_sql2_2
      --DECLARE i510_tc_sfe03_curs2_2 CURSOR FOR i510_tc_sfe03_pre2_2
      --FOREACH i510_tc_sfe03_curs2_2 INTO qty2_2
           --IF STATUS THEN LET qty2_2=0 END IF
           --EXIT FOREACH
      --END FOREACH
   --END IF
   #按作業編號空格+工藝段值
   --IF NOT cl_null(l_sql_3) THEN
      --LET l_sql2_3 = l_sql_3 CLIPPED
      --PREPARE i510_tc_sfe03_pre2_3 FROM l_sql2_3
      --DECLARE i510_tc_sfe03_curs2_3 CURSOR FOR i510_tc_sfe03_pre2_3
      --FOREACH i510_tc_sfe03_curs2_3 INTO qty2_3
           --IF STATUS THEN LET qty2_3=0 END IF
           --EXIT FOREACH
      --END FOREACH
   --END IF
   #按作業編號空格+工藝段空格
   --IF NOT cl_null(l_sql_4) THEN
      --LET l_sql2_4 = l_sql_4 CLIPPED," AND tc_sfd01 <> '",g_tc_sfd.tc_sfd01,"' "    #TQC-C20473 AND tc_sfd01 <> '",g_tc_sfd.tc_sfd01,"'
      --PREPARE i510_tc_sfe03_pre2_4 FROM l_sql2_4
      --DECLARE i510_tc_sfe03_curs2_4 CURSOR FOR i510_tc_sfe03_pre2_4
      --FOREACH i510_tc_sfe03_curs2_4 INTO qty2_4
           --IF STATUS THEN LET qty2_4=0 END IF
           --EXIT FOREACH
      --END FOREACH
   --END IF
   --IF cl_null(qty2_1) THEN LET qty2_1=0 END IF
   --IF cl_null(qty2_2) THEN LET qty2_2=0 END IF
   --IF cl_null(qty2_3) THEN LET qty2_3=0 END IF
   --IF cl_null(qty2_4) THEN LET qty2_4=0 END IF
   --LET l_qty2 = qty2_1 + qty2_2 + qty2_3 + qty2_4
   ##-------------計算已退-------------##end
   #end-----mark by guanyao160919

   #str-----add by guanyao160817   #工单已经成套发料没走申请单的数量

   LET ls_sql = " SELECT SUM(sfq03) FROM sfq_file, sfp_file ",
               "  WHERE sfq02 = '",p_tc_sfe02,"'",
               "    AND sfq01 = sfp01 ",
               "    AND sfpud02 is null"
   CASE p_flag
       WHEN '1'              #只計算已過帳的
          LET ls_sql = ls_sql CLIPPED,
                      "    AND sfp04 ='Y'"
       WHEN '2'   #只要有效存在於發料當中的都計算進去
          LET ls_sql = ls_sql CLIPPED,
                      "    AND sfpconf !='X'"
       OTHERWISE   #只要有效存在於發料當中的都計算進去
          LET ls_sql = ls_sql CLIPPED,
                      "    AND sfpconf !='X'"
   END CASE

   #FUN-C70014 add begin------Run Card發料時，計算已發和未發套數需要根據Run Card單號查詢
   IF g_argv2 = 'D' AND NOT cl_null(p_tc_sfe014) THEN 
      LET ls_sql = ls_sql CLIPPED," AND sfq014 = '",p_tc_sfe014,"'"
   END IF 
   #FUN-C70014 add end--------
   
   #工藝段與作業編號都有輸入
   IF NOT cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1 = ls_sql CLIPPED," AND sfq04 = '",p_tc_sfe04,"' ",
                                  " AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號值+工藝段空格
      LET ls_sql_2 = ls_sql CLIPPED," AND sfq04 = '",p_tc_sfe04,"' ",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
      #按作業編號空格+工藝段值
      LET ls_sql_3 = ls_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET ls_sql_4 = ls_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')",
                                  " AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #只輸入了作業編號——可以不考慮工藝段了
   IF NOT cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2 = ls_sql CLIPPED," AND sfq04 = '",p_tc_sfe04,"' "
      #按作業編號空格+工藝段值
      LET ls_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET ls_sql_4 = ls_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF
   #只輸入了工藝段——可以不考慮作業編號了
   IF cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段值
      LET ls_sql_3 = ls_sql CLIPPED," AND sfq012= '",p_tc_sfe012,"'"
      #按作業編號空格+工藝段空格
      LET ls_sql_4 = ls_sql CLIPPED," AND (sfq012 IS NULL OR sfq012 = ' ')"
   END IF
   #作業編號和工藝段均未輸入——以作業編號為依據來計算（以工藝段為依據也可以，此處以作業編號）
   IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
      #按作業編號值+工藝段值
      LET ls_sql_1 = ''  #賦值空，代表後面不去計算了
      #按作業編號值+工藝段空格
      LET ls_sql_2 = ls_sql CLIPPED," AND sfq04 IS NOT NULL AND sfq04 != ' ' "
      #按作業編號空格+工藝段值
      LET ls_sql_3 = ''  #賦值空，代表後面不去計算了
      #按作業編號空格+工藝段空格
      LET ls_sql_4 = ls_sql CLIPPED," AND (sfq04 IS NULL OR sfq04 = ' ')"
   END IF

   ##-------------計算已發-------------##begin
   LET l_qty1_1 = 0
   LET l_qty1_2 = 0
   LET l_qty1_3 = 0
   LET l_qty1_4 = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(ls_sql_1) THEN
     #LET l_sql1_1 = l_sql_1 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_1 = ls_sql_1 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_1 FROM ls_sql1_1
      DECLARE i510_sfq03_curs1_1 CURSOR FOR i510_sfq03_pre1_1
      FOREACH i510_sfq03_curs1_1 INTO l_qty1_1
           IF STATUS THEN LET l_qty1_1=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(ls_sql_2) THEN
     #LET l_sql1_2 = l_sql_2 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_2 = ls_sql_2 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         LET ls_sql1_2 = ls_sql1_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i510_sfq03_pre1_2 FROM ls_sql1_2
      DECLARE i510_sfq03_curs1_2 CURSOR FOR i510_sfq03_pre1_2
      FOREACH i510_sfq03_curs1_2 INTO l_qty1_2
           IF STATUS THEN LET l_qty1_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(ls_sql_3) THEN
     #LET l_sql1_3 = l_sql_3 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_3 = ls_sql_3 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_3 FROM ls_sql1_3
      DECLARE i510_sfq03_curs1_3 CURSOR FOR i510_sfq03_pre1_3
      FOREACH i510_sfq03_curs1_3 INTO l_qty1_3
           IF STATUS THEN LET l_qty1_3=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(ls_sql_4) THEN
     #LET l_sql1_4 = l_sql_4 CLIPPED," AND sfp06 = '1'"
      LET ls_sql1_4 = ls_sql_4 CLIPPED," AND sfp06 IN ('1','D')"   #FUN-C70014  sfp06 = '1' --> sfp06 IN ('1','D')
      PREPARE i510_sfq03_pre1_4 FROM ls_sql1_4
      DECLARE i510_sfq03_curs1_4 CURSOR FOR i510_sfq03_pre1_4
      FOREACH i510_sfq03_curs1_4 INTO l_qty1_4
           IF STATUS THEN LET l_qty1_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(l_qty1_1) THEN LET l_qty1_1=0 END IF
   IF cl_null(l_qty1_2) THEN LET l_qty1_2=0 END IF
   IF cl_null(l_qty1_3) THEN LET l_qty1_3=0 END IF
   IF cl_null(l_qty1_4) THEN LET l_qty1_4=0 END IF
   LET ls_qty1 = l_qty1_1 + l_qty1_2 + l_qty1_3 + l_qty1_4
   ##-------------計算已發-------------##end
   LET l_qty1 =l_qty1+ls_qty1
   #end-----add by guanyao160817

   #str-----add by guanyao160919
   ##-------------計算已退-------------##begin
   LET qty2_1 = 0
   LET qty2_2 = 0
   LET qty2_3 = 0
   LET qty2_4 = 0
   #按作業編號值+工藝段值
   IF NOT cl_null(l_sql_1) THEN
      LET l_sql2_1 = l_sql_1 CLIPPED," AND sfp06 = '6'"
      PREPARE i501_sfq03_pre2_1 FROM l_sql2_1
      DECLARE i501_sfq03_curs2_1 CURSOR FOR i501_sfq03_pre2_1
      FOREACH i501_sfq03_curs2_1 INTO qty2_1
           IF STATUS THEN LET qty2_1=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號值+工藝段空格
   IF NOT cl_null(l_sql_2) THEN
      LET l_sql2_2 = l_sql_2 CLIPPED," AND sfp06 = '6'"      #TQC-C20473  AND sfp01 <> '",g_sfp.sfp01,"'
      IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         LET l_sql2_2 = l_sql2_2 CLIPPED,
                        " GROUP BY sfq04 ",
                        " ORDER BY 1 DESC "
      END IF
      PREPARE i501_sfq03_pre2_2 FROM l_sql2_2
      DECLARE i501_sfq03_curs2_2 CURSOR FOR i501_sfq03_pre2_2
      FOREACH i501_sfq03_curs2_2 INTO qty2_2
           IF STATUS THEN LET qty2_2=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段值
   IF NOT cl_null(l_sql_3) THEN
      LET l_sql2_3 = l_sql_3 CLIPPED," AND sfp06 = '6'"
      PREPARE i501_sfq03_pre2_3 FROM l_sql2_3
      DECLARE i501_sfq03_curs2_3 CURSOR FOR i501_sfq03_pre2_3
      FOREACH i501_sfq03_curs2_3 INTO qty2_3
           IF STATUS THEN LET qty2_3=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   #按作業編號空格+工藝段空格
   IF NOT cl_null(l_sql_4) THEN
      LET l_sql2_4 = l_sql_4 CLIPPED," AND sfp06 = '6' "    #TQC-C20473 AND sfp01 <> '",g_sfp.sfp01,"'
      PREPARE i501_sfq03_pre2_4 FROM l_sql2_4
      DECLARE i501_sfq03_curs2_4 CURSOR FOR i501_sfq03_pre2_4
      FOREACH i501_sfq03_curs2_4 INTO qty2_4
           IF STATUS THEN LET qty2_4=0 END IF
           EXIT FOREACH
      END FOREACH
   END IF
   IF cl_null(qty2_1) THEN LET qty2_1=0 END IF
   IF cl_null(qty2_2) THEN LET qty2_2=0 END IF
   IF cl_null(qty2_3) THEN LET qty2_3=0 END IF
   IF cl_null(qty2_4) THEN LET qty2_4=0 END IF
   LET l_qty2 = qty2_1 + qty2_2 + qty2_3 + qty2_4
   ##-------------計算已退-------------##begin
   #end-----add by guanyao160919

   #str----add by guanyao160818  #此批号已经完成的数量
   IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
      LET l_c_sql = " SELECT SUM(tc_sfe03) FROM tc_sfe_file, tc_sfd_file ",
                  "  WHERE tc_sfe02 = '",p_tc_sfe02,"'",
                  "    AND tc_sfe01 = tc_sfd01 ",
                  "    AND tc_sfd07 = '",g_tc_sfd.tc_sfd07,"'"

      CASE p_flag
          WHEN '1'              #只計算已過帳的
             LET l_c_sql = l_c_sql CLIPPED,
                         "    AND tc_sfd04 ='Y'"
          WHEN '2'   #只要有效存在於發料當中的都計算進去
             LET l_c_sql = l_c_sql CLIPPED,
                         "    AND tc_sfd04 !='X'"
          OTHERWISE   #只要有效存在於發料當中的都計算進去
             LET l_c_sql = l_c_sql CLIPPED,
                         "    AND tc_sfd04 !='X'"
       END CASE

      #FUN-C70014 add begin------Run Card發料時，計算已發和未發套數需要根據Run Card單號查詢
      IF g_argv2 = 'D' AND NOT cl_null(p_tc_sfe014) THEN 
         LET l_c_sql = l_c_sql CLIPPED," AND tc_sfe014 = '",p_tc_sfe014,"'"
      END IF 
      #FUN-C70014 add end--------
   
      #工藝段與作業編號都有輸入
      IF NOT cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
         #按作業編號值+工藝段值
         LET l_c_sql_1 = l_c_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' ",
                                     " AND tc_sfe012= '",p_tc_sfe012,"'"
         #按作業編號值+工藝段空格
         LET l_c_sql_2 = l_c_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' ",
                                     " AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
         #按作業編號空格+工藝段值
         LET l_c_sql_3 = l_c_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')",
                                     " AND tc_sfe012= '",p_tc_sfe012,"'"
         #按作業編號空格+工藝段空格
         LET l_c_sql_4 = l_c_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')",
                                     " AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
      END IF
      #只輸入了作業編號——可以不考慮工藝段了
      IF NOT cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         #按作業編號值+工藝段值
         LET l_c_sql_1 = ''  #賦值空，代表後面不去計算了
         #按作業編號值+工藝段空格
         LET l_c_sql_2 = l_c_sql CLIPPED," AND tc_sfe04 = '",p_tc_sfe04,"' "
         #按作業編號空格+工藝段值
         LET l_c_sql_3 = ''  #賦值空，代表後面不去計算了
         #按作業編號空格+工藝段空格
         LET l_c_sql_4 = l_c_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')"
      END IF
      #只輸入了工藝段——可以不考慮作業編號了
      IF cl_null(p_tc_sfe04) AND NOT cl_null(p_tc_sfe012) THEN
         #按作業編號值+工藝段值
         LET l_c_sql_1 = ''  #賦值空，代表後面不去計算了
         #按作業編號值+工藝段空格
         LET l_c_sql_2 = ''  #賦值空，代表後面不去計算了
         #按作業編號空格+工藝段值
         LET l_c_sql_3 = l_c_sql CLIPPED," AND tc_sfe012= '",p_tc_sfe012,"'"
         #按作業編號空格+工藝段空格
         LET l_c_sql_4 = l_c_sql CLIPPED," AND (tc_sfe012 IS NULL OR tc_sfe012 = ' ')"
      END IF
      #作業編號和工藝段均未輸入——以作業編號為依據來計算（以工藝段為依據也可以，此處以作業編號）
      IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
         #按作業編號值+工藝段值
         LET l_c_sql_1 = ''  #賦值空，代表後面不去計算了
         #按作業編號值+工藝段空格
         LET l_c_sql_2 = l_c_sql CLIPPED," AND tc_sfe04 IS NOT NULL AND tc_sfe04 != ' ' "
         #按作業編號空格+工藝段值
         LET l_c_sql_3 = ''  #賦值空，代表後面不去計算了
         #按作業編號空格+工藝段空格
         LET l_c_sql_4 = l_c_sql CLIPPED," AND (tc_sfe04 IS NULL OR tc_sfe04 = ' ')",
                                         "   AND tc_sfe01 <> '",g_tc_sfd.tc_sfd01,"'"  #add by guanyao160918 
      END IF

   
      ##-------------計算已發-------------##begin
      LET c_qty1_1 = 0
      LET c_qty1_2 = 0
      LET c_qty1_3 = 0
      LET c_qty1_4 = 0
      #按作業編號值+工藝段值
      IF NOT cl_null(l_c_sql_1) THEN
        #LET l_c_sql1_1 = l_c_sql_1 CLIPPED," AND tc_sfd06 = '1'"
         LET l_c_sql1_1 = l_c_sql_1 CLIPPED
         PREPARE i510_tc_sfe03_1_f FROM l_c_sql1_1
         DECLARE i510_tc_sfe03_1_c CURSOR FOR i510_tc_sfe03_1_f
         FOREACH i510_tc_sfe03_1_c INTO c_qty1_1
              IF STATUS THEN LET c_qty1_1=0 END IF
              EXIT FOREACH
         END FOREACH
      END IF
      #按作業編號值+工藝段空格
      IF NOT cl_null(l_c_sql_2) THEN
         #LET l_c_sql1_2 = l_c_sql_2 CLIPPED," AND tc_sfd06 = '1'"
         LET l_c_sql1_2 = l_c_sql_2 CLIPPED
         IF cl_null(p_tc_sfe04) AND cl_null(p_tc_sfe012) THEN
            LET l_c_sql1_2 = l_c_sql1_2 CLIPPED,
                           " GROUP BY tc_sfe04 ",
                           " ORDER BY 1 DESC "
         END IF
         PREPARE i510_tc_sfe03_2_f FROM l_c_sql1_2
         DECLARE i510_tc_sfe03_2_c CURSOR FOR i510_tc_sfe03_2_f
         FOREACH i510_tc_sfe03_2_c INTO c_qty1_2
              IF STATUS THEN LET c_qty1_2=0 END IF
              EXIT FOREACH
         END FOREACH
      END IF
      #按作業編號空格+工藝段值
      IF NOT cl_null(l_c_sql_3) THEN
        #LET l_c_sql1_3 = l_c_sql_3 CLIPPED," AND tc_sfd06 = '1'"
         LET l_c_sql1_3 = l_c_sql_3 CLIPPED
         PREPARE i510_tc_sfe03_3_f FROM l_c_sql1_3
         DECLARE i510_tc_sfe03_3_c CURSOR FOR i510_tc_sfe03_3_f
         FOREACH i510_tc_sfe03_3_c INTO c_qty1_3
              IF STATUS THEN LET c_qty1_3=0 END IF
              EXIT FOREACH
         END FOREACH
      END IF
      #按作業編號空格+工藝段空格
      IF NOT cl_null(l_c_sql_4) THEN
         #LET l_c_sql1_4 = l_c_sql_4 CLIPPED," AND tc_sfd06 = '1'"
         LET l_c_sql1_4 = l_c_sql_4 CLIPPED
         PREPARE i510_tc_sfe03_4_f FROM l_c_sql1_4
         DECLARE i510_tc_sfe03_4_c CURSOR FOR i510_tc_sfe03_4_f
         FOREACH i510_tc_sfe03_4_c INTO c_qty1_4
              IF STATUS THEN LET c_qty1_4=0 END IF
              EXIT FOREACH
         END FOREACH
      END IF
      IF cl_null(c_qty1_1) THEN LET c_qty1_1=0 END IF
      IF cl_null(c_qty1_2) THEN LET c_qty1_2=0 END IF
      IF cl_null(c_qty1_3) THEN LET c_qty1_3=0 END IF
      IF cl_null(c_qty1_4) THEN LET c_qty1_4=0 END IF
      LET l_qty1_a = c_qty1_1 + c_qty1_2 + c_qty1_3 + c_qty1_4
      SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file WHERE sfb01 = p_tc_sfe02 
      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF 
      SELECT SUM (shm08) INTO l_sfb08_1 FROM shm_file 
       WHERE shm012 = p_tc_sfe02 
         AND ta_shm05 = g_tc_sfd.tc_sfd07
      IF cl_null(l_sfb08_1) THEN LET l_sfb08_1 = 0  END IF 
      #IF (l_sfb08-l_sfb08_1)<= ls_qty1 THEN   #mark by guanyao160918
      IF (l_sfb08-l_sfb08_1)<=l_qty1 THEN      #add by guanyao160918
         #LET l_qty1 = l_sfb08_1-(l_qty1-(l_sfb08-l_sfb08_1))-l_qty1_a  #mark by guanyao160919
         LET l_qty1 = l_qty1-(l_sfb08-l_sfb08_1)+l_qty1_a
      ELSE 
         LET l_qty1=l_qty1_a
      END IF 
   END IF 
   #end----add by guanyao160818
   RETURN l_qty1,l_qty2

END FUNCTION
#FUN-BC0060 add--end
 
FUNCTION i510_set_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' OR p_cmd = 'u' THEN
       CALL cl_set_comp_entry("tc_sfe03",TRUE)
    END IF
END FUNCTION
 
FUNCTION i510_set_no_entry_d(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF g_tc_sfd06 NOT MATCHES '[16ABD]' THEN #FUN-5C0114 add AB #FUN-740232 將3拿掉 #FUN-C70014 add 'D'
       CALL cl_set_comp_entry("tc_sfe03",FALSE)
    END IF
END FUNCTION


#CHI-C50011 str add-----
FUNCTION i510_chk_entry_tc_sff27()
    IF cl_null(g_tc_sff[l_ac].tc_sff26) OR g_sma.sma107='N' THEN  #TQC-C70050 add sma107
       CALL cl_set_comp_entry("tc_sff27",FALSE)
    ELSE
       CALL cl_set_comp_entry("tc_sff27",TRUE)
    END IF
END FUNCTION

FUNCTION i510_tc_sff09_chkall()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5

   IF g_tc_sff.getlength() = 0  THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      FOR l_cnt = 1 TO  g_tc_sff.getlength()
         CALL s_get_where(g_tc_sfd.tc_sfd01,g_tc_sff[l_cnt].tc_sff03,'',g_tc_sff[l_cnt].tc_sff04,g_tc_sff[l_cnt].tc_sff07,g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfd06) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0 
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_tc_sff[l_cnt].tc_sff09,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE 
            END IF
         END IF 
      END FOR
   END IF    
   RETURN TRUE 
END FUNCTION 

FUNCTION i510_tc_sfdud02(p_cmd)  #申請人編號
 DEFINE   p_cmd      LIKE type_file.chr1,
          l_gen02    LIKE gen_file.gen02,
          l_genacti  LIKE gen_file.genacti

    LET g_errno = ' '

    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file
     WHERE gen01 = g_tc_sfd.tc_sfdud02
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='mfg1312'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION

FUNCTION i510_sfb01(p_sfb01)
   DEFINE p_sfb01   LIKE sfb_file.sfb01
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(p_sfb01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(p_sfb01)
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy69 = l_slip
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-875'    #不可使用组合拆解对应工单单别
   END IF

END FUNCTION


FUNCTION i510_g_b()
  DEFINE l_gen02         LIKE gen_file.gen02    #No.FUN-940039 add
  DEFINE qty1,qty2	 LIKE tc_sfe_file.tc_sfe03    #No.FUN-680121 DEC(15,3)
 #DEFINE l_qty           LIKE tc_sfe_file.tc_sfe03    #NO.FUN-A20048  #FUN-AC0074 mark
  DEFINE l_n             LIKE type_file.num5    #No.FUN-680121 SMALLINT
  DEFINE l_cnt           LIKE type_file.num5    #No.MOD-640402  #No.FUN-680121 SMALLINT
  DEFINE l_tc_sfe02         LIKE tc_sfe_file.tc_sfe02
  DEFINE l_i             LIKE type_file.num5    #add FUN-A20048 add
  DEFINE l_sql           STRING #FUN-5C0114
  DEFINE l_date          LIKE type_file.dat     #No.FUN-680121 DATE   #FUN-5C0114 有效日
  DEFINE l_bmb RECORD
                 bmb03   LIKE bmb_file.bmb03,
                 bmb06   LIKE bmb_file.bmb06,
                 bmb07   LIKE bmb_file.bmb07,
                 bmb08   LIKE bmb_file.bmb08,
                 bmb16   LIKE bmb_file.bmb16
               END RECORD
  DEFINE l_sre051    LIKE sre_file.sre051   #No.FUN-870041
  DEFINE l_sfa36     LIKE sfa_file.sfa36    #FUN-950088 add 
  #DEFINE l_sma894    STRING                     #No.TQC-A50063  #FUN-D30024
  #No.FUN-A70034  --Begin
  DEFINE l_bmb081    LIKE bmb_file.bmb081
  DEFINE l_bmb082    LIKE bmb_file.bmb082
  DEFINE l_total     LIKE sfa_file.sfa05     #总用量
  DEFINE l_QPA       LIKE bmb_file.bmb06     #标准QPA
  DEFINE l_ActualQPA LIKE bmb_file.bmb06     #实际QPA
  #No.FUN-A70034  --End  
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02                   #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03                 #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03
  #FUN-AC0074 (E)
  IF g_tc_sfd06 MATCHES '[2479C]' THEN RETURN END IF #FUN-5C0114 add C
  IF g_tc_sfd.tc_sfd04 = 'Y'   THEN CALL cl_err('','9023',0) RETURN END IF   #MOD-D60244 add
  LET noqty = 'Y'
  LET short_data = 'N'
  LET part_type = ' '
  LET issue_type = '1'

  LET b_part = '0'
  LET e_part = 'Z'
  LET ware_no = NULL #MOD-4A0145
  LET loc_no = NULL  #MOD-4A0145
  LET lot_no = NULL  #MOD-4A0145
  LET gen_no = NULL  #MOD-9C0195 add
  LET gen_all = 'Y'  #FUN-A20048 add
  DELETE FROM tc_sff_file WHERE tc_sff01=g_tc_sfd.tc_sfd01  #add by guanyao160908
 
  #1)當發/退料方式選擇1:依料件主要倉庫/儲位/倉管員發退料時,
  #  指定倉庫,指定儲位,指定倉管員字段變為QBE方式
  #  對應table字段:ima35,ima36,ima23
  #2)當發/退料方式選擇2:依下列指定倉庫/儲位/批號/倉管員發退料時,
  #  則不篩選,指定倉庫,指定儲位字段與原來一致,邏輯也不變,
  #  代表所有備料的發料都指定此倉儲批
  #3)當發/退料方式選擇3:依工單指定倉庫/儲位/倉管員發退料時,
  #  指定倉庫,指定儲位,指定倉管員字段變為QBE方式
  #  對應table字段:sfa30,sfa31,ima23
  LET g_x = 1   #str--add by huanglf160823
  DECLARE i510_g_b_c CURSOR FOR
         SELECT * FROM tc_sfe_file WHERE tc_sfe01=g_tc_sfd.tc_sfd01 AND tc_sfeud02 = 'Y'
      FOREACH i510_g_b_c INTO b_tc_sfe.*
         SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01=b_tc_sfe.tc_sfe02
         IF STATUS THEN 
            CALL cl_err3("sel","sfb_file",b_tc_sfe.tc_sfe02,"",STATUS,"","sel sfb:",1)  #No.FUN-660128
            RETURN
         END IF
         IF g_sfb.sfb08<=(qty1-qty2+b_tc_sfe.tc_sfe03) THEN
            CALL i510_g_b0()#全數發料
         #str----add by guanyao160824
         ELSE 
            CALL i510_g_b1()#依套數
         END IF 
         #end----add by guanyao160824
      END FOREACH 
 
  DISPLAY ARRAY g_tc_sff TO s_tc_sff.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
    BEFORE DISPLAY
       EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION


FUNCTION i510_g_b0() 		# 全數發料 (除了消耗料件&代買料件)
  DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02              #FUN-B80086  main改成mai
  DEFINE l_mai_loc	  LIKE img_file.img03            #FUN-B80086  main改成mai
  DEFINE l_wip_ware	  LIKE img_file.img02
  DEFINE l_wip_loc	  LIKE img_file.img03
  #FUN-AC0074 (E)
  #LET g_x =1    #mark by huanglf160823
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_tc_sfe.tc_sfe02,"'",
              "   AND sfa05>sfa06", 
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X','S') OR sfa11 IS NULL)", #CHI-980013 #FUN-9C0040 
              "   AND (sfa05-sfa065)>0"   #應發-委外代買量>0
 
  IF NOT cl_null(b_tc_sfe.tc_sfe04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_tc_sfe.tc_sfe04,"'"
  END IF
#FUN-B20095 -----------------Begin--------------------
  IF NOT cl_null(b_tc_sfe.tc_sfe012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_tc_sfe.tc_sfe012,"'"
  END IF 
#FUN-B20095 -----------------End----------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE i510_g_b0_pre FROM l_sql
  DECLARE i510_g_b0_c CURSOR FOR i510_g_b0_pre
  
  FOREACH i510_g_b0_c INTO g_sfa2.*,g_ima108
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
 
    LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
    #FUN-AC0074(S)
    CALL i510_issue_sie()
    IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
    #FUN-AC0074(E) 
    IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
    IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
    #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
    #FUN-AC0074 (S)
     SELECT ima35,ima36,ima136,ima137
       INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file            #FUN-B80086  main改成mai
      WHERE ima01=g_sfa2.sfa03
    #FUN-AC0074 (E)
    CALL i510_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074   #FUN-B80086  main改成mai 
    #str------mark by guanyao160824
    # LET issue_qty2=issue_qty1
    # IF issue_qty2 < =0 THEN CONTINUE FOREACH END IF
    # CALL i510_ins_tc_sff()
    # LET img_qty = issue_qty1 #No.+238
    #end------mark by guanyao160824
  END FOREACH
 
END FUNCTION

#str----add by guanyao160824
FUNCTION i510_g_b1() 		# 依套數發料/退料(When sfp06=1/6)
  DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(1000)
  DEFINE s_u_flag	LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
  #FUN-AC0074 (S)
  DEFINE l_mai_ware	LIKE img_file.img02       #FUN-B80086  main改成mai
  DEFINE l_mai_loc	LIKE img_file.img03       #FUN-B80086  main改成mai
  DEFINE l_wip_ware	LIKE img_file.img02
  DEFINE l_wip_loc	LIKE img_file.img03
  #FUN-AC0074 (E)
  DEFINE l_bmd07        LIKE bmd_file.bmd07     #TQC-C30067 add
  DEFINE l_bmd10        LIKE bmd_file.bmd10     #TQC-C30067 add
  DEFINE l_sum_tc_sff05   LIKE tc_sff_file.tc_sff05  #tianry add 161122
  LET l_sql = "SELECT sfa_file.*,ima108 FROM sfa_file, ima_file",
              " WHERE sfa01='",b_tc_sfe.tc_sfe02,"'",                        #tianry add 'S'
              "   AND sfa26 IN ('0','1','2','3','4','5','T','7','8','9','A')",    #bugno:7111 add '5T'  #FUN-A20037 add '7,8' #TQC-C20443 add ,'9' 'A'
              "   AND sfa03=ima01 AND (sfa11 NOT IN ('E','X') OR sfa11 IS NULL)", #CHI-980013
              "   AND (sfa05-sfa065)>=0"    #應發-委外代買量>0   #No:9390   #No.MOD-570241 modify

  LET l_sql = l_sql CLIPPED," AND sfa11 <> 'S' " #FUN-9C0040
    
 
  IF NOT cl_null(b_tc_sfe.tc_sfe04) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa08 = '",b_tc_sfe.tc_sfe04,"'"
  END IF
#FUN-B20095 ---------------------Begin-------------------------- 
  IF NOT cl_null(b_tc_sfe.tc_sfe012) THEN
     LET l_sql = l_sql CLIPPED,"  AND sfa012 = '",b_tc_sfe.tc_sfe012,"'"
  END IF
#FUN-B20095 ---------------------END----------------------------
  LET l_sql = l_sql CLIPPED," ORDER BY sfa03"
  PREPARE i501_g_b1_pre FROM l_sql
  DECLARE i501_g_b1_c CURSOR FOR i501_g_b1_pre
 
  FOREACH i501_g_b1_c INTO g_sfa.*,g_ima108	#原始料件(g_sfa)
    IF part_type = 'Y' AND (g_ima108= 'N' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    IF part_type = 'N' AND (g_ima108 = 'Y' OR cl_null(g_ima108)) THEN
       CONTINUE FOREACH
    END IF
 
    LET g_sfa.sfa05=g_sfa.sfa05-g_sfa.sfa065   #扣除委外代買量
 
    IF STATUS THEN CALL cl_err('fore sfa',STATUS,1) RETURN END IF
 
 
    LET issue_qty  =b_tc_sfe.tc_sfe03*g_sfa.sfa161		#原始料件應發/退數量
    #tianry add 161122   #当尾单数量大于应发-已申请的时候    使用申请数量判断
    SELECT SUM(tc_sff05) INTO l_sum_tc_sff05 FROM tc_sff_file,tc_sfd_file 
    WHERE tc_sff01=tc_sfd01 AND tc_sfd04!='X' AND tc_sfd01!=g_tc_sfd.tc_sfd01 AND tc_sff03=g_sfa.sfa01
    AND tc_sff04=g_sfa.sfa03 AND tc_sff07=g_sfa.sfa08 
    IF cl_null(l_sum_tc_sff05) THEN LET  l_sum_tc_sff05=0 END IF 
    IF issue_qty> g_sfa.sfa05-l_sum_tc_sff05   AND g_sfa.sfa05!=0  AND g_sfa.sfa26!='4'  THEN
       LET issue_qty=g_sfa.sfa05-l_sum_tc_sff05
    END IF 

    #tianry add end 
   IF g_sfa.sfa26 MATCHES '[01257]' THEN   #FUN-A20037 add '7' 
       #若是全數代買時則不允許做退料
       IF g_sfa.sfa05 = 0 THEN 
          CONTINUE FOREACH
       END IF
       IF g_argv1='1' AND issue_qty>(g_sfa.sfa05-g_sfa.sfa06) THEN  #FUN-B50059
          LET issue_qty=(g_sfa.sfa05-g_sfa.sfa06)   #FUN-B50059
       END IF
 
       IF g_argv1='2' AND issue_qty>g_sfa.sfa06 THEN  #FUN-B50059
          LET issue_qty=g_sfa.sfa06   #FUN-B50059
       END IF

       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 
       LET g_sfa2.* = g_sfa.*
 
       LET issue_qty1=issue_qty
 
       #FUN-AC0074(S)
       CALL i510_issue_sie()
       IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
       #FUN-AC0074 (E)

       #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
 
       #FUN-AC0074 (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file           #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 (E)
       CALL i510_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai

       CONTINUE FOREACH
 
    END IF
 
    # 當有替代狀況時, 須作以下處理:
    LET l_sql="SELECT * FROM sfa_file",
              " WHERE sfa01='",g_sfa.sfa01,"' AND sfa27='",g_sfa.sfa03,"'",
              "   AND sfa08='",g_sfa.sfa08,"' AND sfa12='",g_sfa.sfa12,"'",
              "   AND sfa012= '",g_sfa.sfa012,"' AND sfa013 = ",g_sfa.sfa013   #FUN-A60028 add
 
    SELECT MAX(sfa26) INTO s_u_flag FROM sfa_file	# 到底是 S 或 U ?
                WHERE sfa01=g_sfa.sfa01 AND sfa27=g_sfa.sfa03
                  AND sfa08=g_sfa.sfa08 AND sfa12=g_sfa.sfa12
                  AND sfa012=g_sfa.sfa012 AND sfa013=g_sfa.sfa013   #FUN-A60028 add
    # U:先發取代件,再發原料件 S:先發原料件,再發替代件
    IF s_u_flag='U' OR s_u_flag = 'T' THEN     #bungo:711l add 'T'
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26 DESC, sfa03"
    ELSE
       LET l_sql=l_sql CLIPPED," ORDER BY sfa26     , sfa03"
    END IF
    PREPARE g_b1_p2 FROM l_sql
    DECLARE g_b1_c2 CURSOR FOR g_b1_p2
    FOREACH g_b1_c2 INTO g_sfa2.*	             #應發(含替代)料件(g_sfa2
       LET g_sfa2.sfa05=g_sfa2.sfa05-g_sfa2.sfa065   #扣除委外代買量
       IF STATUS THEN CALL cl_err('f sfa2',STATUS,1) RETURN END IF
       LET issue_qty=issue_qty*g_sfa2.sfa28
       #FUN-AC0074 (S)
        SELECT ima35,ima36,ima136,ima137
          INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file         #FUN-B80086  main改成mai
         WHERE ima01=g_sfa2.sfa03
       #FUN-AC0074 (E) 
       IF cl_null(g_sfa2.sfa30) THEN LET g_sfa2.sfa30 = ' '  END IF    #MOD-B50240 add
       IF cl_null(g_sfa2.sfa31) THEN LET g_sfa2.sfa31 = ' '  END IF    #MOD-B50240 add
 # issue_qty的計算應以sfq03* sfa161來計算才不會被改變,影響後續欠料數量的計算
       IF g_argv1='1' THEN	# 發料時
         # IF g_sfa2.sfa05<=g_sfa2.sfa06 THEN CONTINUE FOREACH END IF #FUN-B50059 #darcy: mod 20220314
         IF g_sfa2.sfa05<=g_sfa2.sfa06  OR g_action_choice='alteraction2' THEN CONTINUE FOREACH END IF #FUN-B50059 #darcy: add 20220314
         IF issue_qty<=(g_sfa2.sfa05-g_sfa2.sfa06) THEN  #FUN-B50059
            LET issue_qty1=issue_qty
            #FUN-AC0074(S)
            CALL i510_issue_sie()
            IF issue_qty1 <=0 THEN CONTINUE FOREACH END IF
            #FUN-AC0074 (E)
            #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
            CALL i510_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
          #  EXIT FOREACH  #tianry mark
         ELSE
            LET issue_qty1=(g_sfa2.sfa05-g_sfa2.sfa06)  #FUN-B50059
            #CALL i500_chk_ima64(g_sfa2.sfa03, issue_qty1) RETURNING issue_qty1  #mark by guanyao160601
            CALL i510_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,lot_no,FALSE)		# 依 issue_qty1 尋找 img_file可用資料           #FUN-AC0074 #FUN-B80086  main改成mai
            LET issue_qty=(issue_qty-img_qty)/g_sfa2.sfa28
         END IF
       END IF
    END FOREACH
  END FOREACH
END FUNCTION

FUNCTION i510_chk_img(l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc,l_lot_no,l_sie_flag)	# 依 issue_qty1 尋找 img_file可用資料  #FUN-AC0074     #FUN-B80086  main改成mai
    DEFINE l_sql		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(600)
    DEFINE l_img10              LIKE img_file.img10    #No.MOD-910026
    DEFINE l_factor             LIKE img_file.img21    #No.MOD-940302 add
    DEFINE l_cnt                LIKE type_file.num5    #No.MOD-940302 add
    DEFINE l_n                  LIKE type_file.num5    #CHI-B90038 add
    define l_mai_ware	LIKE img_file.img02        #FUN-B80086  main改成mai
    define l_mai_loc	LIKE img_file.img03        #FUN-B80086  main改成mai
    define l_wip_ware	LIKE img_file.img02
    define l_wip_loc	LIKE img_file.img03
    DEFINE l_lot_no LIKE img_file.img04  #FUN-AC0074
    DEFINE l_sie_flag LIKE type_file.num5  #TRUE->依備置單產生  FALSE->不依備置產生
    DEFINE l_flag       LIKE type_file.chr1   #MOD-CB0046 add
    DEFINE l_img09      LIKE img_file.img09   #MOD-CB0046 add
    
    #FUN-AC0074 mark (S)
    #SELECT ima35,ima36,ima136,ima137
    #  INTO l_mai_ware,l_mai_loc,l_wip_ware,l_wip_loc FROM ima_file      #FUN-B80086  main改成mai
    # WHERE ima01=g_sfa2.sfa03
    #FUN-AC0074 mark (E)
    #Add No.FUN-AB0018

    LET issue_qty2=issue_qty1
    CALL i510_ins_tc_sff()
    LET img_qty = issue_qty1 #No.+238
    RETURN
END FUNCTION 
#end----add by guanyao160824

FUNCTION i510_issue_sie()
  DEFINE l_sie         RECORD LIKE sie_file.*
  DEFINE l_issue_qty1  LIKE tc_sfe_file.tc_sfe03
  DEFINE l_sql,l_where         STRING

    IF g_tc_sfd06 NOT MATCHES '[13]' THEN RETURN END IF
    LET l_where =''
    IF issue_type = '2' THEN
       IF NOT cl_null(ware_no) THEN LET l_where=l_where," AND sie02 ='",ware_no,"'" END IF
       IF NOT cl_null(loc_no) THEN LET l_where=l_where," AND sie03 ='",loc_no,"'" END IF
       IF NOT cl_null(lot_no) THEN LET l_where=l_where," AND sie04 ='",lot_no,"'" END IF
    END IF    
    LET l_sql = "SELECT sie_file.* FROM ima_file, sfa_file, sie_file ",
                " WHERE sfa01 =  '",g_sfa2.sfa01 ,"'",
                "   AND sfa03 =  '",g_sfa2.sfa03 ,"'",
                "   AND sfa08 =  '",g_sfa2.sfa08 ,"'",
                "   AND sfa12 =  '",g_sfa2.sfa12 ,"'",
                "   AND sfa27 =  '",g_sfa2.sfa27 ,"'",
                "   AND sfa012=  '",g_sfa2.sfa012,"'",
                "   AND sfa013=  '",g_sfa2.sfa013,"'",
                "   AND ima01 = sfa03  AND sfa01=sie05 AND sfa27=sie01 ",
                "   AND sfa03 = sie08  AND sfa08=sie06 AND sfa12=sie07 ",
                "   AND sfa012= sie012 AND sfa013=sie013 ",
                "   AND sie11 > 0 AND (sie02 IS NOT NULL AND sie02 <> ' ')",l_where
    PREPARE i510_g_b0_pre1 FROM l_sql
    DECLARE i510_g_b0_c1 CURSOR FOR i510_g_b0_pre1
    FOREACH i510_g_b0_c1 INTO l_sie.*
      IF issue_qty1 <=0 THEN EXIT FOREACH END IF
       LET l_issue_qty1 = issue_qty1
       IF l_sie.sie11 > issue_qty1 THEN 
          LET issue_qty1 = issue_qty1
       ELSE  
          LET issue_qty1 = l_sie.sie11
       END IF 
       LET issue_qty2=issue_qty1
       CALL i510_ins_tc_sff()
       LET issue_qty1 = l_issue_qty1 - issue_qty2
       IF issue_qty1 < 0 THEN LET issue_qty1 = 0 END IF
       
    END FOREACH
END FUNCTION

FUNCTION i510_ins_tc_sff()	# 依 issue_qty2 Insert tc_sff_file
DEFINE l_gfe03 LIKE gfe_file.gfe03 #MOD-640364
DEFINE l_tot   LIKE tc_sff_file.tc_sff05 #No.TQC-750232    #記錄未過賬退料數量
DEFINE l_count LIKE type_file.num5   #NO.FUN-A40053 add 
DEFINE l_ima64 LIKE ima_file.ima64 #add by guanyao160601
 
    SELECT gfe03 INTO l_gfe03 FROM gfe_file
       WHERE gfe01=g_sfa2.sfa12
    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
       LET l_gfe03=0
    END IF
    #FUN-A40053 -add --begin
    IF gen_all ='Y' AND g_flag_sie01 = 'Y' THEN  
       SELECT COUNT(*) INTO l_count FROM sie_file WHERE sie01 = g_img.img01 
               AND sie02 = g_img.img02 AND sie03 = g_img.img03 
               AND sie04 = g_img.img04 AND sie05 = b_tc_sfe.tc_sfe02 
       IF l_count > 0 THEN 
          LET g_flag_sie01 = 'N'
          RETURN 
       END IF 
     END IF 
    #FUN-A40053 --add --end 
    LET b_tc_sff.tc_sff01=g_tc_sfd.tc_sfd01
    LET b_tc_sff.tc_sff02=g_x 
    LET b_tc_sff.tc_sff03=b_tc_sfe.tc_sfe02
    LET b_tc_sff.tc_sff04=g_sfa2.sfa03
    LET b_tc_sff.tc_sff05=issue_qty2 #MOD-640364
    LET b_tc_sff.tc_sff06=g_sfa2.sfa12
    LET b_tc_sff.tc_sff05=s_digqty(issue_qty2,b_tc_sff.tc_sff06)  #FUN-D60039 add
    LET b_tc_sff.tc_sff07=g_sfa2.sfa08
    LET b_tc_sff.tc_sff26=NULL
    LET b_tc_sff.tc_sff27=NULL
    LET b_tc_sff.tc_sff28=NULL
    IF g_sfa2.sfa26 MATCHES '[SUTZ9BC]' THEN  #FUN-A20037 add 'Z' #TQC-C20443 add '9'
       LET b_tc_sff.tc_sff26=g_sfa2.sfa26
       LET b_tc_sff.tc_sff27=g_sfa2.sfa27
       LET b_tc_sff.tc_sff28=g_sfa2.sfa28
    END IF
    IF g_sfa2.sfa26 = 'A' THEN LET  b_tc_sff.tc_sff26 = '9' END IF  #TQC-C20443 add
    
#FUN-A60028 --begin--
    LET b_tc_sff.tc_sff012 = g_sfa2.sfa012
    LET b_tc_sff.tc_sff013 = g_sfa2.sfa013
#FUN-A60028 --end--    

#FUN-A60028 --begin--
    IF cl_null(b_tc_sff.tc_sff012) THEN LET b_tc_sff.tc_sff012 = ' ' END IF 
    IF cl_null(b_tc_sff.tc_sff013) THEN LET b_tc_sff.tc_sff013 = 0   END IF  
#FUN-A60028 --end--  

#FUN-C70014 add begin--------------   
    LET b_tc_sff.tc_sff014 = b_tc_sfe.tc_sfe014  
    IF cl_null(b_tc_sff.tc_sff014) THEN LET b_tc_sff.tc_sff014 = ' ' END IF
#FUN-C70014 add end ---------------
    IF g_sma.sma115 = 'Y' THEN
       CALL i510_set_du_by_origin()
    END IF
    IF cl_null(b_tc_sff.tc_sff27) THEN
       LET b_tc_sff.tc_sff27=b_tc_sff.tc_sff04
    END IF
    IF cl_null(b_tc_sff.tc_sff27) THEN
       LET b_tc_sff.tc_sff27 = ' '
    END IF
 
    LET b_tc_sff.tc_sffplant = g_plant #FUN-980008 add
    LET b_tc_sff.tc_sfflegal = g_legal #FUN-980008 add
    IF g_aza.aza115 ='Y' THEN    
       LET b_tc_sff.tc_sff09=s_reason_code(b_tc_sff.tc_sff01,b_tc_sff.tc_sff03,'',b_tc_sff.tc_sff04,'',g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfd06) 
    END IF
    #FUN-CB0087--add--str--
    LET b_tc_sff.tc_sffud02 = 'Y'
    LET g_x = g_x +1
    INSERT INTO tc_sff_file VALUES(b_tc_sff.*)
    IF STATUS THEN 
       CALL cl_err3("ins","tc_sff_file",b_tc_sff.tc_sff01,b_tc_sff.tc_sff02,STATUS,"","ins tc_sff:",1)  #No.FUN-660128
    END IF
    
END FUNCTION

FUNCTION i510_d_fill(p_wc2)              #BODY FILL UP
 DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(800)
 DEFINE l_ima01 LIKE ima_file.ima01
 
       LET g_sql =
           "SELECT tc_sfe014,tc_sfe02,tc_sfe012,'',tc_sfe04,sfb05,'','',tc_sfe05,tc_sfe06,tc_sfe07,tc_sfe03", #No.FUN-870097 add tc_sfe06 #FUN-5C0114 add tc_sfe05 #FUN-940008 add tc_sfe07  #FUN-B20095 add tc_sfe012,'' #FUN-C70014 add tc_sfe014
           ",tc_sfeud01,tc_sfeud02,tc_sfeud03,tc_sfeud04,tc_sfeud05,",
           "tc_sfeud06,tc_sfeud07,tc_sfeud08,tc_sfeud09,tc_sfeud10,",
           "tc_sfeud11,tc_sfeud12,tc_sfeud13,tc_sfeud14,tc_sfeud15", 
           " FROM tc_sfe_file LEFT OUTER JOIN sfb_file ON tc_sfe02 = sfb01 ",                     #09/10/21 xiaofeizhu Add
           " WHERE tc_sfe01 ='",g_tc_sfd.tc_sfd01,"' ",
           " ORDER BY tc_sfe02"                                                                #09/10/21 xiaofeizhu Add
    
    PREPARE i510_pd FROM g_sql
    DECLARE tc_sfe_curs CURSOR FOR i510_pd
 
    CALL g_tc_sfe.clear()
 
    LET g_cnt = 1
    LET g_rec_d = 0
 
    FOREACH tc_sfe_curs INTO g_tc_sfe[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

       LET l_ima01=g_tc_sfe[g_cnt].sfb05

       SELECT ima02,ima021 INTO g_tc_sfe[g_cnt].ima02_a, g_tc_sfe[g_cnt].ima021_a
         FROM ima_file
        WHERE ima01=l_ima01
       CALL s_schdat_ecm014(g_tc_sfe[g_cnt].tc_sfe02,g_tc_sfe[g_cnt].tc_sfe012)    #FUN-B20095
          RETURNING g_tc_sfe[g_cnt].ecm014                                #FUN-B20095
       LET g_cnt = g_cnt + 1
    END FOREACH
 
    IF STATUS THEN CALL cl_err('fore tc_sfe:',STATUS,1) END IF
    CALL g_tc_sfe.deleteElement(g_cnt)
 
    LET g_rec_d = g_cnt - 1
 
    DISPLAY g_rec_d TO FORMONLY.cn3
 
    DISPLAY ARRAY g_tc_sfe TO s_tc_sfe.* ATTRIBUTE(COUNT=g_rec_d,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
 
END FUNCTION
 
FUNCTION i510_b_fill(p_wc2)              #BODY FILL UP
    DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(800)
    DEFINE l_factor        LIKE ima_file.ima31_fac  #TQC-7B0065
    DEFINE l_cnt           LIKE type_file.num5  #TQC-7B0065
    DEFINE l_sfb05         LIKE sfb_file.sfb05  #FUN-A60028
    DEFINE l_sfb06         LIKE sfb_file.sfb06   #FUN-A60028
    DEFINE l_flag          LIKE type_file.num5   #MOD-AC0336
    DEFINE l_flag1         LIKE type_file.chr1   #FUN-B20095
    DEFINE i               LIKE type_file.num5   #FUN-B20095
    DEFINE l_sfa05_r       LIKE sfa_file.sfa05   #TQC-CA0035 add

    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF 
    
       LET g_sql =
        "SELECT tc_sff02,tc_sff26,tc_sff28,tc_sff014,tc_sff03,tc_sff27,tc_sff04,ima02,ima021,tc_sff012,'',tc_sff013,tc_sff06,tc_sff07,(sfa05-sfa065),sfa06,'',",   
        "       tc_sff05,tc_sff08,0,0,tc_sff09,azf03 ",     
        "       ,tc_sffud01,tc_sffud02,tc_sffud03,tc_sffud04,tc_sffud05,",
        "       tc_sffud06,tc_sffud07,tc_sffud08,tc_sffud09,tc_sffud10,",
        "       tc_sffud11,tc_sffud12,tc_sffud13,tc_sffud14,tc_sffud15", 
        "  FROM tc_sff_file LEFT OUTER JOIN sfa_file ON tc_sff03=sfa01 AND tc_sff06=sfa12 AND tc_sff07=sfa08 ",   #MOD-BB0307 Add
        "   AND tc_sff012=sfa012 AND tc_sff013=sfa013 AND tc_sff27=sfa27 AND tc_sff04=sfa03 ",                   
        " LEFT OUTER JOIN ima_file ON tc_sff04=ima01 ",                                                  #09/10/21 xiaofeizhu Add
        " LEFT OUTER JOIN azf_file ON tc_sff09=azf01 AND azf02 = '2' ",                                  #FUN-CB0087 add
        " WHERE tc_sff01 ='",g_tc_sfd.tc_sfd01,"'", 

       "   AND ",p_wc2 CLIPPED,             
       " ORDER BY tc_sff02 "  
    PREPARE i510_pb FROM g_sql
    DECLARE tc_sff_curs CURSOR FOR i510_pb  
 
    CALL g_tc_sff.clear()
 
    LET g_cnt = 1
 
    FOREACH tc_sff_curs INTO g_tc_sff[g_cnt].*, g_short_qty #單身 ARRAY 填充#FUN-940039 add 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        SELECT SUM(img10) INTO g_tc_sff[g_cnt].img10  FROM img_file WHERE img01 =  g_tc_sff[g_cnt].tc_sff04
        #計算欠料量g_short_qty(原g_sfa07)
         IF cl_null(g_tc_sff[g_cnt].tc_sff012) THEN LET g_tc_sff[g_cnt].tc_sff012=' ' END IF #TQC-CB0084 add 
         IF cl_null(g_tc_sff[g_cnt].tc_sff013) THEN LET g_tc_sff[g_cnt].tc_sff013= 0  END IF #TQC-CB0084 add 
         CALL s_shortqty(g_tc_sff[g_cnt].tc_sff03,g_tc_sff[g_cnt].tc_sff04,g_tc_sff[g_cnt].tc_sff07,
                         g_tc_sff[g_cnt].tc_sff06,g_tc_sff[g_cnt].tc_sff27,
                         g_tc_sff[g_cnt].tc_sff012,g_tc_sff[g_cnt].tc_sff013)  
              RETURNING g_short_qty
         IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
         LET g_tc_sff[g_cnt].short_qty = g_short_qty
 
        IF g_tc_sfd.tc_sfd04='N' THEN
           SELECT SUM(sfs05) INTO g_tc_sff[g_cnt].img10_alo FROM sfs_file,sfp_file #No:8247
            WHERE sfs04=g_tc_sff[g_cnt].tc_sff04
              AND sfp01=sfs01 AND sfpconf!='X'  #No:8247  #FUN-660106
              AND sfs03 = g_tc_sff[g_cnt].tc_sff03
           IF g_tc_sfd06='3' THEN
              LET g_tc_sff[g_cnt].sfa05=g_short_qty   #FUN-940039 add
              LET g_tc_sff[g_cnt].sfa06=0
           END IF
        END IF
        
        CALL s_schdat_ecm014(g_tc_sff[g_cnt].tc_sff03,g_tc_sff[g_cnt].tc_sff012) RETURNING g_tc_sff[g_cnt].ecu014       
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore tc_sff:',STATUS,1) END IF
    CALL g_tc_sff.deleteElement(g_cnt)
    
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY ARRAY g_tc_sff TO s_tc_sff.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
    END DISPLAY
  
END FUNCTION
 
FUNCTION i510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_tc_sfe TO s_tc_sfe.* ATTRIBUTE(COUNT=g_rec_d)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
   END DISPLAY
  
   DISPLAY ARRAY g_tc_sff TO s_tc_sff.* ATTRIBUTE(COUNT=g_rec_b)
     
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   END DISPLAY
   
      #No.TQC-A70090  --start--
      BEFORE DIALOG                     
         CALL cl_show_fld_cont()
      #No.TQC-A70090  --end--
     #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
     #FUN-CB0014---add---end--- 
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
 
      ON ACTION first
         CALL i510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
       	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i510_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	      ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i510_pic() #圖形顯示
         EXIT DIALOG
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
#@    ON ACTION 套數
      ON ACTION sets
         LET g_action_choice="sets"
         EXIT DIALOG
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG

      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG

      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG     

      #add by darcy 2022年3月4日 s---
      ON ACTION alteration
         LET g_action_choice="alteration"
         EXIT DIALOG     

      #add by darcy 2022年3月4日 e---
      #add by darcy: 2022-03-14 14:31:28 s---
      ON ACTION alteration2
         LET g_action_choice="alteration2"
         EXIT DIALOG 
      #add by darcy: 2022-03-14 14:31:28 e---
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG
         
      
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
         
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 

      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
   END DIALOG   
   
   IF g_errno='genb' THEN CALL i510_b_fill(' 1=1') LET g_errno='' END IF
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #No.FUN-A40055--end
END FUNCTION

FUNCTION i510_set_du_by_origin()
  DEFINE l_ima55    LIKE ima_file.ima55,
         l_ima31    LIKE ima_file.ima31,
         l_ima906   LIKE ima_file.ima906,
         l_ima907   LIKE ima_file.ima907,
         l_ima908   LIKE ima_file.ima908,
         l_factor   LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
      SELECT ima55,ima906,ima907,ima908
        INTO l_ima55,l_ima906,l_ima907,l_ima908
        FROM ima_file WHERE ima01 = b_tc_sff.tc_sff04
 
      #應該是與工單備料檔中的備料單位轉換
       CALL s_umfchk(b_tc_sff.tc_sff04,b_tc_sff.tc_sff06,g_sfa2.sfa12)
            RETURNING g_errno,l_factor
 
END FUNCTION

FUNCTION i510_list_fill()
  DEFINE l_tc_sfd01         LIKE tc_sfd_file.tc_sfd01
  DEFINE l_i             LIKE type_file.num10

    CALL g_tc_sfd_l.clear()
    LET l_i = 1
    FOREACH i510_fill_cs INTO l_tc_sfd01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT tc_sfd01,tc_sfd02,tc_sfd03,tc_sfd06,gem02,tc_sfd07,tc_sfdud02,a.gen02,
              tc_sfd04,tc_sfd05,tc_sfd08,tc_sfd09,b.gen02
         INTO g_tc_sfd_l[l_i].*
         FROM tc_sfd_file
              LEFT OUTER JOIN gen_file a ON tc_sfdud02 = a.gen01
              LEFT OUTER JOIN gen_file b ON tc_sfd09 = b.gen01
              LEFT OUTER JOIN gem_file ON tc_sfd06 = gem01
        WHERE tc_sfd01=l_tc_sfd01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_buf = NULL
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_tc_sfd_l TO s_tc_sfd_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION


FUNCTION i510_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_sfd_l TO s_tc_sfd_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
         CALL fgl_set_arr_curr(g_curs_index) 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
  
       BEFORE ROW
         LET l_ac2 = ARR_CURR()
         LET g_curs_index = l_ac2
         CALL cl_show_fld_cont()
     ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         IF g_rec_b2 > 0 THEN
             CALL i510_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL i510_fetch('/')
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_list", TRUE)    
         EXIT DISPLAY 
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i510_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i510_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i510_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
       	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i510_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
        	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i510_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b2 != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  ######add in 040505
           END IF
	      ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#TQC-D10084---mark---str---
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL i510_pic() #圖形顯示
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 套數
      ON ACTION sets
         LET g_action_choice="sets"
         EXIT DISPLAY
#@    ON ACTION 庫存不足查詢
      ON ACTION qry_short_inventory
         LET g_action_choice="qry_short_inventory"
         EXIT DISPLAY
      #No.FUN-A40055--begin
      # ON ACTION qry_sets #套數查詢
      #   LET g_action_choice="qry_sets"
      #   EXIT DISPLAY
      #No.FUN-A40055--end
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#@    ON ACTION 產生調撥單
      ON ACTION gen_transfer_note
         LET g_action_choice="gen_transfer_note"
         EXIT DISPLAY
     #DEV-D30026 add str------------------------
#@    ON ACTION 條碼欠料調整(發料條碼數量分配)
      ON ACTION barcode_qty_allot
         LET g_action_choice="barcode_qty_allot"
         EXIT DISPLAY
     #DEV-D30026 add end------------------------
      
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY
 
#TQC-AC0197 ---------------------------Begin-------------------------------
      ON ACTION warahouse_modify
         LET g_action_choice="warahouse_modify"
         EXIT DISPLAY
#TQC-AC0197 ---------------------------End---------------------------------

      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6A0166  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 

      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      

      #FUN-AB0001---add----str---
      ON ACTION approval_status #簽核狀況
         LET g_action_choice="approval_status"
         EXIT DISPLAY

      ON ACTION easyflow_approval #easyflow送簽
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY

      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DISPLAY

      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DISPLAY

      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DISPLAY

      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DISPLAY

      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DISPLAY

      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DISPLAY
      #FUN-AB0001---add----end---

   END DISPLAY   
   
   IF g_errno='genb' THEN CALL i510_b_fill(' 1=1') LET g_errno='' END IF
   CALL cl_set_act_visible("accept,cancel", TRUE)
   #No.FUN-A40055--end
END FUNCTION

FUNCTION i510_pic()
   IF g_tc_sfd.tc_sfd04 = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF

  #FUN-AB0001 add str -------
   CALL cl_set_field_pic(g_tc_sfd.tc_sfd04,"","","",g_void,"")
  #FUN-AB0001 add end -------
END FUNCTION

FUNCTION i510_chk_tc_sfe(p_n,p_type)
DEFINE p_n           LIKE type_file.num5
DEFINE p_type        LIKE type_file.chr1
DEFINE l_length,l_i  LIKE type_file.num5
DEFINE l_err         STRING 

   IF p_n <=0 THEN RETURN TRUE END IF 
   LET l_length = g_tc_sfe.getLength()
   FOR l_i = 1 TO l_length
      IF p_n = l_i THEN CONTINUE FOR END IF 
      IF g_tc_sfe[l_i].tc_sfe02 = g_tc_sfe[p_n].tc_sfe02 AND 
         g_tc_sfe[l_i].tc_sfe04 = g_tc_sfe[p_n].tc_sfe04  THEN 
         LET l_err = p_n,'/',g_tc_sfe[l_i].tc_sfe02,'/',g_tc_sfe[l_i].tc_sfe04
         IF p_type = '1' THEN 
            CALL cl_err(l_err,'asf-188',1)
         ELSE 
            LET g_success = 'N'
            CALL s_errmsg('tc_sfe02,tc_sfe04',l_err,'','asf-188',1)
         END IF 
         RETURN FALSE 
      END IF 
   END FOR 
   RETURN TRUE
END FUNCTION 


FUNCTION i510_multi_tc_sfe014(p_n)
DEFINE tok          base.StringTokenizer
DEFINE l_sql        STRING
DEFINE l_plant      LIKE azw_file.azw01
DEFINE l_n,l_i      INTEGER 
DEFINE p_n          INTEGER   
DEFINE unissue_qty	LIKE sfb_file.sfb08
DEFINE l_success    STRING 

   CALL s_showmsg_init()
   LET l_plant = g_plant
   LET l_n = p_n
   LET g_success='Y'
   LET l_success='Y'
   FOR l_i=1 TO g_multi_tc_sfe014.getLength()
      LET g_tc_sfe[l_n].tc_sfe014 = g_multi_tc_sfe014[l_i].shm01
      LET g_tc_sfe[l_n].tc_sfe02 = g_multi_tc_sfe014[l_i].shm012
      LET g_tc_sfe[l_n].tc_sfe04 = g_multi_tc_sfe014[l_i].sgm04
      LET g_tc_sfe[l_n].sfb05 = g_multi_tc_sfe014[l_i].shm05
      SELECT ima02,ima021 INTO g_tc_sfe[l_n].ima02_a,g_tc_sfe[l_n].ima021_a
        FROM ima_file 
       WHERE ima01 = g_tc_sfe[l_n].sfb05
      
      IF g_tc_sfd06 MATCHES '[D]' THEN
         IF cl_null(g_tc_sfe[l_n].tc_sfe04) THEN
            LET g_tc_sfe[l_n].tc_sfe04 = ' '
         END IF 
         IF cl_null(g_tc_sfe[l_n].tc_sfe012) THEN
            LET g_tc_sfe[l_n].tc_sfe012 = ' ' 
         END IF 
         #抓去發料套數自動帶出
         CALL i510_tc_sfe03_519(g_tc_sfe[l_n].tc_sfe014,g_tc_sfe[l_n].tc_sfe02,g_tc_sfe[l_n].tc_sfe04)
             RETURNING unissue_qty
         IF cl_null(unissue_qty) THEN LET unissue_qty = 0 END IF 
         LET g_tc_sfe[l_n].tc_sfe03 = unissue_qty
         IF cl_null(g_tc_sfe[l_n].tc_sfe03) OR g_tc_sfe[l_n].tc_sfe03<0 THEN 
            LET g_tc_sfe[l_n].tc_sfe03 = 0
         END IF 
      END IF
      IF NOT i510_chk_tc_sfe(l_n,'2') THEN 
         LET l_success = 'N'
         CONTINUE FOR 
      END IF 
      LET l_n = l_n + 1
   END FOR 
   CALL g_tc_sfe.deleteElement(l_n)
   LET l_n = l_n - 1
   IF l_success = 'N' THEN LET g_success = 'N' END IF 
   CALL s_showmsg()
   DISPLAY ARRAY g_tc_sfe TO s_tc_sfe.* ATTRIBUTE(COUNT=l_n,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
END FUNCTION 


FUNCTION i510_tc_sfe03_519(p_tc_sfe014,p_tc_sfe02,p_tc_sfe04)
DEFINE p_tc_sfe014     LIKE tc_sfe_file.tc_sfe014,  #Run Card單號
       p_tc_sfe02      LIKE tc_sfe_file.tc_sfe02,   #工單編號 
       p_tc_sfe04      LIKE tc_sfe_file.tc_sfe04
DEFINE qty1,qty2	LIKE tc_sfe_file.tc_sfe03    
DEFINE unissue_qty	LIKE sfb_file.sfb08
DEFINE l_shm08 	    LIKE shm_file.shm08
       
   LET unissue_qty = 0
   LET qty1 = 0
   LET qty2 = 0
   IF cl_null(p_tc_sfe02) OR cl_null(p_tc_sfe014) THEN 
      RETURN unissue_qty
   END IF 
   LET l_shm08 = NULL    
   #取得Run Card生產數量 
   SELECT shm08 INTO l_shm08 FROM shm_file 
    WHERE shm01 = p_tc_sfe014

   IF l_shm08  IS NULL THEN LET l_shm08  = 0 END IF
   #將撈取qty1,qty2的部分整理到函數 i510_tc_sfe03_chk1()處理  
   CALL i510_tc_sfe03_chk(p_tc_sfe02,p_tc_sfe04,'',p_tc_sfe014,'1')  #FUN-C70014 add tc_sfe014
           RETURNING qty1,qty2                   
   IF qty1 IS NULL THEN LET qty1=0 END IF
   IF qty2 IS NULL THEN LET qty2=0 END IF
   LET unissue_qty = l_shm08-(qty1-qty2)

   RETURN unissue_qty
END FUNCTION 

FUNCTION i510_b_i_move_back(l_i)
   DEFINE l_i LIKE type_file.num10
   LET b_tc_sfe.tc_sfe01  = g_tc_sfd.tc_sfd01
   LET b_tc_sfe.tc_sfe02  = g_tc_sfe[l_i].tc_sfe02   
   LET b_tc_sfe.tc_sfe04  = g_tc_sfe[l_i].tc_sfe04   
   LET b_tc_sfe.tc_sfe05  = g_tc_sfe[l_i].tc_sfe05 
   LET b_tc_sfe.tc_sfe06  = g_tc_sfe[l_i].tc_sfe06     #No.FUN-870097  
   LET b_tc_sfe.tc_sfe07  = g_tc_sfe[l_i].tc_sfe07     #No.FUN-940008 add
   LET b_tc_sfe.tc_sfe03  = g_tc_sfe[l_i].tc_sfe03 
   IF cl_null(b_tc_sfe.tc_sfe05) OR (b_tc_sfe.tc_sfe05=0) THEN
      LET b_tc_sfe.tc_sfe05=g_tc_sfd.tc_sfd02
   END IF
#FUN-B20095 ------------Begin------------- 
   LET b_tc_sfe.tc_sfe012 = g_tc_sfe[l_i].tc_sfe012
   IF cl_null(b_tc_sfe.tc_sfe012) THEN
      LET b_tc_sfe.tc_sfe012 = ' '
   END IF
#FUN-B20095 ------------End---------------
#FUN-C70014 ---------begin---------------
   LET b_tc_sfe.tc_sfe014 = g_tc_sfe[l_i].tc_sfe014
   IF cl_null(b_tc_sfe.tc_sfe014) THEN
      LET b_tc_sfe.tc_sfe014 = ' '
   END IF
#FUN-C70014 ---------end-----------------
   LET b_tc_sfe.tc_sfeud01 = g_tc_sfe[l_i].tc_sfeud01
   LET b_tc_sfe.tc_sfeud02 = g_tc_sfe[l_i].tc_sfeud02
   LET b_tc_sfe.tc_sfeud03 = g_tc_sfe[l_i].tc_sfeud03
   LET b_tc_sfe.tc_sfeud04 = g_tc_sfe[l_i].tc_sfeud04
   LET b_tc_sfe.tc_sfeud05 = g_tc_sfe[l_i].tc_sfeud05
   LET b_tc_sfe.tc_sfeud06 = g_tc_sfe[l_i].tc_sfeud06
   LET b_tc_sfe.tc_sfeud07 = g_tc_sfe[l_i].tc_sfeud07
   LET b_tc_sfe.tc_sfeud08 = g_tc_sfe[l_i].tc_sfeud08
   LET b_tc_sfe.tc_sfeud09 = g_tc_sfe[l_i].tc_sfeud09
   LET b_tc_sfe.tc_sfeud10 = g_tc_sfe[l_i].tc_sfeud10
   LET b_tc_sfe.tc_sfeud11 = g_tc_sfe[l_i].tc_sfeud11
   LET b_tc_sfe.tc_sfeud12 = g_tc_sfe[l_i].tc_sfeud12
   LET b_tc_sfe.tc_sfeud13 = g_tc_sfe[l_i].tc_sfeud13
   LET b_tc_sfe.tc_sfeud14 = g_tc_sfe[l_i].tc_sfeud14
   LET b_tc_sfe.tc_sfeud15 = g_tc_sfe[l_i].tc_sfeud15
 
   LET b_tc_sfe.tc_sfeplant = g_plant #FUN-980008 add
   LET b_tc_sfe.tc_sfelegal = g_legal #FUN-980008 add
END FUNCTION

FUNCTION i510_tc_sfe04(p_tc_sfe04)
DEFINE p_tc_sfe04    LIKE tc_sfe_file.tc_sfe04
DEFINE l_eciacti  LIKE eci_file.eciacti
DEFINE l_ecdacti  LIKE ecd_file.ecdacti
DEFINE l_errno    LIKE type_file.chr10
    
    LET l_errno = ''
    IF g_tc_sfd06 MATCHES '[ABC]' THEN
       SELECT eciacti INTO l_eciacti FROM eci_file
        WHERE eci01=p_tc_sfe04 
    ELSE
       SELECT ecdacti INTO l_ecdacti FROM ecd_file
        WHERE ecd01 = p_tc_sfe04
    END IF
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_eciacti     = 'N'  LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION



FUNCTION i510_b()
DEFINE
    l_ac_t              LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_row,l_col         LIKE type_file.num5,                #No.FUN-680121 SMALLINT,	           #分段輸入之行,列數
    l_n,l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw           LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd               LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_b2      		LIKE type_file.chr50,   #No.FUN-680121 VARCHAR(30),
    l_b3      		LIKE sfa_file.sfa08,
    l_b4                LIKE sfa_file.sfa012,   #FUN-B20079
    l_b5                LIKE sfa_file.sfa013,   #FUN-B20079
    l_sfa06             LIKE sfa_file.sfa06,
    l_sfa062            LIKE sfa_file.sfa062,   #No.MOD-940164 add
    l_sfa05             LIKE sfa_file.sfa05,    #No.TQC-6C0122 add
    l_sfb08             LIKE sfb_file.sfb08,    #MOD-8B0230 add
    l_sfa100            LIKE sfa_file.sfa100,   #MOD-8B0230 add
    l_sfa100_t          LIKE sfa_file.sfa100,   #MOD-8B0230 add
    l_sfa161            LIKE sfa_file.sfa161,
    l_sfb09             LIKE sfb_file.sfb09,
    l_sfb11             LIKE sfb_file.sfb11,    #No.MOD-760050 add
    l_ima35	            LIKE ima_file.ima35, #MOD-580001
    l_ima36	            LIKE ima_file.ima36, #MOD-580001
    l_tc_sfe               RECORD LIKE tc_sfe_file.*,
    l_qty		            LIKE sfa_file.sfa06,  #No.FUN-680121 DECIMAL(15,3),
    l_sub_qty		        LIKE sfa_file.sfa06,  #No.MOD-7C0166 add
    l_sub_qty1          LIKE sfa_file.sfa06,  #No.MOD-7C0166 add
    t_sfa05             LIKE sfa_file.sfa05,
    t_sfa06             LIKE sfa_file.sfa06,
    t_short_qty         LIKE sfa_file.sfa07,  #FUN-940039 add
    s_sfa05             LIKE sfa_file.sfa05,
    s_sfa06             LIKE sfa_file.sfa06,
    l_ima108            LIKE ima_file.ima108,
    l_ima70             LIKE ima_file.ima70,
    l_sfa11             LIKE sfa_file.sfa11,    #No:9724
    l_tc_sff05x            LIKE tc_sff_file.tc_sff05,    #FUN-560047
    l_msg               LIKE type_file.chr1000, #No.FUN-680121 VARCHAR(72) #FUN-560047
    no1		        LIKE type_file.num10,   #No.FUN-680121 INTEGER
    l_factor            LIKE ima_file.ima31_fac,#No.FUN-680121 DECIMAL(16,8)
    l_flag              LIKE type_file.num10,   #No.FUN-830132 add
    l_allow_insert      LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_sfa06_t           LIKE sfa_file.sfa06,
    l_sfa161_t          LIKE sfa_file.sfa161,
    l_sfa26             LIKE sfa_file.sfa26,
    l_sfa27             LIKE sfa_file.sfa27,
    l_sfa28             LIKE sfa_file.sfa28,
    l_sfa28_t           LIKE sfa_file.sfa28,
    l_tc_sff05             LIKE tc_sff_file.tc_sff05,
    l_allow_delete      LIKE type_file.num5,                #可刪除否  #No.FUN-680121 SMALLINT
    l_sfb02             LIKE sfb_file.sfb02    #FUN-660110 add
DEFINE l_i     LIKE type_file.num5
DEFINE l_fac   LIKE ima_file.ima31_fac  #TQC-7B0065
 
DEFINE l_sfa29          LIKE sfa_file.sfa29
DEFINE l_tottc_sff05       LIKE tc_sff_file.tc_sff05   #No.TQC-750232
DEFINE l_sfa27_a        LIKE sfa_file.sfa27   #MOD-910167
DEFINE l_ima159         LIKE ima_file.ima159  #FUN-BA0050
DEFINE l_cn             LIKE type_file.num5   #TQC-940138 add
DEFINE l_sfa08_tmp         LIKE sfa_file.sfa08
DEFINE l_sfa12_tmp         LIKE sfa_file.sfa12
DEFINE l_sfa27_tmp         LIKE sfa_file.sfa27
DEFINE l_sfa36          LIKE sfa_file.sfa36   #FUN-950088 add
DEFINE l_sfb05          LIKE sfb_file.sfb05   #No.MOD-930195 add
DEFINE l_bno            LIKE rvbs_file.rvbs08 #CHI-9A0022
DEFINE l_sie            RECORD LIKE sie_file.* #FUNA-A20048 add 
DEFINE l_sfb06          LIKE sfb_file.sfb06   #FUN-A60028 
DEFINE l_flag1          LIKE type_file.num5   #MOD-AC0336
DEFINE b_sfa06          LIKE sfa_file.sfa06   #MOD-B20062 add
DEFINE b_sfa05          LIKE sfa_file.sfa06   #MOD-B20062 add
DEFINE b_tc_sff05          LIKE tc_sff_file.tc_sff05   #MOD-B20062 add
DEFINE sum_tc_sff05        LIKE tc_sff_file.tc_sff05   #MOD-B20062 add
DEFINE b_sfa27          LIKE sfa_file.sfa27   #MOD-B20062 add
DEFINE b_sfa28          LIKE sfa_file.sfa28   #MOD-B20062 add
#TQC-B60036--add--str--
DEFINE l_ima64          LIKE ima_file.ima64
DEFINE l_ima641         LIKE ima_file.ima641
DEFINE l_num_y          LIKE tc_sff_file.tc_sff05
DEFINE l_num_z          LIKE type_file.num20
#TQC-B60036--add--end--
DEFINE l_ima906         LIKE ima_file.ima906 #FUN-B20095
DEFINE l_sum_tc_sff05      LIKE tc_sff_file.tc_sff05  #NO.TQC-B90236 add
DEFINE l_base_sfa05     LIKE sfa_file.sfa05  #CHI-BC0040 add
DEFINE l_replace        LIKE type_file.chr1  #TQC-C30028 add
DEFINE l_c              LIKE type_file.num5  #CHI-C30106---add 
DEFINE l_flag2          LIKE type_file.chr1  #FUN-CB0087 add       
DEFINE l_where          STRING               #FUN-CB0087 add  
DEFINE l_imd10          LIKE imd_file.imd10  #MOD-D60040 add
DEFINE l_tc_sfe03          LIKE tc_sfe_file.tc_sfe03  #2013090084 add

    LET g_action_choice = ""
    IF g_tc_sfd.tc_sfd01 IS NULL THEN RETURN END IF
    SELECT * INTO g_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01=g_tc_sfd.tc_sfd01
    IF g_tc_sfd.tc_sfd04 = 'X' THEN CALL cl_err('','9024',1) RETURN END IF #FUN-660106
    IF g_tc_sfd.tc_sfd04='Y'  THEN
       CALL cl_err('','mfg3168',0) #此張單據已核准, 不允許更改或取消
       RETURN
    END IF
    #FUN-AB0001  add end ---

    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM tc_sff_file ",
                       " WHERE tc_sff01= ? AND tc_sff02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i510_bcl CURSOR FROM g_forupd_sql
 

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")      
 
    IF g_rec_b=0 THEN CALL g_tc_sff.clear() END IF
    IF g_rec_b > 0  THEN LET l_ac = 1  END IF
 
    INPUT ARRAY g_tc_sff WITHOUT DEFAULTS FROM s_tc_sff.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF NOT (g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114
              CALL cl_set_docno_format("tc_sff03")
           END IF
           IF g_rec_b!=0 THEN
              CALL fgl_set_arr_curr(l_ac)
              CALL i510_set_entry_b('u')
              CALL i510_set_no_entry_b('u')
           ELSE
              CALL i510_set_entry_b('a')
              CALL i510_set_no_entry_b('a')
           END IF              
        BEFORE ROW
            LET p_cmd='' 
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
	    BEGIN WORK
            DISPLAY "begin work"
            OPEN i510_cl USING g_tc_sfd.tc_sfd01                     #09/10/21 xiaofeizhu Add
            IF STATUS THEN
               CALL cl_err("OPEN i510_cl:", STATUS, 1)
               CLOSE i510_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i510_cl INTO g_tc_sfd.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE i510_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_tc_sff_t.* = g_tc_sff[l_ac].*  #BACKUP
         #FUN-BB0084 -----------Begin------------
               LET g_tc_sff06_t = g_tc_sff[l_ac].tc_sff06
         #FUN-BB0084 -----------End--------------
               LET g_tc_sfd.tc_sfdmodu=g_user              #NO:6908
               LET g_tc_sfd.tc_sfddate=g_today             #NO:6908
               DISPLAY BY NAME g_tc_sfd.tc_sfdmodu         #NO:6908
               DISPLAY BY NAME g_tc_sfd.tc_sfddate         #NO:6908

 
               OPEN i510_bcl USING g_tc_sfd.tc_sfd01,g_tc_sff_t.tc_sff02
               IF STATUS THEN
                  CALL cl_err("OPEN i510_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i510_bcl INTO b_tc_sff.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock tc_sff',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i510_b_move_to()
                     CALL i510_azf03_desc()  #TQC-D20042 add
                     CALL i510_set_entry_b(p_cmd)
                     CALL i510_set_no_entry_b(p_cmd)
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            INITIALIZE g_tc_sff_t.* TO NULL
            INITIALIZE b_tc_sff.* TO NULL     #No.MOD-950017 add
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_sff[l_ac].* TO NULL      #900423
        #FUN-BB0084 ----------Begin---------
            LET g_tc_sff06_t = NULL
        #FUN-BB0084 ----------End-----------
            LET b_tc_sff.tc_sff01=g_tc_sfd.tc_sfd01
            LET g_tc_sff[l_ac].tc_sff05=0
            IF g_sma.sma541 = 'N' THEN  #FUN-B20079 jan
               LET g_tc_sff[l_ac].tc_sff012=' '  #TQC-AB0183
               LET g_tc_sff[l_ac].tc_sff013=0    #TQC-AB0183
            END IF  #FUN-B20079 jan
            LET g_tc_sff[l_ac].tc_sffud02='Y'
            CALL i510_set_entry_b(p_cmd)
            CALL i510_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD tc_sff02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               ROLLBACK WORK #MOD-640419 解除mark
                CANCEL INSERT #MOD-4A0307
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_tc_sff[l_ac].tc_sff04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD tc_sff04
               END IF
 
               CALL i510_set_origin_field()
               IF NOT (g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114
                  #計算tc_sff05的值,檢查入庫數量的合理性
                  CALL i510_check_inventory_qty()
                      RETURNING g_flag
    
               END IF
            END IF
 
            CALL i510_b_move_back()
            CALL i510_b_else()
            IF g_tc_sff[l_ac].tc_sff04 IS NULL AND g_tc_sff[l_ac].tc_sff05 = 0 THEN
               DISPLAY 'import field is null OR blank '
               INITIALIZE g_tc_sff[l_ac].* TO NULL  #重要欄位空白,無效
               DISPLAY g_tc_sff[l_ac].* TO s_tc_sff[l_ac].*
               CANCEL INSERT
            END IF
           #IF NOT cl_null(l_sfa27_a) THEN LET b_tc_sff.tc_sff27=l_sfa27_a END IF #MOD-910229  #TQC-B50140 Mark
            IF cl_null(b_tc_sff.tc_sff27) THEN
               LET b_tc_sff.tc_sff27=b_tc_sff.tc_sff04
            END IF
            IF cl_null(b_tc_sff.tc_sff27) THEN
               LET b_tc_sff.tc_sff27 = ' '
            END IF
            IF cl_null(b_tc_sff.tc_sff28) THEN
               SELECT sfa28 INTO b_tc_sff.tc_sff28
                 FROM sfa_file
                WHERE sfa01 = b_tc_sff.tc_sff03 
                  AND sfa03 = b_tc_sff.tc_sff04
                  AND sfa08 = b_tc_sff.tc_sff07
                  AND sfa12 = b_tc_sff.tc_sff06
                  AND sfa27 = b_tc_sff.tc_sff27
                  AND sfa012= b_tc_sff.tc_sff012   #FUN-A60028 
                  AND sfa013= b_tc_sff.tc_sff013   #FUN-A60028
            END IF
            #FUN-A60028 --begin--
            IF cl_null(b_tc_sff.tc_sff012) THEN LET b_tc_sff.tc_sff012 = ' ' END IF 
            IF cl_null(b_tc_sff.tc_sff013) THEN LET b_tc_sff.tc_sff013 = 0   END IF  
            #FUN-A60028 --end--     
            IF b_tc_sff.tc_sff014 IS NULL THEN LET b_tc_sff.tc_sff014=' ' END IF  #FUN-C70014 add
            INSERT INTO tc_sff_file VALUES(b_tc_sff.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","tc_sff_file",b_tc_sff.tc_sff01,b_tc_sff.tc_sff02,SQLCA.sqlcode,"","ins tc_sff",1)  #No.FUN-660128
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
        BEFORE FIELD tc_sff02                            #default 序號
            IF g_tc_sff[l_ac].tc_sff02 IS NULL OR g_tc_sff[l_ac].tc_sff02 = 0 THEN
                SELECT MAX(tc_sff02)+1 INTO g_tc_sff[l_ac].tc_sff02
                   FROM tc_sff_file WHERE tc_sff01 = g_tc_sfd.tc_sfd01
                IF g_tc_sff[l_ac].tc_sff02 IS NULL THEN LET g_tc_sff[l_ac].tc_sff02=1 END IF
            END IF
 
        AFTER FIELD tc_sff02                        #check 序號是否重複
            IF NOT cl_null(g_tc_sff[l_ac].tc_sff02) THEN
               IF g_tc_sff[l_ac].tc_sff02 != g_tc_sff_t.tc_sff02 OR
                  g_tc_sff_t.tc_sff02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM tc_sff_file
                       WHERE tc_sff01 = g_tc_sfd.tc_sfd01
                         AND tc_sff02 = g_tc_sff[l_ac].tc_sff02
                   IF l_n > 0 THEN
                       LET g_tc_sff[l_ac].tc_sff02 = g_tc_sff_t.tc_sff02
                       CALL cl_err('',-239,0) NEXT FIELD tc_sff02
                   END IF
               END IF
            END IF

 
        AFTER FIELD tc_sff26
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN
             #IF g_tc_sff[l_ac].tc_sff26 NOT MATCHES '[SU]' THEN   #No.TQC-5C0135 mark
              IF g_tc_sff[l_ac].tc_sff26 NOT MATCHES '[SUTZ]' THEN  #No.TQC-5C0135 add   #FUN-A40058 add 'Z'
                 NEXT FIELD tc_sff26
              END IF
           END IF
           CALL i510_chk_entry_tc_sff27()  #TQC-C70050 add
           
          ON CHANGE tc_sff26
#NO.TQC-B90236------add----begin 不能手動選擇9BC選項
              IF p_cmd = 'a' OR
                (p_cmd ='u' AND g_tc_sff_t.tc_sff26 != g_tc_sff[l_ac].tc_sff26) 
                OR (p_cmd = 'u' AND (g_tc_sff_t.tc_sff26 IS NULL)) THEN
                IF g_tc_sff[l_ac].tc_sff26 MATCHES '[9BC]' THEN
                  LET g_tc_sff[l_ac].tc_sff26 = g_tc_sff_t.tc_sff26
                  DISPLAY BY NAME g_tc_sff[l_ac].tc_sff26
                  NEXT FIELD tc_sff26
                END IF
             END IF
#NO.TQC-B90236------add----end
          IF (cl_null(g_tc_sff[l_ac].tc_sff03)) AND (NOT (g_tc_sfd06 MATCHES '[ABC]')) THEN #FUN-5C0114
             NEXT FIELD tc_sff03
          ELSE
           #CHI-C50011 str add-----
             CALL i510_chk_entry_tc_sff27()
               LET g_tc_sff[l_ac].tc_sff27 = ''
               DISPLAY BY NAME g_tc_sff[l_ac].tc_sff27 
            #CHI-C50011 end add-----
             #NEXT FIELD tc_sff04 #MOD-D30037
             NEXT FIELD tc_sff03  #MOD-D30037
          END IF
 
#-----CHI-BC0040 str add--------
        BEFORE FIELD tc_sff28
          SELECT COUNT(*) INTO l_flag1 FROM sfa_file WHERE sfa01=g_tc_sff[l_ac].tc_sff03 AND sfa03=g_tc_sff[l_ac].tc_sff04
          IF g_tc_sff[l_ac].tc_sff26 MATCHES '[SU]' AND l_flag1=0 THEN
             CALL cl_set_comp_entry("tc_sff28",TRUE)
          ELSE
             CALL cl_set_comp_entry("tc_sff28",FALSE)
          END IF

         AFTER FIELD tc_sff28
           IF g_tc_sff[l_ac].tc_sff26 MATCHES '[SU]' AND cl_null(g_tc_sff[l_ac].tc_sff28) THEN
                CALL cl_err('','aps-100',1)
                NEXT FIELD tc_sff02
           END IF
           CALL cl_set_comp_entry("tc_sff28",TRUE)

#-----CHI-BC0040 end add--------

        #FUN-C70014 add begin-------------
        AFTER FIELD tc_sff014
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff014) THEN 
              SELECT COUNT(*) INTO l_n FROM shm_file
               WHERE shm01 = g_tc_sff[l_ac].tc_sff014
                 AND shm28 = 'N'
              IF l_n = 0 THEN 
                 CALL cl_err('','asf-910',1)
                 LET g_tc_sff[l_ac].tc_sff014 = g_tc_sff_t.tc_sff014
                 NEXT FIELD tc_sff014
              END IF 
              
              SELECT shm012 INTO g_tc_sff[l_ac].tc_sff03 FROM shm_file
               WHERE shm01 = g_tc_sff[l_ac].tc_sff014
                 AND shm28 = 'N'
              DISPLAY BY NAME g_tc_sff[l_ac].tc_sff03
           END IF 
        #FUN-C70014 add end --------------

        AFTER FIELD tc_sff03    
#FUN-AA0059 ---------------------start----------------------------
          #IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) THEN                             #No.FUN-AB0021
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND g_argv2 MATCHES '[ABC]' THEN #No.FUN-AB0021
              IF NOT s_chk_item_no(g_tc_sff[l_ac].tc_sff03,"") THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD tc_sff03
              END IF
           END IF
#FUN-AA0059 ---------------------end-------------------------------
           IF (NOT cl_null(g_tc_sff[l_ac].tc_sff03)) AND (NOT (g_tc_sfd06 MATCHES '[ABC]')) THEN #FUN-5C0114
              CALL i510_sfb01(g_tc_sff[l_ac].tc_sff03)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_sff[l_ac].tc_sff03,g_errno,0)
                 NEXT FIELD tc_sff03
              END IF
              SELECT sfb02 INTO l_sfb02 FROM sfb_file
               WHERE sfb01=g_tc_sff[l_ac].tc_sff03
              IF l_sfb02 = '15' THEN
                 CALL cl_err(g_tc_sff[l_ac].tc_sff03,'asr-047',1)   #所輸入之工單型態
                 NEXT FIELD tc_sff03
              END IF
 
              IF g_tc_sfd06 NOT MATCHES '[24789]' THEN
                 SELECT COUNT(*) INTO l_n FROM tc_sfe_file
                  WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
                    AND tc_sfe02 = g_tc_sff[l_ac].tc_sff03
                    AND tc_sfeud02 = 'Y' #add by guanyao160824
                 IF l_n = 0 THEN
                    CALL cl_err(g_tc_sff[l_ac].tc_sff03,'asf-999',1)
                    NEXT FIELD tc_sff03
                 END IF
              END IF
              SELECT * INTO g_sfb.* FROM sfb_file
               WHERE sfb01=g_tc_sff[l_ac].tc_sff03 AND sfbacti='Y' AND sfb87!='X'
              IF STATUS THEN
                 CALL cl_err3("sel","sfb_file",g_tc_sff[l_ac].tc_sff03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
                 NEXT FIELD tc_sff03  
              END IF
 
              IF g_sfb.sfb81 > g_tc_sfd.tc_sfd02 THEN
                 CALL cl_err(g_tc_sff[l_ac].tc_sff03,'asf-819',0) NEXT FIELD tc_sff03
              END IF
              IF g_sfb.sfb04='1' THEN
                 CALL cl_err('sfb04=1','asf-381',0) NEXT FIELD tc_sff03
              END IF
              IF g_sfb.sfb04='8' THEN
                 CALL cl_err('sfb04=8','asf-345',0) NEXT FIELD tc_sff03
              END IF
              IF g_sfb.sfb04 < 4 AND g_argv2 = 2 THEN                 #CHI-C40013 add
                   CALL cl_err('','asf-383',0) NEXT FIELD tc_sff03       #CHI-C40013 add
              END IF                                                  #CHI-C40013 add
              IF g_sfb.sfb02=13 THEN   #bugno:4863
                 CALL cl_err('sfb02=13','asf-346',0) NEXT FIELD tc_sff03
              END IF
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM snb_file
               WHERE snb01 = g_tc_sff[l_ac].tc_sff03
                #AND snbconf = 'N'    #MOD-B60143 mark
                 AND snbconf != 'X'   #MOD-B60143 add
                 AND snb99 != '2'     #MOD-B60143 add
              IF l_cnt > 0 THEN
                 CALL cl_err('check tc_sff','asf-068',0)
                 NEXT FIELD tc_sff03
              END IF
           END IF
 
           IF (NOT cl_null(g_tc_sff[l_ac].tc_sff03)) AND (g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
               WHERE ima01 = g_tc_sff[l_ac].tc_sff03
                 AND imaacti = 'Y'
                 AND ima911='Y' #MOD-630064
              IF l_cnt = 0 THEN
                 CALL cl_err('chk ima:','100',0)
                 NEXT FIELD tc_sff03
              END IF
              #FUN-B20079 jan (S)
              CALL i510_chk_tc_sff()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD tc_sff03
              END IF
              #FUN-B20079 jan (E)
           END IF
 
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff27) AND 
              NOT cl_null(g_tc_sff[l_ac].tc_sff03) THEN     #FUN-B80143              
              
              #FUN-B80143 --START--
              IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN
                 LET g_tc_sff[l_ac].tc_sff012 = ' '
              END IF
              IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN
                 LET g_tc_sff[l_ac].tc_sff013 = 0
              END IF      
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_tc_sff[l_ac].tc_sff03, "'",
                          "   AND sfa03 ='", g_tc_sff[l_ac].tc_sff27, "'",
                          "   AND sfa012 ='", g_tc_sff[l_ac].tc_sff012, "'",
                          "   AND sfa013 ='", g_tc_sff[l_ac].tc_sff013, "'"                          
              IF g_tc_sfd06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i510_b_p1 FROM g_sql
              DECLARE i510_b_c1 CURSOR FOR i510_b_p1
              OPEN i510_b_c1
              FETCH i510_b_c1 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i510_b_c1
                 NEXT FIELD tc_sff03 
              END IF 
              CLOSE i510_b_c1
              #FUN-B80143 --END--
                 
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD tc_sff03
#FUN-A60028 --begin--
              ELSE
                   CALL s_schdat_ecm014(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff012) RETURNING g_tc_sff[l_ac].ecu014
                  #FUN-B10056 ---------mod end-----------------   
            	   DISPLAY BY NAME g_tc_sff[l_ac].ecu014   
   
#FUN-A60028 --end--                 
              END IF 
           END IF 

#FUN-A60028 --begin--
        BEFORE FIELD tc_sff012
           IF cl_null(g_tc_sff[l_ac].tc_sff03) THEN 
              NEXT FIELD tc_sff03 
           END IF   
           IF cl_null(g_tc_sff[l_ac].tc_sff04) THEN 
              NEXT FIELD tc_sff04 
           END IF                              
        
        AFTER FIELD tc_sff012
          IF NOT cl_null(g_tc_sff[l_ac].tc_sff012) THEN #FUN-B20079 jan
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM sfa_file
              WHERE sfa01 =g_tc_sff[l_ac].tc_sff03 
                AND sfa03 =g_tc_sff[l_ac].tc_sff04
                AND sfa27 =g_tc_sff[l_ac].tc_sff27 
                AND sfa012=g_tc_sff[l_ac].tc_sff012
             IF l_cnt = 0 THEN 
                CALL cl_err('','aic-036',0)
                NEXT FIELD tc_sff012
             END IF   
            CALL s_schdat_ecm014(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff012) RETURNING g_tc_sff[l_ac].ecu014 
            #FUN-B10056 --------mod end------------  
             DISPLAY BY NAME g_tc_sff[l_ac].ecu014   
             #FUN-B20079  jan--add--begin
             CALL i510_chk_tc_sff()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel sfa:',g_errno,0)
                 NEXT FIELD tc_sff012
             END IF
             #FUN-B20079 jan--add--end            
          END IF  #FUN-B20079 jan

        BEFORE FIELD tc_sff013
          IF cl_null(g_tc_sff[l_ac].tc_sff03) THEN 
             NEXT FIELD tc_sff03
          END IF 
           IF cl_null(g_tc_sff[l_ac].tc_sff04) THEN 
              NEXT FIELD tc_sff04 
           END IF                    
          IF g_tc_sff[l_ac].tc_sff012 IS NULL THEN 
             NEXT FIELD tc_sff012
          END IF 
          
        AFTER FIELD tc_sff013
         IF g_sma.sma541 = 'Y' THEN 
             IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                NEXT FIELD tc_sff013
             END IF  
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM sfa_file
              WHERE sfa01 =g_tc_sff[l_ac].tc_sff03 
                AND sfa03 =g_tc_sff[l_ac].tc_sff04
                AND sfa27 =g_tc_sff[l_ac].tc_sff27 
                AND sfa012=g_tc_sff[l_ac].tc_sff012
                AND sfa013=g_tc_sff[l_ac].tc_sff013
             IF l_cnt = 0 THEN 
                CALL cl_err('','aic-036',0)
                NEXT FIELD tc_sff013
             END IF       
             #FUN-B20079 jan--add--begin
             CALL i510_chk_tc_sff()
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err('sel sfa:',g_errno,0)
                 NEXT FIELD tc_sff013
             END IF
             #FUN-B20079 jan--add--edd----
          END IF       
#FUN-A60028 --end--
 
        BEFORE FIELD tc_sff04
           CALL i510_set_entry_b('u')
 
        AFTER FIELD tc_sff04
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_tc_sff[l_ac].tc_sff04,"") THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD tc_sff04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              #GP5.15發料改善:重復性生產時,tc_sff27=tc_sff04
              #MOD-D30037---begin
              SELECT COUNT(*) INTO l_cnt
                FROM sfa_file 
               WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                 AND sfa27=g_tc_sff[l_ac].tc_sff27 
                 AND sfa03=g_tc_sff[l_ac].tc_sff04
              IF l_cnt = 0 THEN
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfa_file 
                  WHERE sfa01=g_tc_sff[l_ac].tc_sff03 
                    AND sfa03=g_tc_sff[l_ac].tc_sff04
                 IF l_cnt = 1 THEN
                    SELECT sfa26,sfa27 INTO l_sfa26,l_sfa27
                      FROM sfa_file 
                     WHERE sfa01=g_tc_sff[l_ac].tc_sff03 
                       AND sfa03=g_tc_sff[l_ac].tc_sff04
                    IF g_tc_sff[l_ac].tc_sff26 <> l_sfa26 OR g_tc_sff[l_ac].tc_sff27 <> l_sfa27 OR cl_null(g_tc_sff[l_ac].tc_sff26) OR cl_null(g_tc_sff[l_ac].tc_sff27) THEN
                       IF cl_confirm("asf-450") THEN
                          LET g_tc_sff[l_ac].tc_sff26 = l_sfa26
                          LET g_tc_sff[l_ac].tc_sff27 = l_sfa27
                       END IF 
                    END IF 
                   #MOD-D60234 add begin----------------------
                    IF l_sfa26 NOT  MATCHES '[9BCUSTZ]' THEN
                       LET g_tc_sff[l_ac].tc_sff26 = ''
                    END IF
                   #MOD-D60234 add end------------------------
                 END IF 
                 IF l_cnt > 1 THEN
                    CALL i510_tc_sff27_cho()
                    DISPLAY BY NAME g_tc_sff[l_ac].tc_sff26
                    DISPLAY BY NAME g_tc_sff[l_ac].tc_sff27
                    DISPLAY BY NAME g_tc_sff[l_ac].tc_sff04
                 END IF 
              END IF 
              IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
                 LET g_tc_sff[l_ac].tc_sff27 = g_tc_sff[l_ac].tc_sff04
                 SELECT COUNT(*) INTO l_cnt
                   FROM sfa_file 
                  WHERE sfa01=g_tc_sff[l_ac].tc_sff03 
                    AND sfa27=g_tc_sff[l_ac].tc_sff27 
                    AND sfa03=g_tc_sff[l_ac].tc_sff04
                 IF l_cnt = 0 THEN
                    CALL cl_err('tc_sff04=tc_sff27','aem-015',0)
                    NEXT FIELD tc_sff04
                 END IF 
              END IF 
              #MOD-D30037---end
              IF g_tc_sff[l_ac].tc_sff26 MATCHES '[SUZ]' AND             #FUN-A40058 add 'Z'
                 g_tc_sfd06 MATCHES '[12346789]' THEN             #MOD-B20062 add 6789
                  IF g_tc_sff[l_ac].tc_sff04=g_tc_sff27 THEN        #MOD-9A0123
                    CALL cl_err('tc_sff04=tc_sff27','mfg2626',0)
                    NEXT FIELD tc_sff04
                 END IF
                #GP5.15發料改善修改:b_tc_sff.tc_sff27 原由i510_tc_sff27()開出的
                #畫面手工輸入,現此欄位當g_argv2 NOT MATCHES '[ABC]'
                #(重復性生成模組不顯示)時,在畫面上都顯示出來,故直接
                LET b_tc_sff.tc_sff27 = g_tc_sff[l_ac].tc_sff27 
                LET g_tc_sff27 = b_tc_sff.tc_sff27   #MOD-9A0123
 
                #因被替代料可以手key,故此處檢查必須tc_sff27有值 
                IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND NOT cl_null(b_tc_sff.tc_sff27) THEN
                 IF g_tc_sfd06 MATCHES '[ABC]' THEN #FUN-5C0114
                    LET l_sfa29=g_tc_sff[l_ac].tc_sff03
                 ELSE
                    LET l_sfa29=NULL
                    SELECT MAX(sfa29) INTO l_sfa29 FROM sfa_file
                     WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                       AND sfa27=b_tc_sff.tc_sff27
                 END IF
                 IF g_tc_sfd06 NOT MATCHES '[6789B]' THEN      #MOD-C20203 add
                   SELECT COUNT(*) INTO l_n FROM bmd_file	#檢查是否存在取替代檔
                      WHERE bmd01 = b_tc_sff.tc_sff27
                         AND (bmd08=l_sfa29     OR bmd08='ALL') #MOD-530024
                        AND bmd04 = g_tc_sff[l_ac].tc_sff04
                        AND bmdacti = 'Y'  #MOD-910166 add
                     IF l_n=0 THEN
                        IF g_sma.sma887[1]='Y' THEN
                           CALL cl_err('sel bmd:','mfg2636',0) NEXT FIELD tc_sff04
                        END IF
                        IF g_sma.sma887[1]='W' THEN
                           IF NOT cl_confirm('mfg2637') THEN NEXT FIELD tc_sff04 END IF
                        END IF
                     END IF
                 END IF                                          #MOD-C20203 add
                END IF
              END IF    #FUN-940039 add
              #FUN-940039 end
              SELECT COUNT(*) INTO g_cnt FROM tc_sff_file
               WHERE tc_sff01=g_tc_sfd.tc_sfd01
                 AND tc_sff02<>g_tc_sff[l_ac].tc_sff02
                 AND tc_sff04=g_tc_sff[l_ac].tc_sff04
                 AND tc_sff03=g_tc_sff[l_ac].tc_sff03     #MOD-BA0197 add
                 AND tc_sff014=g_tc_sff[l_ac].tc_sff014   #TQC-CA0045 add
              IF g_cnt>0 THEN CALL cl_err('','aim-401',0) END IF
 
              SELECT ima25 INTO l_b2
                FROM ima_file WHERE ima01=g_tc_sff[l_ac].tc_sff04 AND imaacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","ima_file",g_tc_sff[l_ac].tc_sff04,"",STATUS,"","sel ima",1)  #No.FUN-660128
                 NEXT FIELD tc_sff04
              END IF
 
              IF g_tc_sfd06 MATCHES '[ABC]' THEN
                 LET g_tc_sff[l_ac].tc_sff06=''
                 SELECT ima55 INTO g_tc_sff[l_ac].tc_sff06 FROM ima_file
                    WHERE ima01=g_tc_sff[l_ac].tc_sff04
                 IF cl_null(g_tc_sff[l_ac].tc_sff06) THEN
                    SELECT ima25 INTO g_tc_sff[l_ac].tc_sff06 FROM ima_file
                       WHERE ima01=g_tc_sff[l_ac].tc_sff04
                 END IF
                 LET g_tc_sff[l_ac].tc_sff07=' '
                 LET g_tc_sff[l_ac].tc_sff012 = ' '      #FUN-B20079
                 LET g_tc_sff[l_ac].tc_sff013 = 0        #FUN-B20079
              ELSE
              #  SELECT COUNT(*),MIN(sfa12),MIN(sfa08)  #FUN-B20079  mark
              #    INTO l_n, l_b2, l_b3                 #FUN-B20079  mark
                 SELECT COUNT(*),MIN(sfa12),MIN(sfa08),MIN(sfa012),MIN(sfa013)  #FUN-B20079
                   INTO l_n, l_b2, l_b3,l_b4,l_b5                               #FUN-B20079
                   FROM sfa_file
                  WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                    AND (sfa03=g_tc_sff[l_ac].tc_sff04 OR sfa03=b_tc_sff.tc_sff27)
                 IF l_n=0 THEN
                    CALL cl_err('sel sfa',100,0) NEXT FIELD tc_sff03
                 END IF
                 IF cl_null(l_b2) THEN LET l_b2 = ' ' END IF
                 IF cl_null(l_b3) THEN LET l_b3 = ' ' END IF
                 IF cl_null(l_b4) THEN LET l_b4 = ' ' END IF                     #FUN-B20079
                 IF cl_null(l_b5) THEN LET l_b5 = 0   END IF                     #FUN-B20079
                 IF cl_null(g_tc_sff[l_ac].tc_sff06) THEN
                    LET g_tc_sff[l_ac].tc_sff06=l_b2
                 END IF
                 IF cl_null(g_tc_sff[l_ac].tc_sff07) THEN
                    LET g_tc_sff[l_ac].tc_sff07=l_b3
                 END IF
             #FUN-B20079--add--begin
                 IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN
                    LET g_tc_sff[l_ac].tc_sff012 = l_b4
                 END IF
                 IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN
                    LET g_tc_sff[l_ac].tc_sff013 = l_b5
                 END IF
              DISPLAY BY NAME g_tc_sff[l_ac].tc_sff012
              DISPLAY BY NAME g_tc_sff[l_ac].tc_sff013
             #FUN-B20079--add--end
              DISPLAY BY NAME g_tc_sff[l_ac].tc_sff06
              DISPLAY BY NAME g_tc_sff[l_ac].tc_sff07
              END IF
              SELECT ima02,ima021 INTO g_tc_sff[l_ac].ima02, g_tc_sff[l_ac].ima021
                FROM ima_file
               WHERE ima01=g_tc_sff[l_ac].tc_sff04
              DISPLAY g_tc_sff[l_ac].ima02 TO FORMONLY.ima02
              DISPLAY g_tc_sff[l_ac].ima021 TO FORMONLY.ima021
             #FUN-940039修改GP5.15發料改善:被替代料可以手key,此處檢查必須tc_sff27有值
              IF (NOT cl_null(g_tc_sff[l_ac].tc_sff27)) AND #FUN-940039  #TQC-9C0048
                 (NOT cl_null(g_tc_sff[l_ac].tc_sff06)) THEN  #TQC-9C0048
                 IF  cl_null(g_tc_sff[l_ac].tc_sff07) THEN  LET g_tc_sff[l_ac].tc_sff07=' ' END IF   #TQC-9C0048
                 IF  cl_null(g_tc_sff[l_ac].tc_sff012) THEN  LET g_tc_sff[l_ac].tc_sff012=' ' END IF   #FUN-A60028
                 IF  cl_null(g_tc_sff[l_ac].tc_sff013) THEN  LET g_tc_sff[l_ac].tc_sff013=0 END IF     #FUN-A60028                 
                 IF (g_tc_sff[l_ac].tc_sff26 MATCHES '[SUZ]') AND (NOT g_tc_sfd06 MATCHES '[ABC]') THEN  #FUN-A40058 add 'Z' 
                    SELECT sfa26 INTO g_sfa26 FROM sfa_file
                     WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                      #AND sfa03=g_tc_sff[l_ac].tc_sff04  #TQC-9C0048 #TQC-B50089
                      #AND sfa27=g_tc_sff[l_ac].tc_sff27  #TQC-9C0048 #TQC-B50089
                       AND sfa03=g_tc_sff[l_ac].tc_sff27  #TQC-B50089
                       AND sfa12=g_tc_sff[l_ac].tc_sff06
                       AND sfa08=g_tc_sff[l_ac].tc_sff07
                       AND sfa012= g_tc_sff[l_ac].tc_sff012   #FUN-A60028
                       AND sfa013= g_tc_sff[l_ac].tc_sff013   #FUN-A60028
                    IF STATUS THEN
                       CALL cl_err3("sel","sfa_file",g_tc_sff[l_ac].tc_sff03,b_tc_sff.tc_sff27,STATUS,"","sel o.sfa",1)  #No.FUN-660128
                       NEXT FIELD tc_sff26
                    END IF
                    LET l_sfa29=NULL
                    LET l_sfa11=''     #FUN-9C0040
                    SELECT sfa29,sfa11 INTO l_sfa29,l_sfa11 FROM sfa_file  #TQC-9C0048 #FUN-9C0040
                     WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                       AND sfa03=g_tc_sff[l_ac].tc_sff04  #TQC-9C0048
                       AND sfa27=g_tc_sff[l_ac].tc_sff27  #TQC-9C0048
                       AND sfa12=g_tc_sff[l_ac].tc_sff06  #TQC-9C0048
                       AND sfa08=g_tc_sff[l_ac].tc_sff07  #TQC-9C0048
                       AND sfa012= g_tc_sff[l_ac].tc_sff012   #FUN-A60028
                       AND sfa013= g_tc_sff[l_ac].tc_sff013   #FUN-A60028
                       
                    #SELECT bmd07 FROM sfb_file,bmd_file   #MOD-A40144 mark
                    SELECT SUM(bmd07) FROM sfb_file,bmd_file  #MOD-A40144 mod
                     WHERE sfb01=g_tc_sff[l_ac].tc_sff03
                       AND bmd01=g_tc_sff[l_ac].tc_sff27  #MOD-9C0234
                       AND (bmd08='ALL' OR bmd08=l_sfa29)
                       AND bmd04=g_tc_sff[l_ac].tc_sff04
                       AND bmdacti = 'Y'  #MOD-910166 add
                    IF STATUS THEN
                       CALL cl_err3("sel","sfb_file,bmd_file",g_tc_sff[l_ac].tc_sff03,b_tc_sff.tc_sff27,STATUS,"","sel bmd",1)  #No.FUN-660128
                       IF g_sma.sma887[1]='Y' THEN
                          NEXT FIELD tc_sff26
                       END IF
                    END IF
                 END IF    
                 #MOD-C50150 add begin-----------------------------------
                 LET l_sfa11=''
                 SELECT sfa29,sfa11 INTO l_sfa29,l_sfa11 FROM sfa_file
                  WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                    AND sfa03=g_tc_sff[l_ac].tc_sff04  
                    AND sfa27=g_tc_sff[l_ac].tc_sff27  
                    AND sfa12=g_tc_sff[l_ac].tc_sff06  
                    AND sfa08=g_tc_sff[l_ac].tc_sff07 
                    AND sfa012= g_tc_sff[l_ac].tc_sff012  
                    AND sfa013= g_tc_sff[l_ac].tc_sff013 
                 IF g_argv1='1' OR g_tc_sfd06 = '9' THEN
                    IF g_tc_sfd06='1' AND l_sfa11 = 'E' THEN
                       CALL cl_err('','asf-602',0)
                       NEXT FIELD tc_sff04
                    END IF
                 END IF
                 #MOD-C50150 add end-------------------------------------       
              END IF  #FUN-940039 add
 
           END IF
           IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_tc_sff[l_ac].tc_sff04) THEN
                 CALL s_chk_va_setting(g_tc_sff[l_ac].tc_sff04)
                     RETURNING g_flag,g_ima906,g_ima907
                 SELECT ima55 INTO g_ima55
                   FROM ima_file WHERE ima01=g_tc_sff[l_ac].tc_sff04
                 IF g_flag=1 THEN
                    NEXT FIELD tc_sff04
                 END IF
              END IF
              CALL i510_set_no_entry_b('u')
           END IF
          IF  (p_cmd='a') OR (g_tc_sff_t.tc_sff04 <> g_tc_sff[l_ac].tc_sff04) THEN
             SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
              WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                AND sfa03=g_tc_sff[l_ac].tc_sff04
                AND sfa12=g_tc_sff[l_ac].tc_sff06
                AND sfa27=g_tc_sff[l_ac].tc_sff27
                AND sfa08=g_tc_sff[l_ac].tc_sff07
                AND sfa012= g_tc_sff[l_ac].tc_sff012   #FUN-A60028
                AND sfa013= g_tc_sff[l_ac].tc_sff013   #FUN-A60028                              
          END IF
           #當替代碼為空的時候,發料料號應該=被替代料號
           IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
              IF NOT cl_null(g_tc_sff[l_ac].tc_sff04) AND 
                 NOT cl_null(g_tc_sff[l_ac].tc_sff27) THEN 
                 IF g_tc_sff[l_ac].tc_sff04 <> g_tc_sff[l_ac].tc_sff27 THEN 
                    CALL cl_err('','asf-475',1) 
                    NEXT FIELD tc_sff04
                 END IF
              END IF 
           END IF 
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff27) AND 
              NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND 
              NOT cl_null(g_tc_sff[l_ac].tc_sff04) THEN  
             #g_tc_sff[l_ac].tc_sff012 IS NOT NULL AND    #FUN-A60028 add tc_sff012 #FUN-B20079 jan
             #NOT cl_null(g_tc_sff[l_ac].tc_sff013) THEN  #FUN-A60028 ADD tc_sff013 #FUN-B20079 jan
             
             #FUN-B80143 --START mark--
             # SELECT COUNT(*) INTO l_n FROM sfa_file
             #  WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
             #   #AND sfa03 = g_tc_sff[l_ac].tc_sff04  #TQC-B50089
             #   #AND sfa27 = g_tc_sff[l_ac].tc_sff27  #TQC-B50089
             #    AND sfa03 = g_tc_sff[l_ac].tc_sff27  #TQC-B50089
             #   #AND sfa012= g_tc_sff[l_ac].tc_sff012   #FUN-A60028  #FUN-B20079 jan
             #   #AND sfa013= g_tc_sff[l_ac].tc_sff013   #FUN-A60028  #FUN-B20079 jan
             #FUN-B80143 --END mark--

              #FUN-B80143 --START--
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_tc_sff[l_ac].tc_sff03, "'",
                          "   AND sfa03 ='", g_tc_sff[l_ac].tc_sff27, "'"                                                   
              IF g_tc_sfd06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i510_b_p2 FROM g_sql
              DECLARE i510_b_c2 CURSOR FOR i510_b_p2
              OPEN i510_b_c2
              FETCH i510_b_c2 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i510_b_c2
                 NEXT FIELD tc_sff04 
              END IF 
              CLOSE i510_b_c2
              #FUN-B80143 --END--
              
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD tc_sff04
              END IF 
           END IF 
           #FUN-B20079 jan (S)
           CALL i510_chk_tc_sff()
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD tc_sff04
           END IF
           #FUN-B20079 jan (E)
        #CHI-C50011 str add------
           CALL i510_chk_entry_tc_sff27()
           IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
             LET g_tc_sff[l_ac].tc_sff27 = g_tc_sff[l_ac].tc_sff04
             DISPLAY BY NAME g_tc_sff[l_ac].tc_sff27
           END IF 


         BEFORE FIELD tc_sff27          
           CALL i510_chk_entry_tc_sff27()
        #CHI-C50011 end add------
         AFTER FIELD tc_sff27
           #當"工單單號+發料料號"依序判斷其中有一個位空時候,則NEXT FIELD到空的欄位
           IF cl_null(g_tc_sff[l_ac].tc_sff03) THEN
              NEXT FIELD tc_sff03
           END IF
          #CHI-C40013 str add-----
           SELECT sfb04 INTO g_sfb.sfb04 FROM sfb_file
            WHERE sfb01=g_tc_sff[l_ac].tc_sff03 AND sfbacti='Y' AND sfb87!='X'
           IF STATUS THEN
              CALL cl_err3("sel","sfb_file",g_tc_sff[l_ac].tc_sff03,"",STATUS,"","sel sfb",1)  #No.FUN-660128
              NEXT FIELD tc_sff03
           END IF
           IF g_sfb.sfb04 < 4 AND g_argv2 = 2 THEN
                CALL cl_err('','asf-383',0) NEXT FIELD tc_sff27
           END IF
          #CHI-C40013 end add-----
           IF cl_null(g_tc_sff[l_ac].tc_sff04) THEN
             #CHI-BC0040 str add-----
             #NEXT FIELD tc_sff04
             #當替代碼為空,發料料號如果也為空,則預設發料料號為被替代料號
             IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
                LET g_tc_sff[l_ac].tc_sff04 = g_tc_sff[l_ac].tc_sff27
                DISPLAY BY NAME g_tc_sff[l_ac].tc_sff04
             ELSE
                NEXT FIELD tc_sff04
             END IF
             #CHI-BC0040 end add-----
           END IF
           #判斷被替代料須存在于備料檔中
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff27) THEN
             #g_tc_sff[l_ac].tc_sff012 IS NOT NULL AND           #FUN-A60028  #FUN-B20079 jan
             #NOT cl_null(g_tc_sff[l_ac].tc_sff013) THEN         #FUN-A60028  #FUN-B20079 jan

             #FUN-B80143 --START mark--
             # SELECT COUNT(*) INTO l_n FROM sfa_file
             #  WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
             #   #AND sfa03 = g_tc_sff[l_ac].tc_sff04  #TQC-B50089
             #   #AND sfa27 = g_tc_sff[l_ac].tc_sff27  #TQC-B50089
             #    AND sfa03 = g_tc_sff[l_ac].tc_sff27  #TQC-B50089
             #   #AND sfa012= g_tc_sff[l_ac].tc_sff012    #FUN-A60028  #FUN-B20079 jan
             #   #AND sfa013= g_tc_sff[l_ac].tc_sff013    #FUN-A60028  #FUN-B20079 jan
             #FUN-B80143 --END mark--

             #FUN-B80143 --START--
              LET g_sql = "SELECT COUNT(*) FROM sfa_file",
                          " WHERE sfa01 ='", g_tc_sff[l_ac].tc_sff03, "'",
                          "   AND sfa03 ='", g_tc_sff[l_ac].tc_sff27, "'"                                                   
              IF g_tc_sfd06 = '7' THEN
                 LET g_sql = g_sql, " AND sfa062 > 0 "
              END IF              
              PREPARE i510_b_p3 FROM g_sql
              DECLARE i510_b_c3 CURSOR FOR i510_b_p3
              OPEN i510_b_c3
              FETCH i510_b_c3 INTO l_n              
              IF SQLCA.SQLCODE THEN
                 CALL cl_err("", SQLCA.SQLCODE, 0)
                 CLOSE i510_b_c3
                 NEXT FIELD tc_sff27
              END IF 
              CLOSE i510_b_c3
              #FUN-B80143 --END--
             
              IF l_n <=0 THEN
                 CALL cl_err('','asf-340',1) 
                 NEXT FIELD tc_sff27
              END IF 
              #FUN-B20079 jan (S)
              CALL i510_chk_tc_sff()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD tc_sff27
              END IF
              #FUN-B20079 jan (E)
           END IF 
           #當替代碼為空的時候,發料料號應該=被替代料號
           IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
              IF g_tc_sff[l_ac].tc_sff04 <> g_tc_sff[l_ac].tc_sff27 THEN 
                 CALL cl_err('','asf-475',1) 
                 NEXT FIELD tc_sff27
              END IF
           END IF 
          SELECT sfa36 INTO l_sfa36 FROM sfa_file
           WHERE sfa01=g_tc_sff[l_ac].tc_sff03
             AND sfa03=g_tc_sff[l_ac].tc_sff04
             AND sfa12=g_tc_sff[l_ac].tc_sff06
             AND sfa08=g_tc_sff[l_ac].tc_sff07
             AND sfa27=g_tc_sff[l_ac].tc_sff27  #g_tc_sff[l_ac].tc_sff27
             AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
             AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028 
          
         AFTER FIELD tc_sff06
            IF NOT cl_null(g_tc_sff[l_ac].tc_sff06) THEN
               SELECT gfe02 INTO g_buf FROM gfe_file
                WHERE gfe01=g_tc_sff[l_ac].tc_sff06
               IF STATUS THEN
                  CALL cl_err3("sel","gfe_file",g_tc_sff[l_ac].tc_sff06,"",STATUS,"","gfe:",1)  #No.FUN-660128
                  NEXT FIELD tc_sff06
               END IF
               IF NOT g_tc_sfd06 MATCHES '[ABC]' THEN #FUN-5C0114
                  SELECT COUNT(*) INTO l_n FROM sfa_file
                   WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                     AND (sfa03=g_tc_sff[l_ac].tc_sff04 OR sfa27=b_tc_sff.tc_sff27)
                     AND sfa12=g_tc_sff[l_ac].tc_sff06
                     AND sfa012=g_tc_sff[l_ac].tc_sff012       #FUN-A60028 
                     AND sfa013=g_tc_sff[l_ac].tc_sff013       #FUN-A60028
                  IF l_n=0 THEN
                     CALL cl_err('sel sfa',100,0) NEXT FIELD tc_sff06
                  END IF
               END IF
            END IF
        #FUN-BB0084 ----------------Begin------------------
            IF NOT cl_null(g_tc_sff[l_ac].tc_sff06) AND NOT cl_null(g_tc_sff[l_ac].tc_sff05) THEN
               IF cl_null(g_tc_sff06_t) OR cl_null(g_tc_sff_t.tc_sff05) OR g_tc_sff06_t!=g_tc_sff[l_ac].tc_sff06
                  OR g_tc_sff_t.tc_sff05!=g_tc_sff[l_ac].tc_sff05 THEN
                  LET g_tc_sff[l_ac].tc_sff05 = s_digqty(g_tc_sff[l_ac].tc_sff05,g_tc_sff[l_ac].tc_sff06)
               END IF
            END IF 
        #FUN-BB0084 ----------------End--------------------
 
        AFTER FIELD tc_sff07
           IF cl_null(g_tc_sff[l_ac].tc_sff07) THEN 
              LET g_tc_sff[l_ac].tc_sff07=' ' 
           ELSE 
              CALL i510_tc_sff07(g_tc_sff[l_ac].tc_sff07) RETURNING g_errno
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_tc_sff[l_ac].tc_sff07,g_errno,1)
                NEXT FIELD tc_sff07
              END IF 
           END IF
           IF (g_tc_sff[l_ac].tc_sff26 MATCHES '[SUZ]') AND   #FUN-A40058 add 'Z' 
               (NOT g_tc_sfd06 MATCHES '[ABC]') THEN
               IF cl_null(g_tc_sff[l_ac].tc_sff27) THEN #FUN-9B0149      
                  #LET l_sfa27 = g_tc_sff[l_ac].tc_sff03  #MOD-D30037
                  LET l_sfa27 = g_tc_sff[l_ac].tc_sff04  #MOD-D30037
               ELSE
                  LET l_sfa27 = g_tc_sff[l_ac].tc_sff27 #FUN-9B0149
               END IF
               LET l_cn = 0 
               SELECT COUNT(*) INTO l_cn FROM sfa_file
                WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
                  AND sfa27 = l_sfa27
                  AND sfa08 = g_tc_sff[l_ac].tc_sff07
            ELSE
               LET l_cn = 0 
               SELECT COUNT(*) INTO l_cn FROM sfa_file
                WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
                  AND sfa03 = g_tc_sff[l_ac].tc_sff04
                  AND sfa08 = g_tc_sff[l_ac].tc_sff07
            END IF     
           
            IF l_cn = 0 THEN
               CALL cl_err(g_tc_sff[l_ac].tc_sff07,'asf-905',0)
               NEXT FIELD tc_sff07
            END IF      
#作業編號
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff07) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file
               WHERE ecd01=g_tc_sff[l_ac].tc_sff07
              IF g_cnt=0 THEN
                 CALL cl_err('sel ecd_file',100,0)
                 NEXT FIELD tc_sff07
              END IF
           END IF
 
           IF (g_tc_sff[l_ac].tc_sff26 MATCHES '[SUZ]') AND (NOT g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114   #FUN-A40058 add 'Z'
              SELECT sfa26 INTO g_sfa26 FROM sfa_file
               WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                 #AND sfa03=g_tc_sff[l_ac].tc_sff04   #MOD-B80111 mark
                 AND sfa12=g_tc_sff[l_ac].tc_sff06
                 AND sfa08=g_tc_sff[l_ac].tc_sff07
                 #AND sfa27=g_tc_sff[l_ac].tc_sff27    #MOD-B80111 mark
                 AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                 AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028             
                 AND sfa03=g_tc_sff[l_ac].tc_sff27      #MOD-B80111 add
              IF STATUS THEN
                 CALL cl_err3("sel","sfa_file",g_tc_sff[l_ac].tc_sff03,b_tc_sff.tc_sff27,STATUS,"","sel o.sfa",1)  #No.FUN-660128
                 NEXT FIELD tc_sff26
              END IF
 
             LET l_sfa29=NULL
             SELECT sfa29 INTO l_sfa29 FROM sfa_file  #TQC-9C0048
              WHERE sfa01=g_tc_sff[l_ac].tc_sff03  #TQC-9C0048
                #AND sfa03=g_tc_sff[l_ac].tc_sff04  #TQC-9C0048 #MOD-B80111 mark
                AND sfa12=g_tc_sff[l_ac].tc_sff06  #TQC-9C0048
                AND sfa08=g_tc_sff[l_ac].tc_sff07  #TQC-9C0048
                #AND sfa27=g_tc_sff[l_ac].tc_sff27  #TQC-9C0048 #MOD-B80111 mark
                AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028 
                AND sfa03=g_tc_sff[l_ac].tc_sff27      #MOD-B80111 add
 
              #SELECT bmd07 FROM sfb_file,bmd_file    #MOD-A40144 mark
              SELECT SUM(bmd07) FROM sfb_file,bmd_file    #MOD-A40144 mod
               WHERE sfb01=g_tc_sff[l_ac].tc_sff03
                 AND bmd01=g_tc_sff[l_ac].tc_sff27 #MOD-9C0234
                  AND (bmd08='ALL' OR bmd08=l_sfa29)  #MOD-530024
                 AND bmd04=g_tc_sff[l_ac].tc_sff04
                 AND bmdacti = 'Y'  #MOD-910166 add
              IF STATUS THEN
                 CALL cl_err3("sel","sfb_file,bmd_file",g_tc_sff[l_ac].tc_sff03,b_tc_sff.tc_sff27,STATUS,"","sel bmd",1)  #No.FUN-660128
                 IF g_sma.sma887[1]='Y' THEN
                    NEXT FIELD tc_sff26
                 END IF
              END IF
           END IF
           # 有可能二次取替代所以改以下判斷方式
           IF (g_tc_sfd06 = '1') OR (g_tc_sfd06 = '2') OR (g_tc_sfd06 = '4' ) THEN #MOD-6C0050 #帶應發已發欠料的資料,超領和成套發一樣 #MOD-8C0239 modify 
              IF cl_null(g_tc_sff[l_ac].tc_sff26) THEN
                  LET l_sfa11=''   #MOD-B80013 add
                  SELECT (sfa05-sfa065),sfa06,sfa11  # 扣除代買部分        #FUN-940039 add   #FUN-B50059 #MOD-B80013 add sfa11
                    INTO g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06,l_sfa11         #FUN-940039 add #MOD-B80013 add l_sfa11
                    FROM sfa_file
                   WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                     #AND sfa03=g_tc_sff[l_ac].tc_sff04   #MOD-B80111 mark
                     AND sfa12=g_tc_sff[l_ac].tc_sff06
                     AND sfa08=g_tc_sff[l_ac].tc_sff07
                     #AND sfa27=g_tc_sff[l_ac].tc_sff27    #FUN-940039 add #MOD-B80111 mark
                     AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                     AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028                     
                     AND sfa03=g_tc_sff[l_ac].tc_sff27     #MOD-B80111 add
                     AND sfa27 = g_tc_sff[l_ac].tc_sff04    #TQC-CA0014 add
                    #  AND sfa03=g_tc_sff[l_ac].tc_sff04     #tianry add 170204
                    #  AND sfa27 = g_tc_sff[l_ac].tc_sff27 
                  IF SQLCA.SQLCODE THEN
                     LET s_sfa05 = 0 LET s_sfa06 = 0
                  END IF
                 #計算欠料量g_short_qty(原g_sfa07) 
                  IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN LET g_tc_sff[l_ac].tc_sff012=' ' END IF #TQC-CB0084 add 
                  IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN LET g_tc_sff[l_ac].tc_sff013= 0  END IF #TQC-CB0084 add 
                  CALL s_shortqty(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,
                                  g_tc_sff[l_ac].tc_sff06,g_tc_sff[l_ac].tc_sff27,
                                 #g_tc_sff012,g_tc_sff013)   #FUN-A50066 add     #MOD-CB0154 mark
                                  g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013)   #MOD-CB0154
                       RETURNING g_short_qty
                  IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              ELSE
                  LET l_sfa11=''   #MOD-B80013 add
                  SELECT SUM(sfa05-sfa065),SUM(sfa06),sfa11  # 扣除代買部分                #FUN-940039 add #FUN-B50059 #MOD-B80013 add sfa11
                    INTO g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06,l_sfa11                         #FUN-940039 add #MOD-B80013 add l_sfa11
                    FROM sfa_file
                   WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                     #AND sfa03=g_tc_sff[l_ac].tc_sff04  #MOD-630129  #MOD-B80111 mark 
                     AND sfa12=g_tc_sff[l_ac].tc_sff06
                     AND sfa08=g_tc_sff[l_ac].tc_sff07
                     #AND sfa27=g_tc_sff[l_ac].tc_sff27 #FUN-940039 add #MOD-B80111 mark
                     AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                     AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028                     
                     AND sfa03=g_tc_sff[l_ac].tc_sff04    #g_tc_sff[l_ac].tc_sff27     #MOD-B80111 add
                     AND sfa27 =g_tc_sff[l_ac].tc_sff27    #g_tc_sff[l_ac].tc_sff04    #TQC-CA0014 add
                     GROUP BY sfa11                  #MOD-C70247 add
                  IF SQLCA.SQLCODE THEN
                     LET s_sfa05 = 0 LET s_sfa06 = 0 
                  END IF
                 #計算欠料量g_short_qty(原g_sfa07)
                  IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN LET g_tc_sff[l_ac].tc_sff012=' ' END IF #TQC-CB0084 add 
                  IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN LET g_tc_sff[l_ac].tc_sff013= 0  END IF #TQC-CB0084 add 
                  CALL s_shortqty(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,
                                  g_tc_sff[l_ac].tc_sff06,g_tc_sff[l_ac].tc_sff27,
                                 #g_tc_sff012,g_tc_sff013)   #FUN-A50066 add   #MOD-CB0154 mark
                                  g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013)   #MOD-CB0154
                       RETURNING g_short_qty
                  IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
              END IF
              DISPLAY BY NAME g_tc_sff[l_ac].sfa05
              DISPLAY BY NAME g_tc_sff[l_ac].sfa06
           END IF
 #超領單不控制  --so '2' 要拿掉
           IF g_tc_sfd06 MATCHES '[134]' AND     #NO:7075,補2,4
              g_tc_sff[l_ac].sfa05<=g_tc_sff[l_ac].sfa06 AND          #MOD-B80013 add
              g_tc_sfd06 != '4' AND l_sfa11 = 'E' THEN         #MOD-B80013 add
              CALL cl_err('sfa05<=sfa06','asf-462',0) NEXT FIELD tc_sff07
           END IF
           IF g_tc_sfd06 MATCHES '[6789]' THEN    #NO:7075
              SELECT sfa05,sfa06   #FUN-B50059
                INTO g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06  #FUN-940039 add
                FROM sfa_file
               WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                 AND sfa03=g_tc_sff[l_ac].tc_sff04     #MOD-B80111 mark #MOD-D60027 remark
                 AND sfa12=g_tc_sff[l_ac].tc_sff06
                 AND sfa08=g_tc_sff[l_ac].tc_sff07
                 AND sfa27=g_tc_sff[l_ac].tc_sff27
                 AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                 AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028                 
              IF g_tc_sff[l_ac].sfa05<0 AND p_cmd='a' THEN
                 LET g_tc_sff[l_ac].tc_sff05=g_tc_sff[l_ac].sfa05*(-1)
              END IF
              IF g_tc_sff[l_ac].sfa05<0  THEN
                 LET g_tc_sff[l_ac].sfa05=g_tc_sff[l_ac].sfa05*(-1)
              END IF
              IF SQLCA.SQLCODE THEN
                 LET s_sfa05 = 0 LET s_sfa06 = 0                    #FUN-940039 add   {FUN-AC0074}
              END IF
             #計算欠料量g_short_qty(原g_sfa07)
              IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN LET g_tc_sff[l_ac].tc_sff012=' ' END IF #TQC-CB0084 add 
              IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN LET g_tc_sff[l_ac].tc_sff013= 0  END IF #TQC-CB0084 add 
              CALL s_shortqty(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,
                              g_tc_sff[l_ac].tc_sff06,g_tc_sff[l_ac].tc_sff27,
                             #g_tc_sff012,g_tc_sff013)   #FUN-A50066 add    #MOD-CB0154 mark
                              g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013)  #MOD-CB0154
                   RETURNING g_short_qty
              IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF
           END IF
 
           LET g_tc_sff[l_ac].short_qty = g_short_qty #FUN-940039 add
           DISPLAY BY NAME g_tc_sff[l_ac].sfa05
           DISPLAY BY NAME g_tc_sff[l_ac].sfa06
           DISPLAY BY NAME g_tc_sff[l_ac].short_qty       #FUN-940039 add

        AFTER FIELD tc_sff05                                                                                                                                            
#FUN-BB0084 ---------------Begin--------------------
           IF NOT cl_null(g_tc_sff[l_ac].tc_sff05) AND NOT cl_null(g_tc_sff[l_ac].tc_sff06) THEN
              IF cl_null(g_tc_sff06_t) OR cl_null(g_tc_sff_t.tc_sff05) OR g_tc_sff06_t! = g_tc_sff[l_ac].tc_sff06
                 OR g_tc_sff_t.tc_sff05! = g_tc_sff[l_ac].tc_sff05  THEN
                 LET g_tc_sff[l_ac].tc_sff05 = s_digqty(g_tc_sff[l_ac].tc_sff05,g_tc_sff[l_ac].tc_sff06)
                 DISPLAY BY NAME g_tc_sff[l_ac].tc_sff05
              END IF
           END IF 
#FUN-BB0084 ---------------End----------------------
           IF NOT cl_null(g_tc_sfd06) THEN                                                                                                                                            
             IF NOT cl_null(g_tc_sff[l_ac].tc_sff05) THEN
                IF cl_null(g_tc_sff[l_ac].tc_sff04) THEN
                   CALL cl_err('','asf-878',1)
                   NEXT FIELD CURRENT
                END IF
             END IF
             IF g_tc_sff[l_ac].tc_sff05 >0 THEN                                                                                         
                IF (g_tc_sff[l_ac].sfa05 = 0 OR cl_null(g_tc_sff[l_ac].sfa05)) THEN  #No.MOD-8B0086 mark   #FUN-A40058 add 'Z' 
                   CALL cl_err('','asf-081',0)                                                                                        
                   NEXT FIELD tc_sff07                                                                                                  
                END IF                                                                                                                
               #MOD-B20062---add---start---
                SELECT sfa27 INTO b_sfa27 FROM sfa_file
                 WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
                   AND sfa03 = g_tc_sff[l_ac].tc_sff04
               #MOD-B20062---add---end---
             ELSE

             END IF                       
            #IF g_tc_sfd06 MATCHES '[13]' THEN        #TQC-CA0035 mark                                                                                                                          
             IF g_tc_sfd06 MATCHES '[13D]' THEN       #TQC-CA0035 add D                                                                                                                          
                IF g_tc_sff[l_ac].tc_sff05 <0 THEN                                                                                                                                                          
                   CALL cl_err(g_tc_sff[l_ac].tc_sff05,"asf-037",1)                                                                                                               
                   NEXT FIELD tc_sff05                                                                                                                            
                END IF                                                                                                                                                        
                # 同一張備料單也考慮單身有數筆同一張工單的備料量計算                                                    
                LET l_tc_sff05x = 0                                                                                                                                                                                
                SELECT SUM(tc_sff05) INTO l_tc_sff05x FROM tc_sff_file,tc_sfd_file                                                                                                                  
                 WHERE tc_sff03=g_tc_sff[l_ac].tc_sff03                                                                                                                                          
                   AND tc_sff04=g_tc_sff[l_ac].tc_sff04                    
                   AND tc_sff06=g_tc_sff[l_ac].tc_sff06                                                                                                                                         
                   AND tc_sff07=g_tc_sff[l_ac].tc_sff07   
                   AND tc_sff27=g_tc_sff[l_ac].tc_sff27                   
                   AND tc_sff012=g_tc_sff[l_ac].tc_sff012  #FUN-B20079 jan
                   AND tc_sff013=g_tc_sff[l_ac].tc_sff013  #FUN-B20079 jan   
                   AND tc_sff01 = g_tc_sfd.tc_sfd01                                                                                                                                                  
                   AND tc_sff02 != g_tc_sff[l_ac].tc_sff02                                                                                                                                              
                   AND tc_sfd01=tc_sff01 AND tc_sfd04 !='X'  #FUN-660106
                                                                                                                                                                                
                IF STATUS OR cl_null(l_tc_sff05x) THEN                                                                                                                          
                   LET l_tc_sff05x = 0                                                                                                                             
                END IF                                           
                
                IF g_tc_sff[l_ac].tc_sff05>(g_tc_sff[l_ac].sfa05-g_tc_sff[l_ac].sfa06-l_tc_sff05x) THEN                                                                                                                   
                   LET l_msg=g_tc_sff[l_ac].tc_sff04 CLIPPED,' tc_sff05<>sfa05:'                                                                                                                                               
                   CALL cl_err(l_msg CLIPPED ,'asf-351',0) NEXT FIELD tc_sff05                                                                                      
                END IF                                                                                                                                                
                #2013090084 add begin----------------------------------
                IF g_tc_sfd06 = '1' THEN
                   LET l_sfa161 = 0
                   SELECT sfa161 INTO l_sfa161 FROM sfa_file
                    WHERE sfa01 = g_tc_sff[l_ac].tc_sff03
                      AND sfa03 = g_tc_sff[l_ac].tc_sff04
                      AND sfa08 = g_tc_sff[l_ac].tc_sff07
                      AND sfa27 = g_tc_sff[l_ac].tc_sff27  
                      AND sfa12 = g_tc_sff[l_ac].tc_sff06
                      AND sfa012= g_tc_sff[l_ac].tc_sff012
                      AND sfa013= g_tc_sff[l_ac].tc_sff013

                   SELECT SUM(tc_sfe03) INTO l_tc_sfe03 FROM tc_sfe_file
                    WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
                      AND tc_sfe02 = g_tc_sff[l_ac].tc_sff03
                      AND tc_sfe04 = g_tc_sff[l_ac].tc_sff07

                   IF (g_tc_sff[l_ac].tc_sff05/l_sfa161) > l_tc_sfe03 THEN 
                      CALL cl_err(g_tc_sff[l_ac].tc_sff05,'asf-958',0)
                      NEXT FIELD tc_sff05 
                   END IF
                END IF
                #2013090084 add end------------------------------------
             END IF
             
             #TQC-B60036--add--str--
             IF g_tc_sfd06 = '1' THEN 
                SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
                 WHERE ima01 = g_tc_sff[l_ac].tc_sff04 
                IF STATUS THEN 
                   LET l_ima64 = 0 
                   LET l_ima641 = 0 
                END IF
                #check最少發料數量
                IF l_ima641 <>  0 AND g_tc_sff[l_ac].tc_sff05 < l_ima641 THEN
                   CALL cl_err(g_tc_sff[l_ac].tc_sff05,'asf-100',0) 
                   #NEXT FIELD tc_sff05 
                END IF
                LET l_num_z = g_tc_sff[l_ac].tc_sff05/l_ima64
                LET l_num_y = g_tc_sff[l_ac].tc_sff05-l_num_z*l_ima64
  
                IF l_ima64 <> 0 AND (l_num_y) <> 0 THEN
                   CALL cl_err(g_tc_sff[l_ac].tc_sff05,'asf-101',0) 
                   #NEXT FIELD tc_sff05  
                 END IF
             END IF
             #TQC-B60036--add--end--

                
             IF g_tc_sfd06 MATCHES '[1234]' THEN
                #BUGNO:3264 tc_sff05發料量 * l_factor > img10庫存量 01/08/10mandy
               #IF (g_tc_sff[l_ac].tc_sff05 * l_factor) > g_tc_sff[l_ac].img10 THEN     #MOD-C50190 mark
                IF (g_tc_sff[l_ac].tc_sff05 * l_factor) > g_tc_sff[l_ac].img10 THEN #MOD-C50190 add i510_isVMI 
                  #IF g_sma.sma894[3,3]='N' OR g_sma.sma894[3,3] IS NULL THEN                                #FUN-C80107 mark
                  #FUN-D30024--modify--str--
                  #INITIALIZE g_sma894 TO NULL                                                               #FUN-C80107
                  #CALL s_inv_shrt_by_warehouse(g_sma.sma894[3,3],g_tc_sff[l_ac].tc_sff07) RETURNING g_sma894      #FUN-C80107
                  #IF g_sma894 = 'N' THEN                                                                    #FUN-C80107
                  INITIALIZE g_imd23 TO NULL
                  CALL s_inv_shrt_by_warehouse(g_tc_sff[l_ac].tc_sff07,g_plant) RETURNING g_imd23  #TQC-D40078 g_plant 
                  IF g_imd23 = 'N' THEN
                  #FUN-D30024--modify--end--
                      CALL cl_err(g_tc_sff[l_ac].tc_sff05,'mfg1303',0)
                      NEXT FIELD tc_sff05
                   END IF
                END IF
             END IF
                                                        
            SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30059 add ima930 
              FROM ima_file
             WHERE ima01 = g_tc_sff[l_ac].tc_sff04
               AND imaacti = "Y"
            
            IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30059 add

            IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
               (cl_null(g_tc_sff_t.tc_sff05) OR (g_tc_sff[l_ac].tc_sff05<>g_tc_sff_t.tc_sff05 )) THEN
               SELECT DISTINCT img09 INTO g_img09
                 FROM img_file
                WHERE img01=g_tc_sff[l_ac].tc_sff04
               CALL s_umfchk(g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff06,g_img09) 
                    RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF
               IF g_tc_sfd06 MATCHES '[6789B]' THEN
               ELSE
#No.CHI-9A0022 --Begin
                  LET l_bno = ''
                  SELECT sfb27
                    INTO l_bno
                    FROM sfb_file
                   WHERE sfb01 = g_tc_sff[l_ac].tc_sff03
                  IF cl_null(l_bno) THEN
                     LET l_bno = g_tc_sff[l_ac].tc_sff03
                  END IF
#No.CHI-9A0022 --End
#TQC-C10033 --unmark
  #MOD-C10100 --begin--
                    IF g_ima930 = 'N' THEN                                        #DEV-D30059
                    CALL s_mod_lot(g_prog,g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff02,0,   #No.TQC-B90236 modify s_lotout->s_mod_lot
                                  g_tc_sff[l_ac].tc_sff04,' ',
                                  ' ',' ',
                                  g_tc_sff[l_ac].tc_sff06,g_img09,l_fac,
                                  g_tc_sff[l_ac].tc_sff05,l_bno,'MOD',-1)#CHI-9A0022 add l_bno #No.TQC-B90236 add -1
                          RETURNING l_r,g_qty 
                    END IF                                                        #DEV-D30059
  #MOD-C10100 --end--
#TQC-C10033 --unmark
               END IF
               
               IF l_r = "Y" THEN
                  LET g_tc_sff[l_ac].tc_sff05 = g_qty
               END IF
            END IF
         END IF 
#FUN-A20048 --begin     #發料數量不可大於庫存-備置量
#FUN-AC0074--begin--mark-----
#           IF NOT cl_null(g_tc_sff[l_ac].tc_sff04) AND NOT cl_null(g_tc_sff[l_ac].tc_sff03)  THEN   
#              IF g_tc_sfd06 MATCHES '[1234AC]' THEN  
#                 SELECT SUM(sie10) INTO l_qty FROM sie_file 
#                 WHERE sie05!=g_tc_sff[l_ac].tc_sff03 AND sie01=g_tc_sff[l_ac].tc_sff04                 
#                 IF g_tc_sff[l_ac].tc_sff05 > g_img10 - l_qty THEN 
#                    CALL cl_err(g_tc_sff[l_ac].tc_sff05,'sia-103',1)
#                    NEXT FIELD tc_sff05
#                 END IF 
#              END IF 
#           END IF                
##FUN-A20048 --end 
##FUN-A20048 --begin
##检查此料是否有备置，如果有备置，须检查发料的仓储批与备料仓储批是否一致
##如不一致，须检查备置数量之和不可大于发料数量，并提示已备其他仓储批，是否考虑退备置。
#          IF NOT cl_null(g_tc_sff[l_ac].tc_sff04) THEN
#           LET l_cnt = 0
#           LET l_qty = 0
#           SELECT COUNT(*) INTO l_cnt FROM sie_file WHERE sie05=g_tc_sff[l_ac].tc_sff03   
#           IF l_cnt > 0 THEN                 
#            DECLARE sie_curs CURSOR FOR SELECT * FROM sie_file WHERE sie01=g_tc_sff[l_ac].tc_sff04 AND sie11 > 0 
#                 AND sie05=g_tc_sff[l_ac].tc_sff03
#            FOREACH sie_curs INTO l_sie.*
#             IF l_sie.sie02 = g_tc_sff[l_ac].tc_sff07 AND l_sie.sie03 = g_tc_sff[l_ac].tc_sff08 
#               AND l_sie.sie04 = g_tc_sff[l_ac].tc_sff09 THEN              
#                CONTINUE FOREACH 
#             ELSE 
#             	 LET l_qty = l_qty + l_sie.sie11
#             END IF 
#            END FOREACH
#            IF l_qty > g_tc_sff[l_ac].tc_sff05 THEN 
#               CALL cl_err(l_qty,'sia-104',1)
#               NEXT FIELD tc_sff05
#            END IF 
#           END IF
#          END IF        
#FUN-AC0074--end--mark----
#FUN-A20048 --end  

 
        AFTER FIELD tc_sffud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD tc_sffud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_tc_sff_t.tc_sff02 > 0 AND g_tc_sff_t.tc_sff02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
#No.TQC-B90236-------add-----------begin
                IF g_tc_sff[l_ac].tc_sff26 MATCHES '[BC]' THEN
                   CALL cl_err('','asf1020',0)
                   CANCEL DELETE
                END IF
#No.TQC-B90236-------add-----------end
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_tc_sff[l_ac].tc_sff04
                   AND imaacti = "Y"
                
#TQC-C10033 --unmark
 #MOD-C10100 --begin--
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
 #                   IF NOT s_lotout_del(g_prog,g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff02,0,g_tc_sff[l_ac].tc_sff04,'DEL') THEN   #No.FUN-860045 #No.TQC-B90236 MARK
                    IF NOT s_lot_del(g_prog,g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff02,0,g_tc_sff[l_ac].tc_sff04,'DEL') THEN  #No.TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_tc_sfd.tc_sfd01,g_tc_sff_t.tc_sff02,
                                     SQLCA.sqlcode,"","",1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF
 #MOD-C10100 --end--
#TQC-C10033 --unmark
 
                DELETE FROM tc_sff_file
                 WHERE tc_sff01 = g_tc_sfd.tc_sfd01 AND tc_sff02 = g_tc_sff_t.tc_sff02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","tc_sff_file",g_tc_sfd.tc_sfd01,g_tc_sff_t.tc_sff02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
		COMMIT WORK
                display "commit work before delete"
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_sff[l_ac].* = g_tc_sff_t.*
               CLOSE i510_bcl
               DISPLAY "on row change rollback work"
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_sff[l_ac].tc_sff02,-263,1)
               LET g_tc_sff[l_ac].* = g_tc_sff_t.*
            ELSE
             LET l_cnt=0
              SELECT COUNT(*) INTO g_cnt FROM img_file
               WHERE img01 = g_tc_sff[l_ac].tc_sff04   #料號
                 AND  img18 < g_tc_sfd.tc_sfd03        #過帳日   #MOD-870247
                 AND img10 > 0                         # add by donghy 已没有库存的数据不考虑
              IF g_cnt > 0 THEN    #大於有效日期
                 call cl_err('','aim-400',0)   #須修改
                 NEXT FIELD tc_sff07
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_tc_sff[l_ac].tc_sff04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD tc_sff04
                 END IF
 
                 CALL i510_set_origin_field()
                 IF NOT (g_tc_sfd06 MATCHES '[ABC]') THEN #FUN-5C0114
                  #計算tc_sff05的值,檢查入庫數量的合理性
                    CALL i510_check_inventory_qty()
                        RETURNING g_flag
                 END IF
              END IF
              IF NOT i510_tc_sff09_check() THEN NEXT FIELD tc_sff09 END IF  #FUN-CB0087 add
              
               CALL i510_b_move_back()
               CALL i510_b_else()
               IF NOT cl_null(l_sfa27_a) THEN
                  SELECT UNIQUE sfa27 INTO l_sfa27_a FROM sfa_file
                   WHERE sfa01=g_tc_sff[l_ac].tc_sff03
                     AND sfa03=g_tc_sff[l_ac].tc_sff04
                     AND sfa12=g_tc_sff[l_ac].tc_sff06
                     AND sfa08=g_tc_sff[l_ac].tc_sff07
                     AND sfa012=g_tc_sff[l_ac].tc_sff012   #FUN-A60028 
                     AND sfa013=g_tc_sff[l_ac].tc_sff013   #FUN-A60028
                   LET b_tc_sff.tc_sff27=l_sfa27_a
               END IF
               IF cl_null(b_tc_sff.tc_sff27) THEN LET b_tc_sff.tc_sff27=b_tc_sff.tc_sff04 END IF  #No.MOD-8B0086 add
              IF cl_null(b_tc_sff.tc_sff28) THEN
                 SELECT sfa28 INTO b_tc_sff.tc_sff28
                   FROM sfa_file
                  WHERE sfa01 = b_tc_sff.tc_sff03 
                    AND sfa03 = b_tc_sff.tc_sff04
                    AND sfa08 = b_tc_sff.tc_sff07
                    AND sfa12 = b_tc_sff.tc_sff06
                    AND sfa27 = b_tc_sff.tc_sff27
                    AND sfa012= b_tc_sff.tc_sff012  #FUN-A60028 
                    AND sfa013= b_tc_sff.tc_sff013  #FUN-A60028                    
              END IF
               UPDATE tc_sff_file SET * = b_tc_sff.*
                WHERE tc_sff01=g_tc_sfd.tc_sfd01 AND tc_sff02=g_tc_sff_t.tc_sff02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","tc_sff_file",g_tc_sfd.tc_sfd01,g_tc_sff_t.tc_sff02,SQLCA.sqlcode,"","upd tc_sff",1)  #No.FUN-660128
                  LET g_tc_sff[l_ac].* = g_tc_sff_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
                display "commit work on row change"
               END IF
               SELECT SUM(tc_sff05) INTO g_tc_sff[l_ac].img10_alo FROM tc_sff_file,tc_sfd_file                                                  
                WHERE tc_sff04=g_tc_sff[l_ac].tc_sff04                                                                                                                                                                             
                  AND tc_sfd01=tc_sff01 AND tc_sfd04!='X'                                                                                  
                  AND tc_sff01 != g_tc_sfd.tc_sfd01    #MOD-A80031 add
               DISPLAY BY NAME g_tc_sff[l_ac].img10_alo                                                                                
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark    
            DISPLAY "after row int_flag before"
            IF INT_FLAG THEN
               DISPLAY "after row int_flag after"
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              IF p_cmd='a' AND l_ac <= g_tc_sff.getLength() THEN   #CHI-C30106 add
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_tc_sff[l_ac].tc_sff04
                  AND imaacti = "Y"
               
#TQC-C10033 --unmark
  #MOD-C10100 --begin--
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
  #                  IF NOT s_lotout_del(g_prog,g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff02,0,g_tc_sff[l_ac].tc_sff04,'DEL') THEN   #No.FUN-860045 #No.TQC-B90236 MARK
                    IF NOT s_lot_del(g_prog,g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff02,0,g_tc_sff[l_ac].tc_sff04,'DEL') THEN  #No.TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_tc_sfd.tc_sfd01,g_tc_sff_t.tc_sff02,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
              END IF  #CHI-C30106 add
  #MOD-C10100 --end--
#TQC-C10033 --unmark

               IF p_cmd='u' THEN
                  LET g_tc_sff[l_ac].* = g_tc_sff_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_tc_sff.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end-- 
               END IF
               CLOSE i510_bcl
               DISPLAY "after row rollback work"
               ROLLBACK WORK
               DISPLAY "after row rollback work"
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            IF NOT i510_tc_sff09_check() THEN NEXT FIELD tc_sff09 END IF  #FUN-CB0087 add
            LET l_flag1 =0
            SELECT COUNT(*) INTO l_flag1 FROM sfa_file WHERE sfa03=g_tc_sff[l_ac].tc_sff04  AND sfa27=g_tc_sff[l_ac].tc_sff27
            IF l_flag1>0 THEN
            SELECT (sfa05-sfa065),sfa06   #FUN-B50059
               INTO g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06
               FROM tc_sff_file
               LEFT OUTER JOIN sfa_file ON tc_sff03=sfa01 AND tc_sff04=sfa03 AND tc_sff06=sfa12 AND tc_sff07=sfa08 AND tc_sff27=sfa27
                                                       AND tc_sff012=sfa012 AND tc_sff013=sfa013
               LEFT OUTER JOIN ima_file ON tc_sff04=ima01
               WHERE tc_sff01 = g_tc_sfd.tc_sfd01 AND tc_sff02 = g_tc_sff[l_ac].tc_sff02
           ELSE
            SELECT (sfa05-sfa065),sfa06
               INTO g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06
               FROM tc_sff_file
               LEFT OUTER JOIN sfa_file ON tc_sff03=sfa01 AND tc_sff06=sfa12 AND tc_sff07=sfa08 AND tc_sff012=sfa012
                                                       AND tc_sff013=sfa013 AND tc_sff27=sfa03
               LEFT OUTER JOIN ima_file ON tc_sff04=ima01
               WHERE tc_sff01 = g_tc_sfd.tc_sfd01 AND tc_sff02 = g_tc_sff[l_ac].tc_sff02
           END IF
           #CHI-BC0040 end------------
 
             #計算欠料量g_short_qty(原g_sfa07)
              IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN LET g_tc_sff[l_ac].tc_sff012=' ' END IF #TQC-CB0084 add 
              IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN LET g_tc_sff[l_ac].tc_sff013= 0  END IF #TQC-CB0084 add 
              CALL s_shortqty(g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,
                              g_tc_sff[l_ac].tc_sff06,g_tc_sff[l_ac].tc_sff27,
                             #g_tc_sff012,g_tc_sff013)   #FUN-A50066 add    #MOD-CB0154 mark
                              g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013)  #MOD-CB0154
                   RETURNING g_short_qty
              IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
           
            IF g_tc_sfd06='3' THEN
               LET g_tc_sff[l_ac].sfa05=g_short_qty
               LET g_tc_sff[l_ac].sfa06=0
            END IF
            IF g_tc_sfd06 MATCHES '[6789]' THEN   
               IF g_tc_sff[l_ac].sfa05<0  THEN
                  LET g_tc_sff[l_ac].sfa05=g_tc_sff[l_ac].sfa05*(-1)
                  LET g_tc_sff[l_ac].sfa06=g_tc_sff[l_ac].sfa06*(-1)
               END IF
            END IF
            LET g_tc_sff[l_ac].short_qty = g_short_qty 
            DISPLAY BY NAME g_tc_sff[l_ac].sfa05,g_tc_sff[l_ac].sfa06,g_tc_sff[l_ac].tc_sff28,           #CHI-BC0040 add g_tc_sff[l_ac].tc_sff28
                            g_tc_sff[l_ac].short_qty     
            CLOSE i510_bcl
            COMMIT WORK
                display "commit work after row"
 
           #CALL g_tc_sff.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
            CALL g_tc_sff.deleteElement(g_rec_b+1)   #MOD-D60165 add
 
       #CHI-C30106---add---S---
        AFTER INPUT
        LET g_cnt = 0
        SELECT COUNT(*) INTO g_cnt FROM tc_sff_file WHERE tc_sff01=g_tc_sfd.tc_sfd01
          FOR l_c=1 TO g_cnt
             SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
              WHERE ima01 = g_tc_sff[l_c].tc_sff04
                AND imaacti = "Y"

             IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             UPDATE rvbs_file SET rvbs021=g_tc_sff[l_c].tc_sff04
              WHERE rvbs00=g_prog
                AND rvbs01=g_tc_sfd.tc_sfd01
                AND rvbs02=g_tc_sff[l_c].tc_sff02
             END IF
          END FOR
       #CHI-C30106---add---E--- 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_sff02) AND l_ac > 1 THEN
                LET g_tc_sff[l_ac].tc_sff03=g_tc_sff[l_ac-1].tc_sff03
                LET g_tc_sff[l_ac].tc_sff04=g_tc_sff[l_ac-1].tc_sff04
                LET g_tc_sff[l_ac].tc_sff06=g_tc_sff[l_ac-1].tc_sff06
                LET g_tc_sff[l_ac].tc_sff07=g_tc_sff[l_ac-1].tc_sff07
                NEXT FIELD tc_sff02
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(tc_sff04)
                    #g_argv2   1:成套發料 2:超領   3:欠/補料   4.領料
                    #          6.工單成套退料單維護作業
                    #          7.工單超領退料單維護作業
                    #          8.工單一般退料單維護作業
                    #          9.工單領退料維護作業
                    #---------No.MOD-780002 modify
                #單身選擇取替代時，料號開窗出來的應該是在abmi600中維護好的料號
                 IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND g_tc_sff[l_ac].tc_sff26 MATCHES '[US]' THEN   
                    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_tc_sff[l_ac].tc_sff03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_bmd1"
                   # LET g_qryparam.arg1 = l_sfb05              #CHI-BA0016 mark
                    LET g_qryparam.arg1 = g_tc_sff[l_ac].tc_sff03     #CHI-BA0016 add
                    IF g_tc_sff[l_ac].tc_sff26 = 'U' THEN   #取代
                       LET g_qryparam.arg2 = '1'
                    END IF
                    IF g_tc_sff[l_ac].tc_sff26 = 'S' THEN   #替代
                       LET g_qryparam.arg2 = '2'
                    END IF
                    LET g_qryparam.arg3 = g_tc_sff[l_ac].tc_sff27  #CHI-C30089
                    CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04
                    DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                    NEXT FIELD tc_sff04
#FUN-A40058 --begin--
                 ELSE IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND g_tc_sff[l_ac].tc_sff26 MATCHES '[Z]' THEN   
                    SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_tc_sff[l_ac].tc_sff03
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_bon09"
                    LET g_qryparam.arg1 = l_sfb05
                    CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04
                    DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                    NEXT FIELD tc_sff04
#FUN-A40058 --end--
                 ELSE
	             CASE WHEN g_argv2 MATCHES '[136]'
                               LET li_where = " AND sfa01 IN (SELECT tc_sfe02 FROM tc_sfe_file WHERE tc_sfe01 = '",g_tc_sfd.tc_sfd01,"') "
                               IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN 
                               #  LET li_where = " AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' " #FUN-A40058  
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' " #FUN-A40058  
                               ELSE
                               #  LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'  #FUN-A40058 
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'  #FUN-A40058 
                               END IF
                               IF g_argv2 = 3 THEN
                                  CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'1') 
                                       RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,l_sfa27_tmp
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 add
                               ELSE
                                  CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'4') 
                                       RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,l_sfa27_tmp
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 add                                       
                               END IF
              #FUN-A60028 --begin--     
                               LET g_tc_sff[l_ac].tc_sff07 = l_sfa08_tmp               
                               LET g_tc_sff[l_ac].tc_sff06 = l_sfa12_tmp                                      
                               LET g_tc_sff[l_ac].tc_sff27 = l_sfa27_tmp                            
                               IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = ' '
                               END IF 
                               IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                                  LET g_tc_sff[l_ac].tc_sff013 = 0
                               END IF 
                               DISPLAY g_tc_sff[l_ac].tc_sff012 TO tc_sff012
                               DISPLAY g_tc_sff[l_ac].tc_sff013 TO tc_sff013
                               DISPLAY g_tc_sff[l_ac].tc_sff27 TO tc_sff27
                               DISPLAY g_tc_sff[l_ac].tc_sff06 TO tc_sff06                               
                               DISPLAY g_tc_sff[l_ac].tc_sff07 TO tc_sff07                                   
              #FUN-A60028 --end--
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                               NEXT FIELD tc_sff04
                          WHEN g_argv2 MATCHES '[24789]'           #MOD-C30910 add 9
                               CALL cl_init_qry_var()
                               LET g_qryparam.form ="q_sfa1"
                               LET g_qryparam.arg1 =g_tc_sff[l_ac].tc_sff03
                               LET g_qryparam.default2 = g_tc_sff[l_ac].tc_sff27
                               LET g_qryparam.default3 = b_tc_sff.tc_sff28
                               IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN 
                                  LET g_qryparam.where = " sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' " 
                               ELSE
                                  LET g_qryparam.where = " sfa26 IN ('0','1','2','3','4','5','6','7','8','S','U','T','Z') "   #FUN-A20037 add '7,8'  #MOD-C40028 add,'S','U','T','Z'
                               END IF
                               #FUN-B80143 --START--
                               IF g_tc_sfd06 = '7' THEN
                                  LET g_qryparam.where = g_qryparam.where CLIPPED, " AND sfa062 > 0 "
                               END IF 
                               #FUN-B80143 --END--
                               LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff04
                              #CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff27,b_tc_sff.tc_sff28  #FUN-940039 add   #MOD-C40028 mark
                               CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff27,b_tc_sff.tc_sff28,g_tc_sff[l_ac].tc_sff26  #MOD-C40028 add
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                               DISPLAY g_tc_sff[l_ac].tc_sff27 TO tc_sff27   #FUN-940039 add
                               IF g_tc_sff[l_ac].tc_sff26 MATCHES '[USTZ]' THEN      #MOD-C40028 add
                                 DISPLAY g_tc_sff[l_ac].tc_sff26 TO tc_sff26            #MOD-C40028 add
                               ELSE                                            #MOD-CA0045 add
                                 LET g_tc_sff[l_ac].tc_sff26 = ''                    #MOD-CA0045 add
                               END IF                                          #MOD-C40028 add
                          WHEN g_argv2 MATCHES '[ABC]'
                               CALL cl_init_qry_var()
                               LET g_qryparam.form ="q_bmb303"
                               LET g_qryparam.arg1 = g_tc_sff[l_ac].tc_sff03
                               LET g_qryparam.arg2 = g_tc_sfd.tc_sfd03
                               CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                               NEXT FIELD tc_sff04
                     OTHERWISE
#FUN-AA0059---------mod------------str-----------------
#                              CALL cl_init_qry_var()
#                              LET g_qryparam.form ="q_ima"
#                              LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff04
#                              CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff04
                               CALL q_sel_ima(FALSE, "q_ima","",g_tc_sff[l_ac].tc_sff04,"","","","","",'' ) 
                                  RETURNING g_tc_sff[l_ac].tc_sff04  
#FUN-AA0059---------mod------------end-----------------
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
                               NEXT FIELD tc_sff04
                     END CASE
                END IF        #No.MOD-930195 add     
          END IF           #FUN-A40058
                WHEN INFIELD(tc_sff03)
	             #CASE WHEN g_argv2 MATCHES '[13]'
                  CASE WHEN g_argv2 MATCHES '[13D]'   #TQC-CA0045 add D
                               LET li_where = " AND sfa01 IN (SELECT tc_sfe02 FROM tc_sfe_file WHERE tc_sfe01 = '",g_tc_sfd.tc_sfd01,"') "
                               ##組合拆解的工單不顯示出來!
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN 
                              #   LET li_where = " AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "                    #FUN-A40058 mark
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "   #FUN-A40058 
                               ELSE
                              #   LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A20037 add '7,8'   #FUN-A40058
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A40058
                               END IF
                               #TQC-CA0045 add begin--------------------
                               IF g_argv2 = 'D' AND NOT cl_null(g_tc_sff[l_ac].tc_sff014) THEN 
                                  LET li_where = li_where CLIPPED," AND sfb01 IN (SELECT shm012 FROM shm_file WHERE shm01='",g_tc_sff[l_ac].tc_sff014,"') "
                               END IF 
                               #TQC-CA0045 add end----------------------
                               IF g_argv2 = '3' THEN
                                  CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'1') 
                                       RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,g_tc_sff[l_ac].tc_sff27
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 ADD
                               ELSE
                                  CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'4') 
                                       RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,g_tc_sff[l_ac].tc_sff27
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 ADD                                       
                               END IF   
                               DISPLAY g_tc_sff[l_ac].tc_sff27 TO tc_sff27
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
#FUN-A60028 --begin--                               
                               IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = ' '
                               END IF 
                               IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = 0
                               END IF                                
                               DISPLAY g_tc_sff[l_ac].tc_sff012 TO tc_sff012   
                               DISPLAY g_tc_sff[l_ac].tc_sff013 TO tc_sff013   
#FUN-A60028 --end--
                               NEXT FIELD tc_sff03
	                  WHEN g_argv2 MATCHES '[2]'
                               LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') "
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN 
                              #   LET li_where = " AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "                                        #TQC-A30112
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "                       #TQC-A30112
                               ELSE
                              #   LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "  #FUN-A20037 add '7,8'  #TQC-A30112
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "        #TQC-A30112
                               END IF
                               CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'4') 
                                    RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,g_tc_sff[l_ac].tc_sff27
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 ADD                                    
                               DISPLAY g_tc_sff[l_ac].tc_sff27 TO tc_sff27
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
#FUN-A60028 --begin--                               
                               IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = ' '
                               END IF 
                               IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = 0
                               END IF                                
                               DISPLAY g_tc_sff[l_ac].tc_sff012 TO tc_sff012   
                               DISPLAY g_tc_sff[l_ac].tc_sff013 TO tc_sff013   
#FUN-A60028 --end--
                               NEXT FIELD tc_sff03
                          WHEN g_argv2 MATCHES '[ABC]'
#FUN-AA0059---------mod------------str----------------- 
#                              CALL cl_init_qry_var()
#                              LET g_qryparam.form ="q_ima17" #MOD-630064 
#                              LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff03
#                              CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff03
                               CALL q_sel_ima(FALSE, "q_ima17","",g_tc_sff[l_ac].tc_sff03,"","","","","",'' ) 
                                     RETURNING g_tc_sff[l_ac].tc_sff03  
#FUN-AA0059---------mod------------end-----------------
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               NEXT FIELD tc_sff03
                     OTHERWISE
                               LET li_where = " AND sfb04 IN ('2','3','4','5','6','7') "
                               LET li_where = li_where CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "   #CHI-9B0005 mod
                               #CHI-C30040---begin
                               IF g_tc_sfd06 = '4' OR g_tc_sfd06 = '9' THEN
                                  LET li_where = li_where CLIPPED, " AND sfa11 = 'E' "    
                               END IF 
                               #CHI-C30040---end
                               IF NOT cl_null(g_tc_sff[l_ac].tc_sff26) THEN 
                             #    LET li_where = " AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "   #FUN-A40058 
                                  LET li_where = li_where CLIPPED," AND sfa26 = '",g_tc_sff[l_ac].tc_sff26,"' "  #FUN-A40058
                               ELSE
                             #    LET li_where = " AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A20037 add '7,8'    #FUN-A40058 MARK
                                  LET li_where = li_where CLIPPED," AND sfa26 IN ('0','1','2','3','4','5','6','7','8') "   #FUN-A40058
                               END IF
                               #FUN-B80143 --START--
                               IF g_tc_sfd06 = '7' THEN
                                  LET li_where = li_where CLIPPED, " AND sfa062 > 0 "
                               END IF 
                               #FUN-B80143 --END--
                               CALL q_short_qty(FALSE,TRUE,g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,li_where,'4') 
                                    RETURNING g_tc_sff[l_ac].tc_sff03,g_tc_sff[l_ac].tc_sff04,l_sfa08_tmp,l_sfa12_tmp,g_tc_sff[l_ac].tc_sff27
                                                ,g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013   #FUN-A60028 ADD                                    
                               DISPLAY g_tc_sff[l_ac].tc_sff27 TO tc_sff27
                               DISPLAY g_tc_sff[l_ac].tc_sff03 TO tc_sff03
                               DISPLAY g_tc_sff[l_ac].tc_sff04 TO tc_sff04
#FUN-A60028 --begin--                               
                               IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = ' '
                               END IF 
                               IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                                  LET g_tc_sff[l_ac].tc_sff012 = 0
                               END IF                                
                               DISPLAY g_tc_sff[l_ac].tc_sff012 TO tc_sff012   
                               DISPLAY g_tc_sff[l_ac].tc_sff013 TO tc_sff013   
#FUN-A60028 --end--
                               NEXT FIELD tc_sff03
                     END CASE
#FUN-A60028 --begin--
                WHEN INFIELD(tc_sff012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_tc_sff012_1"
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff012
                     LET g_qryparam.default2 = g_tc_sff[l_ac].tc_sff013
                     LET g_qryparam.arg1     = g_tc_sff[l_ac].tc_sff03
                     LET g_qryparam.arg2     = g_tc_sff[l_ac].tc_sff04
                     LET g_qryparam.arg3     = g_tc_sff[l_ac].tc_sff07     #l_sfa08_tmp
                     LET g_qryparam.arg4     = g_tc_sff[l_ac].tc_sff06     # l_sfa12_tmp
                     LET g_qryparam.arg5     = g_tc_sff[l_ac].tc_sff27                                                          
                     CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013
                     IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                        LET g_tc_sff[l_ac].tc_sff012 = ' '
                     END IF 
                     IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                        LET g_tc_sff[l_ac].tc_sff012 = 0
                     END IF                            
                     DISPLAY BY NAME g_tc_sff[l_ac].tc_sff012 
                     DISPLAY BY NAME g_tc_sff[l_ac].tc_sff013 
                     NEXT FIELD tc_sff012                    
                
                WHEN INFIELD(tc_sff013)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_tc_sff012_1"
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff012
                     LET g_qryparam.default2 = g_tc_sff[l_ac].tc_sff013
                     LET g_qryparam.arg1     = g_tc_sff[l_ac].tc_sff03
                     LET g_qryparam.arg2     = g_tc_sff[l_ac].tc_sff04
                     LET g_qryparam.arg3     = g_tc_sff[l_ac].tc_sff07     #l_sfa08_tmp
                     LET g_qryparam.arg4     = g_tc_sff[l_ac].tc_sff06     # l_sfa12_tmp
                     LET g_qryparam.arg5     = g_tc_sff[l_ac].tc_sff27                                                                
                     CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff012,g_tc_sff[l_ac].tc_sff013
                     IF cl_null(g_tc_sff[l_ac].tc_sff012) THEN 
                        LET g_tc_sff[l_ac].tc_sff012 = ' '
                     END IF 
                     IF cl_null(g_tc_sff[l_ac].tc_sff013) THEN 
                        LET g_tc_sff[l_ac].tc_sff012 = 0
                     END IF                              
                     DISPLAY BY NAME g_tc_sff[l_ac].tc_sff012
                     DISPLAY BY NAME g_tc_sff[l_ac].tc_sff013 
                     NEXT FIELD tc_sff013              
#FUN-A60028 --end--                     
                WHEN INFIELD(tc_sff06)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff06
                     CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff06
                     DISPLAY g_tc_sff[l_ac].tc_sff06 TO tc_sff06   #MOD-8A0041
                     NEXT FIELD tc_sff06
                WHEN INFIELD(tc_sff07)
                     CALL cl_init_qry_var()
                     # LET g_qryparam.form ="q_ecd3"  #MOD-4A0262 #TQC-960373 mark
                     LET g_qryparam.form ="q_sfa15"   #TQC-960373 add
                     LET g_qryparam.arg1= g_tc_sff[l_ac].tc_sff03  #TQC-960373 add
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff07
                     CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff07
                     DISPLAY "g_tc_sff[l_ac].tc_sff07=",g_tc_sff[l_ac].tc_sff07
                     DISPLAY g_tc_sff[l_ac].tc_sff07 TO tc_sff07
                     NEXT FIELD tc_sff07
               WHEN INFIELD(tc_sff09)      
                  CALL s_get_where(g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff03,'',g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfd06) RETURNING l_flag2,l_where
                  IF l_flag2 AND g_aza.aza115 = 'Y' THEN 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff09
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf41"             
                     LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff09               
                  END IF
                  CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff09 
                  DISPLAY BY NAME g_tc_sff[l_ac].tc_sff09 
                  CALL i510_azf03_desc()  #TQC-D20042 add
                  NEXT FIELD tc_sff09

#FUN-C70014 add begin----------------------------
              WHEN INFIELD(tc_sff014)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_shm4"
                 IF p_cmd = 'a' THEN
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    #CALL i510_multi_ima01()
                    CALL i510_b_fill(' 1=1')
                 ELSE 
                    LET g_qryparam.default1 = g_tc_sff[l_ac].tc_sff014
                    CALL cl_create_qry() RETURNING g_tc_sff[l_ac].tc_sff014
                    DISPLAY BY NAME g_tc_sff[l_ac].tc_sff014
                 END IF 
#FUN-C70014 add end -----------------------------
           END CASE
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG 
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
    UPDATE tc_sfd_file SET tc_sfdmodu=g_tc_sfd.tc_sfdmodu,  #NO:6908
                        tc_sfddate=g_tc_sfd.tc_sfddate
                       ,tc_sfdud02=g_tc_sfd.tc_sfdud02       #FUN-AB0001 add
     WHERE tc_sfd01=g_tc_sfd.tc_sfd01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","tc_sfd_file",g_tc_sfd.tc_sfd01,"",SQLCA.sqlcode,"","upd tc_sfdmodu",1)  #No.FUN-660128
       LET g_tc_sfd.tc_sfdmodu=g_tc_sfd_t.tc_sfdmodu
       LET g_tc_sfd.tc_sfddate=g_tc_sfd_t.tc_sfddate
       DISPLAY BY NAME g_tc_sfd.tc_sfdmodu
       DISPLAY BY NAME g_tc_sfd.tc_sfddate
    END IF
    DISPLAY BY NAME g_tc_sfd.tc_sfdmodu,g_tc_sfd.tc_sfddate,g_tc_sfd.tc_sfdud02    #FUN-AB0001 add 

    SELECT COUNT(*) INTO g_cnt FROM tc_sff_file WHERE tc_sff01=g_tc_sfd.tc_sfd01
    IF g_cnt=0 THEN 			# 未輸入單身資料, 則取消單頭資料 
       IF cl_confirm('9042') THEN
          DELETE FROM tc_sfd_file WHERE tc_sfd01 = g_tc_sfd.tc_sfd01
          DELETE FROM tc_sfe_file WHERE tc_sfe01 = g_tc_sfd.tc_sfd01
          IF g_tc_sfd06 = '4' THEN
             LET l_cnt=0
             SELECT COUNT(*) INTO l_cnt FROM sfu_file
              WHERE sfu09 = g_tc_sfd.tc_sfd01
             IF l_cnt > 0 THEN
                UPDATE sfu_file SET sfu09 = NULL
                 WHERE sfu09 = g_tc_sfd.tc_sfd01
                IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                   CALL cl_err3("upd","sfu_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd sfu",1)  #No.FUN-660128
                END IF
             END IF
             # 當有耗材產生時,應將apmt730之耗材單號清為NULL                                                     
             LET l_cnt = 0                                                                                                            
             SELECT COUNT(*) INTO l_cnt FROM rvu_file                                                                                 
              WHERE rvu16 = g_tc_sfd.tc_sfd01                                                                                               
             IF l_cnt > 0 THEN                                                                                                        
                UPDATE rvu_file SET rvu16 = NULL                                                                                      
                 WHERE rvu16 = g_tc_sfd.tc_sfd01                                                                                            
                IF STATUS OR SQLCA.sqlerrd[3]=0 THEN                                                                                  
                   CALL cl_err3("upd","rvu_file",g_tc_sfd.tc_sfd01,"",STATUS,"","upd rvu",1)                                                
                END IF                                                                                                                
             END IF                                                                                                                   
          END IF
          LET g_cnt=0
          CLEAR FORM
          CALL g_tc_sfe.clear()
          CALL g_tc_sff.clear()
          INITIALIZE g_tc_sfd.* TO NULL    #TQC-C40150
       END IF
    END IF
 
   #IF g_cnt>0 AND g_smy.smydmy4='Y' THEN                         #FUN-AB0001 mark         
   #FUN-AB0001 add str-------------------
    IF g_cnt>0 AND g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y'THEN  #單據需自動確認且不需簽核
       LET g_action_choice = "insert"
   #FUN-AB0001 add end-------------------
#       CALL i510sub_y_chk(g_tc_sfd.tc_sfd01,g_action_choice)  #TQC-C60079
#       IF g_success = "Y" THEN
#          CALL i510sub_y_upd(g_tc_sfd.tc_sfd01,g_action_choice,FALSE)   
#            RETURNING g_tc_sfd.*
#          DISPLAY BY NAME g_tc_sfd.tc_sfd04  
#          IF g_tc_sfd.tc_sfd04='X' THEN
#             LET g_chr='Y' 
#          ELSE 
#             LET g_chr='N' 
#          END IF  
#          CALL i510_pic() #圖形顯示  
#       END IF
    END IF
 
    IF g_cnt>0 THEN
       IF g_tc_sff.getlength()>g_cnt THEN
          WHILE g_tc_sff.getlength()>g_cnt
             CALL g_tc_sff.deleteElement(g_tc_sff.getlength())
          END WHILE
       END IF
    END IF
    CALL i510_show() #FUN-AB0001 add
#TQC-C30028 ----- add ----- begin
    IF l_replace = 'Y' THEN
       CALL i510_b()
    END IF
#TQC-C30028 ----- add ----- end
END FUNCTION


FUNCTION i510_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 

 
END FUNCTION


FUNCTION i510_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
   DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
   #DEFINE l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B70061 #FUN-BA0058 mark
 
   IF g_sma.sma107='N' THEN
      CALL cl_set_comp_entry("tc_sff26,tc_sff27",FALSE)     #TQC-C70050 add sfs27
   ELSE 
      #TQC-C70050--add--str--
      IF g_rec_b <> 0 THEN     
         IF cl_null(g_tc_sff[l_ac].tc_sff26)  THEN
            CALL cl_set_comp_entry("tc_sff27",FALSE)
         END IF
      END IF
      #TQC-C70050--add--end--
   END IF
 
END FUNCTION

FUNCTION i510_b_move_to()
   LET g_tc_sff[l_ac].tc_sff02 = b_tc_sff.tc_sff02
   LET g_tc_sff[l_ac].tc_sff03 = b_tc_sff.tc_sff03
   LET g_tc_sff[l_ac].tc_sff04 = b_tc_sff.tc_sff04
   LET g_tc_sff[l_ac].tc_sff05 = b_tc_sff.tc_sff05
   LET g_tc_sff[l_ac].tc_sff06 = b_tc_sff.tc_sff06
   LET g_tc_sff[l_ac].tc_sff07 = b_tc_sff.tc_sff07
   LET g_tc_sff[l_ac].tc_sff08 = b_tc_sff.tc_sff08
   LET g_tc_sff[l_ac].tc_sff09 = b_tc_sff.tc_sff09
   LET g_tc_sff[l_ac].tc_sffud01 = b_tc_sff.tc_sffud01
   LET g_tc_sff[l_ac].tc_sffud02 = b_tc_sff.tc_sffud02
   LET g_tc_sff[l_ac].tc_sffud03 = b_tc_sff.tc_sffud03
   LET g_tc_sff[l_ac].tc_sffud04 = b_tc_sff.tc_sffud04
   LET g_tc_sff[l_ac].tc_sffud05 = b_tc_sff.tc_sffud05
   LET g_tc_sff[l_ac].tc_sffud06 = b_tc_sff.tc_sffud06
   LET g_tc_sff[l_ac].tc_sffud07 = b_tc_sff.tc_sffud07
   LET g_tc_sff[l_ac].tc_sffud08 = b_tc_sff.tc_sffud08
   LET g_tc_sff[l_ac].tc_sffud09 = b_tc_sff.tc_sffud09
   LET g_tc_sff[l_ac].tc_sffud10 = b_tc_sff.tc_sffud10
   LET g_tc_sff[l_ac].tc_sffud11 = b_tc_sff.tc_sffud11
   LET g_tc_sff[l_ac].tc_sffud12 = b_tc_sff.tc_sffud12
   LET g_tc_sff[l_ac].tc_sffud13 = b_tc_sff.tc_sffud13
   LET g_tc_sff[l_ac].tc_sffud14 = b_tc_sff.tc_sffud14
   LET g_tc_sff[l_ac].tc_sffud15 = b_tc_sff.tc_sffud15
END FUNCTION

FUNCTION i510_b_move_back()
   LET b_tc_sff.tc_sff02 = g_tc_sff[l_ac].tc_sff02
   LET b_tc_sff.tc_sff03 = g_tc_sff[l_ac].tc_sff03
   LET b_tc_sff.tc_sff04 = g_tc_sff[l_ac].tc_sff04
   LET b_tc_sff.tc_sff27 = g_tc_sff[l_ac].tc_sff27    #FUN-940039 add
   LET b_tc_sff.tc_sff05 = g_tc_sff[l_ac].tc_sff05
   LET b_tc_sff.tc_sff06 = g_tc_sff[l_ac].tc_sff06
   LET b_tc_sff.tc_sff07 = g_tc_sff[l_ac].tc_sff07
   LET b_tc_sff.tc_sff08 = g_tc_sff[l_ac].tc_sff08
   LET b_tc_sff.tc_sff09 = g_tc_sff[l_ac].tc_sff09
   LET b_tc_sff.tc_sff26 = g_tc_sff[l_ac].tc_sff26
   LET b_tc_sff.tc_sff28 = g_tc_sff[l_ac].tc_sff28    #CHI-BC0040 add
   LET b_tc_sff.tc_sffud01 = g_tc_sff[l_ac].tc_sffud01
   LET b_tc_sff.tc_sffud02 = g_tc_sff[l_ac].tc_sffud02
   LET b_tc_sff.tc_sffud03 = g_tc_sff[l_ac].tc_sffud03
   LET b_tc_sff.tc_sffud04 = g_tc_sff[l_ac].tc_sffud04
   LET b_tc_sff.tc_sffud05 = g_tc_sff[l_ac].tc_sffud05
   LET b_tc_sff.tc_sffud06 = g_tc_sff[l_ac].tc_sffud06
   LET b_tc_sff.tc_sffud07 = g_tc_sff[l_ac].tc_sffud07
   LET b_tc_sff.tc_sffud08 = g_tc_sff[l_ac].tc_sffud08
   LET b_tc_sff.tc_sffud09 = g_tc_sff[l_ac].tc_sffud09
   LET b_tc_sff.tc_sffud10 = g_tc_sff[l_ac].tc_sffud10
   LET b_tc_sff.tc_sffud11 = g_tc_sff[l_ac].tc_sffud11
   LET b_tc_sff.tc_sffud12 = g_tc_sff[l_ac].tc_sffud12
   LET b_tc_sff.tc_sffud13 = g_tc_sff[l_ac].tc_sffud13
   LET b_tc_sff.tc_sffud14 = g_tc_sff[l_ac].tc_sffud14
   LET b_tc_sff.tc_sffud15 = g_tc_sff[l_ac].tc_sffud15
   LET b_tc_sff.tc_sffplant = g_plant #FUN-980008 add
   LET b_tc_sff.tc_sfflegal = g_legal #FUN-980008 add
END FUNCTION

FUNCTION i510_b_else()
#FUN-A60028 --begin--   
   IF g_tc_sff[l_ac].tc_sff012 IS NULL THEN LET g_tc_sff[l_ac].tc_sff012 =' ' END IF
   IF g_tc_sff[l_ac].tc_sff013 IS NULL THEN LET g_tc_sff[l_ac].tc_sff013 =0 END IF      
   LET b_tc_sff.tc_sff012= g_tc_sff[l_ac].tc_sff012
   LET b_tc_sff.tc_sff013= g_tc_sff[l_ac].tc_sff013
#FUN-A60028 --end--   
END FUNCTION

FUNCTION i510_azf03_desc() 
   LET g_tc_sff[l_ac].azf03_1 = ''
   IF NOT cl_null(g_tc_sff[l_ac].tc_sff09) THEN  
      SELECT azf03 INTO g_tc_sff[l_ac].azf03_1 FROM azf_file WHERE azf01=g_tc_sff[l_ac].tc_sff09 AND azf02='2'
   END IF
   DISPLAY BY NAME  g_tc_sff[l_ac].azf03_1
END FUNCTION


#對原來數量/換算率/單位的賦值
FUNCTION i510_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
   DEFINE   l_ima63  LIKE ima_file.ima63
 
    SELECT ima63 INTO l_ima63
      FROM ima_file WHERE ima01=g_tc_sff[l_ac].tc_sff04

    LET b_tc_sff.tc_sff05 = g_tc_sff[l_ac].tc_sff05
    LET b_tc_sff.tc_sff06 = g_tc_sff[l_ac].tc_sff06
 
END FUNCTION

#FUN-B20079 jan (S)
FUNCTION i510_chk_tc_sff()
DEFINE l_cnt   LIKE type_file.num5

   LET g_errno=''
   LET l_cnt= 0
   IF g_sma.sma541 = 'N' THEN 
      LET g_tc_sff[l_ac].tc_sff012=' '
      LET g_tc_sff[l_ac].tc_sff013=0
   END IF
   IF NOT cl_null(g_tc_sff[l_ac].tc_sff03) AND    #TQC-B60091
      NOT cl_null(g_tc_sff[l_ac].tc_sff07) AND NOT cl_null(g_tc_sff[l_ac].tc_sff06) AND 
      NOT cl_null(g_tc_sff[l_ac].tc_sff27) AND g_tc_sff[l_ac].tc_sff012 IS NOT NULL AND
      NOT cl_null(g_tc_sff[l_ac].tc_sff013) THEN
      SELECT COUNT(*) INTO l_cnt FROM sfa_file
       WHERE sfa01 =g_tc_sff[l_ac].tc_sff03
         AND sfa08 =g_tc_sff[l_ac].tc_sff07 
         AND sfa12 =g_tc_sff[l_ac].tc_sff06
         AND sfa03 =g_tc_sff[l_ac].tc_sff27 
         AND sfa012=g_tc_sff[l_ac].tc_sff012
         AND sfa013=g_tc_sff[l_ac].tc_sff013
      IF l_cnt = 0 THEN
         LET g_errno='aic-036'
      END IF
   END IF
END FUNCTION
#FUN-B20079 jan (E)

FUNCTION i510_tc_sff27_cho() 
    DEFINE l_sfa  DYNAMIC ARRAY OF RECORD
                   sfa26   LIKE sfa_file.sfa26,
                   sfa27   LIKE sfa_file.sfa27,
                   sfa03   LIKE sfa_file.sfa03,
                   sfa05   LIKE sfa_file.sfa05,
                   sfa06   LIKE sfa_file.sfa06
               END RECORD
    DEFINE l_cnt           LIKE type_file.num5
    DEFINE l_rec_b         LIKE type_file.num5

               
    OPEN WINDOW i501_tc_sff27_w WITH FORM "asf/42f/asfi501f"
   	          ATTRIBUTE(STYLE = g_win_style CLIPPED )
    CALL cl_ui_locale("asfi501f") 
  
    LET g_sql="SELECT sfa26,sfa27,sfa03,sfa05,sfa06 FROM sfa_file WHERE sfa01= '",g_tc_sff[l_ac].tc_sff03,"'" 
    PREPARE i501_tc_sff27_pb FROM g_sql
    DECLARE tc_sff27_curs CURSOR FOR i501_tc_sff27_pb 
    CALL l_sfa.clear()
 
    LET l_cnt = 1
 
    FOREACH tc_sff27_curs INTO l_sfa[l_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET l_cnt = l_cnt + 1
 
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF STATUS THEN CALL cl_err('fore tc_sff27:',STATUS,1) END IF
    CALL l_sfa.deleteElement(l_cnt)
    
    LET l_rec_b=l_cnt - 1

    LET l_cnt = 0
    DISPLAY ARRAY l_sfa TO s_tc_sff27.* ATTRIBUTE(COUNT=l_rec_b)

         BEFORE ROW
            LET l_cnt = ARR_CURR()
            CALL cl_show_fld_cont()
         
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
            
         ON ACTION ACCEPT
            LET l_cnt = ARR_CURR()
            IF l_sfa[l_cnt].sfa26 MATCHES '[9BCUSTZ]' THEN  
               LET g_tc_sff[l_ac].tc_sff26 = l_sfa[l_cnt].sfa26
            ELSE
               LET g_tc_sff[l_ac].tc_sff26 = ''
            END IF 
            LET g_tc_sff[l_ac].tc_sff27 = l_sfa[l_cnt].sfa27
            LET g_tc_sff[l_ac].tc_sff04 = l_sfa[l_cnt].sfa03
            EXIT DISPLAY

         ON ACTION EXIT
            EXIT DISPLAY
            
    END DISPLAY
    CLOSE WINDOW i501_tc_sff27_w
 
END FUNCTION

FUNCTION i510_tc_sff07(p_tc_sff07)
DEFINE p_tc_sff07     LIKE tc_sff_file.tc_sff07
DEFINE l_ecdacti   LIKE ecd_file.ecdacti
DEFINE l_errno     LIKE type_file.chr10
      
    LET l_errno =''
    SELECT ecdacti INTO l_ecdacti FROM ecd_file 
     WHERE ecd01 = p_tc_sff07
    CASE
      WHEN SQLCA.sqlcode = 100  LET l_errno = 'mfg4009'
      WHEN l_ecdacti = 'N'      LET l_errno = 'ams-106'
      OTHERWISE LET l_errno = SQLCA.sqlcode USING '-----'
    END CASE
 
    RETURN l_errno
 
END FUNCTION 


FUNCTION i510_check_inventory_qty()
DEFINE l_n                 LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
       l_factor            LIKE ima_file.ima31_fac,  #No.FUN-680121 DECIMAL(16,8),
       l_sfa05             LIKE sfa_file.sfa05,      #MOD-7A0133 add
       l_sfa06             LIKE sfa_file.sfa06,
       l_sfa161            LIKE sfa_file.sfa161,
       l_sfa100            LIKE sfa_file.sfa100,     #MOD-8B0230 add
       l_sfa100_t          LIKE sfa_file.sfa100,     #MOD-8B0230 add
       l_sfa06_t           LIKE sfa_file.sfa06,
       l_sfa161_t          LIKE sfa_file.sfa161,
       l_sfa26             LIKE sfa_file.sfa26,
       l_sfa27             LIKE sfa_file.sfa27,
       l_sfa28             LIKE sfa_file.sfa28,
       l_sfa28_t           LIKE sfa_file.sfa28,
       l_tc_sff05             LIKE tc_sff_file.tc_sff05,
       l_sfb09             LIKE sfb_file.sfb09,
       l_sfb08             LIKE sfb_file.sfb08,      #MOD-8B0230
       l_sfb11             LIKE sfb_file.sfb11,      #MOD-8B0230
       l_sfa11             LIKE sfa_file.sfa11,      #MOD-BA0193
       l_qty	           LIKE sfb_file.sfb09  #No.FUN-680121 DECIMAL(15,3)
 
   IF NOT cl_null(g_tc_sfd06) THEN
      IF g_tc_sfd06 MATCHES '[13]' THEN
         IF g_tc_sff[l_ac].tc_sff05>(g_tc_sff[l_ac].sfa05-g_tc_sff[l_ac].sfa06) THEN
            CALL cl_err('tc_sff05<>sfa05:','asf-351',0)
            RETURN 1
         END IF
      END IF
      IF g_tc_sfd06 MATCHES '[1234]' THEN
         IF (g_tc_sff[l_ac].tc_sff05 * l_factor) > g_tc_sff[l_ac].img10 THEN #MOD-C50190 add i501_isVMI 
            INITIALIZE g_imd23 TO NULL
            CALL s_inv_shrt_by_warehouse(g_tc_sff[l_ac].tc_sff07,g_plant) RETURNING g_imd23 
            IF g_imd23 = 'N' THEN
               CALL cl_err(g_tc_sff[l_ac].tc_sff05,'mfg1303',0)
               RETURN 1
            END IF
         END IF
      END IF
   END IF
   IF NOT cl_null(g_tc_sff[l_ac].tc_sff06) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_tc_sff[l_ac].tc_sff06
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_tc_sff[l_ac].tc_sff06,"",STATUS,"","gfe:",1)  #No.FUN-660128
         RETURN 2
      END IF
      SELECT COUNT(*) INTO l_n FROM sfa_file
       WHERE sfa01=g_tc_sff[l_ac].tc_sff03
         AND (sfa03=g_tc_sff[l_ac].tc_sff04 OR sfa27=b_tc_sff.tc_sff27)
         AND sfa12=g_tc_sff[l_ac].tc_sff06
      IF l_n=0 THEN
         CALL cl_err('sel sfa',100,0)
         RETURN 2
      END IF
   END IF
   RETURN 0
END FUNCTION

FUNCTION i510_tc_sff09_check()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5

   LET l_flag = FALSE 
   IF cl_null(g_tc_sff[l_ac].tc_sff09) THEN RETURN TRUE END IF
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(g_tc_sfd.tc_sfd01,g_tc_sff[l_ac].tc_sff03,'',g_tc_sff[l_ac].tc_sff04,g_tc_sff[l_ac].tc_sff07,g_tc_sfd.tc_sfdud02,g_tc_sfd.tc_sfd06) RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_tc_sff[l_ac].tc_sff09,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_tc_sff[l_ac].tc_sff09,'aim-425',0) #TQC-D20042
         RETURN FALSE 
      END IF
   ELSE 
      SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_tc_sff[l_ac].tc_sff09 AND azf02='2'
      IF l_n < 1 THEN
         CALL cl_err(g_tc_sff[l_ac].tc_sff09,'aim-425',0) #TQC-D20042
         RETURN FALSE
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 

FUNCTION i510_y_chk()
DEFINE l_str STRING 
DEFINE  l_buf  LIKE type_file.chr1,
        l_tc_sff03   LIKE tc_sff_file.tc_sff03,
        l_tc_sff04   LIKE tc_sff_file.tc_sff04,
        l_sum_tc_sff05   LIKE tc_sff_file.tc_sff05,
        l_tc_sff07    LIKE tc_sff_file.tc_sff07,
        l_sum         LIKE sfa_file.sfa06,
        l_tc_sff27    LIKE tc_sff_file.tc_sff07


  #TQC-B80091  --begin houlia
   IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN
      CALL i510_tc_sfdud02('a')
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_tc_sfd.tc_sfdud02,g_errno,0)
         LET  g_success = 'N'
         RETURN
      END IF
   END IF
   #TQC-B80091  --end  houlia
     
    #tianry add 161122  针对于尾单的情况 可能存在 发料套数*QPA>应发-已发 在此管控一下
   LET l_buf='Y'
   DECLARE sel_ttrryy_cur CURSOR FOR
   SELECT tc_sff03,tc_sff07,tc_sff27 FROM tc_sff_file,tc_sfd_file WHERE
   tc_sff01=tc_sfd01 AND tc_sfd04!='X'  AND tc_sfd01=g_tc_sfd.tc_sfd01   GROUP BY tc_sff03,tc_sff07,tc_sff27
   FOREACH sel_ttrryy_cur INTO l_tc_sff03,l_tc_sff07,l_tc_sff27
     IF cl_null(l_tc_sff07) THEN LET l_tc_sff07=' ' END IF 
     SELECT SUM(tc_sff05) INTO l_sum_tc_sff05 FROM tc_sff_file,tc_sfd_file WHERE tc_sff01=tc_sfd01
     AND tc_sfd04!='X'  AND tc_sff03=l_tc_sff03 AND tc_sff27=l_tc_sff27 AND tc_sff07=l_tc_sff07
     IF cl_null(l_sum_tc_sff05) THEN LET l_sum_tc_sff05=0 END IF    

     #SELECT sfa05 INTO l_sum FROM sfa_file WHERE sfa01=l_tc_sff03 AND sfa03=l_tc_sff04
     SELECT SUM(sfa05) INTO l_sum FROM sfa_file WHERE sfa01=l_tc_sff03 AND sfa27=l_tc_sff27 #按BOM料号统计，否则会有取替代的问题 donghy170209
     AND sfa08=l_tc_sff07 
     IF cl_null(l_sum) THEN LET l_sum=0 END IF
     IF l_sum_tc_sff05> l_sum THEN
        CALL cl_err(l_tc_sff04,'csf-993',1)
        LET g_success='N'
        LET l_buf='N'
     END IF

   END FOREACH 
   IF l_buf='N' THEN RETURN END IF 


    #tianry add end 

   CALL i510_sub_y_chk(g_tc_sfd.tc_sfd01,g_action_choice)  #TQC-C60079

 
   IF g_success='N' THEN
      RETURN   
   END IF
 
END FUNCTION


FUNCTION i510_sub_y_chk(p_tc_sfd01,p_action_choice) #TQC-C60079 add
   DEFINE l_cnt        LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_str        STRING                 #No.MOD-8A0088
   DEFINE p_tc_sfd01      LIKE tc_sfd_file.tc_sfd01  #FUN-840012
   DEFINE l_tc_sfd RECORD LIKE tc_sfd_file.* #FUN-840012
   DEFINE l_tc_sff RECORD LIKE tc_sff_file.* #FUN-840012
   DEFINE l_ima918     LIKE ima_file.ima918
   DEFINE l_ima921     LIKE ima_file.ima921
   DEFINE l_ima930     LIKE ima_file.ima930  #DEV-D30040 add
   DEFINE l_sfa05      LIKE sfa_file.sfa05  #TQC-980097
   DEFINE l_sfa06      LIKE sfa_file.sfa06  #TQC-980097
   DEFINE l_sfa05_1    LIKE sfa_file.sfa05   #TQC-980097
   DEFINE l_sfa06_1    LIKE sfa_file.sfa06   #TQC-980097
   DEFINE l_tc_sff05      LIKE tc_sff_file.tc_sff05   #No:CHI-B50041 add
   DEFINE l_sfa28      LIKE sfa_file.sfa28   #No:CHI-B50041 add
   DEFINE l_sfa11      LIKE sfa_file.sfa11  #TQC-B60001 add
   DEFINE g_rvbs00     LIKE rvbs_file.rvbs00
   DEFINE l_gem01      LIKE gem_file.gem01   #TQC-C60207
   DEFINE l_pmc01      LIKE pmc_file.pmc01   #TQC-C60207
   
   #TQC-A50122--begin--add----------
   DEFINE l_tc_sff03a     LIKE tc_sff_file.tc_sff03
   DEFINE l_tc_sff04a     LIKE tc_sff_file.tc_sff04
   DEFINE l_tc_sff05a     LIKE tc_sff_file.tc_sff05
   DEFINE l_tc_sff27a     LIKE tc_sff_file.tc_sff27
   DEFINE l_tc_sff06a     LIKE tc_sff_file.tc_sff06
   DEFINE l_tc_sff07a     LIKE tc_sff_file.tc_sff07
   DEFINE l_sfa05a     LIKE sfa_file.sfa05
   DEFINE l_sfa06a     LIKE sfa_file.sfa06
   DEFINE l_tc_sff012     LIKE tc_sff_file.tc_sff012 #TQC-B30039
   DEFINE l_tc_sff013     LIKE tc_sff_file.tc_sff013 #TQC-B30039
   #TQC-A50122--end--add--------------
   DEFINE l_tc_sfe02      LIKE tc_sfe_file.tc_sfe02   #MOD-C10100
   DEFINE p_action_choice STRING             #CHI-C30106---add
   DEFINE l_tc_sfe04      LIKE tc_sfe_file.tc_sfe04   #add by guanyao160824
   DEFINE l_x             LIKE type_file.num5         #add by guanyao160824
   DEFINE l_sql           STRING                      #add by guanyao160824
   DEFINE l_n             LIKE type_file.num5         #add by huanglf161008
   DEFINE l_flag          LIKE type_file.chr1         #add by huanglf161009
   DEFINE l_sfb02         LIKE sfb_file.sfb02
  #CHI-C30106---add---S
   IF NOT cl_null(p_action_choice) THEN
      IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
         p_action_choice CLIPPED = "insert"
      THEN
          SELECT * INTO l_tc_sfd.* FROM tc_sfd_file
                               WHERE tc_sfd01=p_tc_sfd01
         IF NOT cl_confirm('axm-108') THEN
            LET g_success = 'N'
            RETURN          
         END IF
      END IF
     #FUN-AB0001 add end --------
   END IF
  #CHI-C30106---add---E

     LET g_success = 'Y'
   
     LET g_rvbs00 = 'asfi511'
     IF cl_null(p_tc_sfd01) THEN 
        CALL cl_err('',-400,0) 
        LET g_success = 'N'
        RETURN 
     END IF
   
     SELECT * INTO l_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01 = p_tc_sfd01
     IF l_tc_sfd.tc_sfd04='Y' AND g_action_choice != "alteration" THEN #add by darcy2022-03-07 14:39:35  alteration
        LET g_success = 'N'           
        CALL cl_err('','9023',0)      
        RETURN
     END IF

     #MOD-D30209---begin
     SELECT COUNT(*) INTO l_cnt
       FROM tc_sff_file
      WHERE tc_sff01 = p_tc_sfd01
     IF l_cnt = 0 THEN
        LET g_success = 'N'           
        CALL cl_err('','asf-348',0)      
        RETURN
     END IF 
     #MOD-D30209---end
   
     IF l_tc_sfd.tc_sfd04 = 'X' THEN
        LET g_success = 'N'   
        CALL cl_err(' ','9024',0)
        RETURN
     END IF
     SELECT COUNT(*) INTO l_cnt FROM tc_sfd_file
        WHERE tc_sfd01= p_tc_sfd01
     IF l_cnt = 0 THEN
        LET g_success = 'N'
        CALL cl_err('','mfg-009',0)
        RETURN
     END IF

#TQC-C60207 ----------------Begin---------------
     IF NOT cl_null(l_tc_sfd.tc_sfd06) THEN
        SELECT gem01 INTO l_gem01 FROM gem_file
         WHERE gem01 = l_tc_sfd.tc_sfd06
           AND gemacti = 'Y'
        IF STATUS THEN
           SELECT pmc01 INTO l_pmc01 FROM pmc_file
            WHERE pmc01 = l_tc_sfd.tc_sfd06
              AND pmcacti = 'Y'
           IF STATUS THEN
              LET g_success = 'N'
              CALL cl_err(l_tc_sfd.tc_sfd06,'asf-683',0)
              RETURN
           END IF
        END IF
     END IF
#TQC-C60207 ----------------End-----------------

#MOD-C10100 --begin--
     #str-----add by guanyao160824
     LET l_tc_sfe02 = NULL
     LET l_tc_sfe04 = NULL 
     LET l_sql = "SELECT tc_sfe02,tc_sfe04 FROM tc_sfe_file WHERE tc_sfe01 = '",l_tc_sfd.tc_sfd01,"'",
                 "   AND tc_sfeud02 = 'Y'"
     PREPARE i510_check_tc_sff_p FROM l_sql
     DECLARE i510_check_tc_sff_c CURSOR FOR i510_check_tc_sff_p
     FOREACH i510_check_tc_sff_c INTO l_tc_sfe02,l_tc_sfe04

#str----add by huanglf161008
    LET l_n = 0
    SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01 = l_tc_sfe02
    IF l_sfb02 != '5' THEN 
        IF NOT cl_null(l_tc_sfd.tc_sfd07) THEN   #tianry add 161116
           SELECT COUNT(*) INTO l_n  FROM shm_file WHERE ta_shm05 = g_tc_sfd.tc_sfd07 AND shm012 = l_tc_sfe02
           IF l_n=0 OR cl_null(l_n) THEN 
              CALL cl_err(l_tc_sfe02,'csf-315',1)
              LET g_success = 'N'
           END IF  
        END IF 
     END IF 
#str----end by huanglf161008
        IF cl_null(l_tc_sfe04) THEN 
           SELECT COUNT(*) INTO l_x FROM tc_sff_file 
            WHERE tc_sff01 = l_tc_sfd.tc_sfd01 
              AND tc_sff03 = l_tc_sfe02
              AND tc_sffud02 = 'Y'
        #str----add by guanyao160904
        ELSE 
           SELECT COUNT(*) INTO l_x FROM tc_sff_file 
            WHERE tc_sff01 = l_tc_sfd.tc_sfd01 
              AND tc_sff03 = l_tc_sfe02
              AND tc_sff07 = l_tc_sfe04
              AND tc_sffud02 = 'Y'
        END IF 
        #end----add by guanyao160904
        IF cl_null(l_x) OR l_x = 0 THEN 
           CALL cl_err(l_tc_sfe02,'csf-077',0)
           LET g_success='N'
           RETURN
        END IF 
     END FOREACH 
     #end-----add by guanyao160824

     #tc_sfe_file的工單一定要存在tc_sff_file裡
      LET l_tc_sfe02=NULL
      DECLARE i501_chk_tc_sfe02 CURSOR FOR
      SELECT tc_sfe02 FROM tc_sfe_file
       WHERE tc_sfe02 NOT IN (SELECT tc_sff03 FROM tc_sff_file WHERE tc_sff01=l_tc_sfd.tc_sfd01)
         AND tc_sfe01=l_tc_sfd.tc_sfd01
         AND tc_sfe03 >= 0

      FOREACH i501_chk_tc_sfe02 INTO l_tc_sfe02
        IF STATUS THEN
           LET l_tc_sfe02=NULL
        END IF
        EXIT FOREACH
      END FOREACH

      IF NOT cl_null(l_tc_sfe02) THEN
         CALL cl_err(l_tc_sfe02,'asf-361',0)
         LET g_success='N'
         RETURN
      END IF
#MOD-C10100 --end--

     #TQC-A50122--begin
     #工單補料時檢查單身相同工單下的相同料件的補料量是否大於欠料量
        DECLARE i501_y_chk_tc_sff05 CURSOR FOR 
         SELECT tc_sff03,tc_sff04,tc_sff27,tc_sff06,tc_sff07,tc_sff012,tc_sff013 FROM tc_sff_file  #TQC-B30039
                WHERE tc_sff01=p_tc_sfd01
        FOREACH i501_y_chk_tc_sff05 INTO l_tc_sff03a,l_tc_sff04a,l_tc_sff27a,
                                      l_tc_sff06a,l_tc_sff07a,l_tc_sff012,l_tc_sff013  #TQC-B30039 
            SELECT SUM(tc_sff05) INTO l_tc_sff05a FROM tc_sff_file,tc_sfd_file                                                                                                                  
             WHERE tc_sff03=l_tc_sff03a                                                                                                                                          
               AND tc_sff04=l_tc_sff04a                                                                                                                                                
               AND tc_sff27=l_tc_sff27a   
               AND tc_sff06=l_tc_sff06a                                                                                                                                         
               AND tc_sff07=l_tc_sff07a                                                                                                                                               
               AND tc_sff012=l_tc_sff012  
               AND tc_sff013=l_tc_sff013  
               AND tc_sff01 = p_tc_sfd01                                                                                                                                                                           
               AND tc_sfd01=tc_sff01 AND tc_sfd04 !='X'  
           #SELECT sum(sfa05),sum(sfa06) INTO l_sfa05a,l_sfa06a FROM sfa_file WHERE sfa01=l_tc_sff03a AND sfa03=l_tc_sff04a #FUN-B20070  #MOD-C90067 mark
           #MOD-C90067---S---
            SELECT sum(sfa05),sum(sfa06) INTO l_sfa05a,l_sfa06a
              FROM sfa_file
             WHERE sfa01=l_tc_sff03a
               AND sfa03=l_tc_sff04a
               AND sfa27=l_tc_sff27a
           #MOD-C90067---E---            

            IF l_tc_sff05a >l_sfa05a-l_sfa06a THEN                                                                                                                                                
               CALL cl_err(l_tc_sff04a CLIPPED,'asf-351',0) 
               LET g_success='N' 
               EXIT FOREACH 
            END IF 
        END FOREACH   
        IF g_success = 'N' THEN RETURN END IF
     #TQC-A50122--end      

     #Cehck 單身 料倉儲批是否存在 img_file
     DECLARE i501_y_chk_c CURSOR FOR SELECT * FROM tc_sff_file
                                      WHERE tc_sff01=p_tc_sfd01
     FOREACH i501_y_chk_c INTO l_tc_sff.*

        #FUN-CB0087--add--str--
        IF g_aza.aza115='Y' AND cl_null(l_tc_sff.tc_sff09) THEN
           CALL cl_err('','aim-888',1)
           LET g_success = "N"
           EXIT FOREACH
        END IF 

        SELECT ima918,ima921,ima930 INTO l_ima918,l_ima921,l_ima930 
          FROM ima_file
         WHERE ima01 = l_tc_sff.tc_sff04
           AND imaacti = "Y"

        IF cl_null(l_ima930) THEN LET l_ima930 = 'N' END IF  #DEV-D30040 add
       #end MOD-A40047 add
        LET l_sfa05_1 = NULL         #MOD-B20080 add
        LET l_sfa06_1 = NULL         #MOD-B20080 add
        SELECT sfa05,sfa06,sfa28,sfa11 into l_sfa05,l_sfa06,l_sfa28,l_sfa11 FROM sfa_file  #FUN-B50059 #TQC-B60001 add sfa11  #No:CHI-B50041  add sfa28
         WHERE sfa01=l_tc_sff.tc_sff03 AND sfa03=l_tc_sff.tc_sff04
           AND sfa12=l_tc_sff.tc_sff06 AND sfa08=l_tc_sff.tc_sff07
           AND sfa27 = l_tc_sff.tc_sff27  #FUN-9B0149 
           AND sfa012= l_tc_sff.tc_sff012   #FUN-A60028
           AND sfa013= l_tc_sff.tc_sff013   #FUN-A60028
           AND sfa27=l_tc_sff.tc_sff27   
     #------------No:CHI-B50041  add
         #取替代料控管
            IF l_tc_sff.tc_sff26 MATCHES '[US]' AND g_sma.sma107 = 'Y' THEN        
               SELECT SUM(sfa05/sfa28),SUM(sfa06/sfa28) into l_sfa05_1,l_sfa06_1 FROM sfa_file
               WHERE sfa01=l_tc_sff.tc_sff03 AND sfa27=l_tc_sff.tc_sff27
               AND sfa12=l_tc_sff.tc_sff06 AND sfa08=l_tc_sff.tc_sff07
             
               IF cl_null(l_sfa05_1) THEN LET l_sfa05_1 = 0 END IF
               IF cl_null(l_sfa06_1) THEN LET l_sfa06_1 = 0 END IF
               IF l_sfa05_1 - l_sfa06_1 < l_tc_sff.tc_sff05/l_sfa28 THEN
                  CALL cl_err(l_tc_sff.tc_sff04,'asf-351',1) 
                  LET g_success='N'
                  EXIT FOREACH     
               END IF 
             ELSE
               IF l_sfa05_1-l_sfa06_1 < l_tc_sff.tc_sff05 THEN 
                  CALL cl_err(l_tc_sff.tc_sff04,'asf-351',1) 
                  LET g_success='N'
                  EXIT FOREACH     
               END IF
            END IF                                    #No:CHI-B50041  add                                

                                                                                                        
           LET l_cnt=0                                                                                                                
           SELECT COUNT(*) INTO l_cnt FROM tc_sfe_file                                                                                   
            WHERE tc_sfe01=p_tc_sfd01                                                                                                       
              AND tc_sfe02=l_tc_sff.tc_sff03                                                                                                   
           IF l_cnt=0 THEN                                                                                                            
              LET l_str=l_tc_sff.tc_sff03                                                                                                   
              CALL cl_err(l_str,'asf-000',1)                                                                                          
              LET g_success='N'                                                                                                       
              EXIT FOREACH                                                                                                            
           END IF                                                                                                                                                                                   
     END FOREACH
 
     IF g_success = 'N' THEN RETURN END IF
END FUNCTION

FUNCTION i510_y_upd()  
 
   CALL i510_sub_y_upd(g_tc_sfd.tc_sfd01,g_action_choice,FALSE)  #FUN-840012  
     RETURNING g_tc_sfd.*
 
   IF g_success='N' THEN
      RETURN  
   END IF
 
END FUNCTION

FUNCTION i510_sub_y_upd(p_tc_sfd01,p_action_choice,p_inTransaction)  
   DEFINE l_forupd_sql    STRING
   DEFINE p_tc_sfd01         LIKE tc_sfd_file.tc_sfd01
  #DEFINE p_action_choice LIKE type_file.chr1         #FUN-AB0001 mark
   DEFINE p_action_choice STRING                      #FUN-AB0001 add
   DEFINE l_tc_sfd    RECORD LIKE tc_sfd_file.*
   DEFINE p_inTransaction LIKE type_file.num5
 
   LET g_success = 'Y'                                #FUN-AB0001 add
 
   IF NOT p_inTransaction THEN #FUN-840012
      BEGIN WORK
   END IF
 
   OPEN i510_cl USING p_tc_sfd01
   IF STATUS THEN
      CALL cl_err("OPEN i510_cl:", STATUS, 1)
      CLOSE i510_cl
      IF NOT p_inTransaction THEN #FUN-840012
         ROLLBACK WORK
      END IF
      RETURN l_tc_sfd.*
   END IF
 
   FETCH i510_cl INTO l_tc_sfd.*     # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(l_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE i510_cl 
       ROLLBACK WORK 
       RETURN l_tc_sfd.*
   END IF
   CLOSE i510_cl

   UPDATE tc_sfd_file 
      SET tc_sfd04 = 'Y'
         ,tc_sfd09 = g_user
    WHERE tc_sfd01 = l_tc_sfd.tc_sfd01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","tc_sfd_file",l_tc_sfd.tc_sfd01,"",STATUS,"","upd tc_sfd04",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF

   #str---add by guanyao160904
   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN
         COMMIT WORK
      END IF
   ELSE
      IF NOT p_inTransaction THEN
         ROLLBACK WORK
      END IF
   END IF
   #str---add by guanyao160904

   RETURN l_tc_sfd.*
END FUNCTION

FUNCTION i510_sub_refresh(p_tc_sfd01)
    DEFINE p_tc_sfd01 LIKE tc_sfd_file.tc_sfd01
    DEFINE l_tc_sfd RECORD LIKE tc_sfd_file.*
   
    SELECT * INTO l_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01=p_tc_sfd01
    RETURN l_tc_sfd.*
END FUNCTION

FUNCTION i510_sub_w(p_tc_sfd01,p_action_choice,p_call_transaction)
  DEFINE p_tc_sfd01         LIKE tc_sfd_file.tc_sfd01
  DEFINE p_action_choice STRING
  DEFINE p_call_transaction LIKE type_file.num5 #WHEN TRUE -> CALL BEGIN/ROLLBACK/COMMIT WORK
  DEFINE l_tc_sfd RECORD    LIKE tc_sfd_file.*
  DEFINE l_cnt     LIKE type_file.num5   #No.TQC-750029
 
   LET g_success='Y'
   IF cl_null(p_tc_sfd01) THEN CALL cl_err('',-400,0) LET g_success='N' RETURN END IF
   SELECT * INTO l_tc_sfd.* FROM tc_sfd_file WHERE tc_sfd01 = p_tc_sfd01
   IF l_tc_sfd.tc_sfd04='N' THEN 
      LET g_success='N' 
      CALL cl_err('','9025',0) 
      RETURN 
   END IF  
  #FUN-AB0001 add end--- 

   IF l_tc_sfd.tc_sfd04='X' THEN CALL cl_err(' ','9024',0) LET g_success='N' RETURN END IF

   #str---add by guanyao160912
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sfp_file WHERE sfpud03 = l_tc_sfd.tc_sfd01 AND  sfpconf <>'X'
   IF l_cnt > 0 THEN
      CALL cl_err('','csf-081',0)
      RETURN  
   END IF 
   #end---add by guanyao160912
 
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-109') THEN LET g_success='N' RETURN END IF
   END IF
   
   IF p_call_transaction THEN
      BEGIN WORK
   END IF
   
   OPEN i510_cl USING l_tc_sfd.tc_sfd01
   IF STATUS THEN
      CALL cl_err("OPEN i510_cl:", STATUS, 1)
      CLOSE i510_cl
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   FETCH i510_cl INTO l_tc_sfd.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_tc_sfd.tc_sfd01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE i510_cl 
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
      LET g_success='N' 
      RETURN
   END IF
   CLOSE i510_cl
   
   LET g_success = 'Y'
   UPDATE tc_sfd_file 
      SET tc_sfd04 = 'N' 
         ,tc_sfd09 = g_user                 #FUN-AB0001 add
    WHERE tc_sfd01 = l_tc_sfd.tc_sfd01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      IF p_call_transaction THEN
         COMMIT WORK
      END IF
   ELSE
      IF p_call_transaction THEN
         ROLLBACK WORK
      END IF
   END IF
END FUNCTION

#add by darcy 2022年3月4日 s---
# 发料套数变更
FUNCTION i510_2()
   DEFINE l_tc_sfg_b DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
        tc_sfg014    LIKE tc_sfg_file.tc_sfg014,    #FUN-C70014
        tc_sfg02     LIKE tc_sfg_file.tc_sfg02,
        tc_sfg012    LIKE tc_sfg_file.tc_sfg012,    #FUN-B20095 
        ecm014       LIKE ecm_file.ecm014,    #FUN-B20095
        tc_sfg04     LIKE tc_sfg_file.tc_sfg04,
        sfb05        LIKE sfb_file.sfb05,
        ima02_a      LIKE ima_file.ima02,
        ima021_a     LIKE ima_file.ima021,
        tc_sfg05     LIKE tc_sfg_file.tc_sfg05, #FUN-5C0114
        tc_sfg06     LIKE tc_sfg_file.tc_sfg06, #FUN-5C0114
        tc_sfg07     LIKE tc_sfg_file.tc_sfg07, #FUN-870097
        tc_sfg03     LIKE tc_sfg_file.tc_sfg03,
        tc_sfgud01   LIKE tc_sfg_file.tc_sfgud01,
        tc_sfgud02   LIKE tc_sfg_file.tc_sfgud02,
        tc_sfgud03   LIKE tc_sfg_file.tc_sfgud03,
        tc_sfgud04   LIKE tc_sfg_file.tc_sfgud04,
        tc_sfgud05   LIKE tc_sfg_file.tc_sfgud05,
        tc_sfgud06   LIKE tc_sfg_file.tc_sfgud06,
        tc_sfgud07   LIKE tc_sfg_file.tc_sfgud07,
        tc_sfgud08   LIKE tc_sfg_file.tc_sfgud08,
        tc_sfgud09   LIKE tc_sfg_file.tc_sfgud09,
        tc_sfgud10   LIKE tc_sfg_file.tc_sfgud10,
        tc_sfgud11   LIKE tc_sfg_file.tc_sfgud11,
        tc_sfgud12   LIKE tc_sfg_file.tc_sfgud12,
        tc_sfgud13   LIKE tc_sfg_file.tc_sfgud13,
        tc_sfgud14   LIKE tc_sfg_file.tc_sfgud14,
        tc_sfgud15   LIKE tc_sfg_file.tc_sfgud15
            END RECORD
   DEFINE l_success  LIKE type_file.chr1,
          l_cnt      LIKE type_file.num5,
          l_qty      LIKE type_file.num15_3 
   DEFINE l_sfb08 	LIKE sfb_file.sfb08     
   DEFINE l_str         STRING  
   DEFINE l_ima56       LIKE ima_file.ima56   
   DEFINE l_faqty       LIKE ima_file.ima56   
   DEFINE l_qty1        LIKE tc_sfe_file.tc_sfe03   
   DEFINE l_qty2        LIKE tc_sfe_file.tc_sfe03   
   DEFINE l_sfb081 	    LIKE sfb_file.sfb081    
   DEFINE l_ima153      LIKE ima_file.ima153
   DEFINE l_allowqty    LIKE tc_sfe_file.tc_sfe03 
   DEFINE l_shm08 	    LIKE shm_file.shm08 
   DEFINE l_shm08_sum   LIKE shm_file.shm08   
   DEFINE qty1,qty2	LIKE tc_sfe_file.tc_sfe03  
   DEFINE unissue_qty	LIKE sfb_file.sfb08  
   DEFINE l_tc_sfg03       LIKE tc_sfg_file.tc_sfg03, 
          l_tc_sfg03_t     LIKE tc_sfg_file.tc_sfg03,
          l_tc_sfg03_o     LIKE tc_sfg_file.tc_sfg03,   #No.MOD-860012 
          l_tc_sfg03_r     LIKE tc_sfg_file.tc_sfg03  
   DEFINE l_sfa062      LIKE sfa_file.sfa062 #TQC-670083
   DEFINE l_per         LIKE type_file.num10  #MOD-B70193 
   DEFINE l_sfa06      LIKE sfa_file.sfa06
   DEFINE l_ima01 LIKE ima_file.ima01
   

   #TODO 1. 查询未发料的笔数
   #TODO 2. 修改，不允许新增
   #TODO 3. 审核

   LET g_sql =
           "SELECT tc_sfe014,tc_sfe02,tc_sfe012,'',tc_sfe04,sfb05,'','',tc_sfe05,tc_sfe06,tc_sfe07,tc_sfe03", #No.FUN-870097 add tc_sfe06 #FUN-5C0114 add tc_sfe05 #FUN-940008 add tc_sfe07  #FUN-B20095 add tc_sfe012,'' #FUN-C70014 add tc_sfe014
           ",tc_sfeud01,tc_sfeud02,tc_sfeud03,tc_sfeud04,tc_sfeud05,",
           "tc_sfeud06,tc_sfeud07,tc_sfeud08,tc_sfeud09,tc_sfeud10,",
           "tc_sfeud11,tc_sfeud12,tc_sfeud13,tc_sfeud14,tc_sfeud15", 
           " FROM tc_sfe_file LEFT OUTER JOIN sfb_file ON tc_sfe02 = sfb01 ", 
           ",  (SELECT sfa01,SUM(sfa06) sfa06 FROM sfa_file GROUP BY sfa01)",
           " WHERE tc_sfe01 ='",g_tc_sfd.tc_sfd01,"' ",
           " AND sfa01 = tc_sfe02  "
   IF g_action_choice = "alteration" THEN 
      LET g_sql = g_sql," AND  sfa06 =0  ORDER BY tc_sfe02"
   ELSE 
      LET g_sql = g_sql," ORDER BY tc_sfe02"
   END IF                                                               #09/10/21 xiaofeizhu Add
    
   PREPARE i510_pd2 FROM g_sql
   DECLARE tc_sfg_curs CURSOR FOR i510_pd2
 
   CALL l_tc_sfg_b.clear()
 
   LET g_cnt = 1
   LET g_rec_d = 0
 
   FOREACH tc_sfg_curs INTO l_tc_sfg_b[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF 
       

      LET l_ima01=l_tc_sfg_b[g_cnt].sfb05

      SELECT ima02,ima021 INTO l_tc_sfg_b[g_cnt].ima02_a, l_tc_sfg_b[g_cnt].ima021_a
        FROM ima_file
       WHERE ima01=l_ima01
      CALL s_schdat_ecm014(l_tc_sfg_b[g_cnt].tc_sfg02,l_tc_sfg_b[g_cnt].tc_sfg012)    #FUN-B20095
         RETURNING l_tc_sfg_b[g_cnt].ecm014                                #FUN-B20095
      
      LET l_tc_sfg_b[g_cnt].tc_sfgud03 = g_user 
      SELECT NVL(MAX(tc_sfgud10),0)+1 INTO l_tc_sfg_b[g_cnt].tc_sfgud10 FROM tc_sfg_file 
       WHERE tc_sfg01 =g_tc_sfd.tc_sfd01 and  tc_sfg02 = l_tc_sfg_b[g_cnt].tc_sfg02 AND tc_sfg04 = l_tc_sfg_b[g_cnt].tc_sfg04
      # LET l_tc_sfg_b[g_cnt].tc_sfgud10 = 1
      LET l_tc_sfg_b[g_cnt].tc_sfgud13 = g_today 
      
      INSERT INTO tc_sfg_file (tc_sfg01,tc_sfg02,tc_sfg03,tc_sfg04,tc_sfg05,
                               tc_sfgud02,tc_sfgud03,tc_sfgud04,tc_sfgud10,tc_sfgud13,
                               tc_sfg06,tc_sfg07,tc_sfg012,tc_sfg014,tc_sfgplant,tc_sfglegal)
           VALUES (g_tc_sfd.tc_sfd01,l_tc_sfg_b[g_cnt].tc_sfg02,l_tc_sfg_b[g_cnt].tc_sfg03,l_tc_sfg_b[g_cnt].tc_sfg04,l_tc_sfg_b[g_cnt].tc_sfg05,
                   l_tc_sfg_b[g_cnt].tc_sfgud02,l_tc_sfg_b[g_cnt].tc_sfgud03,l_tc_sfg_b[g_cnt].tc_sfgud04,l_tc_sfg_b[g_cnt].tc_sfgud10,l_tc_sfg_b[g_cnt].tc_sfgud13,
                   l_tc_sfg_b[g_cnt].tc_sfg06,l_tc_sfg_b[g_cnt].tc_sfg07,l_tc_sfg_b[g_cnt].tc_sfg012,l_tc_sfg_b[g_cnt].tc_sfg014,g_plant,g_legal)

      LET g_cnt = g_cnt + 1

   END FOREACH

   CALL l_tc_sfg_b.deleteElement(g_cnt) 
   LET g_cnt = g_cnt - 1

   IF g_cnt = 0 THEN 
      CALL cl_err("无可处理资料","!",1)
      RETURN
   END IF

   CALL i510_2_b(l_tc_sfg_b)

END FUNCTION
# 修改数量
FUNCTION i510_2_b(p_tc_sfg)
   DEFINE p_tc_sfg DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
        tc_sfg014    LIKE tc_sfg_file.tc_sfg014,    #FUN-C70014
        tc_sfg02     LIKE tc_sfg_file.tc_sfg02,
        tc_sfg012    LIKE tc_sfg_file.tc_sfg012,    #FUN-B20095 
        ecm014       LIKE ecm_file.ecm014,    #FUN-B20095
        tc_sfg04     LIKE tc_sfg_file.tc_sfg04,
        sfb05        LIKE sfb_file.sfb05,
        ima02_a      LIKE ima_file.ima02,
        ima021_a     LIKE ima_file.ima021,
        tc_sfg05     LIKE tc_sfg_file.tc_sfg05, #FUN-5C0114
        tc_sfg06     LIKE tc_sfg_file.tc_sfg06, #FUN-5C0114
        tc_sfg07     LIKE tc_sfg_file.tc_sfg07, #FUN-870097
        tc_sfg03     LIKE tc_sfg_file.tc_sfg03,
        tc_sfgud01   LIKE tc_sfg_file.tc_sfgud01,
        tc_sfgud02   LIKE tc_sfg_file.tc_sfgud02,
        tc_sfgud03   LIKE tc_sfg_file.tc_sfgud03,
        tc_sfgud04   LIKE tc_sfg_file.tc_sfgud04,
        tc_sfgud05   LIKE tc_sfg_file.tc_sfgud05,
        tc_sfgud06   LIKE tc_sfg_file.tc_sfgud06,
        tc_sfgud07   LIKE tc_sfg_file.tc_sfgud07,
        tc_sfgud08   LIKE tc_sfg_file.tc_sfgud08,
        tc_sfgud09   LIKE tc_sfg_file.tc_sfgud09,
        tc_sfgud10   LIKE tc_sfg_file.tc_sfgud10,
        tc_sfgud11   LIKE tc_sfg_file.tc_sfgud11,
        tc_sfgud12   LIKE tc_sfg_file.tc_sfgud12,
        tc_sfgud13   LIKE tc_sfg_file.tc_sfgud13,
        tc_sfgud14   LIKE tc_sfg_file.tc_sfgud14,
        tc_sfgud15   LIKE tc_sfg_file.tc_sfgud15
            END RECORD 
   DEFINE i,j           LIKE type_file.num5
   DEFINE l_success  LIKE type_file.chr1,
          l_cnt      LIKE type_file.num5,
          l_qty      LIKE type_file.num15_3 
   DEFINE l_sfb08 	LIKE sfb_file.sfb08     
   DEFINE l_str         STRING  
   DEFINE l_ima56       LIKE ima_file.ima56   
   DEFINE l_faqty       LIKE ima_file.ima56   
   DEFINE l_qty1        LIKE tc_sfe_file.tc_sfe03   
   DEFINE l_qty2        LIKE tc_sfe_file.tc_sfe03   
   DEFINE l_sfb081 	    LIKE sfb_file.sfb081    
   DEFINE l_ima153      LIKE ima_file.ima153
   DEFINE l_allowqty    LIKE tc_sfe_file.tc_sfe03 
   DEFINE l_shm08 	    LIKE shm_file.shm08 
   DEFINE l_shm08_sum   LIKE shm_file.shm08   
   DEFINE qty1,qty2	LIKE tc_sfe_file.tc_sfe03  
   DEFINE unissue_qty	LIKE sfb_file.sfb08  
   DEFINE l_tc_sfg03       LIKE tc_sfg_file.tc_sfg03, 
          l_tc_sfg03_t     LIKE tc_sfg_file.tc_sfg03,
          l_tc_sfg03_o     LIKE tc_sfg_file.tc_sfg03,   #No.MOD-860012 
          l_tc_sfg03_r     LIKE tc_sfg_file.tc_sfg03  
   DEFINE l_sfa062      LIKE sfa_file.sfa062 #TQC-670083
   DEFINE l_per         LIKE type_file.num10  #MOD-B70193 
   DEFINE l_sfa06      LIKE sfa_file.sfa06 
   DEFINE l_tc_sfg03_flag   LIKE type_file.chr1   #FUN-B20095
   DEFINE l_tc_sfg03_sum   LIKE tc_sfe_file.tc_sfe03
   DEFINE l_ima01 LIKE ima_file.ima01
   DEFINE l_flag_tc_sfe03    LIKE type_file.chr1 
   
   OPEN WINDOW i501_csfi510_2 AT 2,2 WITH FORM "csf/42f/csfi510_2"
               ATTRIBUTE(STYLE = g_win_style CLIPPED )
   CALL cl_ui_locale("csfi510_2") 
   CALL cl_ui_init()

   INPUT ARRAY p_tc_sfg WITHOUT DEFAULTS FROM s_tc_sfg.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)
      
      BEFORE ROW 
         LET i = ARR_CURR()
      
      BEFORE INPUT
         CALL i510_2_comp_set()
      
      BEFORE DELETE

      AFTER INPUT

      BEFORE FIELD tc_sfg03 
 
 
      AFTER FIELD tc_sfg03
         IF NOT cl_null(p_tc_sfg[i].tc_sfg03) THEN
            IF g_tc_sfd06 MATCHES '[ABC]' THEN
               LET l_qty=0
               IF NOT cl_null(p_tc_sfg[i].tc_sfg05) THEN
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre06=p_tc_sfg[i].tc_sfg05
                                                 AND sre07 IS NOT NULL
               ELSE
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre07 IS NOT NULL
               END IF
               IF p_tc_sfg[i].tc_sfg03>l_qty THEN
                  LET l_str="tot:",l_qty
                  CALL cl_err(l_str,"asr-008",1)
               END IF
            END IF
 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = p_tc_sfg[i].sfb05
            IF l_ima56 <> 1 THEN
               #MOD-D40218---begin
               #LET l_faqty = p_tc_sfg[i].tc_sfg03 MOD l_ima56
               LET l_qty1 = p_tc_sfg[i].tc_sfg03 * 1000
               LET l_qty2 = l_ima56 * 1000
               LET l_faqty = l_qty1 MOD l_qty2
               #MOD-D40218---end
               IF  l_faqty <> 0 THEN
                   CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            ELSE
               LET l_per = p_tc_sfg[i].tc_sfg03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> p_tc_sfg[i].tc_sfg03 THEN
                  CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            END IF
  
            IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 > unissue_qty THEN
               CALL cl_err('tc_sfg03>un_issue:','asf-351',0) NEXT FIELD tc_sfg03
            END IF
    
           #str MOD-A30065 add
           #新增時不在此段自動產生單身
            IF g_action_choice="insert" THEN
               LET l_flag_tc_sfe03 = 0
            ELSE
           #end MOD-A30065 add
               IF cl_null(p_tc_sfg[i].tc_sfg03) THEN LET p_tc_sfg[i].tc_sfg03 = 0 END IF #TQC-990094
               IF cl_null(l_tc_sfg03_t) THEN LET l_tc_sfg03_t = 0 END IF           #TQC-990094           
              #IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN                #MOD-C50095 mark
              #IF g_tc_sfd06 MATCHES '[16]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   
               IF g_tc_sfd06 MATCHES '[16D]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   #TQC-CA0045 add
                  LET l_flag_tc_sfe03 = 1 
               END IF
            END IF   #MOD-A30065 add
 
           #IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > (qty1-qty2) THEN    #MOD-BA0078 mark
            #MOD-BA0078 -- begin --
            LET l_ima153 = 0
            LET l_sfb08 = 0
            CALL s_get_ima153(p_tc_sfg[i].sfb05) RETURNING l_ima153
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = p_tc_sfg[i].tc_sfg02
            #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
            #end------add by guanyao160920
            LET l_allowqty = (qty1-qty2) + l_sfb08 * (l_ima153/100)
            IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > l_allowqty THEN
            #MOD-BA0078 -- end --
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
              #MOD-B30647---modify---start---
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
               CALL cl_err('tc_sfg03>issued:','asf-086',0)
               LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
               NEXT FIELD tc_sfg03
              #MOD-B30647---modify---end---
            END IF
 
            IF g_tc_sfd06='3' THEN
               LET p_tc_sfg[i].tc_sfg03=0
            END IF
 
            IF g_tc_sfd06 = '6' THEN    #成套退料
              #IF p_tc_sfg[i].tc_sfg03 <= 0 THEN NEXT FIELD tc_sfg03 END IF   #MOD-BA0017 mark
#MOD-BA0017 -- begin --
               IF p_tc_sfg[i].tc_sfg03 <= 0 THEN
                  CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-685',0)
                  LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
                  NEXT FIELD tc_sfg03
               END IF
#MOD-BA0017 -- end --
              #MOD-BA0078 -- mark begin 上面註記處已有判斷 --
              #SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
              # WHERE sfb01 = p_tc_sfg[i].tc_sfg02
              #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              #IF p_tc_sfg[i].tc_sfg03 > l_qty THEN
              #   CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-705',0)
              #   NEXT FIELD tc_sfg03
              #END IF
              #MOD-BA0078 -- mark end --
            END IF
 
           #IF g_tc_sfd06 = '1' THEN    #成套發料
            IF g_tc_sfd06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'  新增Run Card成套發料
               #FUN-C70014 add begin-----------
               IF g_tc_sfd06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = p_tc_sfg[i].tc_sfg014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = p_tc_sfg[i].tc_sfg02
               #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
               #end------add by guanyao160920
               LET l_tc_sfg03 = 0
               LET l_tc_sfg03_r = 0

               IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                  LET p_tc_sfg[i].tc_sfg04 = ' ' 
               END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF 
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2    #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
    #此段功能由i510_tc_sfe03_chk()代替
               LET l_tc_sfg03 = l_qty1 - l_qty2   
              #end MOD-A70046 mod
 
#MOD-A30070 --BEGIN--
              IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                 LET p_tc_sfg[i].tc_sfg04 = ' ' 
              END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理    
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
              #IF p_tc_sfg[i].tc_sfg04 IS NOT NULL THEN
#此段功能由i510_tc_sfe03_chk()代替
                  LET l_tc_sfg03 = l_qty1 - l_qty2

                  SELECT NVL(sum(tc_sfe03),0) INTO l_qty1 FROM tc_sfe_file 
                WHERE tc_sfe01 = g_tc_sfd.tc_sfd01 and tc_sfe02 = p_tc_sfg[i].tc_sfg02 
                  and tc_sfe04= p_tc_sfg[i].tc_sfg04
                  LET l_tc_sfg03 = l_tc_sfg03 - l_qty1
              #END IF   #MOD-A70046 mark
              #IF g_sma.sma129='N' THEN   #FUN-C70014 mark
               IF g_sma.sma129='N' AND g_tc_sfd06 <> 'D' THEN #FUN-C70014 g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=p_tc_sfg[i].tc_sfg02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_tc_sfg03 = l_sfb081
               END IF
               IF cl_null(l_tc_sfg03_o) THEN LET l_tc_sfg03_o = 0 END IF    #FUN-B20095
               IF l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_sfb08 OR      #No.MOD-860012
                  (g_tc_sfd06 = 'D' AND l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_shm08) THEN #FUN-C70014 add 
                  CALL cl_err(p_tc_sfg[i].tc_sfg02,'asf-704',0)
                  NEXT FIELD tc_sfg03                          #No.MOD-860012 
               END IF
 
               IF g_sma.sma129 = 'N' THEN    #發料不控管套數
                  IF p_tc_sfg[i].tc_sfg03 < 0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-387',0)
                     NEXT FIELD tc_sfg03
                  END IF
               ELSE                          #發料控管套數
                  IF p_tc_sfg[i].tc_sfg03 <=0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-706',0)
                     NEXT FIELD tc_sfg03
                  END IF
               END IF                        #FUN-940039 add
            END IF

            #str---add by jixf 160809
            IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN 
                SELECT SUM(shm08) INTO l_shm08_sum FROM shm_file 
                   WHERE ta_shm05=g_tc_sfd.tc_sfdud02 AND shm012=p_tc_sfg[i].tc_sfg02
                SELECT SUM(tc_sfg03) INTO l_tc_sfg03_sum FROM tc_sfg_file,tc_sfd_file 
                  WHERE tc_sfg01=tc_sfd01 AND tc_sfg02=p_tc_sfg[i].tc_sfg02 AND tc_sfdud02=g_tc_sfd.tc_sfdud02 AND tc_sfg01<>g_tc_sfd.tc_sfd01 AND tc_sfd04<>'X'

                IF l_shm08_sum-l_tc_sfg03_sum < p_tc_sfg[i].tc_sfg03 THEN 
                   CALL cl_err(p_tc_sfg[i].tc_sfg03,'csf-324',1)
                   NEXT FIELD tc_sfg03
                END IF
            END IF 
            
            #end---add by jixf 160809
            LET p_tc_sfg[i].tc_sfg07 = p_tc_sfg[i].tc_sfg03   #FUN-940008 add
            #若tc_sfg03有值且该值合理，则返回tc_sfg012/tc_sfg04/tc_sfg03时不须重给该栏位的预设值
            LET l_tc_sfg03_flag = 'Y'     #FUN-B20095
         END IF
         UPDATE tc_sfg_file 
            SET tc_sfg03 = p_tc_sfg[i].tc_sfg03 
          WHERE tc_sfg01 = g_tc_sfd.tc_sfd01 AND tc_sfg02 = p_tc_sfg[i].tc_sfg02 
            AND tc_sfg04 = p_tc_sfg[i].tc_sfg04 AND tc_sfgud10 = p_tc_sfg[i].tc_sfgud10
         IF STATUS THEN 
            CALL cl_err("UPDATE tc_sfg_file","!",1)
            RETURN
         END IF

      ON change tc_sfg03
         IF NOT cl_null(p_tc_sfg[i].tc_sfg03) THEN
            IF g_tc_sfd06 MATCHES '[ABC]' THEN
               LET l_qty=0
               IF NOT cl_null(p_tc_sfg[i].tc_sfg05) THEN
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre06=p_tc_sfg[i].tc_sfg05
                                                 AND sre07 IS NOT NULL
               ELSE
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre07 IS NOT NULL
               END IF
               IF p_tc_sfg[i].tc_sfg03>l_qty THEN
                  LET l_str="tot:",l_qty
                  CALL cl_err(l_str,"asr-008",1)
               END IF
            END IF
 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = p_tc_sfg[i].sfb05
            IF l_ima56 <> 1 THEN
               #MOD-D40218---begin
               #LET l_faqty = p_tc_sfg[i].tc_sfg03 MOD l_ima56
               LET l_qty1 = p_tc_sfg[i].tc_sfg03 * 1000
               LET l_qty2 = l_ima56 * 1000
               LET l_faqty = l_qty1 MOD l_qty2
               #MOD-D40218---end
               IF  l_faqty <> 0 THEN
                   CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            ELSE
               LET l_per = p_tc_sfg[i].tc_sfg03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> p_tc_sfg[i].tc_sfg03 THEN
                  CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            END IF
  
            IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 > unissue_qty THEN
               CALL cl_err('tc_sfg03>un_issue:','asf-351',0) NEXT FIELD tc_sfg03
            END IF
    
           #str MOD-A30065 add
           #新增時不在此段自動產生單身
            IF g_action_choice="insert" THEN
               LET l_flag_tc_sfe03 = 0
            ELSE
           #end MOD-A30065 add
               IF cl_null(p_tc_sfg[i].tc_sfg03) THEN LET p_tc_sfg[i].tc_sfg03 = 0 END IF #TQC-990094
               IF cl_null(l_tc_sfg03_t) THEN LET l_tc_sfg03_t = 0 END IF           #TQC-990094           
              #IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN                #MOD-C50095 mark
              #IF g_tc_sfd06 MATCHES '[16]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   
               IF g_tc_sfd06 MATCHES '[16D]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   #TQC-CA0045 add
                  LET l_flag_tc_sfe03 = 1 
               END IF
            END IF   #MOD-A30065 add
 
           #IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > (qty1-qty2) THEN    #MOD-BA0078 mark
            #MOD-BA0078 -- begin --
            LET l_ima153 = 0
            LET l_sfb08 = 0
            CALL s_get_ima153(p_tc_sfg[i].sfb05) RETURNING l_ima153
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = p_tc_sfg[i].tc_sfg02
            #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
            #end------add by guanyao160920
            LET l_allowqty = (qty1-qty2) + l_sfb08 * (l_ima153/100)
            IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > l_allowqty THEN
            #MOD-BA0078 -- end --
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
              #MOD-B30647---modify---start---
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
               CALL cl_err('tc_sfg03>issued:','asf-086',0)
               LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
               NEXT FIELD tc_sfg03
              #MOD-B30647---modify---end---
            END IF
 
            IF g_tc_sfd06='3' THEN
               LET p_tc_sfg[i].tc_sfg03=0
            END IF
 
            IF g_tc_sfd06 = '6' THEN    #成套退料
              #IF p_tc_sfg[i].tc_sfg03 <= 0 THEN NEXT FIELD tc_sfg03 END IF   #MOD-BA0017 mark
#MOD-BA0017 -- begin --
               IF p_tc_sfg[i].tc_sfg03 <= 0 THEN
                  CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-685',0)
                  LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
                  NEXT FIELD tc_sfg03
               END IF
#MOD-BA0017 -- end --
              #MOD-BA0078 -- mark begin 上面註記處已有判斷 --
              #SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
              # WHERE sfb01 = p_tc_sfg[i].tc_sfg02
              #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              #IF p_tc_sfg[i].tc_sfg03 > l_qty THEN
              #   CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-705',0)
              #   NEXT FIELD tc_sfg03
              #END IF
              #MOD-BA0078 -- mark end --
            END IF
 
           #IF g_tc_sfd06 = '1' THEN    #成套發料
            IF g_tc_sfd06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'  新增Run Card成套發料
               #FUN-C70014 add begin-----------
               IF g_tc_sfd06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = p_tc_sfg[i].tc_sfg014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = p_tc_sfg[i].tc_sfg02
               #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
               #end------add by guanyao160920
               LET l_tc_sfg03 = 0
               LET l_tc_sfg03_r = 0

               IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                  LET p_tc_sfg[i].tc_sfg04 = ' ' 
               END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF 
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2    #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
    #此段功能由i510_tc_sfe03_chk()代替
               LET l_tc_sfg03 = l_qty1 - l_qty2   
              #end MOD-A70046 mod
 
#MOD-A30070 --BEGIN--
              IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                 LET p_tc_sfg[i].tc_sfg04 = ' ' 
              END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理    
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
              #IF p_tc_sfg[i].tc_sfg04 IS NOT NULL THEN
#此段功能由i510_tc_sfe03_chk()代替
                  LET l_tc_sfg03 = l_qty1 - l_qty2
               SELECT NVL(sum(tc_sfe03),0) INTO l_qty1 FROM tc_sfe_file 
                WHERE tc_sfe01 = g_tc_sfd.tc_sfd01 and tc_sfe02 = p_tc_sfg[i].tc_sfg02 
                  and tc_sfe04= p_tc_sfg[i].tc_sfg04
                  LET l_tc_sfg03 = l_tc_sfg03 - l_qty1
              #END IF   #MOD-A70046 mark
              #IF g_sma.sma129='N' THEN   #FUN-C70014 mark
               IF g_sma.sma129='N' AND g_tc_sfd06 <> 'D' THEN #FUN-C70014 g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=p_tc_sfg[i].tc_sfg02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_tc_sfg03 = l_sfb081
               END IF
               IF cl_null(l_tc_sfg03_o) THEN LET l_tc_sfg03_o = 0 END IF    #FUN-B20095
               IF l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_sfb08 OR      #No.MOD-860012
                  (g_tc_sfd06 = 'D' AND l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_shm08) THEN #FUN-C70014 add 
                  CALL cl_err(p_tc_sfg[i].tc_sfg02,'asf-704',0)
                  NEXT FIELD tc_sfg03                          #No.MOD-860012 
               END IF
 
               IF g_sma.sma129 = 'N' THEN    #發料不控管套數
                  IF p_tc_sfg[i].tc_sfg03 < 0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-387',0)
                     NEXT FIELD tc_sfg03
                  END IF
               ELSE                          #發料控管套數
                  IF p_tc_sfg[i].tc_sfg03 <=0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-706',0)
                     NEXT FIELD tc_sfg03
                  END IF
               END IF                        #FUN-940039 add
            END IF

            #str---add by jixf 160809
            IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN 
                SELECT SUM(shm08) INTO l_shm08_sum FROM shm_file 
                   WHERE ta_shm05=g_tc_sfd.tc_sfdud02 AND shm012=p_tc_sfg[i].tc_sfg02
                SELECT SUM(tc_sfg03) INTO l_tc_sfg03_sum FROM tc_sfg_file,tc_sfd_file 
                  WHERE tc_sfg01=tc_sfd01 AND tc_sfg02=p_tc_sfg[i].tc_sfg02 AND tc_sfdud02=g_tc_sfd.tc_sfdud02 AND tc_sfg01<>g_tc_sfd.tc_sfd01 AND tc_sfd04<>'X'

                IF l_shm08_sum-l_tc_sfg03_sum < p_tc_sfg[i].tc_sfg03 THEN 
                   CALL cl_err(p_tc_sfg[i].tc_sfg03,'csf-324',1)
                   NEXT FIELD tc_sfg03
                END IF
            END IF 
            
            #end---add by jixf 160809
            LET p_tc_sfg[i].tc_sfg07 = p_tc_sfg[i].tc_sfg03   #FUN-940008 add
            #若tc_sfg03有值且该值合理，则返回tc_sfg012/tc_sfg04/tc_sfg03时不须重给该栏位的预设值
            LET l_tc_sfg03_flag = 'Y'     #FUN-B20095
         END IF
         UPDATE tc_sfg_file 
            SET tc_sfg03 = p_tc_sfg[i].tc_sfg03 
          WHERE tc_sfg01 = g_tc_sfd.tc_sfd01 AND tc_sfg02 = p_tc_sfg[i].tc_sfg02 
            AND tc_sfg04 = p_tc_sfg[i].tc_sfg04 AND tc_sfgud10 = p_tc_sfg[i].tc_sfgud10
         IF STATUS THEN 
            CALL cl_err("UPDATE tc_sfg_file",sqlca.sqlcode,1)
            RETURN
         END IF 

      ON ACTION accept
         IF NOT cl_null(p_tc_sfg[i].tc_sfg03) THEN
            IF g_tc_sfd06 MATCHES '[ABC]' THEN
               LET l_qty=0
               IF NOT cl_null(p_tc_sfg[i].tc_sfg05) THEN
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre06=p_tc_sfg[i].tc_sfg05
                                                 AND sre07 IS NOT NULL
               ELSE
                  SELECT SUM(sre07) INTO l_qty FROM sre_file
                                               WHERE sre03=p_tc_sfg[i].tc_sfg04
                                                 AND sre04=p_tc_sfg[i].tc_sfg02
                                                 AND sre07 IS NOT NULL
               END IF
               IF p_tc_sfg[i].tc_sfg03>l_qty THEN
                  LET l_str="tot:",l_qty
                  CALL cl_err(l_str,"asr-008",1)
               END IF
            END IF
 
            SELECT ima56 INTO l_ima56 FROM ima_file where ima01 = p_tc_sfg[i].sfb05
            IF l_ima56 <> 1 THEN
               #MOD-D40218---begin
               #LET l_faqty = p_tc_sfg[i].tc_sfg03 MOD l_ima56
               LET l_qty1 = p_tc_sfg[i].tc_sfg03 * 1000
               LET l_qty2 = l_ima56 * 1000
               LET l_faqty = l_qty1 MOD l_qty2
               #MOD-D40218---end
               IF  l_faqty <> 0 THEN
                   CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            ELSE
               LET l_per = p_tc_sfg[i].tc_sfg03/ l_ima56
               LET l_faqty = l_per *  l_ima56
               IF l_faqty <> p_tc_sfg[i].tc_sfg03 THEN
                  CALL CL_err(p_tc_sfg[i].tc_sfg03,'asf-898',0)
                   NEXT FIELD tc_sfg03
               END IF
            END IF
  
            IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 > unissue_qty THEN
               CALL cl_err('tc_sfg03>un_issue:','asf-351',0) NEXT FIELD tc_sfg03
            END IF
    
           #str MOD-A30065 add
           #新增時不在此段自動產生單身
            IF g_action_choice="insert" THEN
               LET l_flag_tc_sfe03 = 0
            ELSE
           #end MOD-A30065 add
               IF cl_null(p_tc_sfg[i].tc_sfg03) THEN LET p_tc_sfg[i].tc_sfg03 = 0 END IF #TQC-990094
               IF cl_null(l_tc_sfg03_t) THEN LET l_tc_sfg03_t = 0 END IF           #TQC-990094           
              #IF g_tc_sfd06 ='1' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN                #MOD-C50095 mark
              #IF g_tc_sfd06 MATCHES '[16]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   
               IF g_tc_sfd06 MATCHES '[16D]' AND p_tc_sfg[i].tc_sfg03 <> l_tc_sfg03_t THEN      #MOD-C50095 add   #TQC-CA0045 add
                  LET l_flag_tc_sfe03 = 1 
               END IF
            END IF   #MOD-A30065 add
 
           #IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > (qty1-qty2) THEN    #MOD-BA0078 mark
            #MOD-BA0078 -- begin --
            LET l_ima153 = 0
            LET l_sfb08 = 0
            CALL s_get_ima153(p_tc_sfg[i].sfb05) RETURNING l_ima153
            SELECT sfb08 INTO l_sfb08 FROM sfb_file
             WHERE sfb01 = p_tc_sfg[i].tc_sfg02
            #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
            #end------add by guanyao160920
            LET l_allowqty = (qty1-qty2) + l_sfb08 * (l_ima153/100)
            IF g_tc_sfd06 ='6' AND p_tc_sfg[i].tc_sfg03 > l_allowqty THEN
            #MOD-BA0078 -- end --
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
              #MOD-B30647---modify---start---
              #CALL cl_err('tc_sfg03>issued:','asf-086',0) NEXT FIELD tc_sfg03 #MOD-640419
               CALL cl_err('tc_sfg03>issued:','asf-086',0)
               LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
               NEXT FIELD tc_sfg03
              #MOD-B30647---modify---end---
            END IF
 
            IF g_tc_sfd06='3' THEN
               LET p_tc_sfg[i].tc_sfg03=0
            END IF
 
            IF g_tc_sfd06 = '6' THEN    #成套退料
              #IF p_tc_sfg[i].tc_sfg03 <= 0 THEN NEXT FIELD tc_sfg03 END IF   #MOD-BA0017 mark
#MOD-BA0017 -- begin --
               IF p_tc_sfg[i].tc_sfg03 <= 0 THEN
                  CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-685',0)
                  LET p_tc_sfg[i].tc_sfg03 = l_tc_sfg03_t
                  NEXT FIELD tc_sfg03
               END IF
#MOD-BA0017 -- end --
              #MOD-BA0078 -- mark begin 上面註記處已有判斷 --
              #SELECT sfb081-sfb09 INTO l_qty FROM sfb_file
              # WHERE sfb01 = p_tc_sfg[i].tc_sfg02
              #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
              #IF p_tc_sfg[i].tc_sfg03 > l_qty THEN
              #   CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-705',0)
              #   NEXT FIELD tc_sfg03
              #END IF
              #MOD-BA0078 -- mark end --
            END IF
 
           #IF g_tc_sfd06 = '1' THEN    #成套發料
            IF g_tc_sfd06 MATCHES '[1D]' THEN   #FUN-C70014 add 'D'  新增Run Card成套發料
               #FUN-C70014 add begin-----------
               IF g_tc_sfd06 = 'D' THEN
                  #取得Run Card生產數量 
                  SELECT shm08 INTO l_shm08 FROM shm_file 
                   WHERE shm01 = p_tc_sfg[i].tc_sfg014 
                  IF cl_null(l_shm08) THEN LET l_shm08 = 0 END IF    
               END IF 
               #FUN-C70014 add end-------------
               SELECT sfb08 INTO l_sfb08 FROM sfb_file
                WHERE sfb01 = p_tc_sfg[i].tc_sfg02
               #str------add by guanyao160920
               IF NOT cl_null(g_tc_sfd.tc_sfd07) THEN
                  SELECT SUM (shm08) INTO l_sfb08 FROM shm_file 
                   WHERE shm012 = p_tc_sfg[i].tc_sfg02 
                     AND ta_shm05 = g_tc_sfd.tc_sfd07
               END IF
               #end------add by guanyao160920
               LET l_tc_sfg03 = 0
               LET l_tc_sfg03_r = 0

               IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                  LET p_tc_sfg[i].tc_sfg04 = ' ' 
               END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF 
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2    #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
    #此段功能由i510_tc_sfe03_chk()代替
               LET l_tc_sfg03 = l_qty1 - l_qty2   
              #end MOD-A70046 mod
 
#MOD-A30070 --BEGIN--
              IF cl_null(p_tc_sfg[i].tc_sfg04) THEN 
                 LET p_tc_sfg[i].tc_sfg04 = ' ' 
              END IF 
           #FUN-B20095 --------Begin------------
               IF cl_null(p_tc_sfg[i].tc_sfg012) THEN
                  LET p_tc_sfg[i].tc_sfg012 = ' '
               END IF
           #將撈取l_qty1,l_qty2的部分整理到函數 i510_tc_sfe03_chk()處理    
              #CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012)  RETURNING l_qty1,l_qty2  #只要有效存在於發料當中的,用于控管
               CALL i510_tc_sfe03_chk(p_tc_sfg[i].tc_sfg02,p_tc_sfg[i].tc_sfg04,p_tc_sfg[i].tc_sfg012,p_tc_sfg[i].tc_sfg014,'2')  RETURNING l_qty1,l_qty2  #FUN-BC0060 mod  #FUN-C70014 add tc_sfg014
           #FUN-B20095 --------End--------------
              #IF p_tc_sfg[i].tc_sfg04 IS NOT NULL THEN
#此段功能由i510_tc_sfe03_chk()代替
                  LET l_tc_sfg03 = l_qty1 - l_qty2

                  SELECT NVL(sum(tc_sfe03),0) INTO l_qty1 FROM tc_sfe_file 
                WHERE tc_sfe01 = g_tc_sfd.tc_sfd01 and tc_sfe02 = p_tc_sfg[i].tc_sfg02 
                  and tc_sfe04= p_tc_sfg[i].tc_sfg04
                  LET l_tc_sfg03 = l_tc_sfg03 - l_qty1
              #END IF   #MOD-A70046 mark
              #IF g_sma.sma129='N' THEN   #FUN-C70014 mark
               IF g_sma.sma129='N' AND g_tc_sfd06 <> 'D' THEN #FUN-C70014 g_tc_sfd06 <> 'D' Run Card成套發料時統一從發料檔抓取已發套數
                  LET l_sfb08 =NULL
                  LET l_sfb081=NULL
                  SELECT sfb08,sfb081 INTO l_sfb08,l_sfb081 
                                      FROM sfb_file 
                                     WHERE sfb01=p_tc_sfg[i].tc_sfg02
                  IF l_sfb08  IS NULL THEN LET l_sfb08  = 0 END IF
                  IF l_sfb081 IS NULL THEN LET l_sfb081 = 0 END IF
                  LET l_tc_sfg03 = l_sfb081
               END IF
               IF cl_null(l_tc_sfg03_o) THEN LET l_tc_sfg03_o = 0 END IF    #FUN-B20095
               IF l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_sfb08 OR      #No.MOD-860012
                  (g_tc_sfd06 = 'D' AND l_tc_sfg03+p_tc_sfg[i].tc_sfg03-l_tc_sfg03_o > l_shm08) THEN #FUN-C70014 add 
                  CALL cl_err(p_tc_sfg[i].tc_sfg02,'asf-704',0)
                  NEXT FIELD tc_sfg03                          #No.MOD-860012 
               END IF
 
               IF g_sma.sma129 = 'N' THEN    #發料不控管套數
                  IF p_tc_sfg[i].tc_sfg03 < 0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-387',0)
                     NEXT FIELD tc_sfg03
                  END IF
               ELSE                          #發料控管套數
                  IF p_tc_sfg[i].tc_sfg03 <=0 THEN
                     CALL cl_err(p_tc_sfg[i].tc_sfg03,'asf-706',0)
                     NEXT FIELD tc_sfg03
                  END IF
               END IF                        #FUN-940039 add
            END IF

            #str---add by jixf 160809
            IF NOT cl_null(g_tc_sfd.tc_sfdud02) THEN 
                SELECT SUM(shm08) INTO l_shm08_sum FROM shm_file 
                   WHERE ta_shm05=g_tc_sfd.tc_sfdud02 AND shm012=p_tc_sfg[i].tc_sfg02
                SELECT SUM(tc_sfg03) INTO l_tc_sfg03_sum FROM tc_sfg_file,tc_sfd_file 
                  WHERE tc_sfg01=tc_sfd01 AND tc_sfg02=p_tc_sfg[i].tc_sfg02 AND tc_sfdud02=g_tc_sfd.tc_sfdud02 AND tc_sfg01<>g_tc_sfd.tc_sfd01 AND tc_sfd04<>'X'

                IF l_shm08_sum-l_tc_sfg03_sum < p_tc_sfg[i].tc_sfg03 THEN 
                   CALL cl_err(p_tc_sfg[i].tc_sfg03,'csf-324',1)
                   NEXT FIELD tc_sfg03
                END IF
            END IF 
            
            #end---add by jixf 160809
            LET p_tc_sfg[i].tc_sfg07 = p_tc_sfg[i].tc_sfg03   #FUN-940008 add
            #若tc_sfg03有值且该值合理，则返回tc_sfg012/tc_sfg04/tc_sfg03时不须重给该栏位的预设值
            LET l_tc_sfg03_flag = 'Y'     #FUN-B20095
         END IF
         UPDATE tc_sfg_file 
            SET tc_sfg03 = p_tc_sfg[i].tc_sfg03 
          WHERE tc_sfg01 = g_tc_sfd.tc_sfd01 AND tc_sfg02 = p_tc_sfg[i].tc_sfg02 
            AND tc_sfg04 = p_tc_sfg[i].tc_sfg04 AND tc_sfgud10 = p_tc_sfg[i].tc_sfgud10
         IF STATUS THEN 
            CALL cl_err("UPDATE tc_sfg_file","!",1)
            RETURN
         END IF

         CALL i510_2_y(p_tc_sfg[i].tc_sfgud10)

         EXIT INPUT


      ON ACTION cancel
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION CONTROLG     
         CALL cl_cmdask()    

   END INPUT      

   CLOSE WINDOW i501_csfi510_2

   CALL i510_show()
   MESSAGE "变更成功！"


END FUNCTION 
# 审核
FUNCTION i510_2_y(p_tc_sfgud10)
   DEFINE p_tc_sfgud10     LIKE tc_sfg_file.tc_sfgud10
   DEFINE l_cnt            LIKE type_file.num5 
   DEFINE l_tc_sfg   RECORD
               tc_sfg01    LIKE tc_sfg_file.tc_sfg01,
               tc_sfg02    LIKE tc_sfg_file.tc_sfg02,
               tc_sfg03    LIKE tc_sfg_file.tc_sfg03,
               tc_sfg04    LIKE tc_sfg_file.tc_sfg04,
               tc_sfgud10    LIKE tc_sfg_file.tc_sfgud10
               END RECORD
   DEFINE d1   DATETIME HOUR TO SECOND  
   
               

   #NOTE 删除前后工时相同的变更记录
   
   LET g_sql = " DELETE FROM tc_sfg_file 
                 WHERE (tc_sfg01,tc_sfg02,tc_sfg04,tc_sfg03) in (
                    SELECT tc_sfe01,tc_sfe02,tc_sfe04,tc_sfe03 FROM tc_sfe_file
                     WHERE tc_sfe01 = '",g_tc_sfd.tc_sfd01,"' 
                 )
                     AND tc_sfg01= '",g_tc_sfd.tc_sfd01,"'
                     AND tc_sfgud10= ",p_tc_sfgud10
   PREPARE i510_deltc_sfg FROM g_sql 
   EXECUTE i510_deltc_sfg
   IF STATUS THEN 
      CALL cl_err("UPDATE tc_sfg_file",sqlca.sqlcode,1)
      RETURN
   END IF

   BEGIN WORK

   LET g_sql = "SELECT tc_sfg01,tc_sfg02,tc_sfg03,tc_sfg04,tc_sfgud10 FROM tc_sfg_file ",
               " WHERE tc_sfg01 = '",g_tc_sfd.tc_sfd01,"' AND tc_sfgud10 = ",p_tc_sfgud10
   
   PREPARE i510_p_tc_sfg FROM g_sql 
   DECLARE i510_d_tc_sfg CURSOR FOR i510_p_tc_sfg

   FOREACH i510_d_tc_sfg INTO l_tc_sfg.*
      IF STATUS THEN 
         CALL cl_err("i510_d_tc_sfg",sqlca.sqlcode,1)
         RETURN
      END IF
      #TODO 更新tc_sfg_file 单身 
      UPDATE tc_sfe_file SET tc_sfe03 = l_tc_sfg.tc_sfg03
       WHERE tc_sfe01 = l_tc_sfg.tc_sfg01 and tc_sfe02 = l_tc_sfg.tc_sfg02 and tc_sfe04 = l_tc_sfg.tc_sfg04
      
      #TODO 删除tc_sff_file ,重新插入
      DELETE FROM tc_sff_file WHERE tc_sff01 = l_tc_sfg.tc_sfg01 and tc_sff03 = l_tc_sfg.tc_sfg02

      LET  b_tc_sfe.tc_sfe02 = l_tc_sfg.tc_sfg02 
      LET  b_tc_sfe.tc_sfe03 = l_tc_sfg.tc_sfg03

      SELECT NVL(max(tc_sff02),0)+1 INTO g_x FROM tc_sff_file WHERE tc_sff01 = l_tc_sfg.tc_sfg01
      
      CALL i510_g_b1()

   END FOREACH

   #NOTE: 更新替代料
   IF NOT i510_2_tc_sff() THEN 
      ROLLBACK WORK
      CALL cl_err("替代料更新失败","!",1)
      RETURN 
   END IF

   #TODO 2.调用审核函数

   CALL i510_y_chk()
   # IF g_success = "Y" THEN
   #    CALL i510_2_y_upd()
   # END IF 

   LET d1 = CURRENT HOUR TO SECOND
   
   UPDATE tc_sfg_file SET tc_sfgud04 = d1 
    WHERE tc_sfg01 = g_tc_sfd.tc_sfd01 and tc_sfgud10 = p_tc_sfgud10
   
   COMMIT WORK
END FUNCTION 
# 设置显示栏位和可修改的栏位
FUNCTION i510_2_comp_set()
    CALL cl_set_comp_visible("tc_sfg014,tc_sfg012,ecm014,tc_sfgud01,tc_sfgud04,tc_sfgud05,tc_sfgud06,,tc_sfgud07,,tc_sfgud08,tc_sfgud09,tc_sfgud10,tc_sfgud11,tc_sfgud12,tc_sfgud14,tc_sfgud15",FALSE)
   #  CALL cl_set_comp_visible("",FALSE)
END FUNCTION 
#add by darcy 2022年3月4日 e--- 

#add by darcy: 2022-03-14 14:59:21 s---
# 替代料数量确认
FUNCTION i510_2_tc_sff()
   DEFINE l_tc_sff DYNAMIC ARRAY OF type_tc_sff_2 
   DEFINE l_tc_sfe03    LIKE tc_sfe_file.tc_sfe03
   DEFINE l_tc_sff03    LIKE tc_sff_file.tc_sff03,
          l_tc_sff27    LIKE tc_sff_file.tc_sff27,
          l_tc_sff07    LIKE tc_sff_file.tc_sff07
   DEFINE i,j           LIKE type_file.num5

   LET g_sql =
        "SELECT tc_sff02,tc_sff26,tc_sff28,tc_sff014,tc_sff03,tc_sff27,tc_sff04,ima02,ima021,tc_sff012,'',tc_sff013,tc_sff06,tc_sff07,(sfa05-sfa065),sfa06,'',",   
        "       tc_sff05,0,tc_sff08,0,0,tc_sff09,azf03 ",     
        "       ,tc_sffud01,tc_sffud02,tc_sffud03,tc_sffud04,tc_sffud05,",
        "       tc_sffud06,tc_sffud07,tc_sffud08,tc_sffud09,tc_sffud10,",
        "       tc_sffud11,tc_sffud12,tc_sffud13,tc_sffud14,tc_sffud15", 
        "  FROM tc_sff_file LEFT OUTER JOIN sfa_file ON tc_sff03=sfa01 AND tc_sff06=sfa12 AND tc_sff07=sfa08 ",   #MOD-BB0307 Add
        "   AND tc_sff012=sfa012 AND tc_sff013=sfa013 AND tc_sff27=sfa27 AND tc_sff04=sfa03 ",                   
        " LEFT OUTER JOIN ima_file ON tc_sff04=ima01 ",                                                  #09/10/21 xiaofeizhu Add
        " LEFT OUTER JOIN azf_file ON tc_sff09=azf01 AND azf02 = '2' ",                                  #FUN-CB0087 add
        " WHERE tc_sff01 ='",g_tc_sfd.tc_sfd01,"'",  
       "  AND tc_sff28 IS NOT NULL  ORDER BY tc_sff03,tc_sff27,tc_sff07 "  
    PREPARE i510_pb2 FROM g_sql
    DECLARE tc_sff_curs2 CURSOR FOR i510_pb2
 
    CALL l_tc_sff.clear()
    #NOTE: tc_sfe03 的数量就是带出的替代料总数量
    LET l_tc_sfe03 = 0 
 
    LET g_cnt = 1
 
    FOREACH tc_sff_curs2 INTO l_tc_sff[g_cnt].*, g_short_qty #單身 ARRAY 填充#FUN-940039 add 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF

        #NOTE: 不是相同料件，重新计算数量
        IF cl_null(l_tc_sff03) THEN 
            #第一笔或者不同料号了
            LET l_tc_sff03 = l_tc_sff[g_cnt].tc_sff03_2
            LET l_tc_sff27 = l_tc_sff[g_cnt].tc_sff27_2
            LET l_tc_sff07 = l_tc_sff[g_cnt].tc_sff07_2
        END IF 
        IF l_tc_sff03 <> l_tc_sff[g_cnt].tc_sff03_2 OR l_tc_sff27 <> l_tc_sff[g_cnt].tc_sff27_2
           OR l_tc_sff07 <> l_tc_sff[g_cnt].tc_sff07_2 THEN
        #料号不同了
            LET l_tc_sff[g_cnt-1].tc_sfe03_2 = l_tc_sfe03
            LET l_tc_sfe03 = 0 
            LET l_tc_sff03 = l_tc_sff[g_cnt].tc_sff03_2
            LET l_tc_sff27 = l_tc_sff[g_cnt].tc_sff27_2
            LET l_tc_sff07 = l_tc_sff[g_cnt].tc_sff07_2
        END IF 

        SELECT SUM(img10) INTO l_tc_sff[g_cnt].img10_2  FROM img_file WHERE img01 =  l_tc_sff[g_cnt].tc_sff04_2
        #計算欠料量g_short_qty(原g_sfa07)
         IF cl_null(l_tc_sff[g_cnt].tc_sff012_2) THEN LET l_tc_sff[g_cnt].tc_sff012_2=' ' END IF #TQC-CB0084 add 
         IF cl_null(l_tc_sff[g_cnt].tc_sff013_2) THEN LET l_tc_sff[g_cnt].tc_sff013_2= 0  END IF #TQC-CB0084 add 
         CALL s_shortqty(l_tc_sff[g_cnt].tc_sff03_2,l_tc_sff[g_cnt].tc_sff04_2,l_tc_sff[g_cnt].tc_sff07_2,
                         l_tc_sff[g_cnt].tc_sff06_2,l_tc_sff[g_cnt].tc_sff27_2,
                         l_tc_sff[g_cnt].tc_sff012_2,l_tc_sff[g_cnt].tc_sff013_2)  
              RETURNING g_short_qty
         IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
         LET l_tc_sff[g_cnt].short_qty_2 = g_short_qty
 
        IF g_tc_sfd.tc_sfd04='N' THEN
           SELECT SUM(sfs05) INTO l_tc_sff[g_cnt].img10_alo_2 FROM sfs_file,sfp_file #No:8247
            WHERE sfs04=l_tc_sff[g_cnt].tc_sff04_2
              AND sfp01=sfs01 AND sfpconf!='X'  #No:8247  #FUN-660106
              AND sfs03 = l_tc_sff[g_cnt].tc_sff03_2
           IF g_tc_sfd06='3' THEN
              LET l_tc_sff[g_cnt].sfa05_2=g_short_qty   #FUN-940039 add
              LET l_tc_sff[g_cnt].sfa06_2=0
           END IF
        END IF
        
        CALL s_schdat_ecm014(l_tc_sff[g_cnt].tc_sff03_2,l_tc_sff[g_cnt].tc_sff012_2) RETURNING l_tc_sff[g_cnt].ecu014_2       
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    IF g_cnt = 1 THEN 
      RETURN TRUE
    END IF 

    LET l_tc_sff[g_cnt-1].tc_sfe03_2 = l_tc_sfe03

    CALL l_tc_sff.deleteElement(g_cnt)

   OPEN WINDOW i501_csfi510_2 AT 2,2 WITH FORM "csf/42f/csfi510_3"
               ATTRIBUTE(STYLE = g_win_style CLIPPED )
   CALL cl_ui_locale("csfi510_3") 
   CALL cl_ui_init()

    
    INPUT ARRAY l_tc_sff WITHOUT DEFAULTS FROM s_tc_sff_2.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)
      
      BEFORE ROW 
         LET i = ARR_CURR()
      
      BEFORE INPUT
         CALL i510_2_comp_set()
      
      BEFORE DELETE

      AFTER INPUT

      BEFORE FIELD tc_sff05 
      AFTER FIELD tc_sff05
         IF NOT i510_2_tc_sff_check(l_tc_sff,i,l_tc_sff[i].tc_sff05_2) THEN 
            NEXT FIELD tc_sff05
         END IF

      ON CHANGE tc_sff05  
         IF NOT i510_2_tc_sff_check(l_tc_sff,i,l_tc_sff[i].tc_sff05_2) THEN 
            NEXT FIELD tc_sff05
         END IF

      ON ACTION accept 
         IF NOT i510_2_tc_sff_check(l_tc_sff,i,l_tc_sff[i].tc_sff05_2) THEN 
            NEXT FIELD tc_sff05
         END IF
         IF i510_2_tc_sff_update(l_tc_sff) THEN 
         END IF

      ON ACTION cancel
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION CONTROLG     
         CALL cl_cmdask()    

   END INPUT

   RETURN TRUE
END FUNCTION

#检查发料数量
FUNCTION i510_2_tc_sff_check(p_tc_sff,p_ac,p_tc_sff05)
   DEFINE p_tc_sff DYNAMIC ARRAY OF type_tc_sff_2 
   DEFINE p_tc_sff05    LIKE tc_sff_file.tc_sff05
   DEFINE p_ac,i        LIKE type_file.num5
   DEFINE l_qty         LIKE tc_sfe_file.tc_sfe03
 
   LET p_tc_sff[p_ac].tc_sff05_2 = IIF(p_tc_sff[p_ac].tc_sff05_2 != p_tc_sff05,p_tc_sff05,p_tc_sff[p_ac].tc_sff05_2)
   LET l_qty = 0
   FOR i = 1 TO p_tc_sff.getLength()
      IF p_tc_sff[i].tc_sff03_2  = p_tc_sff[p_ac].tc_sff03_2 AND p_tc_sff[i].tc_sff27_2  = p_tc_sff[p_ac].tc_sff27_2 THEN 
         LET l_qty = l_qty + p_tc_sff[i].tc_sff05_2
      END IF 
   END FOR
   IF l_qty > p_tc_sff[p_ac].tc_sfe03_2 THEN 
      CALL cl_err("发料数量大于可发数量","!",1)
      RETURN FALSE
   END IF 
   RETURN TRUE
END FUNCTION 

# 更新csfi510 发料明细
FUNCTION i510_2_tc_sff_update(p_tc_sff)
   DEFINE p_tc_sff DYNAMIC ARRAY OF type_tc_sff_2 
   DEFINE p_ac,i        LIKE type_file.num5 

   FOR i = 1 TO p_tc_sff.getLength() 
      IF p_tc_sff[i].tc_sff05_2 = 0 THEN 
         DELETE FROM tc_sff_file 
          WHERE tc_sff01 = g_tc_sfd.tc_sfd01 
            AND tc_sff02 = p_tc_sff[i].tc_sff02_2
         IF STATUS THEN
            CALL cl_err("delete tc_sff_file","!",1)
            ROLLBACK WORK
            RETURN FALSE
         END IF
      ELSE 
         UPDATE tc_sff_file SET tc_sff05 = p_tc_sff[i].tc_sff05_2
          WHERE tc_sff01 = g_tc_sfd.tc_sfd01 
            AND tc_sff02 = p_tc_sff[i].tc_sff02_2
         IF STATUS THEN
            CALL cl_err("UPDATE tc_sff_file","!",1)
            ROLLBACK WORK
            RETURN FALSE
         END IF
      END IF 
   END FOR

   RETURN TRUE 
END FUNCTION 
#add by darcy: 2022-03-14 14:59:21 e---  
