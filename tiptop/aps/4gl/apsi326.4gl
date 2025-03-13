# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: apsi326.4gl
# Descriptions...: APS替代作業維護
# Date & Author..: 08/06/26 By Duke No:FUN-860060 
# Modify.........: No:FUN-890012 08/09/03 BY DUKE 呼叫apsi312時增加傳遞參數委外否 vms13,並修正畫面增加人工機器工時等欄位
# Modify.........: No:TQC-880030 08/09/17 BY DUKE MOVE PRINT ACTION
# Modify.........: No:FUN-8C0008 08/12/03 BY DUKE apsi312 ADD vmn19 批量後置時間
# Modify.........: No:TQC-8C0016 08/12/09 BY Mandy (1)當系統參數設定有與APS整合時,單身畫面加show資源群組編號(機器)(vmn08)及資源群組編號(工作站)(vmn081)供使用者維護，維護時需判斷系統參數檔的資源型態,當資源型態為機器時,機器跟資源群組編號(機器)至少要有一個欄位有值.
#                                                  (2)維護資源群組編號(機器)及資源群組編號(工作站)時,需判斷vmn_file是否存在,若無存在則需insert,若有存在則需update
# Modify.........: NO.TQC-940088 09/04/16 BY destiny (1)g_sql時多寫了個from
#                                                    (2)after insert 時點退出時應該return
# Modify.........: No:FUN-960167 09/07/13 By Duke 資料異動時需同時修正 aeci100的 ecumodu 及 ecudate
# Modify.........: No:FUN-9A0047 09/10/20 By Mandy 當製程為委外時,不需要控管機器編號和資源群組編號(機器),至少要有一個欄位有值的限制
# Modify.........: No:TQC-9A0108 09/10/22 By Mandy (1)單身有資料,但是查詢時,無法show出來
#                                                  (2)進入單身時,出現Fetch i326_bcl 無此筆資料,或任何上下筆資料,或其他相關主檔資料 !
# Modify.........: No.FUN-A40060 10/04/23 By Mandy 作業編號異動時,需連動更新vmn_file
# Modify.........: No.FUN-B50101 11/05/18 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B80171 11/08/26 By Abby  增加action "APS指定工具(apsi331)"

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_ecb           RECORD LIKE ecb_file.*,   #製程資料
    g_ecb_t         RECORD LIKE ecb_file.*,
    g_ecb01_t       LIKE ecb_file.ecb01,
    g_type          LIKE type_file.chr1,     
    g_vms          DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        vms05      LIKE vms_file.vms05,    #項次
        vms06      LIKE vms_file.vms06,    #優先順序
        vms04      LIKE vms_file.vms04,    #作業編號
        ecd02      LIKE ecd_file.ecd02,    #作業名稱
        vms07      LIKE vms_file.vms07,    #FUN-890012 add
        eca02      LIKE eca_file.eca02,    #FUN-890012 add
        vmn081     LIKE vmn_file.vmn081,   #資源群組編號(工作站) #TQC-8C0016 add
        vms08      LIKE vms_file.vms08,    #FUN-890012 add
        vmn08      LIKE vmn_file.vmn08,    #資源群組編號(機器)    #TQC-8C0016 add
        vms10      LIKE vms_file.vms10,    #FUN-890012 add
        vms09      LIKE vms_file.vms09,    #FUN-890012 add
        vms12      LIKE vms_file.vms12,    #FUN-890012 add
        vms11      LIKE vms_file.vms11,    #FUN-890012 add
        vms13      LIKE vms_file.vms13     #FUN-890012 add
                    END RECORD,
   g_vms_t         RECORD  
        vms05      LIKE vms_file.vms05,    #項次
        vms06      LIKE vms_file.vms06,    #優先順序
        vms04      LIKE vms_file.vms04,    #作業編號
        ecd02      LIKE ecd_file.ecd02,    #作業名稱
        vms07      LIKE vms_file.vms07,    #FUN-890012 add
        eca02      LIKE eca_file.eca02,    #FUN-890012 add
        vmn081     LIKE vmn_file.vmn081,   #資源群組編號(工作站) #TQC-8C0016 add
        vms08      LIKE vms_file.vms08,    #FUN-890012 add
        vmn08      LIKE vmn_file.vmn08,    #資源群組編號(機器)    #TQC-8C0016 add
        vms10      LIKE vms_file.vms10,    #FUN-890012 add
        vms09      LIKE vms_file.vms09,    #FUN-890012add
        vms12      LIKE vms_file.vms12,    #FUN-890012 add
        vms11      LIKE vms_file.vms11,    #FUN-890012 add
        vms13      LIKE vms_file.vms13     #FUN-890012 add
                    END RECORD,
    g_wc,g_sql          STRING,      
    g_wc2               STRING,     
    g_argv1         LIKE ecb_file.ecb01,   #產品編號
    g_argv2         LIKE ecb_file.ecb02,   #製程序號
    g_argv3         LIKE ecb_file.ecb03,   #製程序
    g_argv4         LIKE ecb_file.ecb012,  #製程段號    #FUN-B50101 add
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
   #g_ecb_rowid     LIKE type_file.chr18                #FUN-B50101 mark
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL        
DEFINE g_before_input_done  LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_i            LIKE type_file.num5          
DEFINE g_msg          LIKE type_file.chr1000       
DEFINE g_row_count    LIKE type_file.num10         
DEFINE g_curs_index   LIKE type_file.num10         
DEFINE g_jump         LIKE type_file.num10         
DEFINE g_no_ask       LIKE type_file.num5      
DEFINE l_eci01        LIKE eci_file.eci01    
DEFINE l_sma917       LIKE sma_file.sma917    #FUN-890012
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       l_sql          STRING                                                    
DEFINE g_cmd          LIKE type_file.chr1000  #No.FUN-B80171 VARCHAR(100)

MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1 =ARG_VAL(1)              #產品編號
   LET g_argv2 =ARG_VAL(2)              #製程編號
   LET g_argv3 =ARG_VAL(3)              #製程序
   LET g_argv4 =ARG_VAL(4)              #製程段號 #FUN-B50101 add

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN  #No:FUN-860060
      EXIT PROGRAM
   END IF

   LET g_sql = "vms01.vms_file.vms01,",
               "vms02.vms_file.vms02,",
               "vms03.vms_file.vms03,",
               "vms05.vms_file.vms05,",     
               "vms06.vms_file.vms06,",
               "vms04.vms_file.vms04," 

   LET l_table = cl_prt_temptable('apsi326',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,                        
               " VALUES(?, ?, ?, ?, ?, ?) "                                     
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    

   LET g_ecb01_t = NULL
   LET g_ecb.ecb01 =g_argv1              #產品編號
   LET g_ecb.ecb02 =g_argv2              #製程編號
   LET g_ecb.ecb03 =g_argv3              #製程序
   LET g_ecb.ecb012=g_argv4              #製程段號 #FUN-B50101 add

   OPEN WINDOW i326_w WITH FORM "aps/42f/apsi326"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    CALL cl_set_comp_visible("ecb012",g_sma.sma541='Y')  #FUN-B50101 add
   
   #TQC-8C0016---mark---str---
   #改為:
   ##整體參數資源型態設機器時,機器編號vms08和資源群組編號(機器)vmn08至少要有一個欄位有值
   ##FUN-890012  add l_sma917 判斷 APS資源型態
   # LET l_sma917 = NULL
   # SELECT sma917 into l_sma917  FROM  sma_file
   #    IF l_sma917='1'  THEN
   #       CALL cl_set_comp_required("vms08",TRUE)
   #    ELSE
   #       CALL cl_set_comp_required("vms08",FALSE)  
   #    END IF
   #TQC-8C0016---mark---end---
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' '
      AND g_argv2 IS NOT NULL AND g_argv2 != ' '
      AND g_argv3 IS NOT NULL AND g_argv3 != ' ' 
      AND g_argv4 IS NOT NULL THEN  #FUN-B50101 add
      CALL i326_q()
      CALL i326_menu()
    ELSE
      LET g_type = '1'
      CALL i326_menu()
    END IF

    CLOSE WINDOW i326_w                 #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0100
END MAIN

#QBE 查詢資料
FUNCTION i326_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_vms.clear()

 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '
 THEN
    CALL cl_set_head_visible("","YES")    

    INITIALIZE g_ecb.ecb01 TO NULL        #No.TQC-740341
   INITIALIZE g_ecb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          ecb01,ecb02,ecb03,ecb012        #FUN-B50101 add ecb012
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(ecb01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_ima"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ecb01
                   NEXT FIELD ecb01
              #TQC-8C0016---add----str---
              WHEN INFIELD(vmn08)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form  ="q_vme01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vmn08
                   NEXT FIELD vmn08
              WHEN INFIELD(vmn081)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form ="q_vmp01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO vmn081
                   NEXT FIELD vmn081
              #TQC-8C0016---add----end---
              OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No:FUN-580031 --end--       HCN
    END CONSTRUCT
 ELSE DISPLAY BY NAME g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 add ecb012
      LET g_wc = " ecb01 ='",g_ecb.ecb01,"' AND ecb02 = '",g_ecb.ecb02,"' AND ",
                 " ecb03 ='",g_ecb.ecb03,"' ",
                 " AND ecb012 = '",g_ecb.ecb012,"'" #FUN-B50101 add ecb012
 END IF
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND ecbuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND ecbgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND ecbgrup IN ",cl_chk_tgrup_list()
    END IF

 IF g_argv1 IS NULL OR g_argv1 = ' '  OR
    g_argv2 IS NULL OR g_argv2 = ' '  OR
    g_argv3 IS NULL OR g_argv3 = ' '  OR
    g_argv4 IS NULL #FUN-B50101 add
 THEN
   CONSTRUCT g_wc2 ON vms05,vms06,vms04                 # 螢幕上取單身條件
            FROM s_vms[1].vms05,s_vms[1].vms06,s_vms[1].vms04
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)

      ON ACTION controlp                        #
         CASE
           WHEN INFIELD(vms04)
             CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO vms04
             NEXT FIELD vms04
           #FUN-890012 ADD
            WHEN INFIELD(vms08)                 #機械編號
              CALL cl_init_qry_var()
              LET g_qryparam.state    = "c"
              LET g_qryparam.form = "q_eci"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO vms08
              NEXT FIELD vms08
            WHEN INFIELD(vms07)
              CALL q_eca(TRUE,TRUE,'') RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO vms07
              NEXT FIELD vms07

         END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
   END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 ELSE LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb012 FROM ecb_file ", #FUN-B50101 拿掉ROWID,add ecb012
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 2,3,4"
     ELSE					# 若單身有輸入條件
      #LET g_sql = "SELECT ROWID,ecb01,ecb02,ecb03 FROM ecb_file ",           #No.TQC-940088
       LET g_sql = "SELECT ecb01,ecb02,ecb03,ecb012  ",                       #No.TQC-940088  #FUN-B50101 拿掉ROWID,add ecb012
                   "  FROM ecb_file, vms_file ",
                   " WHERE ecb01 = vms01 ",
                   "   AND ecb02 = vms02 ",
                   "   AND ecb03 = trim(vms03) ",
                   "   AND ecb012 = vms012 ", #FUN-B50101 add
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 2,3,4"
    END IF

    PREPARE i326_prepare FROM g_sql
    DECLARE i326_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i326_prepare

    LET g_forupd_sql = "SELECT * FROM ecb_file ",
                      #"WHERE ecb01 = ? AND ecb02 = ? AND ecb03 = ? FOR UPDATE NOWAIT"  #FUN-B50101 mark
                       "WHERE ecb01 = ? AND ecb02 = ? AND ecb03 = ? AND ecb012 = ? FOR UPDATE "        #FUN-B50101 add

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50101

    DECLARE i326_cl CURSOR FROM g_forupd_sql

    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       #LET g_sql="SELECT COUNT(*) FROM ecb_file WHERE ",g_wc CLIPPED                        #FUN-B50101 mark
        LET g_sql="SELECT UNIQUE ecb01,ecb02,ecb03,ecb012 FROM ecb_file WHERE ",g_wc CLIPPED #FUN-B50101 add
    ELSE
       #LET g_sql="SELECT COUNT(*) FROM ecb_file,vms_file ",                                 #FUN-B50101 mark
        LET g_sql="SELECT UNIQUE ecb01,ecb02,ecb03,ecb012 FROM ecb_file,vms_file ",          #FUN-B50101 add
                  " WHERE ecb01 = vms01 ",
                  "   AND ecb02 = vms02 ",
                  "   AND ecb03 = trim(vms03) ",
                  "   AND ecb012 = vms012 ", #FUN-B50101 add 
                  "   AND ",g_wc  CLIPPED,
                  "   AND ",g_wc2 CLIPPED
    END IF
    #FUN-B50101 add---str---
    LET g_sql = g_sql CLIPPED," GROUP BY ecb01,ecb02,ecb03,ecb012 ",
                " INTO TEMP x "
    DROP TABLE x
    PREPARE i326_precount_x FROM g_sql
    EXECUTE i326_precount_x

    LET g_sql="SELECT COUNT(*) FROM x "
    #FUN-B50101 add---end---

    PREPARE i326_precount FROM g_sql
    DECLARE i326_count CURSOR FOR i326_precount

END FUNCTION

FUNCTION i326_menu()

   WHILE TRUE
      CALL i326_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i326_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i326_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vms),'','')
            END IF

        #串apsi312
        WHEN "aps_related_data_aps_vms"
            #TQC-8C0016 mod---str---
            IF cl_chk_act_auth() THEN
               CALL i326_aps_vms('Y') 
            END IF
            #TQC-8C0016 mod---end---

       #FUN-B80171 add str---
       #串apsi331
        WHEN "aps_route_tools"
           IF l_ac>0 THEN
              CALL i326_aps_vnm()
           ELSE
              CALL cl_err('',-400,0)
           END IF
       #FUN-B80171 add end---

##
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_ecb.ecb01 IS NOT NULL THEN
                LET g_doc.column1 = "ecb01"
                LET g_doc.column2 = "ecb02"
                LET g_doc.column3 = "ecb03"
                LET g_doc.column4 = "ecb012"    #FUN-B50101 add
                LET g_doc.value1 = g_ecb.ecb01
                LET g_doc.value2 = g_ecb.ecb02
                LET g_doc.value3 = g_ecb.ecb03
                LET g_doc.value4 = g_ecb.ecb012 #FUN-B50101 add
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION

#Query 查詢
FUNCTION i326_q()

    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vms.clear()
    CALL i326_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i326_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ecb.ecb01 TO NULL
    ELSE
        CALL i326_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i326_count
        FETCH i326_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION

#處理資料的讀取
FUNCTION i326_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     i326_cs INTO g_ecb.ecb01, g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 拿掉rowid,add ecb012
        WHEN 'P' FETCH PREVIOUS i326_cs INTO g_ecb.ecb01, g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 拿掉rowid,add ecb012
        WHEN 'F' FETCH FIRST    i326_cs INTO g_ecb.ecb01, g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 拿掉rowid,add ecb012
        WHEN 'L' FETCH LAST     i326_cs INTO g_ecb.ecb01, g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 拿掉rowid,add ecb012
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i326_cs INTO g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 拿掉rowid,add ecb012
            LET g_no_ask = FALSE
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ecb.ecb01,SQLCA.sqlcode,0)
        INITIALIZE g_ecb.* TO NULL  #TQC-6B0105
       #LET g_ecb_rowid = NULL      #TQC-6B0105 #FUN-B50101 mark
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
    SELECT * INTO g_ecb.* FROM ecb_file 
    #FUN-B50101---mod---str---
    #WHERE ROWID = g_ecb_rowid
     WHERE ecb01 = g_ecb.ecb01
       AND ecb02 = g_ecb.ecb02
       AND ecb03 = g_ecb.ecb03
       AND ecb012= g_ecb.ecb012
    #FUN-B50101---mod---end---
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
        INITIALIZE g_ecb.* TO NULL
        RETURN
#FUN-4C0034
    ELSE
        LET g_data_owner = g_ecb.ecbuser      #FUN-4C0034
        LET g_data_group = g_ecb.ecbgrup      #FUN-4C0034
        CALL i326_show()
    END IF
##
END FUNCTION

#將資料顯示在畫面上
FUNCTION i326_show()
    DEFINE l_ima02  LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_eca02  LIKE eca_file.eca02 #MOD-580067

    LET g_ecb_t.* = g_ecb.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 add ecb012

    CALL i326_b_fill(g_wc2)                 #單身

    CALL cl_show_fld_cont()                   
END FUNCTION
#單身
FUNCTION i326_b()
DEFINE  l_cnt_vmn   LIKE type_file.num5          #FUN-A40060 add
DEFINE  l_cnt       LIKE type_file.num5          #No.TQC-8C0016
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    l_sw_aps        LIKE type_file.num5,    #No.FUN-9A0047 add
    p_cmd           LIKE type_file.chr1,    #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否        #No.FUN-680073 SMALLINT
    l_sma917        LIKE sma_file.sma917    #FUN-890012

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_ecb.ecb01) OR cl_null(g_ecb.ecb02)
       OR cl_null(g_ecb.ecb03) 
       OR g_ecb.ecb012 IS NULL THEN #FUN-B50101 add ecb012
       RETURN
    END IF

    CALL cl_opmsg('b')

    #FUN-890012  add vms07,vms08,vms09,vms10,vms11,vms12
   #TQC-8C0016--mod---str---
   #LET g_forupd_sql = "SELECT vms05,vms06,vms04,ecd02,vms07,eca02,vms08,vms10,vms09,vms12,vms11,vms13 FROM vms_file,ecd_file,eca_file ",
   #LET g_forupd_sql = "SELECT vms05,vms06,vms04,ecd02,vms07,eca02,'',vms08,'',vms10,vms09,vms12,vms11,vms13 FROM vms_file,ecd_file,eca_file ",    
    LET g_forupd_sql = "SELECT vms05,vms06,vms04,''   ,vms07,''   ,'',vms08,'',vms10,vms09,vms12,vms11,vms13 FROM vms_file ",    
   #TQC-8C0016--mod---end---
                      #" WHERE vms04=ecd01 AND vms07=eca01 AND vms01= ? AND vms02 = ? ",  #TQC-9A0108 mark
                       " WHERE vms01= ? ",        #TQC-9A0108 add
                       "   AND vms02= ? ",        #TQC-9A0108 add
                       "   AND vms03= trim(?) ",
                       "   AND vms012= ? ", #FUN-B50101 add
                       "   AND vms05= ? ",
                      #"   AND vms06= ? AND vms04 = ? FOR UPDATE NOWAIT" #TQC-9A0108 mark
                       "   FOR UPDATE "                            #TQC-9A0108 add #FUN-B50101 mark
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql) #FUN-B50101 add
    DECLARE i326_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_vms WITHOUT DEFAULTS FROM s_vms.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK

            OPEN i326_cl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012 #FUN-B50101 add ecb012
            IF STATUS THEN
               CALL cl_err("OPEN i326_cl_b:", STATUS, 1)
               CLOSE i326_cl
               ROLLBACK WORK
               RETURN
            END IF

            FETCH i326_cl INTO g_ecb.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('Fetch i326_cl_b',SQLCA.sqlcode,1)
               CLOSE i326_cl
               ROLLBACK WORK
               RETURN
            END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_vms_t.* = g_vms[l_ac].*  #BACKUP

               OPEN i326_bcl USING g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012,  #FUN-B50101 add ecb012
                                  #g_vms_t.vms05,g_vms_t.vms06,g_vms_t.vms04 #TQC-9A0108 mark
                                   g_vms_t.vms05                             #TQC-9A0108 add

               IF STATUS THEN
                  CALL cl_err("OPEN i326_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i326_bcl INTO g_vms[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch i326_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vms_t.*=g_vms[l_ac].*
                  END IF
               END IF
               #TQC-8C0016---add---str---
               SELECT vmn08,vmn081 
                 INTO g_vms[l_ac].vmn08,g_vms[l_ac].vmn081
                 FROM vmn_file
                WHERE vmn01 = g_ecb.ecb01
                  AND vmn02 = g_ecb.ecb02
                  AND vmn03 = g_ecb.ecb03
                  AND vmn012= g_ecb.ecb012 #FUN-B50101 add
                  AND vmn04 = g_vms[l_ac].vms04
               #TQC-8C0016---add---end---
               #TQC-9A0108 ---add----str----
               SELECT ecd02 INTO g_vms[l_ac].ecd02
                 FROM ecd_file
                WHERE ecd01 = g_vms[l_ac].vms04

               SELECT eca02 INTO g_vms[l_ac].eca02
                 FROM eca_file
                WHERE eca01 = g_vms[l_ac].vms07
               #TQC-9A0108 ---add----end----
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vms[l_ac].* TO NULL      #900423
            #FUN-890012 
            LET g_vms[l_ac].vms09 = 0
            LET g_vms[l_ac].vms10 = 0
            LET g_vms[l_ac].vms11 = 0
            LET g_vms[l_ac].vms12 = 0
            LET g_vms[l_ac].vms13 = 'N'

            LET g_vms_t.* = g_vms[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD vms05

        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT                               #No.TQC-940088
            END IF
           #TQC-8C0016---mark---str---
           ##FUN-890012  add l_sma917 判斷 APS資源型態
           #LET l_sma917 = NULL
           #SELECT sma917 into l_sma917  FROM  sma_file
           #IF l_sma917='1' and cl_null(g_vms[l_ac].vms08) THEN
           #   CALL cl_err('','aps-723',1)
           #   RETURN
           #END IF
           #TQC-8C0016---mark---end---
          #FUN-9A0047 mark--str---
          ##TQC-8C0016---add----str--
          #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
          #    IF g_vms[l_ac].vms13 = 'N' THEN #FUN-9A0047 add if 判斷
          #        IF cl_null(g_vms[l_ac].vms08) AND cl_null(g_vms[l_ac].vmn08) THEN
          #            #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
          #            CALL cl_err('','aps-033',1) 
          #            LET g_vms[l_ac].* = g_vms_t.*
          #            CANCEL INSERT
          #        END IF #FUN-9A0047 add
          #    END IF
          #END IF
          ##TQC-8C0016---add----end--
          #FUN-9A0047 mark--end---

            INSERT INTO vms_file(vms01,vms02,vms03,vms012,vms05,vms06,vms04,vms07,vms08,vms09,vms10,vms11,vms12,vms13) #FUN-B50101 add vms012
                           VALUES(g_ecb.ecb01,g_ecb.ecb02,g_ecb.ecb03,g_ecb.ecb012, #FUN-B50101 add ecb012
                                  g_vms[l_ac].vms05,g_vms[l_ac].vms06,
                                  g_vms[l_ac].vms04,g_vms[l_ac].vms07,
                                  g_vms[l_ac].vms08,g_vms[l_ac].vms09,
                                  g_vms[l_ac].vms10,g_vms[l_ac].vms11,
                                  g_vms[l_ac].vms12,g_vms[l_ac].vms13)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_vms[l_ac].vms05,SQLCA.sqlcode,0) #No.FUN-660091
                CALL cl_err3("ins","vms_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
                CANCEL INSERT
            ELSE
               #FUN-960167 ADD --STR---------------------------------
                UPDATE ecu_file SET ecumodu=g_user, ecudate=g_today
                 WHERE ecu01 = g_ecb.ecb01
                   AND ecu02 = g_ecb.ecb02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ecu_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL INSERT
                END IF
                UPDATE ecb_file SET ecbmodu=g_user, ecbdate=g_today
                 WHERE ecb01 = g_ecb.ecb01
                   AND ecb02 = g_ecb.ecb02
                   AND ecb03 = g_ecb.ecb03
                   AND ecb012= g_ecb.ecb012 #FUN-B50101 add ecb012
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL INSERT
                END IF
               #FUN-960167 ADD --END---------------------------------
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            #TQC-8C0016 add---str---
            CALL i326_aps_vms('N') 
            #TQC-8C0016 add---end---
 
        BEFORE FIELD vms05                        # dgeeault 序號
            IF g_vms[l_ac].vms05 IS NULL OR g_vms[l_ac].vms05 = 0 THEN
               SELECT max(vms05)+1 INTO g_vms[l_ac].vms05 FROM vms_file
                WHERE vms01 = g_ecb.ecb01
                  AND vms02 = g_ecb.ecb02
                  AND vms03 = g_ecb.ecb03
                  AND vms012= g_ecb.ecb012 #FUN-B50101 add 
               IF g_vms[l_ac].vms05 IS NULL THEN
                  LET g_vms[l_ac].vms05 = 1
               END IF
            END IF

        AFTER FIELD vms05                        #check 序號是否重複
            IF NOT cl_null(g_vms[l_ac].vms05) THEN
               IF (g_vms[l_ac].vms05 != g_vms_t.vms05 OR
                   g_vms_t.vms05 IS NULL) THEN
                   SELECT count(*) INTO l_n FROM vms_file
                    WHERE vms01 = g_ecb.ecb01
                      AND vms02 = g_ecb.ecb02
                      AND vms03 = g_ecb.ecb03
                      AND vms012= g_ecb.ecb012 #FUN-B50101 add 
                      AND vms05 = g_vms[l_ac].vms05
                   IF l_n > 0 THEN
                      CALL cl_err(g_vms[l_ac].vms05,-239,0)
                      LET g_vms[l_ac].vms05 = g_vms_t.vms05
                      NEXT FIELD vms05
                   END IF
               END IF
               IF g_vms[l_ac].vms05 <=0 THEN
                  CALL cl_err('','aec-994',0)
                  NEXT FIELD vms05
               END IF
            END IF


        AFTER FIELD vms06  #check 優先順序是否重複
            IF NOT cl_null(g_vms[l_ac].vms06) THEN
            IF (g_vms[l_ac].vms06 != g_vms_t.vms06 OR
                  g_vms_t.vms06 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM vms_file
                   WHERE vms01 = g_ecb.ecb01
                     AND vms02 = g_ecb.ecb02
                     AND vms03 = g_ecb.ecb03
                     AND vms012= g_ecb.ecb012 #FUN-B50101 add 
                     AND vms06 = g_vms[l_ac].vms06
                  IF l_n > 0 THEN
                     CALL cl_err(g_vms[l_ac].vms06,-239,0)
                     LET g_vms[l_ac].vms06 = g_vms_t.vms06
                     NEXT FIELD vms06
                  END IF
              END IF
              IF g_vms[l_ac].vms06 <=0 THEN
                 CALL cl_err('','aec-994',0)
                 NEXT FIELD vms06
              END IF
            END IF

         #FUN-890012   判斷工時不得小於0且需為數值型態
         AFTER FIELD vms09
            IF NOT cl_null(g_vms[l_ac].vms09) THEN
               IF g_vms[l_ac].vms09 < 0 THEN
                  CALL cl_err(g_vms[l_ac].vms09,'anm-249',0)
                  NEXT FIELD vms09
               END IF
            END IF 
            
          AFTER FIELD vms10
             IF NOT cl_null(g_vms[l_ac].vms10) THEN
                IF g_vms[l_ac].vms10 < 0 THEN
                   CALL cl_err(g_vms[l_ac].vms10,'anm-249',0)
                   NEXT FIELD vms10
                END IF
             END IF

          AFTER FIELD vms11
             IF NOT cl_null(g_vms[l_ac].vms11) THEN
                IF g_vms[l_ac].vms11 < 0 THEN
                   CALL cl_err(g_vms[l_ac].vms11,'anm-249',0)
                   NEXT FIELD vms11
                END IF
             END IF
             

          AFTER FIELD vms12
             IF NOT cl_null(g_vms[l_ac].vms12) THEN
                IF g_vms[l_ac].vms12 < 0 THEN
                   CALL cl_err(g_vms[l_ac].vms12,'anm-249',0)
                   NEXT FIELD vms12
                END IF
             END IF


         AFTER FIELD vms04 #check 作業編號是否重複
             IF NOT cl_null(g_vms[l_ac].vms04) THEN
                CALL i326_vms04(p_cmd)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_vms[l_ac].vms04 = g_vms_t.vms04
                   DISPLAY BY NAME g_vms[l_ac].vms04
                   NEXT FIELD vms04
                END IF
             END IF

             IF NOT cl_null(g_vms[l_ac].vms04) THEN
             IF (g_vms[l_ac].vms04 != g_vms_t.vms04 OR
                  g_vms_t.vms04 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM vms_file
                   WHERE vms01 = g_ecb.ecb01
                     AND vms02 = g_ecb.ecb02
                     AND vms03 = g_ecb.ecb03
                     AND vms012= g_ecb.ecb012 #FUN-B50101 add 
                     AND vms04 = g_vms[l_ac].vms04
                  IF l_n > 0 THEN
                     CALL cl_err(g_vms[l_ac].vms04,-239,0)
                     LET g_vms[l_ac].vms04 = g_vms_t.vms04
                     NEXT FIELD vms04
                  END IF
                  SELECT count(*) INTO l_n FROM ecb_file
                   WHERE ecb01=g_ecb.ecb01
                     AND ecb02=g_ecb.ecb02
                     AND ecb03=g_ecb.ecb03
                     AND ecb012=g_ecb.ecb012 #FUN-B50101 add 
                     AND ecb06=g_vms[l_ac].vms04
                  IF l_n > 0 THEN
                     CALL cl_err('','aps-703',1)
                     LET g_vms[l_ac].vms04 = g_vms_t.vms04
                     NEXT FIELD vms04
                  END IF
                  #FUN-A40060--add---str---
                  IF NOT cl_null(g_vms_t.vms04) AND 
                     g_vms[l_ac].vms04 != g_vms_t.vms04 THEN
                       #==>APS途程製程
                       LET l_cnt_vmn = 0
                       SELECT COUNT(*) INTO l_cnt_vmn
                         FROM vmn_file
                        WHERE vmn01 = g_ecb.ecb01
                          AND vmn02 = g_ecb.ecb02
                          AND vmn04 = g_vms_t.vms04
                       IF l_cnt_vmn >=1 THEN
                           UPDATE vmn_file
                              SET vmn04 = g_vms[l_ac].vms04
                            WHERE vmn01 = g_ecb.ecb01
                              AND vmn02 = g_ecb.ecb02
                              AND vmn04 = g_vms_t.vms04
                           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                               CALL cl_err3("upd","vmn_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) 
                               LET g_vms[l_ac].vms04 = g_vms_t.vms04
                               NEXT FIELD vms04
                           END IF
                       END IF
                  END IF
                  #FUN-A40060--add---str---
              END IF
            END IF

        #FUN-890012  判斷工作站及機器編號是否正確
        AFTER FIELD vms07
           IF NOT cl_null(g_vms[l_ac].vms07)  THEN
              CALL i306_vms07('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_vms[l_ac].vms07 = g_vms_t.vms07
                 DISPLAY BY NAME g_vms[l_ac].vms07
                 NEXT FIELD vms07
              END IF
           ELSE
              NEXT FIELD vms07 
           END IF
        #TQC-8C0016---add---str---
        #有串APS時:
        #整體參數資源型態設機器時,機器編號vms08和資源群組編號(機器)vmn08至少要有一個欄位有值
        AFTER FIELD vmn08
            IF NOT cl_null(g_vms[l_ac].vmn08) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vme_file
                 WHERE vme01 = g_vms[l_ac].vmn08
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-404',1)
                    LET g_vms[l_ac].vmn08 = g_vms_t.vmn08
                    DISPLAY BY NAME g_vms[l_ac].vmn08
                    NEXT FIELD vmn08
                END IF
            END IF
           #FUN-9A0047 mark---str---
           #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
           #    IF cl_null(g_vms[l_ac].vms08) AND cl_null(g_vms[l_ac].vmn08) THEN
           #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
           #        CALL cl_err('','aps-033',1) 
           #        NEXT FIELD vms08
           #    END IF
           #END IF
           #FUN-9A0047 mark---end---
        AFTER FIELD vmn081
            IF NOT cl_null(g_vms[l_ac].vmn081) THEN
                SELECT COUNT(*) INTO l_cnt
                  FROM vmp_file
                 WHERE vmp01 = g_vms[l_ac].vmn081
                IF l_cnt = 0 THEN
                    CALL cl_err('','aps-405',1)
                    LET g_vms[l_ac].vmn081 = g_vms_t.vmn081
                    DISPLAY BY NAME g_vms[l_ac].vmn081
                    NEXT FIELD vmn081
                END IF
            END IF
        #TQC-8C0016---add---end---

        AFTER FIELD vms08
           IF NOT cl_null(g_vms[l_ac].vms08) THEN
              SELECT eci01 INTO l_eci01 FROM eci_file
                WHERE eci01 =  g_vms[l_ac].vms08
              IF STATUS THEN
                 CALL cl_err3("sel","eci_file",g_vms[l_ac].vms08,"","aec-011","","",1) 
              NEXT FIELD vms08
              END IF
           END IF
           #FUN-890012  add l_sma917 判斷 APS資源型態
           #LET l_sma917 = NULL
           #SELECT sma917 into l_sma917  FROM  sma_file
           #IF l_sma917='1' and cl_null(g_vms[l_ac].vms08) THEN
           #   CALL cl_err('','aps-723',1)
           #   NEXT FIELD vms08
           #END IF



        BEFORE DELETE                            #是否取消單身
            IF g_vms_t.vms05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) then
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vms_file
                 WHERE vms01 = g_ecb.ecb01 
                   AND vms02 = g_ecb.ecb02
                   AND vms03 = g_ecb.ecb03 
                   AND vms012= g_ecb.ecb012  #FUN-B50101 add
                   AND vms05 = g_vms_t.vms05
                   
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vms_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF

                DELETE FROM vmn_file
                WHERE vmn01 = g_ecb.ecb01 
                  AND vmn02 = g_ecb.ecb02
                  AND vmn03 = g_ecb.ecb03 
                  AND vmn012= g_ecb.ecb012  #FUN-B50101 add
                  AND vmn04 = g_vms_t.vms04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vmn_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF

               #FUN-B80171 add str---
                DELETE FROM vnm_file
                 WHERE vnm00 = g_ecb.ecb01 AND vnm01 = g_ecb.ecb02
                   AND vnm02 = g_ecb.ecb03 AND vnm03= g_vms_t.vms04
                   AND vnm012 = g_ecb.ecb012
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vnm_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
               #FUN-B80171 add end---

                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2

               #FUN-960167 ADD --STR---------------------------------
                UPDATE ecu_file SET ecumodu=g_user, ecudate=g_today
                 WHERE ecu01 = g_ecb.ecb01
                   AND ecu02 = g_ecb.ecb02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ecu_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                UPDATE ecb_file SET ecbmodu=g_user, ecbdate=g_today
                 WHERE ecb01 = g_ecb.ecb01
                   AND ecb02 = g_ecb.ecb02
                   AND ecb03 = g_ecb.ecb03
                   AND ecb012= g_ecb.ecb012 #FUN-B50101 add
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
               #FUN-960167 ADD --END---------------------------------

                COMMIT WORK
             END IF

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vms[l_ac].* = g_vms_t.*
               CLOSE i326_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #TQC-8C0016---mark---str---
           ##FUN-890012  add l_sma917 判斷 APS資源型態
           #LET l_sma917 = NULL
           #SELECT sma917 into l_sma917  FROM  sma_file
           #IF l_sma917='1' and cl_null(g_vms[l_ac].vms08) THEN
           #   CALL cl_err('','aps-723',0)
           #   NEXT FIELD vms08
           #END IF
           #TQC-8C0016---mark---end---
          #FUN-9A0047 --mark---str----
          ##TQC-8C0016---add----str--
          #IF NOT cl_null(g_sma.sma917) AND g_sma.sma917 = 1 THEN
          #    IF cl_null(g_vms[l_ac].vms08) AND cl_null(g_vms[l_ac].vmn08) THEN
          #        #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
          #        CALL cl_err('','aps-033',1) 
          #        LET g_vms[l_ac].* = g_vms_t.*
          #        CLOSE i326_bcl
          #        ROLLBACK WORK
          #        EXIT INPUT
          #    END IF
          #END IF
          ##TQC-8C0016---add----end--
          #FUN-9A0047 --mark---end----
           



            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vms[l_ac].vms05,-263,1)
               LET g_vms[l_ac].* = g_vms_t.*
            ELSE
               #FUN-890012 add vms07∼vms13
               UPDATE vms_file SET vms05=g_vms[l_ac].vms05,
                                    vms06=g_vms[l_ac].vms06,
                                    vms04=g_vms[l_ac].vms04,
                                    vms07=g_vms[l_ac].vms07,
                                    vms08=g_vms[l_ac].vms08,
                                    vms09=g_vms[l_ac].vms09,
                                    vms10=g_vms[l_ac].vms10,
                                    vms11=g_vms[l_ac].vms11,
                                    vms12=g_vms[l_ac].vms12,
                                    vms13=g_vms[l_ac].vms13
                WHERE vms01=g_ecb.ecb01 
                  AND vms02 = g_ecb.ecb02 
                  AND vms03 = g_ecb.ecb03 
                  AND vms012= g_ecb.ecb012   #FUN-B50101 add
                  AND vms05 = g_vms_t.vms05
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_vms[l_ac].vms05,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("upd","vms_file",g_ecb.ecb01,g_vms_t.vms05,SQLCA.sqlcode,"","",1) #FUN-660091
                   LET g_vms[l_ac].* = g_vms_t.*
                   ROLLBACK WORK       #FUN-960167 ADD
               ELSE
                   #TQC-8C0016 add---str---
                   UPDATE vmn_file
                      SET vmn08  = g_vms[l_ac].vmn08,
                          vmn081 = g_vms[l_ac].vmn081
                    WHERE vmn01 = g_ecb.ecb01
                      AND vmn02 = g_ecb.ecb02
                      AND vmn03 = g_ecb.ecb03
                      AND vmn012= g_ecb.ecb012  #FUN-B50101 add
                      AND vmn04 = g_vms[l_ac].vms04
                   IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","vmn_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1) 
                       LET g_vms[l_ac].* = g_vms_t.*
                       ROLLBACK WORK   #FUN-960167 ADD
                   ELSE
                      #FUN-960167 ADD --STR---------------------------------
                      UPDATE ecu_file SET ecumodu=g_user, ecudate=g_today
                       WHERE ecu01 = g_ecb.ecb01
                         AND ecu02 = g_ecb.ecb02
                      #No.FUN-B80053--增加空白行---
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","ecu_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                         ROLLBACK WORK
                      ELSE
                          UPDATE ecb_file SET ecbmodu=g_user, ecbdate=g_today
                           WHERE ecb01 = g_ecb.ecb01
                             AND ecb02 = g_ecb.ecb02
                             AND ecb03 = g_ecb.ecb03
                             AND ecb012= g_ecb.ecb012  #FUN-B50101 add
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","ecb_file",g_ecb.ecb01,g_ecb.ecb02,SQLCA.sqlcode,"","",1)
                             ROLLBACK WORK
                          ELSE
                             MESSAGE 'UPDATE O.K'
                             COMMIT WORK
                          END IF
                      END IF
                      #FUN-960167 ADD --END---------------------------------
                   END IF
                   #TQC-8C0016 add---end---
               END IF
            END IF

        #FUN-9A0047 add---str---
        AFTER INPUT
        IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
            CALL i326_chk_aps() RETURNING l_sw_aps
            IF l_sw_aps THEN
                CONTINUE INPUT
            END IF
        END IF
        #FUN-9A0047 add---end---

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_vms[l_ac].* = g_vms_t.*
               END IF
               CLOSE i326_bcl
               ROLLBACK WORK
               #FUN-9A0047 add---str---
               IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
                   CONTINUE INPUT
               END IF
               #FUN-9A0047 add---end---
               EXIT INPUT
            END IF
            CLOSE i326_bcl
            COMMIT WORK

        ON ACTION controlp                        #
           CASE
             WHEN INFIELD(vms04)
                  CALL q_ecd(FALSE,TRUE,g_vms[l_ac].vms04)
                       RETURNING g_vms[l_ac].vms04
                   DISPLAY BY NAME g_vms[l_ac].vms04      #No:MOD-490371
                  NEXT FIELD vms04
             #FUN-890012  add
             WHEN INFIELD(vms08)                 #機械編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_eci"
                  LET g_qryparam.default1 = g_vms[l_ac].vms08
                  CALL cl_create_qry() RETURNING g_vms[l_ac].vms08
                  DISPLAY BY NAME g_vms[l_ac].vms08     
                  NEXT FIELD vms08
             WHEN INFIELD(vms07)                #工作站
                  CALL q_eca(FALSE,FALSE,g_vms[l_ac].vms07)
                  RETURNING g_vms[l_ac].vms07
                  DISPLAY BY NAME  g_vms[l_ac].vms07    
                  NEXT FIELD vms07
             #TQC-8C0016---add----str---
             WHEN INFIELD(vmn08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_vme01"
                  CALL cl_create_qry() RETURNING g_vms[l_ac].vmn08
                  DISPLAY BY NAME g_vms[l_ac].vmn08
                  NEXT FIELD vmn08
             WHEN  INFIELD(vmn081)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_vmp01"
                   CALL cl_create_qry() RETURNING g_vms[l_ac].vmn081
                   DISPLAY BY NAME g_vms[l_ac].vmn081
                   NEXT FIELD vmn081
             #TQC-8C0016---add----end---

           END CASE


        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vms05) AND l_ac > 1 THEN
                LET g_vms[l_ac].* = g_vms[l_ac-1].*
                DISPLAY g_vms[l_ac].* TO s_vms[l_ac].*
                NEXT FIELD vms05
            END IF

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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT

    CLOSE i326_bcl
    COMMIT WORK

END FUNCTION
 
FUNCTION i326_b_askkey()
DEFINE
    l_wc       LIKE type_file.chr1000           #No.FUN-680073 VARCHAR(200)

    CONSTRUCT l_wc ON vms05,vms06,vms04             #螢幕上取條件
       FROM s_vms[1].vms05,s_vms[1].vms06,s_vms[1].vms04
       BEFORE CONSTRUCT
          CALL cl_qbe_init()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No:FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i326_b_fill(l_wc)
END FUNCTION

FUNCTION i326_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,  #No.FUN-680073 VARCHAR(300)
    l_flag          LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)

    #FUN-890012  add  vms07,vms08,vms09,vms10,vms11,vms12,vms13
    LET g_sql =
       #TQC-8C0016---mod---str---
       #"SELECT vms05,vms06,vms04,ecd02,vms07,eca02,vms08,vms10,vms09,vms12,vms11,vms13 FROM vms_file,ecd_file,eca_file ",
        "SELECT vms05,vms06,vms04,ecd02,vms07,eca02,'',vms08,'',vms10,vms09,vms12,vms11,vms13 ",
        "  FROM vms_file,OUTER ecd_file,OUTER eca_file ", #TQC-9A0108 mod 
       #TQC-8C0016---mod---str---
        " WHERE vms04 = ecd_file.ecd01 ",
        "   AND vms07 = eca_file.eca01 ",
        "   AND vms01 = '",g_ecb.ecb01,"'",
        "   AND vms02 = '",g_ecb.ecb02,"'",
        "   AND vms03 = trim('",g_ecb.ecb03,"') ",
        "   AND vms012= '",g_ecb.ecb012,"'", #FUN-B50101 add
        "   AND ", p_wc2 CLIPPED,            #單身
        "  ORDER BY 1"
    PREPARE i326_pb FROM g_sql
    DECLARE vms_cs CURSOR FOR i326_pb            #SCROLL CURSOR
 
    CALL g_vms.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vms_cs INTO g_vms[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #TQC-8C0016---add---str---
        SELECT vmn08,vmn081 
          INTO g_vms[g_cnt].vmn08,g_vms[g_cnt].vmn081
          FROM vmn_file
         WHERE vmn01 = g_ecb.ecb01
           AND vmn02 = g_ecb.ecb02
           AND vmn03 = g_ecb.ecb03
           AND vmn012= g_ecb.ecb012 #FUN-B50101 add
           AND vmn04 = g_vms[g_cnt].vms04
        #TQC-8C0016---add---end---
        LET g_cnt = g_cnt + 1

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_vms.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1

    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION

FUNCTION i326_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vms TO s_vms.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

      #TQC-880030 MARK
      #ON ACTION output
      #     LET g_action_choice="output"
      #     EXIT DISPLAY

      ON ACTION first
         CALL i326_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 

      ON ACTION previous
         CALL i326_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 

      ON ACTION jump
         CALL i326_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 

      ON ACTION next
         CALL i326_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 

      ON ACTION last
         CALL i326_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
                LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##

     ON ACTION aps_related_data_aps_vms
        LET g_action_choice="aps_related_data_aps_vms"
        EXIT DISPLAY

    #FUN-B80171 add str---
     ON ACTION aps_route_tools
        LET g_action_choice="aps_route_tools"
        EXIT DISPLAY
    #FUN-B80171 add end---

     ON ACTION related_document                #No:FUN-6A0039  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-860060
FUNCTION i326_aps_vms(p_cmd) #TQC-8C0016 加入參數p_cmd
DEFINE p_cmd     LIKE type_file.chr1      #No.TQC-8C0016 add
DEFINE g_cmd     LIKE  type_file.chr1000,
       l_vmn     RECORD LIKE vmn_file.*

    IF l_ac=0 THEN 
       CALL cl_err('','aps-702',1)
       RETURN
    END IF 
    IF cl_null(g_vms[l_ac].vms05) OR
       cl_null(g_vms[l_ac].vms04) THEN
             CALL cl_err('','arm-034',1)
             RETURN
    END IF
        LET l_vmn.vmn01  = g_ecb.ecb01
        LET l_vmn.vmn02  = g_ecb.ecb02
        LET l_vmn.vmn03  = g_ecb.ecb03
        LET l_vmn.vmn012 = g_ecb.ecb012  #FUN-B50101 add
        LET l_vmn.vmn04  = g_vms[l_ac].vms04
        SELECT * FROM vmn_file
         WHERE vmn01 = l_vmn.vmn01
           AND vmn02 = l_vmn.vmn02
           AND vmn03 = l_vmn.vmn03
           AND vmn012= l_vmn.vmn012 #FUN-B50101 add
           AND vmn04 = l_vmn.vmn04
        IF SQLCA.SQLCODE=100 THEN
           LET l_vmn.vmn01 = g_ecb.ecb01
           LET l_vmn.vmn02 = g_ecb.ecb02
           LET l_vmn.vmn03  = g_ecb.ecb03
           LET l_vmn.vmn012 = g_ecb.ecb012 #FUN-B50101 add
           LET l_vmn.vmn04  = g_vms[l_ac].vms04
          #TQC-8C0016---mod---str---
          #LET l_vmn.vmn08  = NULL
          #LET l_vmn.vmn081 = NULL
           LET l_vmn.vmn08  = g_vms[l_ac].vmn08
           LET l_vmn.vmn081 = g_vms[l_ac].vmn081
           #TQC-8C0016---mod---end---
           LET l_vmn.vmn09 = 0
           LET l_vmn.vmn12 = 0
           LET l_vmn.vmn13 = 1
           LET l_vmn.vmn15 = 0
           LET l_vmn.vmn16 = 9999
           LET l_vmn.vmn17 = 1
           LET l_vmn.vmn19 = 0  #FUN-8C0008 ADD
           LET l_vmn.vmnplant = g_plant #FUN-B50101 add
           LET l_vmn.vmnlegal = g_legal #FUN-B50101 add
           INSERT INTO vmn_file VALUES(l_vmn.*)
              IF STATUS THEN
                CALL cl_err3("ins","vmn_file",l_vmn.vmn01,l_vmn.vmn02,SQLCA.sqlcode,
                              "","",1)
              END IF
        END IF
        #FUN-890012 增加參數傳遞 委外否 vms13
        #LET g_cmd = "apsi312 '",l_vmn.vmn01,"' '",l_vmn.vmn02,"' '",l_vmn.vmn03,"' '",l_vmn.vmn04,"'"
        #LET g_cmd = "apsi312 '",l_vmn.vmn01,"' '",l_vmn.vmn02,"' '",l_vmn.vmn03,"' '",l_vmn.vmn04,"' '",g_vms[l_ac].vms13,"'"                     #FUN-B50101 mark
         LET g_cmd = "apsi312 '",l_vmn.vmn01,"' '",l_vmn.vmn02,"' '",l_vmn.vmn03,"' '",l_vmn.vmn04,"' '",g_vms[l_ac].vms13,"' '",l_vmn.vmn012,"'"  #FUN-B50101 add
         IF p_cmd = 'Y' THEN #TQC-8C0016 add if 判斷
             CALL cl_cmdrun(g_cmd)
         END IF
END FUNCTION


#FUN-860060
FUNCTION i326_vms04(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,#No.TQC-6A0065
       l_ecdacti  LIKE ecd_file.ecdacti

    LET g_errno = ' '
    SELECT ecd01,ecd02 INTO
        g_vms[l_ac].vms04,g_vms[l_ac].ecd02
     FROM ecd_file
     WHERE ecd01 = g_vms[l_ac].vms04
     CASE WHEN SQLCA.SQLCODE = 100  
             LET g_errno = 'aec-015'
             LET g_vms[l_ac].vms04 = NULL
             LET g_vms[l_ac].ecd02 = NULL
          WHEN l_ecdacti='N' LET g_errno = '9028'
          OTHERWISE          
             LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      DISPLAY BY NAME g_vms[l_ac].vms04
      DISPLAY BY NAME g_vms[l_ac].ecd02

END FUNCTION

FUNCTION i306_vms07(p_cmd)
DEFINE p_cmd          LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(01)
      l_ecaacti      LIKE eca_file.ecaacti,
      l_eca02        LIKE eca_file.eca02

   LET g_errno = ''
   SELECT eca02,ecaacti INTO l_eca02,l_ecaacti
     FROM eca_file
    WHERE eca01 = g_vms[l_ac].vms07
     CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aec-054'
                                    LET g_vms[l_ac].vms07 = NULL
          WHEN l_ecaacti='N'        LET g_errno = '9028'
         OTHERWISE                  LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
   DISPLAY BY NAME l_eca02
   LET g_vms[l_ac].eca02 = l_eca02
   DISPLAY BY NAME g_vms[l_ac].eca02
END FUNCTION



#No:FUN-760085---End
#Patch....NO:TQC-610035 <> #

#FUN-9A0047---add----str----
FUNCTION i326_chk_aps()
  DEFINE l_aps_err LIKE type_file.chr1    
  DEFINE l_vmn08   LIKE vmn_file.vmn08
  DEFINE l_vms     RECORD LIKE vms_file.*

   CALL s_showmsg_init()   
   DECLARE i326_chk_aps CURSOR FOR
      SELECT *
        FROM vms_file
       WHERE vms01 = g_ecb.ecb01
         AND vms02 = g_ecb.ecb02
         AND vms03 = g_ecb.ecb03
         AND vms012= g_ecb.ecb012 #FUN-B50101 add

   LET l_aps_err = 'N'
   FOREACH i326_chk_aps INTO l_vms.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err('aps chk:',SQLCA.SQLCODE,0)
        EXIT FOREACH
     END IF
     IF g_sma.sma917 = 1 THEN #機器編號
         SELECT vmn08 INTO l_vmn08 
           FROM vmn_file
          WHERE vmn01 = g_ecb.ecb01     #料號
            AND vmn02 = g_ecb.ecb02     #製程
            AND vmn03 = g_ecb.ecb03     #加工序號
            AND vmn012= g_ecb.ecb012    #製程段號 #FUN-B50101 add
            AND vmn04 = l_vms.vms04     #作業編號
         IF l_vms.vms13 = 'N' THEN 
             IF cl_null(l_vms.vms08) AND cl_null(l_vmn08) THEN
                 #整體參數資源型態設機器時,機器編號和資源群組編號(機器),至少要有一個欄位有值!
                 CALL cl_getmsg('aps-033',g_lang) RETURNING g_showmsg 
                 LET g_showmsg = l_vms.vms05,'==>',g_showmsg
                 CALL s_errmsg('vms05',g_showmsg,l_vms.vms01,STATUS,1)
                 LET l_aps_err = 'Y'
             END IF
         END IF 
     END IF
   END FOREACH
   IF l_aps_err = 'Y' THEN
       CALL s_showmsg()   
       RETURN 1
   ELSE
       RETURN 0
   END IF

END FUNCTION
#FUN-9A0047---add----end----

#FUN-B80171 add str---
FUNCTION i326_aps_vnm()
  LET g_cmd = "apsi331 '",g_ecb.ecb01,"' '",g_ecb.ecb02,"' '",g_ecb.ecb03,"' '",g_vms[l_ac].vms04,"' '",g_ecb.ecb012,"'"  #料/製程/製程序/作業編號/製程段
  CALL cl_cmdrun(g_cmd)
END FUNCTION
#FUN-B80171 add end---
