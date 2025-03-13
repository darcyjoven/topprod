# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapi104.4gl
# Descriptions...: 帳款類別維護作業
# Date & Author..: 91/12/15  By  Felicity Tseng
# Modify.........: 94/12/06 By Danny (將畫面改成多行式)
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0097 04/12/22 By Nicola 報表架構修改
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0088 06/11/08 By baogui 結束位置調整
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-770005 07/06/26 By ve 報表改為使用crystal report
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_apr          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
      apr01          LIKE apr_file.apr01,   
      apr02          LIKE apr_file.apr02,  
     #apracti        VARCHAR(1)                #FUN-660117 remark
      apracti        LIKE apr_file.apracti   #FUN-660117 
                  END RECORD,
   g_apr_t        RECORD                 #程式變數 (舊值)
      apr01          LIKE apr_file.apr01,   
      apr02          LIKE apr_file.apr02,  
     #apracti        VARCHAR(1)                #FUN-660117 remark
      apracti        LIKE apr_file.apracti  #FUN-660117 
                  END RECORD,
   #g_wc2,g_sql    LIKE type_file.chr1000,  #No.FUN-690028 VARCHAR(300)
   g_wc2,g_sql    STRING,                #TQC-630166 
   g_rec_b        LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
   l_ac           LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-570108   #No.FUN-690028 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0055
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
   LET p_row = 3 LET p_col = 30
   OPEN WINDOW i104_w AT p_row,p_col
     WITH FORM "aap/42f/aapi104"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1'
   CALL i104_b_fill(g_wc2)
 
   CALL i104_menu()
 
   CLOSE WINDOW i104_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
END MAIN
 
FUNCTION i104_menu()
 
   WHILE TRUE
      CALL i104_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i104_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i104_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
               CALL i104_out()
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg"   
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN 
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_apr),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i104_q()
 
   CALL i104_b_askkey()
 
END FUNCTION
 
FUNCTION i104_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
   l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = " SELECT apr01,apr02,apracti FROM apr_file WHERE apr01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_apr WITHOUT DEFAULTS FROM s_apr.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_apr_t.* = g_apr[l_ac].*  #BACKUP
#No.FUN-570108 --start--                                                        
            LET g_before_input_done = FALSE                                     
            CALL i104_set_entry(p_cmd)                                          
            CALL i104_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108 --end--            
            BEGIN WORK
            OPEN i104_bcl USING g_apr_t.apr01
            IF STATUS THEN
               CALL cl_err("OPEN i104_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i104_bcl INTO g_apr[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_apr_t.apr01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108 --start--                                                        
         LET g_before_input_done = FALSE                                        
         CALL i104_set_entry(p_cmd)                                             
         CALL i104_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
#No.FUN-570108 --end--                     
         INITIALIZE g_apr[l_ac].* TO NULL      #900423
         LET g_apr_t.* = g_apr[l_ac].*         #新輸入資料
         LET g_apr[l_ac].apracti='Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD apr01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO apr_file(apr01,apr02,apracti,apruser,aprdate,aproriu,aprorig)
              VALUES(g_apr[l_ac].apr01,g_apr[l_ac].apr02,
                     g_apr[l_ac].apracti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_apr[l_ac].apr01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","apr_file",g_apr[l_ac].apr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD apr01                        #check 編號是否重複
         IF g_apr[l_ac].apr01 != g_apr_t.apr01 OR
            (g_apr[l_ac].apr01 IS NOT NULL AND g_apr_t.apr01 IS NULL) THEN
            SELECT count(*) INTO l_n FROM apr_file
             WHERE apr01 = g_apr[l_ac].apr01
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_apr[l_ac].apr01 = g_apr_t.apr01
               NEXT FIELD apr01
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_apr_t.apr01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM apr_file WHERE apr01 = g_apr_t.apr01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_apr_t.apr01,SQLCA.sqlcode,0)   #No.FUN-660122
               CALL cl_err3("del","apr_file",g_apr_t.apr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK" 
            CLOSE i104_bcl     
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_apr[l_ac].* = g_apr_t.*
            CLOSE i104_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_apr[l_ac].apr01,-263,1)
            LET g_apr[l_ac].* = g_apr_t.*
         ELSE
            UPDATE apr_file SET apr01=g_apr[l_ac].apr01,
                                apr02=g_apr[l_ac].apr02,
                                apracti=g_apr[l_ac].apracti,
                                aprmodu=g_user,
                                aprdate=g_today
             WHERE apr01 = g_apr_t.apr01
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_apr[l_ac].apr01,SQLCA.sqlcode,0)   #No.FUN-660122
              CALL cl_err3("upd","apr_file",g_apr_t.apr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
              LET g_apr[l_ac].* = g_apr_t.*
           ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
           END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()                                               
         IF INT_FLAG THEN                 #900423                            
            CALL cl_err('',9001,0)                                           
            LET INT_FLAG = 0                                                 
            IF p_cmd = 'u' THEN
               LET g_apr[l_ac].* = g_apr_t.* 
            #FUN-D30032--add--str--
            ELSE
               CALL g_apr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i104_bcl                                                   
            ROLLBACK WORK                                                    
            EXIT INPUT                                                       
         END IF                                                              
         LET l_ac_t = l_ac                                                   
         CLOSE i104_bcl                                                      
         COMMIT WORK            
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(apr01) AND l_ac > 1 THEN
            LET g_apr[l_ac].* = g_apr[l_ac-1].*
            NEXT FIELD apr01
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
 
   CLOSE i104_bcl
   COMMIT WORK
        
END FUNCTION
 
FUNCTION i104_b_askkey()
 
   CLEAR FORM
   CALL g_apr.clear()
 
   CONSTRUCT g_wc2 ON apr01,apr02,apracti
           FROM s_apr[1].apr01,s_apr[1].apr02,s_apr[1].apracti 
 
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('apruser', 'aprgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0
#      RETURN
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i104_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i104_b_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   LET g_sql = "SELECT apr01,apr02,apracti",
               " FROM apr_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY 1"
   PREPARE i104_pb FROM g_sql
   DECLARE apr_curs CURSOR FOR i104_pb
 
   CALL g_apr.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH apr_curs INTO g_apr[g_cnt].*   #單身 ARRAY 填充
      IF STAtUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_apr.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apr TO s_apr.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION
FUNCTION i104_out()
   DEFINE
      l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
      l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
      l_apr   RECORD LIKE apr_file.*,
      l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF g_wc2 IS NULL THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
   CALL cl_wait()
 
   CALL cl_outnam('aapi104') RETURNING l_name
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
   
   LET g_sql="SELECT * FROM apr_file ",          # 組合出 SQL 指令
             " WHERE ",g_wc2 CLIPPED
#No.FUN-770005----------begin----------------
{
   PREPARE i104_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i104_co CURSOR FOR i104_p1
 
   START REPORT i104_rep TO l_name
 
   FOREACH i104_co INTO l_apr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      OUTPUT TO REPORT i104_rep(l_apr.*)
   END FOREACH
 
   FINISH REPORT i104_rep
 
   CLOSE i104_co
   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
}
   CALL cl_prt_cs1('aapi104','aapi104',g_sql,g_wc2)
#No.FUN-770005-----------end----------------------
END FUNCTION
 
#No.FUN-770005----------begin----------------                                                                                       
{ 
REPORT i104_rep(sr)
   DEFINE
      l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
      sr RECORD LIKE apr_file.*,
      l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
      TOP MARGIN g_top_margin
      LEFT MARGIN g_left_margin
      BOTTOM MARGIN g_bottom_margin
      PAGE LENGTH g_page_line
 
   ORDER BY sr.apr01
 
   FORMAT
      PAGE HEADER
         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1 ,g_x[1]
         LET g_pageno = g_pageno + 1
         LET pageno_total = PAGENO USING '<<<',"/pageno"
         PRINT g_head CLIPPED,pageno_total
         PRINT ' '
         PRINT g_dash[1,g_len]
         PRINT g_x[31],g_x[32]
         PRINT g_dash1
         LET l_trailer_sw = 'y'
 
      ON EVERY ROW
         IF sr.apracti = 'N' THEN
            PRINT '*';
         END IF
         PRINT COLUMN g_c[31],sr.apr01,
               COLUMN g_c[32],sr.apr02
 
      ON LAST ROW
         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
            CALL cl_wcchp(g_wc2,'apr01,apr02') RETURNING g_sql
            PRINT g_dash[1,g_len]
            #TQC-630166 
            #IF g_sql[001,080] > ' ' THEN
            #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,COLUMN g_c[32],g_sql[001,070] CLIPPED
            #END IF
            #IF g_sql[071,140] > ' ' THEN
            #   PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED
            #END IF
            #IF g_sql[141,210] > ' ' THEN
            #   PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED
            #END IF
             CALL cl_prt_pos_wc(g_sql)
            #END TQC-630166 
         END IF
         PRINT g_dash[1,g_len]
         LET l_trailer_sw = 'n'
      #  PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[32],g_x[7] CLIPPED     #TQC-6A0088
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[7] CLIPPED     #TQC-6A0088
 
      PAGE TRAILER
         IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
      #     PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_c[32],g_x[6] CLIPPED   #TQC-6A0088
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN g_len-9,g_x[6] CLIPPED   #TQC-6A0088
         ELSE
            SKIP 2 LINE
         END IF
 
END REPORT
}                                                                                                                                   
#No.FUN-770005-----------end---------------------- 
#No.FUN-570108 --start--                                                        
FUNCTION i104_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-690028 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN                            
     CALL cl_set_comp_entry("apr01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i104_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1      #No.FUN-690028 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey='N' THEN            
     CALL cl_set_comp_entry("apr01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end--  
