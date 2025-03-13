# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: apji100.4gl
# Descriptions...: 工作項目名稱作業維護
# Date & Author..: 00/01/06 By Gina
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/14 By kim 報表轉XML功能
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改 
# Modify.........: No.MOD-590003 05/09/05 By will 報表格式對齊
# Modify.........: No.FUN-660053 06/06/12 By Carrier cl_err --> cl_err3
# Modify.........: NO.FUN-680103 06/08/26 BY hongmei欄位型態轉換
# Modify.........: No.FUN-6A0083 06/10/27 By hellen l_time轉g_time
# Modify.........: No.TQC-6C0169 06/12/27 By xufeng 修改報表格式       
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/09/28 By Carrier _out()轉p_query實現
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pje           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pje01       LIKE pje_file.pje01,       #部門編號
        pje02       LIKE pje_file.pje02,       #簡稱
        pjeacti     LIKE pje_file.pjeacti      #No.FUN-680103 VARCHAR(1)
                    END RECORD,
    g_pje_t         RECORD                     #程式變數 (舊值)
        pje01       LIKE pje_file.pje01,       #部門編號
        pje02       LIKE pje_file.pje02,       #簡稱
        pjeacti     LIKE pje_file.pjeacti      #No.FUN-680103 VARCHAR(1)
                    END RECORD,
    g_wc2,g_sql    STRING,  #No.FUN-580092 HCN 
    g_rec_b         LIKE type_file.num5,                #單身筆數     #No.FUN-680103 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680103 SMALLINT
 
DEFINE g_forupd_sql         STRING                  #SELECT ... FOR UPDATE SQL  
DEFINE g_cnt                LIKE type_file.num10    #No.FUN-680103 INTEGER
DEFINE g_msg                LIKE type_file.chr1000  #No.FUN-790050
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570103 #No.FUN-680103 SMALLINT
DEFINE g_i                  LIKE type_file.num5     #count/index for any purpose   #No.FUN-680103 SMALLINT 
 
MAIN
#DEFINE  l_time          LIKE type_file.chr8        #No.FUN-6A0083
 DEFINE  p_row,p_col	 LIKE type_file.num5        #No.FUN-680103  SMALLINT 
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0083
         RETURNING g_time    #No.FUN-6A0083
    LET p_row = 4 LET p_col = 10 
    OPEN WINDOW i100_w AT p_row,p_col WITH FORM "apj/42f/apji100"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i100_b_fill(g_wc2)
    CALL i100_menu()
    CLOSE WINDOW i100_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0083
         RETURNING g_time    #No.FUN-6A0083
END MAIN
 
FUNCTION i100_menu()
 
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i100_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i100_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i100_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apji100" "',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pje),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i100_q()
   CALL i100_b_askkey()
END FUNCTION
 
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680103 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用         #No.FUN-680103 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680103 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態           #No.FUN-680103 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,      #FUN-680103 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1       #FUN-680103 VARCHAR(01)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pje01,pje02,pjeacti FROM pje_file WHERE pje01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i100_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_pje WITHOUT DEFAULTS FROM s_pje.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
          IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
          END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            #IF g_pje_t.pje01 IS NOT NULL THEN
               LET p_cmd='u'
#No.FUN-570109 --start--                                                                                                            
               LET  g_before_input_done = FALSE                                                                                     
               CALL i100_set_entry(p_cmd)                                                                                           
               CALL i100_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--  
               BEGIN WORK
               LET g_pje_t.* = g_pje[l_ac].*  #BACKUP
               OPEN i100_bcl USING g_pje_t.pje01
               IF STATUS THEN
                  CALL cl_err("OPEN i100_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i100_bcl INTO g_pje[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pje_t.pje01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET  g_before_input_done = FALSE                                                                                     
            CALL i100_set_entry(p_cmd)                                                                                           
            CALL i100_set_no_entry(p_cmd)                                                                                        
            LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end--  
            LET l_n = ARR_COUNT()
            INITIALIZE g_pje[l_ac].* TO NULL      #900423
            LET g_pje[l_ac].pjeacti = 'Y'       #Body default
            LET g_pje_t.* = g_pje[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pje01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO pje_file(pje01,pje02,pjeacti,
                              pjeuser,pjedate,pjeoriu,pjeorig)
         VALUES(g_pje[l_ac].pje01,g_pje[l_ac].pje02,
                g_pje[l_ac].pjeacti, g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
             #CALL cl_err(g_pje[l_ac].pje01,SQLCA.sqlcode,0)  #No.FUN-660053
             CALL cl_err3("ins","pje_file",g_pje[l_ac].pje01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD pje01                        #check 編號是否重複
            IF NOT cl_null(g_pje[l_ac].pje01) THEN 
            IF g_pje[l_ac].pje01 != g_pje_t.pje01 OR
               (g_pje[l_ac].pje01 IS NOT NULL AND g_pje_t.pje01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM pje_file
                    WHERE pje01 = g_pje[l_ac].pje01
                IF l_n > 0 THEN      #資料重複
                    CALL cl_err('',-239,0)
                    LET g_pje[l_ac].pje01 = g_pje_t.pje01
                    NEXT FIELD pje01
                END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pje_t.pje01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM pje_file WHERE pje01 = g_pje_t.pje01
                IF SQLCA.sqlcode THEN
                   #CALL cl_err(g_pje_t.pje01,SQLCA.sqlcode,0)  #No.FUN-660053
                   CALL cl_err3("del","pje_file",g_pje_t.pje01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i100_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pje[l_ac].* = g_pje_t.*
              CLOSE i100_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pje[l_ac].pje01,-263,1)
              LET g_pje[l_ac].* = g_pje_t.*
           ELSE
              UPDATE pje_file SET pje01=g_pje[l_ac].pje01,
                                  pje02=g_pje[l_ac].pje02,
                                  pjeacti=g_pje[l_ac].pjeacti,
                                  pjemodu=g_user,
                                  pjedate=g_today
               WHERE pje01=g_pje_t.pje01 
              IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_pje[l_ac].pje01,SQLCA.sqlcode,0)   #No.FUN-660053
                 CALL cl_err3("upd","pje_file",g_pje_t.pje01,"",SQLCA.sqlcode,"","",1) #No.FUN-660053
                 LET g_pje[l_ac].* = g_pje_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i100_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                   LET g_pje[l_ac].* = g_pje_t.*                                    
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pje.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i100_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i100_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i100_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pje01) AND l_ac > 1 THEN
               LET g_pje[l_ac].* = g_pje[l_ac-1].*
               LET g_pje[l_ac].pje01 = NULL
               NEXT FIELD pje01
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
 
    CLOSE i100_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i100_b_askkey()
    CLEAR FORM
    CALL g_pje.clear()
    CONSTRUCT g_wc2 ON pje01,pje02,pjeacti
            FROM s_pje[1].pje01,s_pje[1].pje02,s_pje[1].pjeacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjeuser', 'pjegrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i100_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i100_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2       LIKE type_file.chr1000   #No.FUN-680103 VARCHAR(200)
 
    LET g_sql =
        "SELECT pje01,pje02,pjeacti",
        " FROM pje_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i100_pb FROM g_sql
    DECLARE pje_curs CURSOR FOR i100_pb
 
    CALL g_pje.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pje_curs INTO g_pje[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pje.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i100_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #No.FUN-680103 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pje TO s_pje.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i100_out()
#    DEFINE
#        l_pje           RECORD LIKE pje_file.*,
#        l_i             LIKE type_file.num5,     #No.FUN-680103 SMALLINT
#        l_name          LIKE type_file.chr20,    #FUN-680103 VARCHAR(20)  # External(Disk) file name  
#        l_za05          LIKE type_file.chr1000   #FUN-680103 VARCHAR(40)
#   
#    IF g_wc2 IS NULL THEN 
#       CALL cl_err('','9057',0)
#    RETURN END IF
#    CALL cl_wait()
##   LET l_name = 'apji100.out'
#    CALL cl_outnam('apji100') RETURNING l_name 
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM pje_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i100_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i100_co                         # CURSOR
#        CURSOR FOR i100_p1
# 
#    START REPORT i100_rep TO l_name
# 
#    FOREACH i100_co INTO l_pje.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i100_rep(l_pje.*)
#    END FOREACH
# 
#    FINISH REPORT i100_rep
# 
#    CLOSE i100_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i100_rep(sr)
#    DEFINE
#        l_str           LIKE aba_file.aba18,     #FUN-680103 VARCHAR(2)
#        l_trailer_sw    LIKE type_file.chr1,     #FUN-680103 VARCHAR(1)
#        sr RECORD LIKE pje_file.*
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.pje01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           #PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0169
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]   #No.TQC-6C0169
#            PRINT 
#            PRINT g_dash
#            PRINT g_x[31],g_x[32],g_x[33]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        ON EVERY ROW
#            IF sr.pjeacti = 'N' 
#                THEN LET l_str='* ';
#                ELSE LET l_str='  ';
#            END IF
#            PRINT COLUMN g_c[31],l_str,sr.pje01,
#                  COLUMN g_c[32],sr.pje02,
#                  COLUMN g_c[33],sr.pjeacti
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
##           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #No.MOD590003
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
##               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    #No.MOD-590003
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT 
#No.FUN-790050  --End   
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i100_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680103 VARCHAR(01)                                                                                                             #No.FUN-680103
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("pje01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i100_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680103 VARCHAR(01)                                                                                                               #No.FUN-680103
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("pje01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--    
