# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmt930.4gl
# Descriptions...: 装箱单維護作业
#                  # 由出貨通知單裝箱產品再將已裝箱的單據拋磚至出貨單
# Date & Author..: 11/09/20 By NO.FUN-B90103  xjll 
# Modify.........: No.TQC-C20500 12/02/27 By xjll   bug修改 转出货单后,装箱单单头资料清空
# Modify.........: No.TQC-C30114 12/03/07 By huangrh 非多屬性料件的判斷BUG和支持出通單的母料件重複
# Modify.........: No.FUN-C40059 12/04/18 By qiaozy  改善裝箱單，動態加載尺寸，支持條碼錄入
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:FUN-C60090 12/06/29 By qiaozy 增加已出貨單單號欄位
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:CHI-C80072 13/03/28 By chenjing 取消確認賦值確認異動人員
# Modify.........: No:FUN-D30034 13/04/16 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50116 13/05/27 By lixh1 報錯信息修改
# Modify.........: No:TQC-D50127 13/05/31 By lixh1 修正库位检查逻辑
# Modify.........: No:TQC-D50126 13/06/06 By lixh1 倉庫出錯跳到儲位欄位
# Modify.........: No:TQC-DB0073 13/11/27 By wangrr 在"轉出貨單"成功后提示語句不正確

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ogl           RECORD   #裝箱單單頭
                    ogl03    LIKE ogl_file.ogl03,
                    ogl01    LIKE ogl_file.ogl01,
                    oglconu  LIKE ogl_file.oglconu,
                    oglcond  LIKE ogl_file.oglcond,
                    oglconf  LIKE ogl_file.oglconf,
                    ogloriu  LIKE ogl_file.ogloriu,
                    oglcrat  LIKE ogl_file.oglcrat,
                    ogluser  LIKE ogl_file.ogluser,
                    oglgrup  LIKE ogl_file.oglgrup,
                    oglmodu  LIKE ogl_file.oglmodu,
                    ogldate  LIKE ogl_file.ogldate,
                    oglplant LIKE ogl_file.oglplant,
                    ogllegal LIKE ogl_file.ogllegal,
                    ogl08    LIKE ogl_file.ogl08     #FUN-C60090--ADD--
                    END RECORD,
    g_ogl_t         RECORD   #舊值
                    ogl03    LIKE ogl_file.ogl03,
                    ogl01    LIKE ogl_file.ogl01,
                    oglconu  LIKE ogl_file.oglconu,
                    oglcond  LIKE ogl_file.oglcond,
                    oglconf  LIKE ogl_file.oglconf,
                    ogloriu  LIKE ogl_file.ogloriu,
                    oglcrat  LIKE ogl_file.oglcrat,
                    ogluser  LIKE ogl_file.ogluser,
                    oglgrup  LIKE ogl_file.oglgrup,
                    oglmodu  LIKE ogl_file.oglmodu,
                    ogldate  LIKE ogl_file.ogldate,
                    oglplant LIKE ogl_file.oglplant,
                    ogllegal LIKE ogl_file.ogllegal,
                    ogl08    LIKE ogl_file.ogl08     #FUN-C60090--ADD--
                    END RECORD,
    g_tc_ogl        DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
                    ogl04      LIKE ogl_file.ogl04,
                    ogl02      LIKE ogl_file.ogl02,
                    ogl07      LIKE ogl_file.ogl07,
                    imx00      LIKE imx_file.imx00,
                    ima02      LIKE ima_file.ima02,
                    ogl09      LIKE ogl_file.ogl09,
                    color      LIKE imx_file.imx01,
                    imx01      LIKE type_file.num10,
                    imx02      LIKE type_file.num10,
                    imx03      LIKE type_file.num10,
                    imx04      LIKE type_file.num10,
                    imx05      LIKE type_file.num10,
                    imx06      LIKE type_file.num10,
                    imx07      LIKE type_file.num10,
                    imx08      LIKE type_file.num10,
                    imx09      LIKE type_file.num10,
                    imx10      LIKE type_file.num10,
                    imx11      LIKE type_file.num10,
                    imx12      LIKE type_file.num10,
                    imx13      LIKE type_file.num10,
                    imx14      LIKE type_file.num10,
                    imx15      LIKE type_file.num10,
#FUN-C40059-----ADD----STR-----
                    imx16      LIKE type_file.num10,
                    imx17      LIKE type_file.num10,
                    imx18      LIKE type_file.num10,
                    imx19      LIKE type_file.num10,
                    imx20      LIKE type_file.num10,
                    imx21      LIKE type_file.num10,
                    imx22      LIKE type_file.num10,
                    imx23      LIKE type_file.num10,
                    imx24      LIKE type_file.num10,
                    imx25      LIKE type_file.num10,
#FUN-C40059------ADD----END-----                    
                    ogl05      LIKE ogl_file.ogl05,
                    ogl06      LIKE ogl_file.ogl06
                    END RECORD,
    g_tc_ogl_t      RECORD                 #程式變數 (舊值)
                    ogl04      LIKE ogl_file.ogl04,
                    ogl02      LIKE ogl_file.ogl02,
                    ogl07      LIKE ogl_file.ogl07,
                    imx00      LIKE imx_file.imx00,
                    ima02      LIKE ima_file.ima02,
                    ogl09      LIKE ogl_file.ogl09,
                    color      LIKE imx_file.imx01,
                    imx01      LIKE type_file.num10,
                    imx02      LIKE type_file.num10,
                    imx03      LIKE type_file.num10,
                    imx04      LIKE type_file.num10,
                    imx05      LIKE type_file.num10,
                    imx06      LIKE type_file.num10,
                    imx07      LIKE type_file.num10,
                    imx08      LIKE type_file.num10,
                    imx09      LIKE type_file.num10,
                    imx10      LIKE type_file.num10,
                    imx11      LIKE type_file.num10,
                    imx12      LIKE type_file.num10,
                    imx13      LIKE type_file.num10,
                    imx14      LIKE type_file.num10,
                    imx15      LIKE type_file.num10,
#FUN-C40059-----ADD----STR-----
                    imx16      LIKE type_file.num10,
                    imx17      LIKE type_file.num10,
                    imx18      LIKE type_file.num10,
                    imx19      LIKE type_file.num10,
                    imx20      LIKE type_file.num10,
                    imx21      LIKE type_file.num10,
                    imx22      LIKE type_file.num10,
                    imx23      LIKE type_file.num10,
                    imx24      LIKE type_file.num10,
                    imx25      LIKE type_file.num10,
#FUN-C40059------ADD----END-----                     
                    ogl05      LIKE ogl_file.ogl05,
                    ogl06      LIKE ogl_file.ogl06
                    END RECORD,
    g_tc_ogl_o      RECORD                 #程式變數 (舊值)
                    ogl04      LIKE ogl_file.ogl04,
                    ogl02      LIKE ogl_file.ogl02,
                    ogl07      LIKE ogl_file.ogl07,
                    imx00      LIKE imx_file.imx00,
                    ima02      LIKE ima_file.ima02,
                    ogl09      LIKE ogl_file.ogl09,
                    color      LIKE imx_file.imx01,
                    imx01      LIKE type_file.num10,
                    imx02      LIKE type_file.num10,
                    imx03      LIKE type_file.num10,
                    imx04      LIKE type_file.num10,
                    imx05      LIKE type_file.num10,
                    imx06      LIKE type_file.num10,
                    imx07      LIKE type_file.num10,
                    imx08      LIKE type_file.num10,
                    imx09      LIKE type_file.num10,
                    imx10      LIKE type_file.num10,
                    imx11      LIKE type_file.num10,
                    imx12      LIKE type_file.num10,
                    imx13      LIKE type_file.num10,
                    imx14      LIKE type_file.num10,
                    imx15      LIKE type_file.num10,
#FUN-C40059-----ADD----STR-----
                    imx16      LIKE type_file.num10,
                    imx17      LIKE type_file.num10,
                    imx18      LIKE type_file.num10,
                    imx19      LIKE type_file.num10,
                    imx20      LIKE type_file.num10,
                    imx21      LIKE type_file.num10,
                    imx22      LIKE type_file.num10,
                    imx23      LIKE type_file.num10,
                    imx24      LIKE type_file.num10,
                    imx25      LIKE type_file.num10,
#FUN-C40059------ADD----END-----                     
                    ogl05      LIKE ogl_file.ogl05,
                    ogl06      LIKE ogl_file.ogl06
                    END RECORD,
    b_ogl           RECORD LIKE ogl_file.*,
    g_argv1         LIKE ogl_file.ogl03,
    g_rec_b         LIKE type_file.num5,    #單身筆數
    g_wc,g_sql      STRING,
    g_t1            LIKE oay_file.oayslip,
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  
DEFINE li_result             LIKE type_file.num5
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_msg                 LIKE type_file.chr1000 
DEFINE g_chr                 LIKE type_file.chr1    
DEFINE g_cnt                 LIKE type_file.num10   
DEFINE g_i                   LIKE type_file.num5   
DEFINE g_row_count           LIKE type_file.num10   
DEFINE g_curs_index          LIKE type_file.num10   
DEFINE g_jump                LIKE type_file.num10  
DEFINE g_no_ask              LIKE type_file.num5   
DEFINE g_before_input_done   LIKE type_file.num5    
DEFINE g_str                 STRING                 
DEFINE g_no2                 LIKE oga_file.oga01
DEFINE g_imd01               LIKE imd_file.imd01   #倉庫 
DEFINE g_ime02               LIKE ime_file.ime02   #儲位
DEFINE g_oga                 RECORD LIKE oga_file.*
DEFINE g_ogb                 RECORD LIKE ogb_file.*
DEFINE g_ogbslk              RECORD LIKE ogbslk_file.*
DEFINE g_ogbi                RECORD LIKE ogbi_file.*
DEFINE g_oglb                RECORD LIKE ogl_file.*
DEFINE g_buf                 LIKE type_file.chr2
DEFINE g_start               LIKE oga_file.oga01
#FUN-C40059---ADD---STR---
DEFINE g_imxtext             DYNAMIC ARRAY OF RECORD
            SIZE             LIKE type_file.chr50
                      
                             END RECORD
DEFINE g_n                   LIKE type_file.num5
#FUN-C40059---ADD---END----                      

MAIN
   OPTIONS
      INPUT NO WRAP,
      FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)    #FUN-C40059----ADD----
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   INITIALIZE g_ogl.* TO NULL                     #清除鍵值
   INITIALIZE g_ogl_t.* TO NULL
   
    OPEN WINDOW axmt930_w WITH FORM "axm/42f/axmt930"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
    CALL cl_set_comp_visible("imx09,imx10,imx11,imx12,imx13,imx14,imx15",FALSE)
#FUN-C40059----ADD---str---
    CALL cl_set_comp_visible("imx16,imx17,imx18,imx19,imx20,imx21,imx22,imx23,imx24,imx25, 
                              imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08",FALSE) 
    CALL cl_set_comp_required("ogl09",TRUE)                          
#FUN-C40059----ADD---end-----
    LET g_forupd_sql =  "SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,",
                        "       oglgrup,oglmodu,ogldate,oglplant,ogllegal,ogl08",
                        " FROM ogl_file WHERE ogl03 =? ",
                        " AND ogl01 = ? FOR UPDATE"
                        #FUN-C60090----ADD ogl08-----
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t930_cl CURSOR FROM g_forupd_sql
    CALL t930_menu()
    CLOSE WINDOW axmt930_w 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t930_cs()
    CLEAR FORM                             #清除畫面
    CALL g_tc_ogl.clear()
       INITIALIZE g_ogl.ogl03 TO NULL
       CALL cl_set_head_visible("","YES")
       CONSTRUCT g_wc ON ogl03,ogl01,oglconu,oga16,oga02,oglcond,oga18,oga04,  #螢幕上取條件
                         oglconf,ogluser,oglmodu,oglcrat,
                         oglgrup,ogldate,ogloriu,ogl08,
                         ogl04,ogl02,ogl07,
                         ogl09,ogl05,ogl06
                         #FUN-C60090----ADD ogl08----
            FROM ogl03,ogl01,oglconu,oga16,oga02,oglcond,oga18,oga04, 
                 oglconf,ogluser,oglmodu,oglcrat,
                 oglgrup,ogldate,ogloriu,ogl08,
                 s_ogl[1].ogl04,s_ogl[1].ogl02,s_ogl[1].ogl07,
                 s_ogl[1].ogl09,s_ogl[1].ogl05,s_ogl[1].ogl06
                 #FUN-C60090----ADD ogl08----

          BEFORE CONSTRUCT 
            CALL cl_qbe_init()

             ON ACTION CONTROLP 
              CASE
                WHEN INFIELD(ogl03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ogl003"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogl03
                   NEXT FIELD ogl03
                WHEN INFIELD(ogl01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ogl001"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogl01
                   NEXT FIELD ogl01
                WHEN INFIELD(oga16)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga16"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga16
                   NEXT FIELD oga16
               WHEN INFIELD(oga18)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga18"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga18
                   NEXT FIELD oga18
               WHEN INFIELD(oga04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga04_1"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO oga04
                   NEXT FIELD oga04
               #FUN-C60090----ADD-----STR---           
               WHEN INFIELD(ogl08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_ogl08"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ogl08
                   NEXT FIELD ogl08  
               #FUN-C60090-----ADD-------END----
                OTHERWISE EXIT CASE
             END CASE

          ON ACTION qbe_select
             CALL cl_qbe_select()

          ON ACTION qbe_save
             CALL cl_qbe_save()

          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT

          ON ACTION about
             CALL cl_about()

          ON ACTION help
             CALL cl_show_help()

          ON ACTION CONTROLG
             CALL cl_cmdask()

       END CONSTRUCT

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)
    IF INT_FLAG THEN RETURN END IF
       
    LET g_sql= "SELECT UNIQUE ogl03,ogl01",
               " FROM ogl_file,oga_file ",
               " WHERE ogl01=oga01 AND ", g_wc CLIPPED,
               " ORDER BY ogl03"
    PREPARE axmt930_prepare FROM g_sql   
    DECLARE axmt930_cs SCROLL CURSOR WITH HOLD FOR axmt930_prepare
    
    LET g_sql="SELECT COUNT(*) FROM (   ",
              "         SELECT DISTINCT ogl03,ogl01",
                        "  FROM ogl_file,oga_file",
                        "  WHERE oga01=ogl01 AND ",g_wc CLIPPED,
              " ) "
    PREPARE axmt930_precount FROM g_sql
    DECLARE axmt930_count CURSOR FOR axmt930_precount
END FUNCTION
 
FUNCTION t930_menu()

   WHILE TRUE
      CALL t930_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t930_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t930_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t930_b()  
            ELSE                         #FUN-D30034 Add
               LET g_action_choice = ""  #FUN-D30034 Add
            END IF
           #LET g_action_choice = ""     #FUN-D30034 Mark
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t930_out()
            END IF
         WHEN "reproduce"
              IF cl_chk_act_auth() THEN
                 CALL t930_copy()
              END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t930_r()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_ogl),'','')
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t930_yes()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t930_no()
            END IF
         WHEN "sub_m"
            IF cl_chk_act_auth() THEN
               CALL t930_c()
            END IF
         WHEN "bill_load"
            IF cl_chk_act_auth() THEN
               #FUN-C40059----ADD--STR----
               SELECT  COUNT(*) INTO g_n FROM ogl_file WHERE ogl03=g_ogl.ogl03 AND ogl08 IS NOT NULL
               IF g_n>0 THEN
                  CALL cl_err("","axm1155",0)
               ELSE
               #FUN-C40059--ADD--END----
                  CALL t930_bill()
               END IF #FUN-C40059--ADD-
            END IF
         WHEN "related_document"
            IF cl_chk_act_auth() THEN
                IF g_ogl.ogl03 IS NOT NULL THEN
                   LET g_doc.column1 = "ogl03"
                   LET g_doc.value1 = g_ogl.ogl03
                   CALL cl_doc()
                END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t930_a()

    MESSAGE ""
    CLEAR FORM
    CALL g_tc_ogl.clear()
    LET g_wc = NULL
    IF s_shut(0) THEN 
       RETURN 
    END IF

    INITIALIZE g_ogl.* TO NULL
    INITIALIZE g_ogl_t.* TO NULL

    LET g_ogl_t.*=g_ogl.*
    CALL cl_opmsg('a')
    WHILE TRUE
       LET g_ogl.oglconf='N'
       LET g_ogl.ogluser=g_user
       LET g_ogl.ogloriu=g_user
       LET g_ogl.oglgrup=g_grup
       LET g_ogl.oglcrat=g_today
       LET g_ogl.oglmodu=NULL 
       LET g_ogl.ogldate=NULL
       LET g_ogl.ogllegal=g_legal         #所屬法人
       LET g_ogl.oglplant=g_plant         #所屬工廠
       CALL t930_i("a")                   #輸入單頭
       IF INT_FLAG THEN        
          INITIALIZE g_ogl.* TO NULL 
          LET INT_FLAG = 0
          CLEAR FORM
          LET g_ogl.ogl03=NULL
          CALL cl_err('',9001,0)
          EXIT WHILE
       END IF

       IF cl_null(g_ogl.ogl03) OR cl_null(g_ogl.ogl01)  THEN
          CONTINUE WHILE 
       END IF

       BEGIN WORK
       LET g_rec_b = 0
       CALL t930_b()                   #輸入單身
       EXIT WHILE
    END WHILE

END FUNCTION

FUNCTION t930_i(p_cmd)
 DEFINE  p_cmd           LIKE type_file.chr1      
 DEFINE  l_n             LIKE type_file.num5
 DEFINE  l_ogaconf       LIKE oga_file.ogaconf  #FUN-C40059---ADD----
    IF s_shut(0) THEN
       RETURN
    END IF 
    DISPLAY BY NAME g_ogl.oglcond,g_ogl.oglconf,g_ogl.oglconu,
                    g_ogl.oglcrat,g_ogl.ogldate,g_ogl.oglgrup,
                    g_ogl.oglmodu,g_ogl.ogloriu,g_ogl.ogluser

    CALL cl_set_head_visible("","YES")
    INPUT BY NAME g_ogl.ogl03,g_ogl.ogl01 WITHOUT DEFAULTS

       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t930_set_entry(p_cmd)
          CALL t930_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ogl03") #FUN-C40059---ADD---

       AFTER FIELD ogl03
          IF NOT cl_null(g_ogl.ogl03) THEN
             LET g_t1=s_get_doc_no(g_ogl.ogl03)
             CALL s_check_no("axm",g_ogl.ogl03,g_ogl_t.ogl03,'64',"ogl_file","ogl03","")
                RETURNING li_result,g_ogl.ogl03
             DISPLAY BY NAME g_ogl.ogl03
             IF (NOT li_result) THEN
                LET g_ogl.ogl03=g_ogl_t.ogl03
                NEXT FIELD ogl03
             END IF
          END IF
      AFTER FIELD ogl01
         IF NOT cl_null(g_ogl.ogl01) THEN
            SELECT COUNT(*) INTO l_n FROM oga_file,occ_file
              WHERE oga01=g_ogl.ogl01
#            AND ogaconf='Y' AND oga04=occ01 AND oga09='1' #FUN-C40059---MARK ---
              AND oga04=occ01 AND oga09='1'                 #FUN-C40059--add---
            IF cl_null(l_n) OR l_n=0 THEN
               CALL cl_err('',"cxm-997",0)    #該通知單號不存在請重新錄入
               NEXT FIELD ogl01
            #FUN-C40059---ADD--STR-----
            ELSE
               SELECT ogaconf INTO l_ogaconf FROM oga_file WHERE oga01=g_ogl.ogl01
               IF l_ogaconf<>'Y' THEN
                  CALL cl_err('',"axm1157",0)
                  NEXT FIELD ogl01
               END IF     
            #FUN-C40059---ADD---END----
            END IF 
         END IF

       AFTER INPUT
          IF NOT cl_null(g_ogl.ogl01) THEN
             CALL t930_ogl01('d')
          END IF

       ON ACTION CONTROLF                  #欄位說明
          CALL cl_set_focus_form(ui.Interface.getRootNode())
             RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(ogl03)
                 LET g_t1=s_get_doc_no(g_ogl.ogl03)
                 CALL q_oay(FALSE,FALSE,g_t1,'64','AXM') RETURNING g_t1
                 LET g_ogl.ogl03 = g_t1 
                 DISPLAY BY NAME g_ogl.ogl03
                 NEXT FIELD ogl03
             WHEN INFIELD(ogl01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ogl01"
                  LET g_qryparam.default1 = g_ogl.ogl01
                  CALL cl_create_qry() RETURNING g_ogl.ogl01
                  DISPLAY BY NAME g_ogl.ogl01
                  NEXT FIELD ogl01
             OTHERWISE EXIT CASE
          END CASE

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT 

       ON ACTION about
          CALL cl_about()
        
       ON ACTION help
          CALL cl_show_help()

       ON ACTION CONTROLG
          CALL cl_cmdask()

    END INPUT
END FUNCTION

FUNCTION t930_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    DISPLAY '' TO FORMONLY.cnt
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_tc_ogl.clear()
    CALL t930_cs()          
      
    IF INT_FLAG THEN                   
        LET INT_FLAG = 0
        INITIALIZE g_ogl.* TO NULL
        RETURN
    END IF

    OPEN axmt930_cs                  
    IF SQLCA.sqlcode AND (g_argv1 IS NULL OR g_argv1=' ') THEN    
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_ogl.* TO NULL
    ELSE
       CALL t930_fetch('F')
       OPEN axmt930_count
       FETCH axmt930_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
FUNCTION t930_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1             
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     axmt930_cs INTO g_ogl.ogl03,g_ogl.ogl01
        WHEN 'P' FETCH PREVIOUS axmt930_cs INTO g_ogl.ogl03,g_ogl.ogl01 
        WHEN 'F' FETCH FIRST    axmt930_cs INTO g_ogl.ogl03,g_ogl.ogl01
        WHEN 'L' FETCH LAST     axmt930_cs INTO g_ogl.ogl03,g_ogl.ogl01
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0 
                PROMPT g_msg CLIPPED,': ' FOR g_jump

                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about        
                      CALL cl_about()     
 
                   ON ACTION help         
                      CALL cl_show_help()  
 
                   ON ACTION controlg    
                      CALL cl_cmdask()    

                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump axmt930_cs INTO g_ogl.*
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                   
        CALL cl_err(g_ogl.ogl03,SQLCA.sqlcode,0)
        INITIALIZE g_ogl.ogl03 TO NULL
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       DISPLAY g_curs_index TO FORMONLY.idx
    END IF
    SELECT DISTINCT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
        oglgrup,oglmodu,ogldate,oglplant,ogllegal,ogl08
      INTO g_ogl.* FROM ogl_file WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03
      #FUN-C60090--add ogl08
    IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ogl_file","","",SQLCA.sqlcode,"","",0)
      INITIALIZE g_ogl.* TO NULL
      RETURN   
   END IF      
   CALL t930_show() 
END FUNCTION
 
FUNCTION t930_show()

    LET g_ogl_t.* = g_ogl.*
    DISPLAY BY NAME g_ogl.ogl03,g_ogl.ogl01,g_ogl.oglconu,g_ogl.oglcond,
                    g_ogl.oglconf,g_ogl.ogloriu,g_ogl.oglcrat,g_ogl.ogluser,
                    g_ogl.oglgrup,g_ogl.oglmodu,g_ogl.ogldate,g_ogl.ogl08
                    #FUN-C60090---add  ogl08        

    CALL cl_set_field_pic(g_ogl.oglconf,"","","","","")    #圖形顯示
    CALL t930_ogl01('d')             #通知單帶出資料顯示
    CALL t930_b_fill(g_wc)             #單身
    CALL cl_show_fld_cont()        
END FUNCTION
 
FUNCTION t930_r()                                                               
 
    IF s_shut(0) THEN 
       RETURN 
    END IF

    IF cl_null(g_ogl.ogl03)  THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_ogl.oglconf='Y' THEN 
       CALL  cl_err('',9023,0)
       RETURN
    END IF

    BEGIN WORK

    OPEN t930_cl USING g_ogl.ogl03,g_ogl.ogl01   #鎖cursor
     IF STATUS THEN
        CALL cl_err("OPEN t930_cl:", STATUS, 1)
        CLOSE t930_cl
        ROLLBACK WORK
        RETURN
     END IF

    FETCH t930_cl INTO g_ogl.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ogl.ogl01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF

    CALL t930_show()

    IF cl_delh(0,0) THEN          
         DELETE FROM ogl_file WHERE ogl03=g_ogl.ogl03
         IF SQLCA.SQLCODE THEN
            ROLLBACK WORK
            RETURN
         END IF
         CLEAR FORM
         CALL g_tc_ogl.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'

         OPEN axmt930_count
          IF STATUS THEN
             CLOSE axmt930_cs
             CLOSE axmt930_count
             COMMIT WORK
             RETURN
          END IF

         FETCH axmt930_count INTO g_row_count
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE axmt930_cs
             CLOSE axmt930_count
             COMMIT WORK
             RETURN
          END IF
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN axmt930_cs
         IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t930_fetch('L')
         ELSE 
           LET g_jump = g_curs_index 
           LET g_no_ask = TRUE
           CALL t930_fetch('/')
         END IF
      END IF
   CLOSE t930_cl 
   COMMIT WORK 
   CALL cl_flow_notify(g_ogl.ogl03,'D') 
 
END FUNCTION
 
FUNCTION t930_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     
    l_n             LIKE type_file.num5,      
    l_lock_sw       LIKE type_file.chr1,     
    p_cmd           LIKE type_file.chr1,     
    l_allow_insert  LIKE type_file.num5,     
    l_allow_delete  LIKE type_file.num5    
DEFINE l_oglconf    LIKE ogl_file.oglconf
DEFINE l_imx RECORD LIKE imx_file.*,
       l_imx000     LIKE imx_file.imx000,
       l_cnt        LIKE type_file.num5,
       l_size       LIKE imx_file.imx02, 
       l_color      LIKE imx_file.imx01, 
       l_ima940     LIKE ima_file.ima940,
       l_ogb12      LIKE ogb_file.ogb12,
       l_imx02      LIKE imx_file.imx02,
       l_ima941     LIKE ima_file.ima941
DEFINE  l_ogb03      LIKE ogb_file.ogb03   #FUN-C40059---ADD--
DEFINE  l_sql        STRING                #FUN-C40059---ADD--
DEFINE  l_ima151    LIKE ima_file.ima151   #FUN-C40059---ADD--
DEFINE  l_imaag     LIKE ima_file.imaag    #FUN-C40059---ADD--
DEFINE  l_n1        LIKE type_file.num5    #FUN-C40059---ADD--
DEFINE  l_n2        LIKE type_file.num5    #FUN-C40059---ADD--
DEFINE  l_n3        LIKE type_file.num5    #FUN-C40059---ADD-- 
DEFINE  l_n4        LIKE type_file.num5    #FUN-C40059---ADD-- 
 
    LET g_action_choice = ""
   
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_ogl.ogl03 IS NULL OR g_ogl.ogl01 IS NULL THEN 
       RETURN
    END IF

    IF g_ogl.oglconf = 'Y' THEN
       CALL cl_err('','art-024',0)
       RETURN 
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ogl04,ogl02,ogl07,'','',ogl09,",
                       "'','','','','','','','','','','','','','','','','','','','','','','','','','',",
                       "ogl05,ogl06 FROM ogl_file ",
                       "WHERE ogl03 = ? AND ogl04=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE axmt930_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_tc_ogl WITHOUT DEFAULTS FROM s_ogl.* 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT"
#FUN-C40059-----ADD---STR----    
           CALL t930_settext_slk()
           CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
#FUN-C40059------ADD----END------ 
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            DISPLAY "BEFORE ROW!"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'   
            LET l_n  = ARR_COUNT()
            LET g_success='Y'
            LET l_imx000=NULL     #FUN-C40059--ADD----
            LET l_ima940=NULL     #FUN-C40059--ADD---- 
#FUN-C40059-----ADD---STR----
            CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
           CALL cl_set_comp_entry("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25,",FALSE)
#FUN-C40059------ADD----END------
            BEGIN WORK

            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_tc_ogl_t.* = g_tc_ogl[l_ac].* 
                OPEN axmt930_bcl USING g_ogl.ogl03,g_tc_ogl_t.ogl04
                IF STATUS THEN
                   CALL cl_err("OPEN axmt930_bcl:", STATUS, 1)
                   CLOSE axmt930_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH axmt930_bcl INTO g_tc_ogl[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_tc_ogl_t.ogl04,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET l_imx000=NULL     #FUN-C40059--ADD----
                       LET l_ima940=NULL     #FUN-C40059--ADD----
                       LET l_ima151=NULL     #FUN-C40059---ADD--
                       LET l_imaag=NULL      #FUN-C40059---ADD--
                       
                       SELECT ogbislk01 INTO g_tc_ogl[l_ac].imx00 FROM ogbi_file WHERE ogbi01=g_ogl.ogl01   #母料件编号
                          AND ogbi03=g_tc_ogl[l_ac].ogl02
                       SELECT ogb06,ogb04 INTO g_tc_ogl[l_ac].ima02,l_imx000     #品名和出貨數量和料件編號
                          FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[l_ac].ogl02
#FUN-C40059--ADD----str-----
                       SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=l_imx000
                       IF l_ima151='N' AND l_imaag='@CHILD' THEN
                          CALL cl_set_comp_entry("ogl05",FALSE)
                       ELSE
                          CALL cl_set_comp_entry("ogl05",TRUE)
                       END IF
                       
#FUN-C40059--ADD----end------                          
                       SELECT rta05 INTO g_tc_ogl[l_ac].ogl09 FROM rta_file WHERE rta01=l_imx000              #條形碼
                       SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx000        #顏色组
                       SELECT tqa02 INTO g_tc_ogl[l_ac].color FROM tqa_file WHERE tqa01=l_ima940 AND tqa03='25'
                       DISPLAY BY NAME g_tc_ogl[l_ac].imx00,g_tc_ogl[l_ac].ima02,g_tc_ogl[l_ac].ogl09, g_tc_ogl[l_ac].COLOR
#FUN-C40059-----MARK---BEGIN----                       
                       
#                      #獲取此料件顏色和尺寸
#                       SELECT ima941 INTO l_ima941 FROM ima_file WHERE ima01=g_tc_ogl[l_ac].imx00     #尺碼組
#                       SELECT imx02 INTO l_imx02 FROM imx_file WHERE imx00=g_tc_ogl[l_ac].imx00 AND #imx000=l_imx000
#                       SELECT agd03 INTO l_size FROM agd_file WHERE agd01=l_ima941 AND agd02=l_imx02#

#                       IF l_size='0' THEN
#                          LET g_tc_ogl[l_ac].imx01=g_tc_ogl[l_ac].ogl05
#                       END IF
#                       IF l_size>='35' AND l_size<='45' THEN
#                          LET l_cnt=0
#                          LET g_sql="SELECT * FROM imx_file WHERE imx00='",g_tc_ogl[l_ac].imx00,"'"
#                          PREPARE t930_imx_p1 FROM g_sql
#                          DECLARE t930_imx_c1 CURSOR FOR t930_imx_p1
#                          FOREACH t930_imx_c1 INTO l_imx.*
#                             LET l_cnt=l_cnt+1
#                             IF l_imx.imx000=l_imx000 THEN
#                                CASE l_cnt
#                                   WHEN 1     LET g_tc_ogl[l_ac].imx01=g_tc_ogl[l_ac].ogl05
#                                   WHEN 2     LET g_tc_ogl[l_ac].imx02=g_tc_ogl[l_ac].ogl05
#                                   WHEN 3     LET g_tc_ogl[l_ac].imx03=g_tc_ogl[l_ac].ogl05
#                                   WHEN 4     LET g_tc_ogl[l_ac].imx04=g_tc_ogl[l_ac].ogl05
#                                   WHEN 5     LET g_tc_ogl[l_ac].imx05=g_tc_ogl[l_ac].ogl05
#                                   WHEN 6     LET g_tc_ogl[l_ac].imx06=g_tc_ogl[l_ac].ogl05
#                                   WHEN 7     LET g_tc_ogl[l_ac].imx07=g_tc_ogl[l_ac].ogl05
#                                END CASE
#                                EXIT FOREACH
#                             END IF
#                          END FOREACH
#                       ELSE
#                          CASE l_size
#                             WHEN 'XS'    LET g_tc_ogl[l_ac].imx01=g_tc_ogl[l_ac].ogl05
#                             WHEN 'S'     LET g_tc_ogl[l_ac].imx02=g_tc_ogl[l_ac].ogl05
#                             WHEN 'M'     LET g_tc_ogl[l_ac].imx03=g_tc_ogl[l_ac].ogl05
#                             WHEN 'L'     LET g_tc_ogl[l_ac].imx04=g_tc_ogl[l_ac].ogl05
#                             WHEN 'XL'    LET g_tc_ogl[l_ac].imx05=g_tc_ogl[l_ac].ogl05
#                             WHEN 'XXL'   LET g_tc_ogl[l_ac].imx06=g_tc_ogl[l_ac].ogl05
#                             WHEN 'XXXL'  LET g_tc_ogl[l_ac].imx07=g_tc_ogl[l_ac].ogl05
#                          END CASE
#                       END IF
#FUN-C40059-----MARK----END-------
                       CALL t930_fillimx_slk(l_imx000,l_ac)    #FUN-C40059----ADD-----
                       
                       LET g_tc_ogl_t.*=g_tc_ogl[l_ac].*
                       LET g_tc_ogl_o.*=g_tc_ogl[l_ac].*
                   END IF
                END IF
                CALL cl_show_fld_cont()
                NEXT FIELD ogl02  #FUN-C40059----ADD----- 
            END IF
 
        AFTER INSERT
           DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           
           IF l_ac =1 THEN
              SELECT COUNT(ogl03) INTO l_n1 FROM ogl_file WHERE ogl03=g_ogl.ogl03  #FUN-C40059---ADD---
              IF cl_null(l_n1) or l_n1=0 THEN #FUN-C40059---ADD----
                 CALL s_auto_assign_no("axm",g_ogl.ogl03,g_today,"64","ogl_file","ogl03","","","") 
                 RETURNING li_result,g_ogl.ogl03
                 IF (NOT li_result) THEN
                    CANCEL INSERT 
                 END IF
                 DISPLAY BY NAME g_ogl.ogl03
              END IF                   #FUN-C40059---ADD----
           END IF 
           
           CALL t930_b_move()
           INSERT INTO ogl_file VALUES(b_ogl.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ogl_file",g_ogl.ogl03,g_tc_ogl[l_ac].ogl04,
                            SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE INSERT
            DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_tc_ogl[l_ac].* TO NULL      
            LET g_tc_ogl_t.* = g_tc_ogl[l_ac].*       
            LET g_tc_ogl_o.* = g_tc_ogl[l_ac].*       
            CALL cl_show_fld_cont()   
#FUN-C40059---ADD----END-------
            CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
            CALL cl_set_comp_entry("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25,",FALSE)
#FUN-C40059---ADD----STR-----
            NEXT FIELD ogl04


        BEFORE FIELD ogl04                    #default 項次
            IF g_tc_ogl[l_ac].ogl04 IS NULL OR g_tc_ogl[l_ac].ogl04 = 0 THEN
                SELECT max(ogl04)+1 INTO g_tc_ogl[l_ac].ogl04
                  FROM ogl_file
                 WHERE ogl03 = g_ogl.ogl03
                IF g_tc_ogl[l_ac].ogl04 IS NULL THEN
                   LET g_tc_ogl[l_ac].ogl04 = 1
                END IF
            END IF
 
        AFTER FIELD ogl04                     #check 序號是否重複
            IF g_tc_ogl[l_ac].ogl04 IS NOT NULL THEN
               IF (g_tc_ogl[l_ac].ogl04 != g_tc_ogl_t.ogl04 OR
                   g_tc_ogl_t.ogl04 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM ogl_file
                   WHERE ogl03 = g_ogl.ogl03
                     AND ogl04 = g_tc_ogl[l_ac].ogl04
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_tc_ogl[l_ac].ogl04 = g_tc_ogl_t.ogl04
                     NEXT FIELD ogl04
                  END IF
               END IF
            END IF

        AFTER FIELD ogl02
            IF NOT cl_null(g_tc_ogl[l_ac].ogl02) THEN    #FUN-C40059--ADD--
               SELECT COUNT(*) INTO l_n FROM ogb_file where ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[l_ac].ogl02
               IF cl_null(l_n) OR l_n=0 THEN
                  CALL cl_err('',"cxm-995",0)
                  NEXT FIELD ogl02
               END IF
               LET g_tc_ogl[l_ac].imx00=NULL
               LET g_tc_ogl[l_ac].ima02=NULL
               LET g_tc_ogl[l_ac].ogl09=NULL
               LET g_tc_ogl[l_ac].color=NULL
            END IF   #FUN-C40059--ADD--
#FUN-C40059--ADD--str-----
            IF p_cmd='a' OR (g_tc_ogl[l_ac].ogl02<>g_tc_ogl_t.ogl02 AND p_cmd='u') THEN
               CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
               CALL cl_set_comp_entry("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25,",FALSE)
               LET g_tc_ogl_t.ogl02=g_tc_ogl[l_ac].ogl02
               LET g_tc_ogl[l_ac].ogl09=null
               CALL t930_null(l_ac)
            END IF  
#FUN-C40059--ADD--end-------
#            IF cl_null(g_tc_ogl[l_ac].ogl05)  AND p_cmd='a' THEN #FUN-C40059--mark-----
           IF cl_null(g_tc_ogl[l_ac].ogl05) THEN
              SELECT ogb12 INTO g_tc_ogl[l_ac].ogl05 FROM ogb_file
              WHERE ogb03=g_tc_ogl[l_ac].ogl02 AND ogb01=g_ogl.ogl01
            END IF 
            LET l_imx000=NULL    #FUN-C40059--ADD----
            LET l_ima940=NULL     #FUN-C40059--ADD----
            LET l_ima151=NULL    #FUN-C40059--ADD----
            LET l_imaag=NULL     #FUN-C40059--ADD----
            SELECT ogbislk01 INTO g_tc_ogl[l_ac].imx00 FROM ogbi_file WHERE ogbi01=g_ogl.ogl01   #母料件编号
               AND ogbi03=g_tc_ogl[l_ac].ogl02

            SELECT ogb06,ogb12,ogb04 INTO g_tc_ogl[l_ac].ima02,l_ogb12,l_imx000     #品名和出貨數量和料件編號
              FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[l_ac].ogl02 
#FUN-C40059--ADD----str-----
            SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=l_imx000
            IF l_ima151='N' AND l_imaag='@CHILD' THEN
               CALL cl_set_comp_entry("ogl05",FALSE)
            ELSE
               CALL cl_set_comp_entry("ogl05",TRUE)
            END IF
                       
#FUN-C40059--ADD----end------             
            SELECT rta05 INTO g_tc_ogl[l_ac].ogl09 FROM rta_file WHERE rta01=l_imx000              #條形碼
            SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx000        #顏色组

            SELECT tqa02 INTO g_tc_ogl[l_ac].color FROM tqa_file WHERE tqa01=l_ima940 AND tqa03='25'
            DISPLAY BY NAME g_tc_ogl[l_ac].imx00,g_tc_ogl[l_ac].ima02,g_tc_ogl[l_ac].ogl09, g_tc_ogl[l_ac].color,g_tc_ogl[l_ac].ogl05
#FUN-C40059-----MARK-------BEGIN------
#            #獲取此料件顏色和尺寸
#              SELECT ima941 INTO l_ima941 FROM ima_file WHERE ima01=g_tc_ogl[l_ac].imx00     #尺碼組
#              SELECT imx02 INTO l_imx02 FROM imx_file WHERE imx00=g_tc_ogl[l_ac].imx00 AND imx000=l_imx000
#              SELECT agd03 INTO l_size FROM agd_file WHERE agd01=l_ima941 AND agd02=l_imx02
#                     IF l_size='0' THEN
#                        LET g_tc_ogl[l_ac].imx01=g_tc_ogl[l_ac].ogl05
#                     END IF
#                     IF l_size>='35' AND l_size<='45' THEN
#                        LET l_cnt=0
#                        LET g_sql="SELECT * FROM imx_file WHERE imx00='",g_tc_ogl[l_ac].imx00,"'"
#                        PREPARE t930_imx_p2 FROM g_sql
#                        DECLARE t930_imx_c2 CURSOR FOR t930_imx_p2
#                        FOREACH t930_imx_c2 INTO l_imx.*
#                           LET l_cnt=l_cnt+1
#                           IF l_imx.imx000=l_imx000 THEN
#                              CASE l_cnt
#                                   WHEN 1     LET g_tc_ogl[l_ac].imx01=l_ogb12
#                                   WHEN 2     LET g_tc_ogl[l_ac].imx02=l_ogb12
#                                   WHEN 3     LET g_tc_ogl[l_ac].imx03=l_ogb12
#                                   WHEN 4     LET g_tc_ogl[l_ac].imx04=l_ogb12
#                                   WHEN 5     LET g_tc_ogl[l_ac].imx05=l_ogb12
#                                   WHEN 6     LET g_tc_ogl[l_ac].imx06=l_ogb12
#                                   WHEN 7     LET g_tc_ogl[l_ac].imx07=l_ogb12
#                                END CASE
#                              EXIT FOREACH
#                           END IF
#                        END FOREACH
#                     ELSE
#                          CASE l_size
#                             WHEN 'XS'    LET g_tc_ogl[l_ac].imx01=l_ogb12
#                             WHEN 'S'     LET g_tc_ogl[l_ac].imx02=l_ogb12
#                             WHEN 'M'     LET g_tc_ogl[l_ac].imx03=l_ogb12
#                             WHEN 'L'     LET g_tc_ogl[l_ac].imx04=l_ogb12
#                             WHEN 'XL'    LET g_tc_ogl[l_ac].imx05=l_ogb12
#                             WHEN 'XXL'   LET g_tc_ogl[l_ac].imx06=l_ogb12
#                             WHEN 'XXXL'  LET g_tc_ogl[l_ac].imx07=l_ogb12
#                          END CASE
#                     END IF 
#FUN-C40059-----MARK-----END-----
             CALL t930_fillimx_slk(l_imx000,l_ac)  #FUN-C40059----ADD---
             
             DISPLAY BY NAME g_tc_ogl[l_ac].imx01,g_tc_ogl[l_ac].imx02,g_tc_ogl[l_ac].imx03,
                             g_tc_ogl[l_ac].imx04,g_tc_ogl[l_ac].imx05,g_tc_ogl[l_ac].imx06,
                             g_tc_ogl[l_ac].imx07
#FUN-C40059-----ADD-----STR-----
                             ,g_tc_ogl[l_ac].imx08,g_tc_ogl[l_ac].imx09,g_tc_ogl[l_ac].imx10,
                             g_tc_ogl[l_ac].imx11,g_tc_ogl[l_ac].imx12,g_tc_ogl[l_ac].imx13,
                             g_tc_ogl[l_ac].imx14,g_tc_ogl[l_ac].imx15,g_tc_ogl[l_ac].imx16,
                             g_tc_ogl[l_ac].imx17,g_tc_ogl[l_ac].imx18,g_tc_ogl[l_ac].imx19,
                             g_tc_ogl[l_ac].imx20,g_tc_ogl[l_ac].imx21,g_tc_ogl[l_ac].imx22,
                             g_tc_ogl[l_ac].imx23,g_tc_ogl[l_ac].imx24,g_tc_ogl[l_ac].imx25
                             
#FUN-C40059-----ADD-----END-----                             

#FUN-C40059-----ADD-----STR-----
        AFTER FIELD ogl09
           IF NOT cl_null(g_tc_ogl[l_ac].ogl09) THEN
              SELECT count(*) INTO l_n2 FROM rta_file WHERE rta05=g_tc_ogl[l_ac].ogl09
              IF l_n2=0 OR cl_null(l_n2) THEN
                 CALL cl_err("","axm1159",0)
                 NEXT FIELD ogl09
              END IF
              SELECT rta01 INTO l_imx000 FROM rta_file WHERE rta05=g_tc_ogl[l_ac].ogl09 AND rtaacti='Y'
              SELECT count(*) INTO l_n3 FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb04=l_imx000
              IF l_n3=0 OR cl_null(l_n3) THEN
                 CALL cl_err("","axm1160",0)
                 NEXT FIELD ogl09
              END IF   
              LET l_sql=" SELECT ogb03 FROM ogb_file WHERE ogb01='",g_ogl.ogl01,"'",
                        "    AND ogb04='",l_imx000,"'",
                        "   ORDER BY ogb03"
              PREPARE t930_imx_pre FROM l_sql
              DECLARE t930_imx_cs CURSOR FOR t930_imx_pre
              FOREACH t930_imx_cs INTO l_ogb03
                 IF p_cmd='a' OR (g_tc_ogl[l_ac].ogl09<>g_tc_ogl_t.ogl09 AND p_cmd='u') THEN
                 SELECT COUNT(*) INTO l_n FROM ogl_file WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03
                    AND ogl02=l_ogb03
                 END IF    
                 IF cl_null(l_n) OR l_n=0 THEN
                    LET g_tc_ogl[l_ac].ogl02=l_ogb03
                    EXIT FOREACH
                 ELSE
                       
                    CONTINUE FOREACH
                 END IF
              END FOREACH
 #             IF p_cmd='a' OR (g_tc_ogl[l_ac].ogl09<>g_tc_ogl_t.ogl09 AND p_cmd='u') THEN
              IF p_cmd='a' OR (p_cmd='u') THEN
                 CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
                 CALL cl_set_comp_entry("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25,",FALSE)
#                 LET g_tc_ogl_t.ogl09=g_tc_ogl[l_ac].ogl09
                 
                 CALL t930_null(l_ac)
                 IF NOT cl_null(g_tc_ogl[l_ac].ogl02) THEN
                    SELECT count(*) INTO l_n4 FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[l_ac].ogl02
                       AND ogb04=l_imx000
                    IF l_n4=0 OR cl_null(l_n4) THEN
                       CALL cl_err("","axm1161",0)
                       NEXT FIELD ogl09
                    END IF 
                 END IF    
              END IF 
#              IF cl_null(g_tc_ogl[l_ac].ogl05)  AND p_cmd='a' THEN
              IF cl_null(g_tc_ogl[l_ac].ogl05) THEN
                 SELECT ogb12 INTO g_tc_ogl[l_ac].ogl05 FROM ogb_file
                  WHERE ogb03=g_tc_ogl[l_ac].ogl02 AND ogb01=g_ogl.ogl01
              END IF
              LET l_imx000=NULL
              LET l_ima940=NULL
              LET l_ima151=NULL
              LET l_imaag=NULL
              SELECT ogbislk01 INTO g_tc_ogl[l_ac].imx00 FROM ogbi_file WHERE ogbi01=g_ogl.ogl01   #母料件编号
                 AND ogbi03=g_tc_ogl[l_ac].ogl02

              SELECT ogb06,ogb12,ogb04 INTO g_tc_ogl[l_ac].ima02,l_ogb12,l_imx000     #品名和出貨數量和料件編號
                FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[l_ac].ogl02

              SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=l_imx000
              IF l_ima151='N' AND l_imaag='@CHILD' THEN
                 CALL cl_set_comp_entry("ogl05",FALSE)
              ELSE
                 CALL cl_set_comp_entry("ogl05",TRUE)
              END IF
                       
              SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx000        #顏色组

              SELECT tqa02 INTO g_tc_ogl[l_ac].color FROM tqa_file WHERE tqa01=l_ima940 AND tqa03='25'
              DISPLAY BY NAME g_tc_ogl[l_ac].imx00,g_tc_ogl[l_ac].ima02,g_tc_ogl[l_ac].ogl02, g_tc_ogl[l_ac].color,g_tc_ogl[l_ac].ogl05 
              CALL t930_fillimx_slk(l_imx000,l_ac)
           
           END IF   
 
        AFTER FIELD imx01
           IF NOT cl_null(g_tc_ogl[l_ac].imx01)  THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx01>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx01
              END IF 
              IF g_tc_ogl[l_ac].imx01<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx01
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx01
              DISPLAY BY NAME  g_tc_ogl[l_ac].imx01,g_tc_ogl[l_ac].ogl05
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx01) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx01
           END IF  
           
            
        AFTER FIELD imx02
           IF NOT cl_null(g_tc_ogl[l_ac].imx02)  THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx02>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx02
              END IF 
              IF g_tc_ogl[l_ac].imx02<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx02
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx02
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx02
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx02) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx02
           END IF   
          
            
        AFTER FIELD imx03
           IF NOT cl_null(g_tc_ogl[l_ac].imx03)  THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx03>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx03
              END IF 
              IF g_tc_ogl[l_ac].imx03<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx03
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx03
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx03
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx03) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx03
           END IF 
        AFTER FIELD imx04
           IF NOT cl_null(g_tc_ogl[l_ac].imx04)  THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx04>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx04
              END IF 
              IF g_tc_ogl[l_ac].imx04<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx04
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx04
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx04
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx04) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx04
           END IF  
           
        AFTER FIELD imx05
           IF NOT cl_null(g_tc_ogl[l_ac].imx05)  THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx05>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx05
              END IF 
              IF g_tc_ogl[l_ac].imx05<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx05
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx05
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx05
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx05) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx05
           END IF

        AFTER FIELD imx06
           IF NOT cl_null(g_tc_ogl[l_ac].imx06) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx06>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx06
              END IF 
              IF g_tc_ogl[l_ac].imx06<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx06
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx06
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx06
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx06) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx06
           END IF
        AFTER FIELD imx07
           IF NOT cl_null(g_tc_ogl[l_ac].imx07) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx07>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx07
              END IF 
              IF g_tc_ogl[l_ac].imx07<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx07
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx07
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx07
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx07) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx07
           END IF
        AFTER FIELD imx08
           IF NOT cl_null(g_tc_ogl[l_ac].imx08) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx08>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx08
              END IF 
              IF g_tc_ogl[l_ac].imx08<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx08
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx08
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx08
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx08) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx08
           END IF
        AFTER FIELD imx09
           IF NOT cl_null(g_tc_ogl[l_ac].imx09) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx09>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx09
              END IF 
              IF g_tc_ogl[l_ac].imx09<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx09
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx09
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx09
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx09) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx09
           END IF
        AFTER FIELD imx10
           IF NOT cl_null(g_tc_ogl[l_ac].imx10) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx10>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx10
              END IF 
              IF g_tc_ogl[l_ac].imx10<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx10
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx10
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx10
           END IF 
           IF cl_null(g_tc_ogl[l_ac].imx10) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx10
           END IF        
        AFTER FIELD imx11
           IF NOT cl_null(g_tc_ogl[l_ac].imx11) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx11>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx11
              END IF 
              IF g_tc_ogl[l_ac].imx11<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx11
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx11
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx11
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx11) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx11
           END IF
        AFTER FIELD imx12
           IF NOT cl_null(g_tc_ogl[l_ac].imx12) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx12>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx12
              END IF 
              IF g_tc_ogl[l_ac].imx12<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx12
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx12
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx12
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx12) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx12
           END IF
        AFTER FIELD imx13
           IF NOT cl_null(g_tc_ogl[l_ac].imx13) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx13>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx13
              END IF 
              IF g_tc_ogl[l_ac].imx13<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx13
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx13
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx13
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx13) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx13
           END IF
        AFTER FIELD imx14
           IF NOT cl_null(g_tc_ogl[l_ac].imx14) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx14>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx14
              END IF 
              IF g_tc_ogl[l_ac].imx14<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx14
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx14
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx14
           END IF 
           IF cl_null(g_tc_ogl[l_ac].imx14) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx14
           END IF
        AFTER FIELD imx15
           IF NOT cl_null(g_tc_ogl[l_ac].imx15) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx15>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx15
              END IF 
              IF g_tc_ogl[l_ac].imx15<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx15
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx15
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx15
           END IF 
           IF cl_null(g_tc_ogl[l_ac].imx15) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx15
           END IF 
        AFTER FIELD imx16
           IF NOT cl_null(g_tc_ogl[l_ac].imx16) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx16>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx16
              END IF 
              IF g_tc_ogl[l_ac].imx16<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx16
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx16
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx16
           END IF  
           IF cl_null(g_tc_ogl[l_ac].imx16) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx16
           END IF
        AFTER FIELD imx17
           IF NOT cl_null(g_tc_ogl[l_ac].imx17) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx17>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx17
              END IF 
              IF g_tc_ogl[l_ac].imx17<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx17
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx17
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx17
           END IF  
           IF cl_null(g_tc_ogl[l_ac].imx17) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx17
           END IF  
        AFTER FIELD imx18
           IF NOT cl_null(g_tc_ogl[l_ac].imx18) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx18>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx18
              END IF 
              IF g_tc_ogl[l_ac].imx18<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx18
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx18
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx18
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx18) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx18
           END IF 
        AFTER FIELD imx19
           IF NOT cl_null(g_tc_ogl[l_ac].imx19) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx19>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx19
              END IF 
              IF g_tc_ogl[l_ac].imx19<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx19
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx19
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx19
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx19) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx19
           END IF
        AFTER FIELD imx20
           IF NOT cl_null(g_tc_ogl[l_ac].imx20) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx20>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx20
              END IF 
              IF g_tc_ogl[l_ac].imx20<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx20
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx20
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx20
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx20) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx20
           END IF
        AFTER FIELD imx21
           IF NOT cl_null(g_tc_ogl[l_ac].imx21) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx21>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx21
              END IF 
              IF g_tc_ogl[l_ac].imx03<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx21
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx21
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx21
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx21) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx21
           END IF
        AFTER FIELD imx22
           IF NOT cl_null(g_tc_ogl[l_ac].imx22) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx22>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx22
              END IF 
              IF g_tc_ogl[l_ac].imx22<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx22
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx22
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx22
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx22) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx22
           END IF
        AFTER FIELD imx23
           IF NOT cl_null(g_tc_ogl[l_ac].imx23) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx23>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx23
              END IF 
              IF g_tc_ogl[l_ac].imx23<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx23
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx23
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx23
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx23) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx23
           END IF 
        AFTER FIELD imx24
           IF NOT cl_null(g_tc_ogl[l_ac].imx24) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx24>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx24
              END IF 
              IF g_tc_ogl[l_ac].imx24<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx24
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx24
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx24
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx24) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx24
           END IF
        AFTER FIELD imx25
           IF NOT cl_null(g_tc_ogl[l_ac].imx25) THEN
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].imx25>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD imx25
              END IF 
              IF g_tc_ogl[l_ac].imx25<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD imx25
              END IF
             
              LET g_tc_ogl[l_ac].ogl05= g_tc_ogl[l_ac].imx25
              DISPLAY BY NAME  g_tc_ogl[l_ac].ogl05,g_tc_ogl[l_ac].imx25
           END IF
           IF cl_null(g_tc_ogl[l_ac].imx25) THEN
              CALL cl_err("","axm1146",0)
              NEXT FIELD imx25
           END IF       
                
#FUN-C40059-----ADD-----END-----
                             
        AFTER FIELD ogl05 
           IF NOT cl_null(g_tc_ogl[l_ac].ogl02) THEN     #FUN-C40059-----ADD--
              SELECT ogb12 INTO l_ogb12 FROM ogb_file 
               WHERE ogb03=g_tc_ogl[l_ac].ogl02
                 AND ogb01=g_ogl.ogl01   
              IF g_tc_ogl[l_ac].ogl05>l_ogb12 THEN
                 CALL cl_err("", "cxm-999", 0)    #錄入的數量不可以大於出貨通知單中項次的數量
                 NEXT FIELD ogl05
              END IF 
              IF g_tc_ogl[l_ac].ogl05<=0 THEN
                 CALL cl_err("","axm-336",0)
                 NEXT FIELD ogl05
              END IF
#FUN-C40059-----ADD----STR---
              IF cl_null(g_tc_ogl[l_ac].ogl05) THEN
                 CALL cl_err("","axm1146",0)
                 NEXT FIELD ogl05
              END IF 
           END IF    
#FUN-C40059-----ADD----END-------
          
             
        BEFORE DELETE                            #是否取消單身
            DISPLAY "BEFORE DELETE"
            IF g_tc_ogl_t.ogl04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM ogl_file
                 WHERE ogl03 = g_ogl.ogl03
                   AND ogl04 = g_tc_ogl_t.ogl04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","ogl_file",g_ogl.ogl03,g_tc_ogl_t.ogl04,
                                 SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_ogl[l_ac].* = g_tc_ogl_t.*
               CLOSE axmt930_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_ogl_t.ogl04,-263,1)
               LET g_tc_ogl[l_ac].* = g_tc_ogl_t.*
            ELSE
                CALL t930_b_move()
                UPDATE ogl_file SET *=b_ogl.*
                 WHERE ogl03 = g_ogl.ogl03 AND ogl04=g_tc_ogl_t.ogl04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ogl_file",g_ogl.ogl03,g_tc_ogl_t.ogl04,
                                 SQLCA.sqlcode,"","",1)
                    LET g_tc_ogl[l_ac].* = g_tc_ogl_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            DISPLAY "AFTER ROW!"
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_tc_ogl[l_ac].* = g_tc_ogl_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_tc_ogl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE axmt930_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D30034 Add
            CLOSE axmt930_bcl
            COMMIT WORK

        ON ACTION CONTROLO                 
            IF INFIELD(ogl04) AND l_ac > 1 THEN
                LET g_tc_ogl[l_ac].* = g_tc_ogl[l_ac-1].*
                DISPLAY g_tc_ogl[l_ac].* TO s_ogl[l_ac].*
                NEXT FIELD ogl04
            END IF

        ON ACTION CONTROLP
           IF INFIELD(ogl02) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ogl02"
               LET g_qryparam.arg1 = g_ogl.ogl01
               CALL cl_create_qry() RETURNING g_tc_ogl[l_ac].ogl02
               DISPLAY BY NAME g_tc_ogl[l_ac].ogl02
               NEXT FIELD ogl02
           END IF

        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about        
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")

#       ON ACTION browse_txt
#          CALL t930_browse()
#          EXIT INPUT  

    END INPUT
    IF p_cmd= 'u' THEN 
       LET g_ogl.oglmodu=g_user
       LET g_ogl.ogldate=g_today
       UPDATE ogl_file SET oglmodu=g_ogl.oglmodu,ogldate=g_ogl.ogldate
          WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03

       DISPLAY BY NAME g_ogl.oglmodu,g_ogl.ogldate
     END IF
    CLOSE axmt930_bcl
    IF g_success = 'N' THEN
       ROLLBACK WORK
       CALL s_showmsg()
        
    ELSE
       COMMIT WORK
      #FUN-D30034----mark&add----str
      #CALL t930_b_fill("1=1 ")
       IF g_action_choice = "detail" THEN
          RETURN
       ELSE
          CALL t930_b_fill("1=1 ")
       END IF
      #FUN-D30034----mark&add----end
    END IF
END FUNCTION

FUNCTION t930_b_fill(p_wc)       
DEFINE
    p_wc            LIKE type_file.chr1000,
    l_imx000        LIKE imx_file.imx000,
    l_imx    RECORD LIKE imx_file.*,
    l_cnt           LIKE type_file.num5,
    l_sum           LIKE ogl_file.ogl05,
    l_ima940        LIKE ima_file.ima940,
    l_ima941        LIKE ima_file.ima941,
    l_size          LIKE imx_file.imx02,
    l_color         LIKE imx_file.imx01, 
    l_imx02         LIKE imx_file.imx02

    LET g_sql =
       "SELECT ogl04,ogl02,ogl07,'','',ogl09,",
       "'','','','','','','','','','','','','','','','','','','','','','','','','','',ogl05,ogl06",
       " FROM ogl_file,oga_file ",
       " WHERE ogl03 = '",g_ogl.ogl03,"' AND ogl01='",g_ogl.ogl01,"'",
       " AND oga01=ogl01",
       " AND ",p_wc CLIPPED ,
       " ORDER BY ogl04 "
    PREPARE axmt930_prepare2 FROM g_sql      
    DECLARE ogl_curs CURSOR FOR axmt930_prepare2
    CALL g_tc_ogl.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
#FUN-C40059-----ADD---STR----    
    CALL t930_settext_slk()
    CALL cl_set_comp_visible("imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10,
                              imx11,imx12,imx13,imx14,imx15,imx16,imx17,imx18,imx19,imx20
                              ,imx21,imx22,imx23,imx24,imx25",FALSE)
#FUN-C40059------ADD----END------                              
    FOREACH ogl_curs INTO g_tc_ogl[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       SELECT ogbislk01 INTO g_tc_ogl[g_cnt].imx00 FROM ogbi_file WHERE ogbi01=g_ogl.ogl01   #母料件编号
          AND ogbi03=g_tc_ogl[g_cnt].ogl02
       SELECT ogb06,ogb04 INTO g_tc_ogl[g_cnt].ima02,l_imx000     #品名和子料件编号
         FROM ogb_file WHERE ogb01=g_ogl.ogl01 AND ogb03=g_tc_ogl[g_cnt].ogl02
       SELECT rta05 INTO g_tc_ogl[g_cnt].ogl09 FROM rta_file WHERE rta01=l_imx000  #條形碼 
       SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx000        #顏色组
       SELECT tqa02 INTO g_tc_ogl[g_cnt].color FROM tqa_file WHERE tqa01=l_ima940 AND tqa03='25'  #颜色
#FUN-C40059-----MARK-----BEGIN------       
#       SELECT ima941 INTO l_ima941 FROM ima_file WHERE ima01=g_tc_ogl[g_cnt].imx00     #尺碼組
#       SELECT imx02 INTO l_imx02 FROM imx_file WHERE imx00=g_tc_ogl[g_cnt].imx00 
#        AND imx000=l_imx000
#       SELECT agd03 INTO l_size FROM agd_file WHERE agd01=l_ima941 AND agd02=l_imx02   #尺码
#       IF l_size>='35' AND l_size<='45' THEN
#          LET l_cnt=0
#          LET g_sql="SELECT * FROM imx_file WHERE imx00='",g_tc_ogl[g_cnt].imx00,"'"
#          PREPARE t930_imx_p FROM g_sql
#          DECLARE t930_imx_c CURSOR FOR t930_imx_p
#          FOREACH t930_imx_c INTO l_imx.*
#             LET l_cnt=l_cnt+1
#             IF l_imx.imx000=l_imx000 THEN
#                CASE l_cnt
#                   WHEN 1     LET g_tc_ogl[g_cnt].imx01=g_tc_ogl[g_cnt].ogl05
#                   WHEN 2     LET g_tc_ogl[g_cnt].imx02=g_tc_ogl[g_cnt].ogl05
#                   WHEN 3     LET g_tc_ogl[g_cnt].imx03=g_tc_ogl[g_cnt].ogl05
#                   WHEN 4     LET g_tc_ogl[g_cnt].imx04=g_tc_ogl[g_cnt].ogl05
#                   WHEN 5     LET g_tc_ogl[g_cnt].imx05=g_tc_ogl[g_cnt].ogl05
#                   WHEN 6     LET g_tc_ogl[g_cnt].imx06=g_tc_ogl[g_cnt].ogl05
#                   WHEN 7     LET g_tc_ogl[g_cnt].imx07=g_tc_ogl[g_cnt].ogl05
#                END CASE
#                EXIT FOREACH
#             END IF
#          END FOREACH
#       ELSE
#          CASE l_size
#             WHEN 'XS'    LET g_tc_ogl[g_cnt].imx01=g_tc_ogl[g_cnt].ogl05
#             WHEN 'S'     LET g_tc_ogl[g_cnt].imx02=g_tc_ogl[g_cnt].ogl05
#             WHEN 'M'     LET g_tc_ogl[g_cnt].imx03=g_tc_ogl[g_cnt].ogl05
#             WHEN 'L'     LET g_tc_ogl[g_cnt].imx04=g_tc_ogl[g_cnt].ogl05
#             WHEN 'XL'    LET g_tc_ogl[g_cnt].imx05=g_tc_ogl[g_cnt].ogl05
#             WHEN 'XXL'   LET g_tc_ogl[g_cnt].imx06=g_tc_ogl[g_cnt].ogl05
#             WHEN 'XXXL'  LET g_tc_ogl[g_cnt].imx07=g_tc_ogl[g_cnt].ogl05
#             WHEN 'XXXXL' LET g_tc_ogl[g_cnt].imx08=g_tc_ogl[g_cnt].ogl05 
#          END CASE
#       END IF
#FUN-C40059-----MARK----END--------
       CALL t930_fillimx_slk(l_imx000,g_cnt) #FUN-C40059--ADD---- 
       
       LET g_cnt = g_cnt + 1

       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_tc_ogl.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

    SELECT SUM(ogl05) INTO l_sum FROM ogl_file
     WHERE ogl03=g_ogl.ogl03
    IF CL_NULL(l_sum) THEN LET l_sum=0 END IF
    DISPLAY l_sum TO FORMONLY.sum
 
END FUNCTION

FUNCTION t930_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_ogl TO s_ogl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()    
      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      ON ACTION first
         CALL t930_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY               
 
      ON ACTION previous
         CALL t930_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                 
 
      ON ACTION jump
         CALL t930_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                

      ON ACTION next
         CALL t930_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
          END IF
         ACCEPT DISPLAY                 
 
      ON ACTION last
         CALL t930_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY              
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               
         CALL cl_set_field_pic(g_ogl.oglconf,"","","","","")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
         
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()     

      ON ACTION confirm
         LET g_action_choice = 'confirm'
         EXIT DISPLAY

      ON ACTION undo_confirm
         LET g_action_choice = 'undo_confirm'
         EXIT DISPLAY

      ON ACTION sub_m
         LET g_action_choice = 'sub_m'
         EXIT DISPLAY

     ON ACTION bill_load
        LET g_action_choice = 'bill_load'
        EXIT DISPLAY

      ON ACTION related_document                      
         LET g_action_choice="related_document"         
         EXIT DISPLAY                                
 
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                            
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")         

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION t930_out()
DEFINE l_cmd   LIKE type_file.chr1000

    IF g_wc IS NULL THEN
       LET g_wc = " 1=1"
    END IF
    LET l_cmd='p_query "tqraxm0010" "',g_wc CLIPPED,'" '
    CALL cl_cmdrun(l_cmd)
END FUNCTION

FUNCTION t930_ogl01(p_cmd)
   DEFINE l_oga02   LIKE oga_file.oga02,
          l_oga04   LIKE oga_file.oga04,
          l_oga16   LIKE oga_file.oga16,
          l_oga18   LIKE oga_file.oga18,
          l_occ02_1 LIKE occ_file.occ02,
          l_occ02_2 LIKE occ_file.occ02,
          p_cmd     LIKE type_file.chr1
 
   LET g_errno=''
   SELECT oga02,oga04,oga16,oga18
     INTO l_oga02,l_oga04,l_oga16,l_oga18
     FROM oga_file
    WHERE oga01=g_ogl.ogl01
          
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_oga02=NULL
                               LET l_oga04=NULL
                               LET l_oga16=NULL
                               LET l_oga18=NULL
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd='d' THEN
     DISPLAY l_oga02  TO oga02
     DISPLAY l_oga04  TO oga04
     DISPLAY l_oga16  TO oga16
     DISPLAY l_oga18  TO oga18
   END IF       

   SELECT occ02 INTO l_occ02_1 FROM occ_file WHERE occ01=l_oga18
     
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_occ02_1=NULL 
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_occ02_1 TO FORMONLY.occ02_1
   END IF

   SELECT occ02 INTO l_occ02_2 FROM occ_file WHERE occ01=l_oga04
     
   CASE WHEN SQLCA.sqlcode=100 LET g_errno='mfg3006'
                               LET l_occ02_2=NULL 
        OTHERWISE              LET g_errno=SQLCA.sqlcode USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd='d' THEN
      DISPLAY l_occ02_2 TO FORMONLY.occ02_2
   END IF
END FUNCTION

FUNCTION t930_b_move()
   LET b_ogl.ogl01=g_ogl.ogl01
   LET b_ogl.ogl02=g_tc_ogl[l_ac].ogl02
   LET b_ogl.ogl03=g_ogl.ogl03
   LET b_ogl.ogl04=g_tc_ogl[l_ac].ogl04
   LET b_ogl.ogl05=g_tc_ogl[l_ac].ogl05
   LET b_ogl.ogl06=g_tc_ogl[l_ac].ogl06
   LET b_ogl.ogl07=g_tc_ogl[l_ac].ogl07
   LET b_ogl.ogl09=g_tc_ogl[l_ac].ogl09
   LET b_ogl.oglconu=g_ogl.oglconu
   LET b_ogl.oglcond=g_ogl.oglcond
   LET b_ogl.oglconf=g_ogl.oglconf
   LET b_ogl.ogloriu=g_ogl.ogloriu
   LET b_ogl.oglcrat=g_ogl.oglcrat
   LET b_ogl.ogluser=g_ogl.ogluser
   LET b_ogl.oglgrup=g_ogl.oglgrup
   LET b_ogl.oglmodu=g_ogl.oglmodu
   LET b_ogl.ogldate=g_ogl.ogldate
   LET b_ogl.oglplant=g_ogl.oglplant
   LET b_ogl.ogllegal=g_ogl.ogllegal
END FUNCTION

FUNCTION t930_browse()
DEFINE  l_file     LIKE  type_file.chr200,
        l_filename LIKE type_file.chr200,
        l_sql      STRING,
        l_data     VARCHAR(300),
        l_count    LIKE type_file.num5,
        m_tempdir  VARCHAR(240) ,
        m_file     VARCHAR(256) ,
        l_str1     STRING,
        l_str2     STRING,
        l_str3     STRING,
        sr         RECORD
                   ogl07 LIKE ogl_file.ogl07,
                   ogl09 LIKE ogl_file.ogl09,
                   ogl05 LIKE ogl_file.ogl05
                   END RECORD
DEFINE l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_ogb12     LIKE ogb_file.ogb12
DEFINE l_ogb RECORD LIKE ogb_file.*
DEFINE l_ogl RECORD LIKE ogl_file.*
DEFINE l_ogl05     LIKE ogl_file.ogl05
DEFINE l_ima01 LIKE ima_file.ima01   

   IF cl_null(g_ogl.ogl03) THEN 
      CALL cl_err('','',0)
      RETURN 
   END IF

   DELETE FROM ogl_file WHERE ogl03=g_ogl.ogl03
   IF SQLCA.sqlcode THEN
      CALL cl_err('del',sqlca.sqlcode,1)
      RETURN
   END IF
   CALL g_tc_ogl.clear()
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
      LET l_count =  LENGTH(l_file)
      IF l_count = 0 THEN  
         LET g_success = 'N'
         RETURN 
      END IF
      INITIALIZE sr.* TO NULL
      SELECT SUBSTR(l_file,instr(l_file,'/',-1,1)+1,length(l_file) - INSTR(l_file,'/',-1,1))  
        INTO l_filename FROM DUAL 
      LET m_tempdir = FGL_GETENV("TEMPDIR") 
      LET m_file = m_tempdir CLIPPED,'/',l_filename  
      IF NOT cl_upload_file(l_file, m_file) THEN  
         CALL cl_err(NULL, "lib-212", 0)
         LET g_success = 'N' 
         RETURN 
      END IF 

      DROP TABLE data_tmp
      CREATE TEMP TABLE data_tmp(
      data LIKE type_file.char300
          );
      RUN 'export DBDELIMITER=" " '

      LOAD FROM m_file DELIMITER '\n' INSERT INTO data_tmp    #系统函数直接读取.txt文件，碰到\n为一行结束

      IF STATUS THEN
         CALL cl_err('','cxm-004',1)
         LET g_success='N' 
         RETURN 
      END IF 
      LET l_sql = "SELECT * FROM data_tmp"
      PREPARE cs_load_pre1 FROM l_sql
      DECLARE cs_load_tmp CURSOR FOR cs_load_pre1
      BEGIN WORK     
      CALL s_showmsg_init()
      LET g_cnt = 1
       CALL s_auto_assign_no("axm",g_ogl.ogl03,g_today,"62","ogl_file","ogl03","","","") 
          RETURNING li_result,g_ogl.ogl03
       IF (NOT li_result) THEN
          RETURN
       END IF
       DISPLAY BY NAME g_ogl.ogl03
      FOREACH cs_load_tmp INTO l_data
         IF SQLCA.sqlcode THEN 
            LET  g_success = 'N'
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF 
         LET l_tok = base.StringTokenizer.create(l_data,",")          #把读到的一行数据做拆分
         IF l_tok.countTokens() > 0 THEN
            WHILE l_tok.hasMoreTokens()
               LET l_str1 = l_tok.nextToken()
               LET l_str2 = l_tok.nextToken()
               LET l_str3 = l_tok.nextToken()
               CALL t930_qy(l_str1) RETURNING sr.ogl07
               CALL t930_qy(l_str2) RETURNING sr.ogl09
               CALL t930_qy(l_str3) RETURNING sr.ogl05
            END WHILE
         END IF
         INITIALIZE b_ogl.* TO NULL
         LET b_ogl.ogl01=g_ogl.ogl01
         LET b_ogl.ogl03=g_ogl.ogl03
         LET b_ogl.ogl04=g_cnt
         LET b_ogl.ogl05=sr.ogl05
         LET b_ogl.ogl07=sr.ogl07
         LET b_ogl.ogl09=sr.ogl09
         LET b_ogl.oglconf=g_ogl.oglconf
         LET b_ogl.oglconu=g_ogl.oglconu
         LET b_ogl.oglcond=g_ogl.oglcond
         LET b_ogl.ogloriu=g_ogl.ogloriu
         LET b_ogl.ogluser=g_ogl.ogluser
         LET b_ogl.oglgrup=g_ogl.oglgrup
         LET b_ogl.ogldate=g_ogl.ogldate
         LET b_ogl.oglmodu=g_ogl.oglmodu
         LET b_ogl.oglcrat=g_ogl.oglcrat
         LET b_ogl.oglplant=g_ogl.oglplant
         LET b_ogl.ogllegal=g_ogl.ogllegal
         LET l_ogb12=0
         SELECT ogb03,ogb12 INTO b_ogl.ogl02,l_ogb12
           FROM ogb_file,rta_file
          WHERE ogb01=g_ogl.ogl01 AND ogb04=rta01 AND rta05=sr.ogl09
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            INITIALIZE l_ima01 TO NULL
            SELECT rta01 INTO l_ima01 FROM rta_file WHERE rta05 = sr.ogl09
            IF l_ima01 IS NULL THEN LET l_ima01 = "null" END IF 	
            LET l_str1 = sr.ogl09,'/',l_ima01,'/',sr.ogl07,'/',sr.ogl05 USING "#####&"
            CALL s_errmsg('ogl01',l_str1,'sel ogb03',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF

         INITIALIZE l_ogl.* TO NULL
         SELECT * INTO l_ogl.* FROM ogl_file
          WHERE ogl03=g_ogl.ogl03 AND ogl01=g_ogl.ogl01
            AND ogl02=b_ogl.ogl02 AND ogl07=b_ogl.ogl07
         IF NOT CL_NULL(l_ogl.ogl04) THEN
            UPDATE ogl_file SET ogl05=l_ogl.ogl05 WHERE ogl03=l_ogl.ogl03 AND ogl04=l_ogl.ogl04
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               CALL s_errmsg('',l_ogl.ogl04,'upd ogl_file',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
         ELSE
            INSERT INTO ogl_file VALUES(b_ogl.*)
            IF SQLCA.sqlcode THEN 
               LET g_success = 'N'
               CALL s_errmsg('',g_cnt,'ins ogl_file',SQLCA.sqlcode,1)
               LET g_cnt = g_cnt +1
               CONTINUE FOREACH 
            END IF
            LET g_cnt = g_cnt + 1
         END IF
      END FOREACH
   END IF
END FUNCTION

FUNCTION t930_yes()
 DEFINE l_sql        STRING,
        l_flag       LIKE type_file.chr1,
        l_ogb03      LIKE ogb_file.ogb03,
        l_ogb12      LIKE ogb_file.ogb12,
        l_ogl05      LIKE ogl_file.ogl05
   
   IF g_ogl.ogl01 IS NULL OR g_ogl.ogl03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
          oglgrup,oglmodu,ogldate,oglplant,ogllegal
    INTO g_ogl.* FROM ogl_file
    WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03

   IF g_ogl.oglconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF

   LET l_flag='N'
   LET l_sql="SELECT ogb03,ogb12,SUM(ogl05) ",
             "FROM ogb_file,ogl_file ",
             "WHERE ogb01=ogl01 AND ogb03=ogl02 ",
             "AND ogl03='",g_ogl.ogl03,"' ",
             "AND ogl01='",g_ogl.ogl01,"' ",
             "GROUP BY ogb03,ogb12"
   PREPARE t930_y_p FROM l_sql
   DECLARE t930_y_c CURSOR FOR t930_y_p
   FOREACH t930_y_c INTO l_ogb03,l_ogb12,l_ogl05
      IF l_ogb12>l_ogl05 THEN
         LET l_flag='Y'
      END IF
      IF l_ogl05>l_ogb12 THEN
         CALL cl_err(l_ogb03,"cxm-999",1)               #裝箱數量不可大於出貨通知單數量
         RETURN
      END IF
   END FOREACH
   IF l_flag='Y' THEN
      IF NOT cl_confirm('cxm-998') THEN RETURN END IF   #出貨通知單數量和裝箱單數量有差異,是否確定審核?
   ELSE
      IF NOT cl_confirm('art-026') THEN RETURN END IF
#CHI-C30107 --------------------- add ---------------------- begin
      SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
             oglgrup,oglmodu,ogldate,oglplant,ogllegal
        INTO g_ogl.* FROM ogl_file
       WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03

      IF g_ogl.oglconf='Y' THEN CALL cl_err('',9023,0) RETURN END IF
#CHI-C30107 --------------------- add ---------------------- end
   END IF
   BEGIN WORK
   OPEN t930_cl USING g_ogl.ogl03,g_ogl.ogl01
    IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t930_cl INTO g_ogl.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_ogl.ogl01,SQLCA.sqlcode,0)
      CLOSE t930_cl ROLLBACK WORK RETURN
    END IF
    LET g_success= 'Y'
   UPDATE ogl_file SET oglconf='Y',
                       oglconu=g_user,
                       oglcond=g_today
     WHERE ogl03=g_ogl.ogl03 
     AND ogl01=g_ogl.ogl01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_ogl.oglconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_ogl.ogl03,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
          oglgrup,oglmodu,ogldate,oglplant,ogllegal
      INTO g_ogl.* FROM ogl_file
   WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03

   DISPLAY BY NAME g_ogl.oglconf,g_ogl.oglconu,g_ogl.oglcond

   IF g_ogl.oglconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ogl.oglconf,"","","",g_chr,"")
   CALL cl_flow_notify(g_ogl.ogl01,'V')
END FUNCTION

FUNCTION t930_no()

DEFINE l_n     LIKE type_file.num5 
   IF g_ogl.ogl01 IS NULL OR g_ogl.ogl03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
    SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
           oglgrup,oglmodu,ogldate,oglplant,ogllegal
         INTO g_ogl.* FROM ogl_file
    WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03
    
   SELECT  COUNT(*) INTO l_n FROM ogl_file WHERE ogl03=g_ogl.ogl03 AND ogl08 IS NOT NULL 
   IF l_n>0 THEN
      CALL cl_err('','axm-crt',0)
      RETURN
   END IF
   CALL t930_show()
   IF g_ogl.oglconf <> 'Y' THEN 
      CALL cl_err('','art-373',0) 
      RETURN 
   END IF
   
   IF NOT cl_confirm('aim-304') THEN RETURN END IF
   BEGIN WORK
   OPEN t930_cl USING g_ogl.ogl03,g_ogl.ogl01

   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t930_cl INTO g_ogl.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ogl.ogl03,SQLCA.sqlcode,0)
      CLOSE t930_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   LET g_success = 'Y'

   UPDATE ogl_file SET oglconf='N',
                #CHI-C80072--str--
                   #   oglconu=NULL,
                   #   oglcond=NULL
                       oglconu= g_user,
                       oglcond = g_today
                #CHI-C80072--end--
    WHERE ogl03=g_ogl.ogl03 
      AND ogl01=g_ogl.ogl01
   IF SQLCA.sqlerrd[3]=0 THEN
      LET g_success='N'
   END IF

   IF g_success = 'Y' THEN
      LET g_ogl.oglconf='N'
      COMMIT WORK
      CALL cl_flow_notify(g_ogl.ogl03,'Y')
   ELSE
      ROLLBACK WORK
   END IF
   
   SELECT ogl03,ogl01,oglconu,oglcond,oglconf,ogloriu,oglcrat,ogluser,
          oglgrup,oglmodu,ogldate,oglplant,ogllegal
      INTO g_ogl.* FROM ogl_file
   WHERE ogl01=g_ogl.ogl01 AND ogl03=g_ogl.ogl03

   DISPLAY BY NAME g_ogl.oglconf,g_ogl.oglconu,g_ogl.oglcond

   IF g_ogl.oglconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_ogl.oglconf,"","","",g_chr,"")
   CALL cl_flow_notify(g_ogl.ogl03,'V')
END FUNCTION

FUNCTION t930_qy(p_str)
 DEFINE p_str   STRING,
        l_i     LIKE type_file.num5

   LET p_str=p_str CLIPPED
   LET l_i=p_str.getLength()
   IF p_str.subString(1,1)="\"" THEN
      LET p_str=p_str.subString(2,l_i)
   END IF
   LET l_i=p_str.getLength()
   IF p_str.subString(l_i,l_i)="\"" THEN
      LET p_str=p_str.subString(1,l_i-1)
   END IF
   RETURN p_str
   
END FUNCTION

FUNCTION t930_get_color_size(l_str1,l_str)
   DEFINE l_str  STRING
   DEFINE l_str1 STRING
   DEFINE l_ps   LIKE type_file.chr1
   DEFINE l_tok  base.stringTokenizer
   DEFINE l_i    LIKE type_file.num5
   DEFINE field_array   DYNAMIC ARRAY OF LIKE type_file.chr100

   LET l_str  = l_str.subString(l_str1.getLength()+1,l_str.getLength())
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN
       LET l_ps=' '
   END IF
   LET l_tok = base.StringTokenizer.createExt(l_str,l_ps,'',TRUE)
   IF l_tok.countTokens() > 0 THEN
      LET l_i=0
      WHILE l_tok.hasMoreTokens()
            LET l_i=l_i+1
            LET field_array[l_i] = l_tok.nextToken()
      END WHILE
   END IF
#    SELECT imx01,imx02 INTO field_array[2],field_array[3]  FROM imx_file WHERE imx00=l_str1 AND imx000=l_str
   RETURN field_array[2],field_array[3]
END FUNCTION

FUNCTION t930_c()
 DEFINE l_sql           STRING,
        l_i         LIKE type_file.num5,
        l_ogl07     LIKE ogl_file.ogl07,
        p_ogl07     LIKE ogl_file.ogl07, 
        l_ima940    LIKE ima_file.ima940,
        l_ogb DYNAMIC ARRAY OF RECORD
              ogb03     LIKE ogb_file.ogb03,
              ogb04     LIKE ogb_file.ogb04,
              tqa02     LIKE tqa_file.tqa02, 
              ogb12     LIKE ogb_file.ogb12,
              ogl05     LIKE ogl_file.ogl05,
              sub       LIKE ogb_file.ogb12,
              ogl07     LIKE type_file.chr100
              END RECORD

   OPEN WINDOW axmt930_c_w WITH FORM "axm/42f/axmt930_c"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET l_i=1
   CALL l_ogb.clear()
   LET l_sql="SELECT UNIQUE ogb03,ogb04,'',ogb12,0,0,'' ",
             "FROM ogb_file,ogl_file ",
             "WHERE ogb01=ogl01 ",
             "AND ogl03='",g_ogl.ogl03,"' ",
             "AND ogl01='",g_ogl.ogl01,"' ",
             "ORDER BY ogb03"
   PREPARE t930_cp FROM l_sql
   DECLARE t930_cc CURSOR FOR t930_cp
   FOREACH t930_cc INTO l_ogb[l_i].*

      SELECT SUM(ogl05) INTO l_ogb[l_i].ogl05 FROM ogl_file                  #匯總裝箱單數量
       WHERE ogl03=g_ogl.ogl03 AND ogl01=g_ogl.ogl01
         AND ogl02=l_ogb[l_i].ogb03
      IF cl_null(l_ogb[l_i].ogl05) THEN LET l_ogb[l_i].ogl05=0 END IF

      SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_ogb[l_i].ogb04
      SELECT tqa02 INTO l_ogb[l_i].tqa02 FROM tqa_file WHERE tqa01=l_ima940 AND tqa03='25'  #根據顏色組抓取顏色

      LET l_ogb[l_i].sub=l_ogb[l_i].ogb12-l_ogb[l_i].ogl05
      IF l_ogb[l_i].sub=0 THEN
         INITIALIZE l_ogb[l_i].* TO NULL
         CONTINUE FOREACH
      END IF

      LET p_ogl07=NULL
      DECLARE t930_cc1 CURSOR FOR   #FUN-C40059---ADD---
#      SELECT ogl07 INTO p_ogl07 FROM ogl_file WHERE ogl03=g_ogl.ogl03 #FUN-C40059---MARK
       SELECT ogl07  FROM ogl_file WHERE ogl03=g_ogl.ogl03     #FUN-C40059---ADD---    
         AND ogl01=g_ogl.ogl01 AND ogl02=l_ogb[l_i].ogb03
#FUN-C40059----ADD---STR----         
      FOREACH t930_cc1 INTO p_ogl07
         IF cl_null(l_ogb[l_i].ogl07) THEN 
            LET l_ogb[l_i].ogl07=p_ogl07
         ELSE             
#FUN-C40059----ADD--END-----
#           LET l_ogb[l_i].ogl07=p_ogl07  #FUN-C40059---MARK----
#FUN-C40059----ADD---STR---- 
            LET l_ogb[l_i].ogl07=l_ogb[l_i].ogl07 CLIPPED,"|",p_ogl07 CLIPPED
         END IF
      END FOREACH  
#FUN-C40059----ADD---END----       
      LET l_i=l_i+1
   END FOREACH

   DISPLAY ARRAY l_ogb TO s_ogb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         CALL cl_show_fld_cont()              

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept 
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION cancel
         LET INT_FLAG=FALSE
         EXIT DISPLAY

      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(l_ogb),'','')

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    

      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")
 
   END DISPLAY
   CLOSE WINDOW axmt930_c_w
END FUNCTION

FUNCTION t930_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
    IF (p_cmd = 'a' OR p_cmd = 'u')  AND ( NOT g_before_input_done ) THEN
         CALL cl_set_comp_entry("ogl03",TRUE)
    END IF

END FUNCTION

FUNCTION t930_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1

    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ogl03",FALSE)
    END IF

END FUNCTION

FUNCTION t930_u()
  DEFINE l_oglconf LIKE ogl_file.oglconf
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_ogl.ogl03 IS NULL  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT oglconf INTO l_oglconf  FROM ogl_file WHERE ogl03=g_ogl.ogl03
    
   IF l_oglconf = 'Y' THEN
      CALL cl_err('','art-024',0)
      RETURN
   END IF 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ogl_t.ogl03 = g_ogl.ogl03
   BEGIN WORK

   OPEN t930_cl USING g_ogl.ogl03,g_ogl.ogl01
   IF STATUS THEN
      CALL cl_err("OPEN t930_cl:", STATUS, 1)
      CLOSE t930_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t930_cl INTO g_ogl.*
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_ogl.ogl03,SQLCA.sqlcode,0)
       CLOSE t930_cl
       ROLLBACK WORK
       RETURN
   END IF

   CALL t930_show()
   WHILE TRUE
      LET g_ogl_t.ogl03 = g_ogl.ogl01
      LET g_ogl_t.* = g_ogl.*
      LET g_ogl.oglmodu=g_user
      LET g_ogl.ogldate=g_today
      CALL t930_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ogl.*=g_ogl_t.*
         CALL t930_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF

      UPDATE ogl_file SET ogl01=g_ogl.ogl01,oglmodu=g_ogl.oglmodu,ogldate=g_ogl.ogldate  
         WHERE ogl03=g_ogl.ogl03 
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","ogl_file",g_ogl.ogl03,"",SQLCA.sqlcode,"","ogl",1) 
        CONTINUE WHILE
     END IF

      EXIT WHILE
   END WHILE

   CLOSE t930_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ogl.ogl03,'U')

   CALL t930_b_fill("1=1")
END FUNCTION

FUNCTION t930_copy()
   DEFINE   l_n              LIKE type_file.num5,
            l_newno          LIKE ogl_file.ogl03,
            l_oldoglplant    LIKE ogl_file.oglplant, 
            l_oldogllegal    LIKE ogl_file.ogllegal, 
            l_oldno          LIKE ogl_file.ogl03 
   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
  
   IF g_ogl.ogl03 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")
   INPUT l_newno FROM ogl03
#     BEFORE INPUT
#      LET g_ogl.ogl01=g_ogl_t.ogl01
#          DISPLAY by name g_ogl.ogl01 
     AFTER INPUT
        IF cl_null(l_newno) THEN
           NEXT FIELD ogl03 
           LET INT_FLAG = 1
        END IF

          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM ogl_file
          WHERE ogl03=l_newno

         IF g_cnt > 0 THEN
            CALL cl_err(l_newno,-239,0)
            NEXT FIELD ogl03 
         END IF


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()
      ON ACTION CONTROLP
           CASE WHEN INFIELD(ogl03)
                 LET g_t1=s_get_doc_no(g_ogl.ogl03)
                 CALL q_oay(FALSE,FALSE,g_t1,'64','AXM') RETURNING g_t1
                 LET l_newno=g_t1
                 DISPLAY BY NAME g_ogl.ogl03
                 NEXT FIELD ogl03

#                WHEN INFIELD(ogl01)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ogl01"
#                 LET g_qryparam.default1 = g_ogl.ogl01
#                 CALL cl_create_qry() RETURNING g_ogl.ogl01
#                 DISPLAY BY NAME g_ogl.ogl01
#                 NEXT FIELD ogl01
             OTHERWISE EXIT CASE
           END CASE

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_ogl.ogl03
      TO ogl03 
      RETURN
   END IF
   CALL s_auto_assign_no("axm",l_newno,g_today,"62","ogl_file","ogl03","","","")
          RETURNING li_result,l_newno
      IF (NOT li_result) THEN
         RETURN
      END IF 
   DROP TABLE x

   SELECT * FROM ogl_file
     WHERE ogl03 = g_ogl.ogl03
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_ogl.ogl03,"",SQLCA.sqlcode,"","",0)
      RETURN
   END IF

   UPDATE x
      SET  ogl03 = l_newno                        # 資料鍵值
   INSERT INTO ogl_file SELECT * FROM x

   IF SQLCA.SQLCODE THEN

      CALL cl_err3("ins","ogl_file",l_newno,"",SQLCA.sqlcode,
                   "","ogl",0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'

   LET l_oldno = g_ogl.ogl03
   LET g_ogl.ogl03 = l_newno
#  CALL t930_u()
   CALL t930_b()
   #LET g_ogl.ogl03 = l_oldno  #FUN-C80046
   #CALL t930_show()           #FUN-C80046
END FUNCTION

FUNCTION t930_bill()

 DEFINE l_n        LIKE type_file.num5,
        l_sql      STRING,
        l_ogl01    LIKE ogl_file.ogl01, 
        l_occ930   LIKE occ_file.occ930,
        l_cnt      LIKE type_file.num5,
        l_ogbslk04 LIKE ogbslk_file.ogbslk04,
        l_message  STRING,
        l_end      STRING
 DEFINE l_ogl08    LIKE ogl_file.ogl08

   LET g_no2=NULL
   LET g_imd01=NULL
   LET g_ime02=NULL 
   IF g_ogl.ogl03 IS NULL  THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_ogl.oglconf ='N' THEN
      CALL cl_err('',9029,0)
      RETURN 
   END IF

    OPEN WINDOW axmp620_t AT 6,20 WITH FORM "axm/42f/axmp620_slk"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
#   CLEAR FORM      #TQC-C20500---mark
    INPUT BY NAME g_no2,g_imd01,g_ime02  WITHOUT DEFAULTS  

    AFTER FIELD g_imd01
          IF NOT cl_null(g_imd01) THEN
             SELECT count(*) INTO l_n FROM imd_file 
              WHERE imd01=g_imd01 AND imd20=g_plant AND imdacti='Y'
             IF cl_null(l_n) OR l_n=0 THEN
                CALL cl_err(g_imd01,'cxm-027',0)
                NEXT FIELD g_imd01
             END IF
          END IF

   #FUN-D40103 -----Begin------
          IF NOT t930_chk_ime02() THEN 
          #  NEXT FIELD g_imd01   #TQC-D50126 add 
             NEXT FIELD g_ime02   #TQC-D50126
          END IF
   #FUN-D40103 -----End--------
   AFTER FIELD g_no2
         IF cl_null(g_no2) THEN
            NEXT FIELD g_no2
         END IF
         CALL s_check_no("axm",g_no2,"","50","oga_file","oga01","")
              RETURNING li_result,g_no2
         IF (NOT li_result) THEN
             NEXT FIELD g_no2 
         END IF
   
   AFTER FIELD g_ime02
       #FUN-D40103 -----Begin-----
      #IF NOT cl_null(g_ime02) AND NOT cl_null(g_imd01) THEN     #FUN-C40059---MODIFY---
      #   SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime01=g_imd01 AND ime02=g_ime02 
      #   IF l_n=0 OR cl_null(l_n) THEN
#     #       CALL cl_err('','mfg6103',0)     #FUN-C40059--mark---
      #      CALL cl_err('','axm1156',0)      #FUN-C40059--add----
      #      NEXT FIELD g_ime02 
      #   END IF 
      #END IF
     #FUN-D40103 -----End-------
      IF cl_null(g_ime02) THEN LET g_ime02 = ' ' END IF    #TQC-D50127
       #FUN-D40103 -----Begin------
       IF NOT t930_chk_ime02() THEN
          NEXT FIELD g_ime02
       END IF
     #FUN-D40103 -----End--------   
     IF NOT cl_null(g_ime02) AND NOT cl_null(g_imd01) THEN     #FUN-C40059---MODIFY---
          SELECT COUNT(*) INTO l_n FROM ime_file WHERE ime01=g_imd01 AND ime02=g_ime02 
          IF l_n=0 OR cl_null(l_n) THEN
#             CALL cl_err('','mfg6103',0)     #FUN-C40059--mark---
             CALL cl_err('','axm1156',0)      #FUN-C40059--add----
             NEXT FIELD g_ime02 
          END IF 
       END IF
   ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CALL cl_set_field_pic(g_ogl.oglconf,"","","","","") 
 
   ON ACTION exit
      LET INT_FLAG = 1
      EXIT INPUT
 
   ON ACTION cancel
      LET INT_FLAG= 1
      EXIT INPUT 

   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
   ON ACTION CONTROLG 
      CALL cl_cmdask()

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE INPUT
   
   ON ACTION about        
      CALL cl_about()   
      
   ON ACTION help          
      CALL cl_show_help() 
      
   ON ACTION CONTROLP                  
      CASE
         WHEN INFIELD(g_no2) #查詢單据
                  LET g_t1=g_no2[1,g_doc_len]  
                  LET g_buf='50'
                  IF g_oga.oga00 = '3' OR g_oga.oga00 = '7' THEN 
                     LET g_buf[2,2] = '3' 
                  END IF
                  IF g_oga.oga00 = '4' THEN
                     LET g_buf[2,2] = '4' 
                  END IF
                  IF g_oga.oga00 = '5' THEN
                     LET g_buf[2,2] = '6' 
                  END IF
                  CALL q_oay(FALSE,FALSE,g_t1,'50','axm') RETURNING g_t1  
                  LET g_no2=g_t1                 
                  DISPLAY BY NAME g_no2 
                  NEXT FIELD g_no2
        WHEN INFIELD(g_imd01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imd02"      
                  LET g_qryparam.default1 = g_imd01
                  LET g_qryparam.arg1=g_plant
                  LET g_qryparam.where=" imd20 ='",g_plant,"'"
                  CALL cl_create_qry() RETURNING g_imd01
                  DISPLAY BY NAME g_imd01

        WHEN INFIELD(g_ime02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ime02_slk"
                  LET g_qryparam.default1 = g_ime02
                  LET g_qryparam.arg1=g_imd01
                  CALL cl_create_qry() RETURNING g_ime02
                  DISPLAY BY NAME g_ime02
           END CASE
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW axmp620_t 
      RETURN
   END IF
 
   IF NOT cl_sure(10,10) THEN
      CLOSE WINDOW axmp620_t 
      RETURN
   END IF

   INITIALIZE g_oga.* TO NULL
   INITIALIZE g_ogb.* TO NULL   
   INITIALIZE g_ogbi.* TO NULL
   INITIALIZE g_ogbslk.* TO NULL  
   LET l_message= " "
   LET l_end=" "
   LET g_start=NULL
   LET g_success='Y' #TQC-DB0073
   LET l_sql = " SELECT DISTINCT ogl01 FROM ogl_file ", 
               " WHERE ogl03 = '",g_ogl.ogl03,"' AND oglconf = 'Y' AND ogl08 IS NULL "
   DECLARE t930_oga_c CURSOR FROM l_sql
   FOREACH t930_oga_c INTO l_ogl01 
    IF SQLCA.SQLCODE THEN
       CALL cl_err('ogl01',SQLCA.SQLCODE,1) 
       EXIT FOREACH 
    END IF       
    IF l_ogl01 IS NULL THEN 
       CONTINUE  FOREACH 
    END IF
     SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = l_ogl01 
       LET g_oga.oga01 = g_no2
       LET g_oga.oga02 = g_today
       LET g_oga.oga011 =l_ogl01 
       LET g_oga.oga09 = '2'
       LET g_oga.ogaconf = 'N' 
       LET g_oga.ogapost = 'N' 
       LET g_oga.ogaprsw = 0
       LET g_oga.oga55='0'             
       LET g_oga.ogamksg = g_oay.oayapr  
       LET g_oga.oga85=' '  
       LET g_oga.oga94='N'  
       LET g_oga.ogaplant = g_plant 
       LET g_oga.ogalegal = g_legal  
       LET g_oga.ogaoriu = g_user     
       LET g_oga.ogaorig = g_grup    
       LET g_oga.ogaslk01 = g_ogl.ogl03   #裝箱單號
       SELECT occ930 INTO l_occ930 FROM occ_file WHERE occ01=g_oga.oga03
        LET l_cnt=0
        SELECT count(*) INTO l_cnt FROM tuo_file WHERE tuo01=g_oga.oga03 
        IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
        IF cl_null(l_occ930) AND l_cnt >0 THEN
           LET g_oga.oga00='7'
        END IF    
        CALL s_auto_assign_no("axm",g_no2,g_today,'50',"oga_file","oga01","","","")
           RETURNING li_result,g_no2
        IF (NOT li_result) THEN
           CONTINUE  FOREACH
        END IF
        LET g_oga.oga01=g_no2

        INSERT INTO oga_file VALUES (g_oga.*)
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
           CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","ins oga",1)
           LET g_success='N' 
           RETURN
        ELSE
           IF cl_null(g_start) THEN
              LET g_start = g_oga.oga01  
           END IF
        END IF
        
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_oga.oga23
       
        LET l_sql = " SELECT * FROM ogl_file ",
                    " WHERE  ogl03 = '",g_ogl.ogl03,"' AND ogl01 = '",l_ogl01,"'"  
        DECLARE t930_ogb_c CURSOR FROM l_sql
        FOREACH t930_ogb_c INTO g_oglb.* 

           SELECT * INTO g_ogb.* FROM ogb_file 
            WHERE ogb01 = g_ogl.ogl01 AND ogb03 = g_oglb.ogl02     #裝箱單項次
           IF g_ogb.ogb12 < g_oglb.ogl05  THEN 
               LET g_success='N' 
               RETURN
           END IF
           LET g_ogb.ogb01 = g_no2       #出货单单号

           SELECT oeb01,oeb03 INTO g_ogb.ogb31,g_ogb.ogb32 FROM oeb_file     #订单单号 订单项次
            WHERE oeb01 = g_ogb.ogb31 AND oeb04 = g_ogb.ogb04
           IF NOT cl_null(g_ogb.ogb31) AND NOT cl_null(g_ogb.ogb32) THEN
              SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb.ogb37,g_ogb.ogb41,g_ogb.ogb42,g_ogb.ogb43,g_ogb.ogb44,
                           g_ogb.ogb45,g_ogb.ogb46,g_ogb.ogb47,g_ogb.ogb48,g_ogb.ogb49,
                           g_ogb.ogb931,g_ogb.ogb932,g_ogb.ogb1003,g_ogb.ogb1001,g_ogb.ogb1002,
                           g_ogb.ogb1005,g_ogb.ogb1004,g_ogb.ogb1006,g_ogb.ogb1007,g_ogb.ogb1008,
                           g_ogb.ogb1009,g_ogb.ogb1010,g_ogb.ogb1011,g_ogb.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb.ogb31 AND oeb03=g_ogb.ogb32

            IF cl_null(g_ogb.ogb37) THEN LET g_ogb.ogb37=0 END IF
            IF cl_null(g_ogb.ogb47) THEN LET g_ogb.ogb47=0 END IF
            IF cl_null(g_ogb.ogb44) THEN LET g_ogb.ogb44=' ' END IF
           END IF 
           #FUN-C50097 ADD BEGIN-----
           IF cl_null(g_ogb.ogb50) THEN
             LET g_ogb.ogb50 = 0
           END IF
           IF cl_null(g_ogb.ogb51) THEN
             LET g_ogb.ogb51 = 0
           END IF
           IF cl_null(g_ogb.ogb52) THEN
             LET g_ogb.ogb52 = 0
           END IF
           IF cl_null(g_ogb.ogb53) THEN
             LET g_ogb.ogb53 = 0
           END IF
           IF cl_null(g_ogb.ogb54) THEN
             LET g_ogb.ogb54 = 0
           END IF
           IF cl_null(g_ogb.ogb55) THEN
             LET g_ogb.ogb55 = 0
           END IF           
           #FUN-C50097 ADD END-------
           LET g_ogb.ogb09 = g_imd01
           LET g_ogb.ogb091 = g_ime02
           LET g_ogb.ogb12 = g_oglb.ogl05
           LET g_ogb.ogb16 = g_oglb.ogl05
           LET g_ogb.ogb18 = g_oglb.ogl05
           LET g_ogb.ogb912 = g_oglb.ogl05
           LET g_ogb.ogb917 = g_oglb.ogl05
           LET g_ogb.ogbplant=g_plant
           LET g_ogb.ogblegal=g_legal  
           IF g_oga.oga213 = 'N' THEN
              LET g_ogb.ogb14 =t930_amount(g_ogb.ogb12,g_ogb.ogb13,g_ogb.ogb1006,t_azi03) 
              LET g_ogb.ogb14t=g_ogb.ogb14*(1+g_oga.oga211/100)
           ELSE
              LET g_ogb.ogb14t=t930_amount(g_ogb.ogb12,g_ogb.ogb13,g_ogb.ogb1006,t_azi03)
              LET g_ogb.ogb14 =g_ogb.ogb14t/(1+g_oga.oga211/100)
           END IF

           CALL cl_digcut(g_ogb.ogb14,t_azi04)  RETURNING g_ogb.ogb14
           CALL cl_digcut(g_ogb.ogb14t,t_azi04)  RETURNING g_ogb.ogb14t
           SELECT COUNT(*) INTO l_cnt FROM ogb_file 
            WHERE ogb01 = g_ogb.ogb01 AND ogb04 = g_ogb.ogb04 

           IF l_cnt=0 OR cl_null(l_cnt) THEN
              SELECT MAX(ogb03)+1 INTO g_ogb.ogb03 FROM ogb_file WHERE ogb01 = g_no2
              IF g_ogb.ogb03 IS NULL OR g_ogb.ogb03 = 0 THEN LET g_ogb.ogb03 = 1 END IF
              LET g_ogb.ogb16=g_ogb.ogb12*g_ogb.ogb15_fac               
              #FUN-CB0087--add--str--
              IF g_aza.aza115 = 'Y' THEN
                 CALL s_reason_code(g_ogb.ogb01,g_ogb.ogb31,'',g_ogb.ogb04,g_ogb.ogb09,g_oga.oga14,g_oga.oga15) RETURNING g_ogb.ogb1001
                 IF cl_null(g_ogb.ogb1001) THEN
                    CALL cl_err(g_ogb.ogb1001,'aim-425',1)
                    LET g_success="N"
                    RETURN
                 END IF
              END IF
              #FUN-CB0087--add--end--
              INSERT INTO ogb_file VALUES (g_ogb.*)
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
                 CALL cl_err3("ins","ogb_file",g_ogb.ogb01,"",SQLCA.SQLCODE,"","ins ogb",1) 
                 LET g_success='N' 
                 RETURN
              END IF 
           ELSE
              UPDATE ogb_file SET ogb12 = ogb12+g_ogb.ogb12,
                                  ogb14 = ogb14+g_ogb.ogb14,
                                  ogb14t=ogb14t+g_ogb.ogb14t
               WHERE ogb01 = g_ogb.ogb01
                 AND ogb04 = g_ogb.ogb04
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("upd","ogb_file",g_ogb.ogb01,"",SQLCA.SQLCODE,"","upd ogb",1)  
                 LET g_success='N'
                 RETURN
              END IF

              UPDATE ogb_file SET ogb16 = ogb12
               WHERE ogb01 = g_ogb.ogb01
                 AND ogb04 = g_ogb.ogb04
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("upd","ogb_file",g_ogb.ogb01,"",SQLCA.SQLCODE,"","upd ogb",1)   
                 LET g_success='N'
                 RETURN
              END IF
           END IF 
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01= g_ogb.ogb04
                                            AND imaacti='Y'
                                            AND ( ima151 != 'N' OR imaag <> '@CHILD' OR imaag is NULL ) #TQC-C30114 add imaag is NULL
                                            AND ima151 != 'Y'
           IF l_n>0 THEN
              LET l_ogbslk04= g_ogb.ogb04
           ELSE
              SELECT imx00 INTO l_ogbslk04 FROM imx_file WHERE imx000 = g_ogb.ogb04  #母料件 
           END IF
              SELECT COUNT(*) INTO l_cnt FROM ogbslk_file 
               WHERE ogbslk01 = g_no2 AND ogbslk04 = l_ogbslk04
            
           LET g_ogbslk.ogbslk04=l_ogbslk04
           ####如果该母料件在出货单中没有则INSERT.否则UPDATE数量为子料件数量累加
           IF cl_null(l_cnt) OR l_cnt=0  THEN
              LET g_ogbslk.ogbslk01=g_no2
              SELECT MAX(ogbslk03)+1 INTO g_ogbslk.ogbslk03 FROM ogbslk_file WHERE ogbslk01 = g_ogbslk.ogbslk01
              IF cl_null(g_ogbslk.ogbslk03) THEN LET g_ogbslk.ogbslk03 = 1 END IF  

              SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01= g_ogb.ogb04    #判斷非子母料件
                                            AND imaacti='Y'
                                            AND ( ima151 != 'N' OR imaag <> '@CHILD' OR imaag is NULL ) #TQC-C30114 add imaag is NULL
                                            AND ima151 != 'Y'
              IF l_n>0 THEN
                LET g_ogbslk.ogbslk04= g_ogb.ogb04
              ELSE
                 SELECT imx00 INTO g_ogbslk.ogbslk04 FROM imx_file WHERE imx000 = g_ogb.ogb04  #母料件
              END IF
              SELECT oebslk01,oebslk03 INTO g_ogbslk.ogbslk31,g_ogbslk.ogbslk32 FROM oebslk_file
               WHERE oebslk01 = g_ogb.ogb31 AND oebslk04 = g_ogbslk.ogbslk04 

              LET g_ogbslk.ogbslk05=g_ogb.ogb05
              LET g_ogbslk.ogbslk05_fac=g_ogb.ogb05_fac
              SELECT ima02 INTO g_ogbslk.ogbslk06 FROM ima_file WHERE ima01=g_ogbslk.ogbslk04    #母料件規格
              LET g_ogbslk.ogbslk07=g_ogb.ogb07
              LET g_ogbslk.ogbslk09=g_imd01
              LET g_ogbslk.ogbslk091=g_ime02
              LET g_ogbslk.ogbslk092=g_ogb.ogb092
              LET g_ogbslk.ogbslk11=g_ogb.ogb11
              LET g_ogbslk.ogbslk12=g_ogb.ogb12
              LET g_ogbslk.ogbslk13=g_ogb.ogb13
              LET g_ogbslk.ogbslk131=g_ogbslk.ogbslk13*g_ogb.ogb1006/100    #结算价
              LET g_ogbslk.ogbslk1006=g_ogbslk.ogbslk131*100/g_ogbslk.ogbslk13  #折扣率 
              LET g_ogbslk.ogbslk14=g_ogb.ogb14
              LET g_ogbslk.ogbslk14t=g_ogb.ogb14t
              LET g_ogbslk.ogbslk15=g_ogb.ogb15
              LET g_ogbslk.ogbslk15_fac=g_ogb.ogb15_fac
              LET g_ogbslk.ogbslk16=g_ogb.ogb16
              LET g_ogbslk.ogbslk18=g_ogb.ogb18
              LET g_ogbslk.ogbslk60=g_ogb.ogb60
              LET g_ogbslk.ogbslk63=g_ogb.ogb63
              LET g_ogbslk.ogbslk64=g_ogb.ogb64 
              LET g_ogbslk.ogbslk1013=g_ogb.ogb1013
              LET g_ogbslk.ogbslkplant=g_ogb.ogbplant
              LET g_ogbslk.ogbslklegal=g_ogb.ogblegal

              INSERT INTO ogbslk_file VALUES (g_ogbslk.*)
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                 CALL cl_err3("ins","ogbslk_file",g_ogbslk.ogbslk01,"",SQLCA.SQLCODE,"","ins ogbslk",1)  
                 LET g_success='N'
                 RETURN
              ELSE
              END IF
           ELSE
              UPDATE ogbslk_file 
                 SET ogbslk12 = ogbslk12+g_ogb.ogb12,
                     ogbslk14 = ogbslk14+g_ogb.ogb14,
                     ogbslk14t= ogbslk14t+g_ogb.ogb14t 
               WHERE ogbslk01 = g_ogb.ogb01 
                 AND ogbslk04 = l_ogbslk04
#               AND ogbslk03 IN( SELECT ogbislk02 FROM ogbi_file 
#                                  WHERE ogbi01=g_ogb.ogb01
#                                    AND ogbi03=g_ogb.ogb03)

               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","ogbslk_file",g_ogb.ogb01,"",SQLCA.SQLCODE,"","upd ogbslk",1)   #No.FUN-660167
                  LET g_success='N'
                  RETURN
               END IF
#----------------------------------begin-------------------------------保持ogbslk16=ogbslk12
              UPDATE ogbslk_file
                 SET ogbslk16 = ogbslk12
               WHERE ogbslk01 = g_ogb.ogb01 AND ogbslk04 = l_ogbslk04
#               AND ogbslk03 IN( SELECT ogbislk02 FROM ogbi_file 
#                                  WHERE ogbi01=g_ogb.ogb01
#                                    AND ogbi03=g_ogb.ogb03)
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","ogbslk_file",g_ogb.ogb01,"",SQLCA.SQLCODE,"","upd ogbslk",1)  
                  LET g_success='N'
                  RETURN
               END IF
#---------------------------------end-------------------------------
           END IF
#--------------------INSERT INTO ogbi_file--------------------------------- 
            #TQC-C30114---add---begin---
            #SELECT COUNT(*) INTO l_cnt FROM ogbi_file WHERE ogbi01=g_no2
            #   AND ogbi03=g_ogb.ogb03 AND ogbi03 IS NOT NULL
            SELECT COUNT(*) INTO l_cnt FROM ogbi_file,ogb_file
             WHERE ogbi01=g_no2
               AND ogbi03=ogb03
               AND ogbi01=ogb01
               AND ogb04=g_ogb.ogb04
               AND ogbi03 IS NOT NULL
            #TQC-C30114---add---end---
            IF l_cnt=0 OR cl_null(l_cnt) THEN
                SELECT ogbslk03 INTO g_ogbslk.ogbslk03 FROM ogbslk_file  #TQC-C30114 add
                 WHERE ogbslk01=g_no2 AND ogbslk04=g_ogbslk.ogbslk04     #TQC-C30114 add
                LET g_ogbi.ogbi01=g_no2
                LET g_ogbi.ogbi03=g_ogb.ogb03
                LET g_ogbi.ogbislk01=g_ogbslk.ogbslk04    #款號
                LET g_ogbi.ogbislk02= g_ogbslk.ogbslk03   #項次
                LET g_ogbi.ogbiplant=g_ogb.ogbplant
                LET g_ogbi.ogbilegal=g_ogb.ogblegal
                INSERT INTO ogbi_file VALUES(g_ogbi.*) 
                 IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                    CALL cl_err3("upd","ogbi_file",g_no2,"",SQLCA.SQLCODE,"","ins ogbi_file",1)
                    LET g_success='N'
                    RETURN
                 END IF
            END IF

            UPDATE ogl_file SET ogl08 = g_ogb.ogb01    
                            WHERE ogl03 =g_oglb.ogl03
                             AND  ogl04 =g_oglb.ogl04 
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN 
              CALL cl_err3("upd","ogl_file",g_oglb.ogl03,"",SQLCA.SQLCODE,"","upd ogl_file",1)   
              LET g_success='N' 
              RETURN
           END IF
                   
       END FOREACH  
   END FOREACH

   CLOSE WINDOW axmp620_t 
   IF g_success = 'Y' THEN
       COMMIT WORK
          CALL cl_cmmsg(1)
          LET l_message = g_start,' ~ ',l_end
          LET l_message = l_message CLIPPED
          CALL cl_err(l_message,'axm-cr',1)
    ELSE
#      CALL cl_rbmsg(1)
       CALL cl_err('','axm-suc',0)
       ROLLBACK WORK 
       RETURN
    END IF
#FUN-C60090----ADD---STR---
    SELECT DISTINCT ogl08 INTO l_ogl08 FROM ogl_file WHERE ogl03=g_ogl.ogl03
    DISPLAY l_ogl08 TO ogl08
#FUN-C60090----ADD----END---   
 
END FUNCTION

#FUN-D40103 --------Begin--------
FUNCTION t930_chk_ime02()
   DEFINE l_ime02      LIKE ime_file.ime02     #TQC-D50116
   DEFINE l_imeacti    LIKE ime_file.imeacti
 # IF g_ime02 IS NOT NULL AND NOT cl_null(g_imd01) THEN  #TQC-D50127 mark
   IF g_ime02 IS NOT NULL AND g_ime02 != ' ' THEN     #TQC-D50127 
      SELECT * FROM ime_file
       WHERE ime01 = g_imd01
         AND ime02 = g_ime02
      IF SQLCA.SQLCODE THEN
      #  CALL cl_err('','axm1156',0)   #TQC-D50116
         CALL cl_err(g_imd01|| ' ' ||g_ime02,'axm1156',0) #TQC-D50116
         RETURN FALSE
      END IF
   END IF    #TQC-D50127
   IF g_ime02 IS NOT NULL  THEN     #TQC-D50127
      LET l_imeacti = ''
      SELECT imeacti INTO l_imeacti FROM ime_file
       WHERE ime01 = g_imd01
         AND ime02 = g_ime02
      IF l_imeacti = 'N' THEN
      #  CALL cl_err(g_imd01,'aim-507',0)        #TQC-D50116
      #TQC-D50116 ------Begin-------
         LET l_ime02 = g_ime02
         IF cl_null(l_ime02) THEN
            LET l_ime02 = "' '"
         END IF
         CALL cl_err_msg("","aim-507",g_imd01 || "|" || l_ime02 ,0)  
      #TQC-D50116 ------End---------
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-D40103 --------End----------

FUNCTION t930_amount(p_qty,p_price,p_rate,p_azi03)
DEFINE   p_qty       LIKE ogb_file.ogb12    #數量
DEFINE   p_price     LIKE ogb_file.ogb13    #單價(未折扣)
DEFINE   p_rate      LIKE ogb_file.ogb1006  #折扣率
DEFINE   p_azi03     LIKE azi_file.azi03    #單價位數
DEFINE   l_price     LIKE ogb_file.ogb13    #單價(已折扣)
DEFINE   l_amount    LIKE ogb_file.ogb14    #金額

    IF cl_null(p_rate) THEN
       LET p_rate = 100
    END IF
    LET l_amount = p_qty*p_price*p_rate/100
    IF cl_null(l_amount) THEN
       LET l_amount = 0
    END IF
    RETURN l_amount
END FUNCTION
#NO.FUN-B90103

#FUN-C40059----add-----begin-----
# Usage..........:服飾版本母料件屬性加載尺寸
FUNCTION t930_settext_slk()
   DEFINE l_index     STRING
   DEFINE l_sql       STRING
   DEFINE l_i,l_j     LIKE type_file.num5
   DEFINE l_tqa01     LIKE tqa_file.tqa01
   DEFINE l_tqa02     LIKE tqa_file.tqa02
   DEFINE l_n         LIKE type_file.num5   

#抓取母料件多屬性資料
   LET l_sql = "SELECT tqa01 FROM tqa_file",
               " WHERE tqa03='26'",
               " ORDER BY tqa01"
   PREPARE s_f3_pre FROM l_sql
   DECLARE s_f2_cs CURSOR FOR s_f3_pre

   CALL g_imxtext.clear()
   LET l_n=1
   FOREACH s_f2_cs INTO l_tqa01
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_imxtext[l_n].size=l_tqa01 CLIPPED
      LET l_n=l_n+1
   END FOREACH


   FOR l_i = 1 TO l_n-1
      
      LET l_tqa01 = g_imxtext[l_i].size CLIPPED
      LET l_index = l_i USING '&&'      
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa01 = l_tqa01
         AND tqa03 = '26'
      CALL cl_set_comp_visible("imx" || l_index,TRUE)
      CALL cl_set_comp_att_text("imx" || l_index,l_tqa02)
   END FOR
   FOR l_i = g_imxtext.getLength()+1 TO 25 
      LET l_index = l_i USING '&&'
      CALL cl_set_comp_visible("imx" || l_index,FALSE)
   END FOR
END FUNCTION


#填充imx的数量 call t930_fillimx_slk(l_imx000,l_cnt)
#l_imx000----子料件   l_cnt-----所在行数
FUNCTION t930_fillimx_slk(l_imx000,l_cnt)
DEFINE l_imx000     LIKE imx_file.imx000
DEFINE l_cnt        LIKE type_file.num10
DEFINE l_ima151     LIKE ima_file.ima151
DEFINE l_imaag      LIKE ima_file.imaag
DEFINE l_n          LIKE type_file.num10
DEFINE l_ima01      LIKE ima_file.ima01
DEFINE l_ps      LIKE sma_file.sma46
DEFINE l_ima940     LIKE ima_file.ima940

       SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=l_imx000
       IF l_ima151='N' AND l_imaag='@CHILD' THEN
  
          SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx000        #顏色组
          SELECT sma46 INTO l_ps FROM sma_file
             IF cl_null(l_ps) THEN
                LET l_ps=' '
             END IF
          FOR l_n=1 TO g_imxtext.getlength()   #遍历尺寸属性
             
             LET l_ima01 = g_tc_ogl[l_cnt].imx00,l_ps,l_ima940,l_ps,g_imxtext[l_n].size
             CASE 
                WHEN (l_n=1 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx01=g_tc_ogl[l_cnt].ogl05  
                   CALL cl_set_comp_visible("imx01",true) 
                   CALL cl_set_comp_entry("imx01",true) 
                   EXIT CASE
                 
                WHEN (l_n=2 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx02=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx02",true) 
                   call cl_set_comp_entry("imx02",true) 
                   EXIT CASE
                WHEN (l_n=3 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx03=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx03",true) 
                   CALL cl_set_comp_entry("imx03",true) 
                   EXIT CASE
                WHEN (l_n=4 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx04=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx04",true) 
                   CALL cl_set_comp_entry("imx04",true) 
                   EXIT CASE
                WHEN (l_n=5 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx05=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx05",true) 
                   CALL cl_set_comp_entry("imx05",true) 
                   EXIT CASE
                WHEN (l_n=6 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx06=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx06",true) 
                   CALL cl_set_comp_entry("imx06",true) 
                   EXIT CASE
                WHEN (l_n=7 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx07=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx07",true) 
                   CALL cl_set_comp_entry("imx07",true) 
                   EXIT CASE
                WHEN (l_n=8 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx08=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx08",true) 
                   CALL cl_set_comp_entry("imx08",true) 
                   EXIT CASE
                WHEN (l_n=9 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx09=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx09",true) 
                   CALL cl_set_comp_entry("imx09",true) 
                   EXIT CASE
                WHEN (l_n=10 AND l_imx000=l_ima01) 
                   LET g_tc_ogl[l_cnt].imx10=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx10",true) 
                   CALL cl_set_comp_entry("imx10",true) 
                   EXIT CASE
                WHEN (l_n=11 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx11=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx11",true) 
                   CALL cl_set_comp_entry("imx11",true) 
                   EXIT CASE
                WHEN (l_n=12 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx12=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx12",true) 
                   CALL cl_set_comp_entry("imx12",true) 
                   EXIT CASE
                WHEN (l_n=13 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx13=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx13",true) 
                   CALL cl_set_comp_entry("imx13",true) 
                   EXIT CASE
                WHEN (l_n=14 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx14=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx14",true) 
                   CALL cl_set_comp_entry("imx14",true) 
                   EXIT CASE
                WHEN (l_n=15 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx15=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx15",true) 
                   CALL cl_set_comp_entry("imx15",true) 
                   EXIT CASE
                WHEN (l_n=16 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx16=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx16",true) 
                   CALL cl_set_comp_entry("imx16",true) 
                   EXIT CASE
                WHEN (l_n=17 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx17=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx17",true) 
                   CALL cl_set_comp_entry("imx17",true) 
                   EXIT CASE
                WHEN (l_n=18 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx18=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx18",true) 
                   CALL cl_set_comp_entry("imx18",true) 
                   EXIT CASE
                WHEN (l_n=19 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx19=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx19",true) 
                   CALL cl_set_comp_entry("imx19",true) 
                   EXIT CASE
                WHEN (l_n=20 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx20=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx20",true) 
                   CALL cl_set_comp_entry("imx20",true) 
                   EXIT CASE
                WHEN (l_n=21 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx21=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx21",true) 
                   CALL cl_set_comp_entry("imx21",true) 
                   EXIT CASE
                WHEN (l_n=22 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx22=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx22",true) 
                   CALL cl_set_comp_entry("imx22",true) 
                   EXIT CASE
                WHEN (l_n=23 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx23=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx23",true) 
                   CALL cl_set_comp_entry("imx23",true) 
                   EXIT CASE
                WHEN (l_n=24 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx24=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx24",true) 
                   CALL cl_set_comp_entry("imx24",true) 
                   EXIT CASE
                WHEN (l_n=25 AND l_imx000=l_ima01)  
                   LET g_tc_ogl[l_cnt].imx25=g_tc_ogl[l_cnt].ogl05 
                   CALL cl_set_comp_visible("imx25",true) 
                   CALL cl_set_comp_entry("imx25",true) 
                   EXIT CASE
                
             END CASE
             
          END FOR
                           
       END IF
END FUNCTION

#清空单身除ogl04和ogl02的栏位
FUNCTION t930_null(l_ac)
DEFINE l_ac    LIKE type_file.num10
   LET g_tc_ogl[l_ac].imx00=NULL
   LET g_tc_ogl[l_ac].ima02=NULL
   LET g_tc_ogl[l_ac].color=NULL
   LET g_tc_ogl[l_ac].imx01=NULL
   LET g_tc_ogl[l_ac].imx02=NULL
   LET g_tc_ogl[l_ac].imx03=NULL
   LET g_tc_ogl[l_ac].imx04=NULL
   LET g_tc_ogl[l_ac].imx05=NULL
   LET g_tc_ogl[l_ac].imx06=NULL
   LET g_tc_ogl[l_ac].imx07=NULL
   LET g_tc_ogl[l_ac].imx08=NULL
   LET g_tc_ogl[l_ac].imx09=NULL
   LET g_tc_ogl[l_ac].imx10=NULL
   LET g_tc_ogl[l_ac].imx11=NULL
   LET g_tc_ogl[l_ac].imx12=NULL
   LET g_tc_ogl[l_ac].imx13=NULL
   LET g_tc_ogl[l_ac].imx14=NULL
   LET g_tc_ogl[l_ac].imx15=NULL
   LET g_tc_ogl[l_ac].imx16=NULL
   LET g_tc_ogl[l_ac].imx17=NULL
   LET g_tc_ogl[l_ac].imx18=NULL
   LET g_tc_ogl[l_ac].imx19=NULL
   LET g_tc_ogl[l_ac].imx20=NULL
   LET g_tc_ogl[l_ac].imx21=NULL
   LET g_tc_ogl[l_ac].imx21=NULL
   LET g_tc_ogl[l_ac].imx23=NULL
   LET g_tc_ogl[l_ac].imx24=NULL
   LET g_tc_ogl[l_ac].imx25=NULL
   LET g_tc_ogl[l_ac].ogl05=NULL
   LET g_tc_ogl[l_ac].ogl06=NULL
#   LET g_tc_ogl[l_ac].ogl07=NULL
END FUNCTION



#FUN-C40059--add---end----
