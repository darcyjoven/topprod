# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: anmi033.4gl
# Descriptions...: 銀行調節碼(FM)
# Date & Author..: 
# Modify         : Nick 94/12/5 modified to Muti-Line 
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0098 05/01/10 By pengu 報表轉XML
# Modify.........: No.MOD-530026 05/03/07 By Kitty  CALL g_nmk.deleteElement(l_ac)  應改為  CALL g_nmk.deleteElement(g_cnt)
# Modify.........: No.FUN-570108 05/07/13 By vivien KEY值更改控制  
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No:No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6A0110 06/11/09 By johnray 報表修改
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/09/06 By Carrier _out()轉p_query實現
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nmk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nmk01       LIKE nmk_file.nmk01,       #銀行調節碼
        nmk02       LIKE nmk_file.nmk02,       #調節說明
        nmk03       LIKE nmk_file.nmk03,       #銀行存款加減方式
        nmkacti     LIKE nmk_file.nmkacti      #No.FUN-680107 VARCHAR(1)
                    END RECORD,
    g_nmk_t         RECORD                     #程式變數 (舊值)
        nmk01       LIKE nmk_file.nmk01,       #銀行調節碼
        nmk02       LIKE nmk_file.nmk02,       #調節說明
        nmk03       LIKE nmk_file.nmk03,       #銀行存款加減方式
        nmkacti     LIKE nmk_file.nmkacti      #No.FUN-680107 VARCHAR(1)
                    END RECORD,
    g_wc,g_sql      STRING,                    #TQC-630166
    g_rec_b         LIKE type_file.num5,       #單身筆數 #No.FUN-680107 SMALLINT
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT #No.FUN-680107 SMALLINT
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-790050
DEFINE g_before_input_done   LIKE type_file.num5      #FUN-570108  #No.FUN-680107 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0082
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i033_w AT p_row,p_col WITH FORM "anm/42f/anmi033"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc = '1=1' CALL i033_b_fill(g_wc)
    CALL i033_menu()
    CLOSE WINDOW i033_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
END MAIN
 
FUNCTION i033_menu()
 
   WHILE TRUE
      CALL i033_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i033_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i033_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i033_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi033" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nmk),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i033_q()
   CALL i033_b_askkey()
END FUNCTION
 
FUNCTION i033_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用    #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否    #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態      #No.FUN-680107 VARCHAR(1)
    L_allow_insert  LIKE type_file.num5,    #No.FUN-680107 VARCHAR(1) #可新增否                            
    l_allow_delete  LIKE type_file.num5     #No.FUN-680107 VARCHAR(1) #可刪除否                            
 
    LET g_action_choice = ""                                                    
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nmk01,nmk02,nmk03,nmkacti FROM nmk_file WHERE nmk01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i033_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nmk
            WITHOUT DEFAULTS
            FROM s_nmk.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)                                           
         END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
#            DISPLAY l_ac TO FORMONLY.cn3  #MOD-960067
           #LET g_nmk_t.* = g_nmk[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_nmk_t.nmk01 IS NOT NULL THEN
                LET p_cmd='u'
                LET g_nmk_t.* = g_nmk[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
                LET g_before_input_done = FALSE                                 
                CALL i033_set_entry(p_cmd)                                      
                CALL i033_set_no_entry(p_cmd)                                   
                LET g_before_input_done = TRUE                                  
#No.FUN-570108 --end           
 
                BEGIN WORK
                OPEN i033_bcl USING g_nmk_t.nmk01
                IF STATUS THEN
                   CALL cl_err("OPEN i033_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i033_bcl INTO g_nmk[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_nmk_t.nmk01,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
          #NEXT FIELD nmk01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i033_set_entry(p_cmd)                                          
            CALL i033_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end         
            INITIALIZE g_nmk[l_ac].* TO NULL      #900423
            LET g_nmk[l_ac].nmkacti = 'Y'       #Body default
            LET g_nmk_t.* = g_nmk[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD nmk01
 
        AFTER INSERT                                                            
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
            #  CLOSE i033_bcl                                                   
            #  CALL g_nmk.deleteElement(l_ac)                                   
            #  IF g_rec_b != 0 THEN                                             
            #     LET g_action_choice = "detail"                                
            #     LET l_ac = l_ac_t                                             
            #  END IF                                                           
            #  EXIT INPUT
           END IF
           INSERT INTO nmk_file(nmk01,nmk02,nmk03,
                                nmkacti,nmkuser,nmkdate,nmkoriu,nmkorig)
           VALUES(g_nmk[l_ac].nmk01,g_nmk[l_ac].nmk02,
                  g_nmk[l_ac].nmk03,g_nmk[l_ac].nmkacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_nmk[l_ac].nmk01,SQLCA.sqlcode,0)   #No.FUN-660148
              CALL cl_err3("ins","nmk_file",g_nmk[l_ac].nmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
             #LET g_nmk[l_ac].* = g_nmk_t.*
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD nmk01                        #check 編號是否重複
            IF g_nmk[l_ac].nmk01 != g_nmk_t.nmk01 OR
               (g_nmk[l_ac].nmk01 IS NOT NULL AND g_nmk_t.nmk01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM nmk_file
                    WHERE nmk01 = g_nmk[l_ac].nmk01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nmk[l_ac].nmk01 = g_nmk_t.nmk01
                    NEXT FIELD nmk01
                END IF
            END IF
 
	AFTER FIELD nmk03
 	IF g_nmk[l_ac].nmk03 NOT MATCHES '[-+]' OR 
		cl_null(g_nmk[l_ac].nmk03) THEN
		LET g_nmk[l_ac].nmk03 = g_nmk_t.nmk03
		NEXT FIELD nmk03
	END IF
        BEFORE DELETE                            #是否取消單身
            IF g_nmk_t.nmk01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM nmk_file WHERE nmk01 = g_nmk_t.nmk01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_nmk_t.nmk01,SQLCA.sqlcode,0) #No.FUN-660148
                   CALL cl_err3("del","nmk_file",g_nmk_t.nmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"                                             
                CLOSE i033_bcl         
                COMMIT WORK
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nmk[l_ac].* = g_nmk_t.*
               CLOSE i033_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nmk[l_ac].nmk01,-263,1)                            
             LET g_nmk[l_ac].* = g_nmk_t.*                                      
          ELSE                                      
             UPDATE nmk_file SET nmk01 = g_nmk[l_ac].nmk01,
                                 nmk02 = g_nmk[l_ac].nmk02,
                                 nmk03 = g_nmk[l_ac].nmk03,
                                 nmkacti = g_nmk[l_ac].nmkacti,
                                 nmkmodu = g_user,
                                 nmkdate = g_today
                         WHERE nmk01=g_nmk_t.nmk01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_nmk[l_ac].nmk01,SQLCA.sqlcode,0)   #No.FUN-660148
                CALL cl_err3("upd","nmk_file",g_nmk_t.nmk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
                LET g_nmk[l_ac].* = g_nmk_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i033_bcl         
             END IF
          END IF
 
        AFTER ROW
          LET l_ac = ARR_CURR()  
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nmk[l_ac].* = g_nmk_t.*
            #FUN-D30032--add--str--
             ELSE
                CALL g_nmk.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
            #FUN-D30032--add--end--
             END IF
             CLOSE i033_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
          END IF
         #LET g_nmk_t.* = g_nmk[l_ac].*          # 900423
          LET l_ac_t = l_ac                                                     
          CLOSE i033_bcl                                                        
          COMMIT WORK   
 
        ON ACTION CONTROLN
            CALL i033_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nmk01) AND l_ac > 1 THEN
                LET g_nmk[l_ac].* = g_nmk[l_ac-1].*
                NEXT FIELD nmk01
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
 
        
        END INPUT
 
    CLOSE i033_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i033_b_askkey()
    CLEAR FORM
   CALL g_nmk.clear()
    CONSTRUCT g_wc ON nmk01,nmk02,nmk03,nmkacti
            FROM s_nmk[1].nmk01,s_nmk[1].nmk02,s_nmk[1].nmk03
				,s_nmk[1].nmkacti
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmkuser', 'nmkgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i033_b_fill(g_wc)
END FUNCTION
 
FUNCTION i033_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(200)
 
    LET g_sql =
        "SELECT nmk01,nmk02,nmk03,nmkacti",
        " FROM nmk_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i033_pb FROM g_sql
    DECLARE nmk_curs CURSOR FOR i033_pb
 
    FOR g_cnt = 1 TO g_nmk.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_nmk[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH nmk_curs INTO g_nmk[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
     CALL g_nmk.deleteElement(g_cnt)             #No.MOD-530026       
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i033_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nmk TO s_nmk.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE )
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i033_out()
#    DEFINE
#        l_nmk           RECORD LIKE nmk_file.*,
#        l_i             LIKE type_file.num5,          #No.FUN-680107 SMALLINT
#        l_name          LIKE type_file.chr20,         # External(Disk) file name #No.FUN-680107 VARCHAR(20)
#        l_za05          LIKE type_file.chr1000        #No.FUN-680107 VARCHAR(40)
#   
#    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0) RETURN END IF
##      CALL cl_err('',-400,0) RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('anmi033') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM nmk_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE i033_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i033_co CURSOR FOR i033_p1
#
#    START REPORT i033_rep TO l_name
#
#    FOREACH i033_co INTO l_nmk.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i033_rep(l_nmk.*)
#    END FOREACH
#
#    FINISH REPORT i033_rep
#
#    CLOSE i033_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i033_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#        sr RECORD       LIKE nmk_file.*,
#        l_chr           LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.nmk01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
#            PRINT G_DASH1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.nmkacti = 'N' THEN PRINT '*'; END IF
#            PRINT COLUMN g_c[31],sr.nmk01,
#                  COLUMN g_c[32],sr.nmk02,
#                  COLUMN g_c[33],sr.nmk03,':',sr.nmk03    #No.TQC-6A0110
#
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc,'nmk01,nmk02,nmk03')
#                    RETURNING g_sql
#               PRINT g_dash[1,g_len]
#
#          #TQC-630166
#          {
#               IF g_sql[001,080] > ' ' THEN
#		       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               IF g_sql[071,140] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               IF g_sql[141,210] > ' ' THEN
#		       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#          }
#                 CALL cl_prt_pos_wc(g_sql)
#          #END TQC-630166
#
#            END IF
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End  
 
#No.FUN-570108 --start                                                          
FUNCTION i033_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("nmk01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i033_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nmk01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end          
