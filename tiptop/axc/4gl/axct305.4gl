# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axct305.4gl
# Descriptions...: 同業借料單價維護作業
# Date & Author..: 03/02/25 By Mandy
# Modify.........: 03/06/03 By Jiunn No.7088
#                  修正應抓取上期開帳資料
# Modify.........: No.MOD-4A0252 04/10/21 By Smapmin 加入借料單號開窗
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/25 By wujie 單據編號加大 
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-890290 09/02/10 By Pengu 執行單價產生,會出現chmod的錯誤訊息
# Modify.........: No.TQC-970204 09/07/20 By dxfwo  display XXX to FORMONLY.cn3  畫面沒有cn3 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990025 09/09/08 By Carrier image顯示修改
# Modify.........: No.TQC-990026 09/09/08 By Carrier 單身單價/金額非負判斷
# Modify.........: No.FUN-9B0113 09/11/19 By alex 改chmod為使用Genero API  7*64+7*8+7=511
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No:FUN-B80056 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No.TQC-BA0020 11/10/09 By yinhy 點擊“單價生成”按鈕，錄入單號後，沒有生成成功

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE 
           g_imo   RECORD LIKE imo_file.*,
           g_imo_t RECORD LIKE imo_file.*,
           g_imo_o RECORD LIKE imo_file.*,
           g_yy,g_mm	   LIKE type_file.num5,          #No.FUN-680122 SMALLINT   #
           b_imp   RECORD LIKE imp_file.*,
           g_imp           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    imp02     LIKE imp_file.imp02,
                    imp03     LIKE imp_file.imp03,
                    ima02     LIKE ima_file.ima02,
                    imp13     LIKE imp_file.imp13,
                    imp11     LIKE imp_file.imp11,
                    imp12     LIKE imp_file.imp12,
                    imp05     LIKE imp_file.imp05,
                    imp14     LIKE imp_file.imp14,
                    imp14_fac LIKE imp_file.imp14_fac,
                    imp04     LIKE imp_file.imp04,
                    imp09     LIKE imp_file.imp09,
                    imp10     LIKE imp_file.imp10
                    END RECORD,
             g_imp_t         RECORD
                    imp02     LIKE imp_file.imp02,
                    imp03     LIKE imp_file.imp03,
                    ima02     LIKE ima_file.ima02,
                    imp13     LIKE imp_file.imp13,
                    imp11     LIKE imp_file.imp11,
                    imp12     LIKE imp_file.imp12,
                    imp05     LIKE imp_file.imp05,
                    imp14     LIKE imp_file.imp14,
                    imp14_fac LIKE imp_file.imp14_fac,
                    imp04     LIKE imp_file.imp04,
                    imp09     LIKE imp_file.imp09,
                    imp10     LIKE imp_file.imp10
                    END RECORD,
             g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
             g_t1            LIKE oay_file.oayslip,          #No.FUn-550025        #No.FUN-680122 VARCHAR(5)
             g_buf           LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
             g_rec_b         LIKE type_file.num5,               #單身筆數        #No.FUN-680122 SMALLINT
             l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
DEFINE g_forupd_sql STRING #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE g_cnt           LIKE type_file.num10            #No.FUN-680122 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg           LIKE ze_file.ze03       #No.FUN-680122 VARCHAR(72)
DEFINE   g_row_count   LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-680122 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5   #No.FUN-680122 SMALLINT
DEFINE   g_confirm       LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
DEFINE   g_approve       LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
DEFINE   g_post          LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
DEFINE   g_close         LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
DEFINE   g_void          LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
DEFINE   g_valid         LIKE type_file.chr1   #No.FUN-680122 VARCHAR(1)
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0146
DEFINE     p_row,p_col     LIKE type_file.num5        #No.FUN-680122 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    LET p_row = 3 LET p_col = 5
 
    OPEN WINDOW t305_w AT p_row,p_col WITH FORM "axc/42f/axct305"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL t305_menu()
    CLOSE WINDOW t305_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t305_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_imp.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_imo.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imo01,imo02,imo03,imo04,imo06,imo05,
        imoconf,imopost,imo07,imouser,imogrup,imomodu,imodate
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
    ON ACTION controlp
          CASE
              WHEN INFIELD(imo01) #借料單號  #MOD-4A0252借料單號開窗
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_imo"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imo01
                  NEXT FIELD imo01
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
 
    
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imouser', 'imogrup') #FUN-980030
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imouser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imogrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    CONSTRUCT g_wc2 ON imp02,imp03,imp13,
                       imp11,imp14,imp04,
                       imp09,imp12
            FROM s_imp[1].imp02, s_imp[1].imp03, s_imp[1].imp13,
                 s_imp[1].imp11, s_imp[1].imp14, s_imp[1].imp04,
                 s_imp[1].imp09, s_imp[1].imp12
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      #MOD-530850                                                                 
     ON ACTION CONTROLP                                                         
        CASE                                                                    
          WHEN INFIELD(imp03)
#FUN-AA0059---------mod------------str-----------------                                                   
#           CALL cl_init_qry_var()                                              
#           LET g_qryparam.form = "q_ima"                                       
#           LET g_qryparam.state = "c"                                          
#           LET g_qryparam.default1 = g_imp[1].imp03                               
#           CALL cl_create_qry() RETURNING g_imp[1].imp03                 
            CALL q_sel_ima(TRUE, "q_ima","",g_imp[1].imp03,"","","","","",'')  RETURNING g_imp[1].imp03
#FUN-AA0059---------mod------------end-----------------
            DISPLAY g_imp[1].imp03 TO imp03                                
            NEXT FIELD imp03                                                    
         OTHERWISE                                                              
            EXIT CASE                                                           
       END CASE                                                                 
    #FUN-530065
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imo01 FROM imo_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND imopost = 'Y'"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  imo01 ",
                   "  FROM imo_file, imp_file",
                   " WHERE imo01 = imp01",
                   "   AND imopost = 'Y'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE t305_prepare FROM g_sql
    DECLARE t305_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t305_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imo_file WHERE ",g_wc CLIPPED,
                       "     AND imopost = 'Y'"
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imo01) FROM imo_file,imp_file WHERE ",
                  "imp01=imo01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                       "     AND imopost = 'Y'"
    END IF
 
    PREPARE t305_precount FROM g_sql
    DECLARE t305_count CURSOR FOR t305_precount
END FUNCTION
 
FUNCTION t305_menu()
 
   WHILE TRUE
      CALL t305_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t305_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t305_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "gen_u_p"  
            IF cl_chk_act_auth() THEN 
               CALL t305_g()
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imp),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imo.imo01 IS NOT NULL THEN
                 LET g_doc.column1 = "imo01"
                 LET g_doc.value1 = g_imo.imo01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t305_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t305_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_imo.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! " 
    OPEN t305_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imo.* TO NULL
    ELSE
       OPEN t305_count
       FETCH t305_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
       CALL t305_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t305_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t305_cs INTO g_imo.imo01
        WHEN 'P' FETCH PREVIOUS t305_cs INTO g_imo.imo01
        WHEN 'F' FETCH FIRST    t305_cs INTO g_imo.imo01
        WHEN 'L' FETCH LAST     t305_cs INTO g_imo.imo01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t305_cs INTO g_imo.imo01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)
        INITIALIZE g_imo.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imo.* FROM imo_file WHERE imo01 = g_imo.imo01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_imo.* TO NULL
        RETURN
    ELSE                                    
        LET g_data_owner=g_imo.imouser           #FUN-4C0061權限控管
        LET g_data_group=g_imo.imogrup
    END IF
    CALL t305_show()
END FUNCTION
 
FUNCTION t305_show()
    LET g_imo_t.* = g_imo.*                #保存單頭舊值
    DISPLAY BY NAME
        g_imo.imo01,g_imo.imo02,g_imo.imo03,g_imo.imo04,g_imo.imo05,g_imo.imo06,
        g_imo.imoconf,g_imo.imo07,g_imo.imopost,g_imo.imouser,
        g_imo.imogrup,g_imo.imomodu,g_imo.imodate
    CASE g_imo.imoconf
         WHEN 'Y'   LET g_confirm = 'Y'
                    LET g_void = ''
         WHEN 'N'   LET g_confirm = 'N'
                    LET g_void = ''
         WHEN 'X'   LET g_confirm = ''
                    LET g_void = 'Y'
      OTHERWISE     LET g_confirm = ''
                    LET g_void = ''
    END CASE
    IF NOT cl_null(g_imo.imopost) THEN
       LET g_post = 'Y'
    ELSE
       LET g_post = 'N'
    END IF 
    #No.TQC-990025  --Begin
    #IF NOT cl_null(g_imo.imo07) THEN
    #   LET g_close = 'Y'
    #ELSE
    #   LET g_close = 'N'
    #END IF 
    IF NOT cl_null(g_imo.imo07) THEN
       LET g_close = g_imo.imo07
    ELSE
       LET g_close = 'N'
    END IF 
    #No.TQC-990025  --End  
    #圖形顯示
    CALL cl_set_field_pic(g_confirm,"",g_post,g_close,g_void,"")
    CALL t305_imo06('d')
    CALL t305_b_fill(g_wc2) 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t305_imo06(p_cmd)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_imo.imo06
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                 LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION t305_b()
DEFINE
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_row,l_col     LIKE type_file.num5,          #No.FUN-680122 SMALLINT 			   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,          #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,          #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,          #處理狀態        #No.FUN-680122 VARCHAR(1)
    l_b2      	    LIKE type_file.chr50,         #No.FUN-680122 VARCHAR(30)
    l_ima35,l_ima36	LIKE ima_file.ima35,      #No.FUN-680122 VARCHAR(10)
  #  l_qty		LIKE ima_file.ima26,      #No.FUN-680122 DECIMAL(15,3)#FUN-A20044
    l_qty		LIKE type_file.num15_3,      #No.FUN-680122 DECIMAL(15,3)#FUN-A20044
    l_flag          LIKE type_file.num10,         #No.FUN-680122 INTEGER
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
    IF g_imo.imo01 IS NULL THEN RETURN END IF
 
    #抑製不可INSERT 和 DELETE 單身資料
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT * FROM imp_file  ",
                       " WHERE imp01=? ", 
                       "   AND imp02=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t305_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_imp WITHOUT DEFAULTS FROM s_imp.* 
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR() 
#           DISPLAY l_ac TO FORMONLY.cn3          #No.TQC-970204 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
       	    BEGIN WORK
            IF g_rec_b>=l_ac THEN
               LET p_cmd = 'u'
               LET g_imp_t.* = g_imp[l_ac].*  #BACKUP
 
                OPEN t305_bcl USING g_imo.imo01,g_imp_t.imp02
 
                IF STATUS THEN
                   CALL cl_err("OPEN t305_bcl:", STATUS, 1)
                   CLOSE t305_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t305_bcl INTO b_imp.* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock imp',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
        BEFORE INSERT
                LET l_n = ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_imp[l_ac].* TO NULL      #900423
                INITIALIZE g_imp_t.* TO NULL
                LET b_imp.imp01=g_imo.imo01
                LET g_imp[l_ac].imp14_fac=1
                LET g_imp[l_ac].imp14=0
                CALL cl_show_fld_cont()     #FUN-550037(smin)
                NEXT FIELD imp02
 
        BEFORE DELETE                            #是否取消單身
            IF g_imp_t.imp02 > 0 AND g_imp_t.imp02 IS NOT NULL THEN
                CALL cl_err(g_imp_t.imp03,'axct001',0)
            END IF
 
        AFTER FIELD imp09 #單價
            IF NOT cl_null(g_imp[l_ac].imp09) THEN 
               #No.TQC-990026  --Begin
               IF g_imp[l_ac].imp09 < 0 THEN
                  CALL cl_err(g_imp[l_ac].imp09,'aim-223',0)
                  LET g_imp[l_ac].imp09 = g_imp_t.imp09
                  NEXT FIELD imp09
               END IF
               #No.TQC-990026  --End  
               LET g_imp[l_ac].imp10 = g_imp[l_ac].imp04*g_imp[l_ac].imp09
               DISPLAY g_imp[l_ac].imp10 TO imp10
            END IF
 
        #No.TQC-990026  --Begin
        AFTER FIELD imp10 #金額
            IF NOT cl_null(g_imp[l_ac].imp10) THEN 
               IF g_imp[l_ac].imp10 < 0 THEN
                  CALL cl_err(g_imp[l_ac].imp10,'aim-223',0)
                  LET g_imp[l_ac].imp10 = g_imp_t.imp10
                  NEXT FIELD imp10
               END IF
            END IF
        #No.TQC-990026  --End  
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imp[l_ac].* = g_imp_t.*
               CLOSE t305_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imp[l_ac].imp02,-263,1)
               LET g_imp[l_ac].* = g_imp_t.*
            ELSE
               UPDATE imp_file 
                  SET imp09=g_imp[l_ac].imp09,
                      imp10=g_imp[l_ac].imp10
                  WHERE imp01=g_imo.imo01 
                    AND imp02=g_imp_t.imp02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd imp',SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","imp_file",g_imo.imo01,g_imp_t.imp02,SQLCA.sqlcode,"","upd imp",1)  #No.FUN-660127
                  LET g_imp[l_ac].* = g_imp_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
               END IF
            END IF
            UPDATE tlf_file SET tlf21 = g_imp[l_ac].imp10,
                                tlf221= g_imp[l_ac].imp10
             WHERE tlf905 = g_imo.imo01 
               AND tlf906 = g_imp_t.imp02
            IF SQLCA.sqlcode  THEN
                MESSAGE "UPDATE tlf ERROR!"
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_imp[l_ac].* = g_imp_t.*
               END IF
               CLOSE t305_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE t305_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
      
      END INPUT
      UPDATE imo_file SET imomodu=g_user,imodate=g_today
          WHERE imo01=g_imo.imo01
 
      SELECT COUNT(*) INTO g_cnt FROM imp_file WHERE imp01=g_imo.imo01
    CLOSE t305_bcl
	COMMIT WORK
END FUNCTION
#---單價產生
FUNCTION t305_g()
  DEFINE  l_cmd     LIKE type_file.chr1000,        #No.FUN-680122CHAR(600)
          l_cmd2    LIKE type_file.chr1000,        #No.FUN-680122CHAR(600)
          x_cnt     LIKE type_file.num5,           #No.FUN-680122 SMALLINT
          l_bdate,l_edate LIKE type_file.dat,      #No.FUN-680122 DATE
          l_za05    LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          l_name    LIKE type_file.chr20,          #No.FUN-680122 VARCHAR(20)
          tm RECORD
               x          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
               yy         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
               mm         LIKE type_file.num5,          #No.FUN-680122 SMALLINT
               plant      LIKE azp_file.azp01
          END RECORD,
          l_fromplant like azp_file.azp03,
          l_flag  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          sr record
               imp01 like imp_file.imp01, #借入單號
               imp02 like imp_file.imp02, #項次
               imp03 like imp_file.imp03, #料件編號
               imp04 like imp_file.imp04  #數量
          end record,
          l_uprice like ccc_file.ccc23,
          l_amount  like imp_file.imp10   #金額
  DEFINE l_plant  LIKE type_file.chr20    #FUN-A50102
  OPEN WINDOW t305_g AT 4,35 WITH FORM "axc/42f/axct305_g"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axct305_g")
 
 
  DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02
  WHILE TRUE 
     CONSTRUCT BY NAME g_wc ON imp01,imp03,ima08 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
     
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
         	   CALL cl_qbe_select() 
		ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',1) CONTINUE WHILE
     END IF 
     EXIT WHILE
  END WHILE
  IF INT_FLAG THEN 
     LET INT_FLAG=0  
     CLOSE WINDOW t305_g 
     RETURN 
  END IF
  IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF 
 
  LET tm.plant = g_plant
  # return 上期年月
  CALL s_lsperiod(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.yy,tm.mm
 
  LET tm.x = 'N'
  INPUT BY NAME tm.x,tm.plant,tm.yy,tm.mm WITHOUT DEFAULTS 
 
    AFTER FIELD plant
      IF tm.x = 'N' THEN 
         IF cl_null(tm.plant) THEN NEXT FIELD plant END IF
         select count(*) into x_cnt 
         from azp_file
         where azp01=tm.plant
         if x_cnt=0 then
            next field plant
         end if
      END IF 
 
    AFTER FIELD yy
      IF tm.x = 'N' THEN IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      END IF 
    AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
      IF tm.x = 'N' THEN IF cl_null(tm.mm) THEN NEXT FIELD mm END IF 
      END IF 
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
    AFTER INPUT
       IF int_flag THEN EXIT INPUT END IF
       CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
            RETURNING l_flag, l_bdate, l_edate #得出起始日與截止日
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW t305_g RETURN END IF
  
   IF tm.x = 'N' THEN 
      SELECT azp03 INTO l_fromplant FROM azp_file WHERE azp01=tm.plant
      LET l_plant = tm.plant    #FUN-A50102
      IF cl_null(l_fromplant) THEN
         SELECT azp03 into l_fromplant from azp_file where azp01 = g_plant
         LET l_plant = g_plant  #FUN-A50102
      END IF
      LET l_cmd ="SELECT ccc23 ",
              #"FROM ",l_fromplant clipped,".ccc_file ",
              "FROM ",cl_get_target_table(l_plant,'ccc_file'), #FUN-A50102
              " WHERE ccc01 = ?  ",
              " AND ccc02 = ",tm.yy ,
              " and ccc03 = ",tm.mm clipped
      CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
	  CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102	
      PREPARE t305_preccc FROM l_cmd
      DECLARE t305_cuccc SCROLL CURSOR WITH HOLD FOR t305_preccc
   END IF 
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('axct305') RETURNING l_name
   START REPORT axct305_rep TO l_name
 
   LET l_cmd2 ="SELECT imp01,imp02,imp03,imp04 ",
               "  FROM imp_file LEFT OUTER JOIN ima_file ON imp03 = ima_file.ima01,imo_file",
               " WHERE imo01 = imp01",
               "   AND imo02 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
               "   AND imopost = 'Y' ", #已過帳
               "   AND ",g_wc CLIPPED
 
   PREPARE t305_pregen FROM l_cmd2
   DECLARE t305_cugen SCROLL CURSOR WITH HOLD FOR t305_pregen
   IF NOT  cl_sure(10,20) THEN
       CLOSE WINDOW t305_g
       RETURN
   END IF 
   LET g_success = 'N'   #TQC-BA0020 add
   #------------------------------
   #掃單據的單身,並更改單價及金額
   #------------------------------
   FOREACH t305_cugen into sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach :t305_cugen',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      MESSAGE sr.imp01,'-',sr.imp02,' ',sr.imp03
 
      IF tm.x = 'N' THEN #是否將單價設定為零
          LET l_uprice= 0 
          #先取開帳單價
         #No.7088 03/06/03 By Jiunn Mod.A.a.01 -----
         {
         SELECT cca23 INTO l_uprice FROM cca_file 
          WHERE cca01 = sr.imp03
         }
         SELECT cca23 INTO l_uprice FROM cca_file 
          WHERE cca01 = sr.imp03 AND cca02 = tm.yy AND cca03 = tm.mm
         #No.7088 End.A.a.01 -----------------------
         IF SQLCA.sqlcode THEN 
            LET l_uprice = 0
            OPEN t305_cuccc USING sr.imp03  #取上月成本價
            FETCH t305_cuccc INTO l_uprice
            IF SQLCA.sqlcode THEN
               LET l_flag = 'Y'
               LET l_uprice = 0
               #最近採購單價
               SELECT ima53 INTO l_uprice FROM ima_file
                WHERE ima01 = sr.imp03
               IF SQLCA.sqlcode THEN
                  LET l_flag = 'Y'
                  LET l_uprice = 0
               END IF 
            END IF
         END IF
         IF l_uprice = 0 THEN 
            OUTPUT TO REPORT axct305_rep(sr.*)
         END IF
      ELSE
         LET l_uprice = 0
         LET l_amount = 0
      END IF 
      
      LET l_amount  = l_uprice * sr.imp04
 
      UPDATE imp_file SET imp09 = l_uprice,
                          imp10 = l_amount
       WHERE imp01 = sr.imp01 
         AND imp03 = sr.imp03
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE ERROR!"
         EXIT FOREACH
      END IF
      UPDATE tlf_file SET tlf21 = l_amount ,
                          tlf221= l_amount
       WHERE tlf905 = sr.imp01 
         AND tlf906 = sr.imp02
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE tlf ERROR!"
         EXIT FOREACH
      END IF
      LET g_success = 'Y'   #TQC-BA0020 add 
      CLOSE t305_cuccc
 
   END FOREACH
 
   FINISH REPORT axct305_rep
   IF l_flag = 'Y' THEN 
      CALL cl_prt(l_name,g_prtway,g_copies,g_len) 
   ELSE
    #--------------No.MOD-890290 modify
    #LET l_cmd = "chmod 777 ", l_name
    #LET l_cmd = "chmod 777 $TEMPDIR/", l_name ," 2>/dev/null"
    #RUN l_cmd
     LET l_cmd = os.Path.join(FGL_GETENV("TEMPDIR"), l_name CLIPPED)    #FUN-9B0113 7*64+7*8+7=511
     IF os.Path.chrwx(l_cmd CLIPPED, 511) THEN
     END IF
    #--------------No.MOD-890290 end
   END IF
 
   CLOSE WINDOW t305_g
   #CALL cl_err('','axc-001',0)  #TQC-BA0020 mark
   #No.TQC-BA0020  --Begin
   IF g_success = 'Y'   THEN 
      CALL cl_err('','axc-001',0)
   ELSE 
      CALL cl_err('','axc-529',0)
   END IF
   #No.TQC-BA0020  --End
END FUNCTION
 
REPORT axct305_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(1) 
       #   l_row3,l_row6    LIKE ima_file.ima26,      #No.FUN-680122  DEC(15,3)#FUN-A20044
          l_row3,l_row6    LIKE type_file.num15_3,      #No.FUN-680122  DEC(15,3)#FUN-A20044
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          sr RECORD
               imp01 LIKE imp_file.imp01,
               imp02 LIKE imp_file.imp02,
               imp03 LIKE imp_file.imp03,
               imp04 LIKE imp_file.imp04
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.imp01,sr.imp02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file 
          WHERE ima01=sr.imp03
      IF SQLCA.sqlcode THEN 
          LET l_ima02 = NULL 
          LET l_ima021 = NULL 
      END IF
      PRINT COLUMN g_c[31],sr.imp01,' - ',
            COLUMN g_c[32],sr.imp02 USING '###&',
            COLUMN g_c[33],sr.imp03,g_x[9],
            COLUMN g_c[34],l_ima02,
            COLUMN g_c[35],l_ima021
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
 
FUNCTION t305_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    CONSTRUCT g_wc2 ON imp02,imp03,imp13,
                       imp11,imp14,imp04,
                       imp09,imp12
            FROM s_imp[1].imp02, s_imp[1].imp03, s_imp[1].imp13,
                 s_imp[1].imp11, s_imp[1].imp14, s_imp[1].imp04,
                 s_imp[1].imp09, s_imp[1].imp12
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
		ON ACTION qbe_select
         	   CALL cl_qbe_select() 
		ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t305_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t305_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
    IF cl_null(p_wc2) THEN
        LET p_wc2 = ' 1=1'
    END IF
    LET g_sql =
        "SELECT imp02,imp03,ima02,imp13,imp11,imp12,imp05,imp14, ",
        "       imp14_fac,imp04,imp09,imp10 ",
        " FROM imp_file LEFT OUTER JOIN ima_file ON ima_file.ima01 = imp03 ",
        " WHERE imp01 ='",g_imo.imo01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1"
 
    PREPARE t305_pb FROM g_sql
    DECLARE imp_curs CURSOR FOR t305_pb
 
    CALL g_imp.clear()
    LET g_cnt = 1
    FOREACH imp_curs INTO g_imp[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_imp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t305_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imp TO s_imp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t305_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL t305_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL t305_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL t305_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL t305_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CASE g_imo.imoconf
              WHEN 'Y'   LET g_confirm = 'Y'
                         LET g_void = ''
              WHEN 'N'   LET g_confirm = 'N'
                         LET g_void = ''
              WHEN 'X'   LET g_confirm = ''
                         LET g_void = 'Y'
           OTHERWISE     LET g_confirm = ''
                         LET g_void = ''
         END CASE
         IF NOT cl_null(g_imo.imopost) THEN
            LET g_post = 'Y'
         ELSE
            LET g_post = 'N'
         END IF 
         #No.TQC-990025  --Begin
         #IF NOT cl_null(g_imo.imo07) THEN
         #   LET g_close = 'Y'
         #ELSE
         #   LET g_close = 'N'
         #END IF 
         IF NOT cl_null(g_imo.imo07) THEN
            LET g_close = g_imo.imo07
         ELSE
            LET g_close = 'N'
         END IF 
         #No.TQC-990025  --End  
         #圖形顯示
         CALL cl_set_field_pic(g_confirm,"",g_post,g_close,g_void,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      #@ON ACTION 單價產生
      ON ACTION gen_u_p
         LET g_action_choice="gen_u_p"
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
 
   
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B80056 
 
