# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: abmi300.4gl
# Descriptions...: 機種代號維護作業
# Date & Author..: 97/10/27 By Chiayi
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510033 05/01/19 By Mandy 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.MOD-580322 05/09/02 By wujie  中文資訊修改進 ze_file 
# Modify.........: No.TQC-5B0030 05/11/08 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-660046 06/06/12 By xumin cl_err To cl_err3 
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770052 07/06/27 By xiaofeizhu制作水晶報表
# Modify.........: No.TQC-920095 09/02/26 By chenyu 程序中不需要提示"查詢中"的訊息
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_bmi           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmi01       LIKE bmi_file.bmi01,   #機種
        bmi02       LIKE bmi_file.bmi02,   #機種說明
        bmiacti     LIKE bmi_file.bmiacti  #有效否
                    END RECORD,
    g_bmi_t         RECORD                 #程式變數 (舊值)
        bmi01       LIKE bmi_file.bmi01,   #機種
        bmi02       LIKE bmi_file.bmi02,   #機種說明
        bmiacti     LIKE bmi_file.bmiacti  #有效否
                    END RECORD,
    g_wc2,g_sql     string,                #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
 
DEFINE g_cnt         LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose  #No.FUN-680096 SMALLINT
DEFINE g_before_input_done    LIKE type_file.num5     #No.FUN-570110       #No.FUN-680096 SMALLINT
DEFINE g_str         STRING                           #No.FUN-770052  
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0060
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
    LET p_row = 4 LET p_col = 15
 
    OPEN WINDOW i300_w AT p_row,p_col WITH FORM "abm/42f/abmi300"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i300_b_fill(g_wc2)
    CALL i300_menu()
    CLOSE WINDOW i300_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
FUNCTION i300_menu()
 
   WHILE TRUE
      CALL i300_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i300_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i300_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmi),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i300_q()
   CALL i300_b_askkey()
END FUNCTION
 
FUNCTION i300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否     #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否     #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT bmi01,bmi02,bmiacti FROM bmi_file WHERE bmi01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmi WITHOUT DEFAULTS FROM s_bmi.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmi_t.* = g_bmi[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i300_set_entry(p_cmd)                                                                                           
               CALL i300_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
               BEGIN WORK
               OPEN i300_bcl USING g_bmi_t.bmi01
               IF STATUS THEN
                  CALL cl_err("OPEN i300_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i300_bcl INTO g_bmi[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_bmi_t.bmi01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD bmi01
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            INSERT INTO bmi_file(bmi01,bmi02,bmiacti,bmiuser,
                                 bmigrup,bmimodu,bmidate,bmioriu,bmiorig)
            VALUES(g_bmi[l_ac].bmi01,g_bmi[l_ac].bmi02,
                   g_bmi[l_ac].bmiacti,g_user,g_grup,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
 
            IF SQLCA.sqlcode THEN 
        #      CALL cl_err(g_bmi[l_ac].bmi01,SQLCA.sqlcode,0) #No.TQC-660046
               CALL cl_err3("ins","bmi_file",g_bmi[l_ac].bmi01,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            #CKP
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i300_set_entry(p_cmd)                                                                                           
            CALL i300_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end--   
            INITIALIZE g_bmi[l_ac].* TO NULL      #971027
            LET g_bmi[l_ac].bmiacti = 'Y'       #Body default
            LET g_bmi_t.* = g_bmi[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmi01
 
        AFTER FIELD bmi01                        #check 編號是否重複
            IF g_bmi[l_ac].bmi01 IS NOT NULL THEN
            IF g_bmi[l_ac].bmi01 != g_bmi_t.bmi01 OR
               (g_bmi[l_ac].bmi01 IS NOT NULL AND g_bmi_t.bmi01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM bmi_file
                    WHERE bmi01 = g_bmi[l_ac].bmi01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_bmi[l_ac].bmi01 = g_bmi_t.bmi01
                    NEXT FIELD bmi01
                END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmi_t.bmi01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
{ckp#1}         DELETE FROM bmi_file WHERE bmi01 = g_bmi_t.bmi01
                IF SQLCA.sqlcode THEN
            #      CALL cl_err(g_bmi_t.bmi01,SQLCA.sqlcode,0) #No.TQC-660046
                   CALL cl_err3("del","bmi_file",g_bmi_t.bmi01,"",SQLCA.sqlcode,"","",1)  #No.TQC-660046
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i300_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmi[l_ac].* = g_bmi_t.*
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmi[l_ac].bmi01,-263,1)
               LET g_bmi[l_ac].* = g_bmi_t.*
            ELSE
               UPDATE bmi_file SET
                      bmi01=g_bmi[l_ac].bmi01,
                      bmi02=g_bmi[l_ac].bmi02,
                      bmiacti=g_bmi[l_ac].bmiacti,
                      bmimodu=g_user,
                      bmidate=g_today
                WHERE bmi01=g_bmi_t.bmi01
 
               IF SQLCA.sqlcode THEN
         #         CALL cl_err(g_bmi[l_ac].bmi01,SQLCA.sqlcode,0) #No.TQC-660046
                   CALL cl_err3("upd","bmi_file",g_bmi_t.bmi01,"",SQLCA.sqlcode,"","",1)   #No.TQC-660046
                   LET g_bmi[l_ac].* = g_bmi_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmi[l_ac].* = g_bmi_t.*   
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_bmi_t.* = g_bmi[l_ac].*          # 900423
            LET l_ac_t = l_ac  #FUN-D40030
            CLOSE i300_bcl
            COMMIT WORK
 
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
 
    CLOSE i300_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i300_b_askkey()
    CLEAR FORM
   CALL g_bmi.clear()
    CONSTRUCT g_wc2 ON bmi01,bmi02,bmiacti
            FROM s_bmi[1].bmi01,s_bmi[1].bmi02,s_bmi[1].bmiacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('bmiuser', 'bmigrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i300_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(200)
 
    LET g_sql =
        "SELECT bmi01,bmi02,bmiacti,'' ",
        " FROM bmi_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i300_pb FROM g_sql
    DECLARE bmi_curs CURSOR FOR i300_pb
 
    CALL g_bmi.clear()
    LET g_cnt = 1
#No.MOD-580322--begin                   
#   MESSAGE "查詢中..."                
   #CALL cl_err('','abm-809','0')     #No.TQC-920095 mark
#No.MOD-580322--end   
    FOREACH bmi_curs INTO g_bmi[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_bmi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_bmi TO s_bmi.* ATTRIBUTE(COUNT=g_rec_b)
     
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
         LET l_ac = 1
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
 
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
    
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i300_out()
    DEFINE
        l_bmi           RECORD LIKE bmi_file.*,
        l_i             LIKE type_file.num5,    #No.FUN-680096 SMALLINT
        l_name          LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680096 VARCHAR(20)
        l_za05          LIKE type_file.chr1000  #No.FUN-680096 VARCHAR(40)
   
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
#   CALL cl_outnam('abmi300') RETURNING l_name                          #FUN-770052
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog            #FUN-770052 
 
    LET g_sql="SELECT * FROM bmi_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
 {  PREPARE i300_p1 FROM g_sql                    # RUNTIME 編譯        #FUN-770052
    DECLARE i300_co                               # CURSOR
        CURSOR FOR i300_p1
 
     START REPORT i300_rep TO l_name
 
    FOREACH i300_co INTO l_bmi.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
         OUTPUT TO REPORT i300_rep(l_bmi.*)
    END FOREACH
 
    FINISH REPORT i300_rep
 
    CLOSE i300_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len) }                        #FUN-770052
#No.FUN-770052--add--begin--
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(g_wc2,'bmi01,bmi02,bmiacti')                                                                             
             RETURNING g_wc2                                                                                                         
        LET g_str = g_wc2                                                                                                            
     END IF                                                                                                                         
    
#No.FUN-770052--end--
    CALL cl_prt_cs1('abmi300','abmi300',g_sql,g_str)           #FUN-770052
END FUNCTION
 
{REPORT i300_rep(sr)                                           #FUN-770052
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
        sr RECORD LIKE bmi_file.*
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.bmi01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT 
            PRINT g_dash
            PRINT g_x[31],g_x[32],g_x[33]
            PRINT g_dash1 
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.bmi01,
                  COLUMN g_c[32],sr.bmi02,
                  COLUMN g_c[33],sr.bmiacti
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED #No.TQC-5B0030 modify
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-10), g_x[6] CLIPPED  #No.TQC-5B0030 modify
            ELSE
                SKIP 2 LINE
            END IF
END REPORT  }                                              #FUN-770052
 
#No.FUN-570110 --start--                                                                                                            
FUNCTION i300_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)                                                                                                               #No.FUN-680096 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("bmi01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i300_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680096 VARCHAR(1)                                                                                                               #No.FUN-680096 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("bmi01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--   
