# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: admi201.4gl
# Descriptions...: 版本代碼維護作業
# Date & Author..: 92/12/26 By Apple 
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0099 05/01/18 By kim 報表轉XML功能
# Modify.........: NO.FUN-570109 05/07/14 By Trisy key值可更改  
# Modify.........: No.FUN-660090 06/06/23 By Douzh cl_err --> cl_err3
# Modify.........: No.TQC-660147 06/07/04 By Pengu 報表列印有pzz寬度不合問題
# modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-780037 07/09/27 By sherry 報表改由p_query輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/18 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_dmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        dmb01       LIKE dmb_file.dmb01,   
        dmb02       LIKE dmb_file.dmb02,  
        dmbacti     LIKE type_file.chr1             #No.FUN-680097 INTEGER
                    END RECORD,
    g_dmb_t         RECORD                 #程式變數 (舊值)
        dmb01       LIKE dmb_file.dmb01,   
        dmb02       LIKE dmb_file.dmb02,  
        dmbacti     LIKE type_file.chr1             #No.FUN-680097 INTEGER
                    END RECORD,
   #g_wc2,g_sql     LIKE type_file.chr1000,       #No.FUN-680097
    g_wc2,g_sql     STRING,        
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680097 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680097 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680097 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5     #NO.FUN-570109          #No.FUN-680097 SMALLINT
DEFINE g_msg             LIKE type_file.chr1000 #No.FUN-780037
MAIN
DEFINE 
    p_row,p_col     LIKE type_file.num5          #No.FUN-680097 SMALLINT
#       l_time    LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW i201_w AT p_row,p_col WITH FORM "adm/42f/admi201"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i201_b_fill(g_wc2)
    CALL i201_menu()
    CLOSE WINDOW i201_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN 
               CALL i201_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN
               CALL i201_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-780037---Begin
               #CALL i201_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                   
               LET g_msg = 'p_query "admi201" "',g_wc2 CLIPPED,'"'               
               CALL cl_cmdrun(g_msg)              
               #No.FUN-780037---End 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"  
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_dmb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i201_q()
   CALL i201_b_askkey()
END FUNCTION
 
FUNCTION i201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680097 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680097 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680097 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態         #No.FUN-680097 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1              #No.FUN-680097 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT dmb01,dmb02,dmbacti FROM dmb_file WHERE dmb01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_dmb WITHOUT DEFAULTS FROM s_dmb.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT                                                              
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac) 
          END IF
   
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
           #IF g_dmb_t.dmb01 IS NOT NULL THEN
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_dmb_t.* = g_dmb[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET  g_before_input_done = FALSE                                                                                     
               CALL i201_set_entry(p_cmd)                                                                                           
               CALL i201_set_no_entry(p_cmd)                                                                                        
               LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end-- 
               BEGIN WORK
               OPEN i201_bcl USING g_dmb_t.dmb01
               IF STATUS THEN
                  CALL cl_err("OPEN i201_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i201_bcl INTO g_dmb[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_dmb_t.dmb01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#           NEXT FIELD dmb01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET  g_before_input_done = FALSE                                                                                     
            CALL i201_set_entry(p_cmd)                                                                                           
            CALL i201_set_no_entry(p_cmd)                                                                                        
            LET  g_before_input_done = TRUE                                                                                      
#No.FUN-570109 --end-- 
            INITIALIZE g_dmb[l_ac].* TO NULL      #900423
            LET g_dmb_t.* = g_dmb[l_ac].*         #新輸入資料
            LET g_dmb[l_ac].dmbacti='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD dmb01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO dmb_file(dmb01,dmb02,dmbacti,
                              dmbuser,dmbdate,dmboriu,dmborig)
         VALUES(g_dmb[l_ac].dmb01,g_dmb[l_ac].dmb02,
                g_dmb[l_ac].dmbacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#            CALL cl_err(g_dmb[l_ac].dmb01,SQLCA.sqlcode,0)   #No.FUN-660090
             CALL cl_err3("ins","dmb_file",g_dmb[l_ac].dmb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
        AFTER FIELD dmb01                        #check 編號是否重複
            IF g_dmb[l_ac].dmb01 IS NOT NULL THEN
            IF g_dmb[l_ac].dmb01 != g_dmb_t.dmb01 OR
               (g_dmb[l_ac].dmb01 IS NOT NULL AND g_dmb_t.dmb01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM dmb_file
                    WHERE dmb01 = g_dmb[l_ac].dmb01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_dmb[l_ac].dmb01 = g_dmb_t.dmb01
                    NEXT FIELD dmb01
                END IF
            END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_dmb_t.dmb01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM dmb_file WHERE dmb01 = g_dmb_t.dmb01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_dmb_t.dmb01,SQLCA.sqlcode,0)   #No.FUN-660090
                   CALL cl_err3("del","dmb_file",g_dmb_t.dmb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i201_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_dmb[l_ac].* = g_dmb_t.*
              CLOSE i201_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_dmb[l_ac].dmb01,-263,1)
              LET g_dmb[l_ac].* = g_dmb_t.*
           ELSE
               UPDATE dmb_file SET
                      dmb01=g_dmb[l_ac].dmb01,
                      dmb02=g_dmb[l_ac].dmb02,
                      dmbacti=g_dmb[l_ac].dmbacti,
                      dmbmodu=g_user,
                      dmbdate=g_today
                WHERE dmb01=g_dmb_t.dmb01  
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_dmb[l_ac].dmb01,SQLCA.sqlcode,0)   #No.FUN-660090
                  CALL cl_err3("upd","dmb_file",g_dmb_t.dmb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660090
                  LET g_dmb[l_ac].* = g_dmb_t.*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i201_bcl
                  COMMIT WORK
              END IF
          END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               IF p_cmd = 'u' THEN
                  LET g_dmb[l_ac].* = g_dmb_t.*                                    
               #FUN-D30034--add--str--
               ELSE
                  CALL g_dmb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i201_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
           #LET g_dmb_t.* = g_dmb[l_ac].*       #900423  #FUN-D30034 Mark                 
            LET l_ac_t = l_ac                                                   
            CLOSE i201_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i201_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(dmb01) AND l_ac > 1 THEN
                LET g_dmb[l_ac].* = g_dmb[l_ac-1].*
                NEXT FIELD dmb01
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
 
    CLOSE i201_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_b_askkey()
    CLEAR FORM
    CALL g_dmb.clear()
    CONSTRUCT g_wc2 ON dmb01,dmb02,dmbacti
            FROM s_dmb[1].dmb01,s_dmb[1].dmb02,s_dmb[1].dmbacti 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('dmbuser', 'dmbgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i201_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING       
 
    LET g_sql =
        "SELECT dmb01,dmb02,dmbacti",
        " FROM dmb_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY dmb01"
    PREPARE i201_pb FROM g_sql
    DECLARE dmb_curs CURSOR FOR i201_pb
 
    CALL g_dmb.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH dmb_curs INTO g_dmb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_dmb.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_dmb TO s_dmb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-780037---Begin
#FUNCTION i201_out()
#    DEFINE
#        l_i             LIKE type_file.num5,          #No.FUN-680097 SMALLINT
#        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#        l_dmb   RECORD LIKE dmb_file.*,
#        l_za05          LIKE type_file.chr1000,               #        #No.FUN-680097 VARCHAR(40)
#        l_chr           LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
#    IF g_wc2 IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
#    CALL cl_wait()
#    CALL cl_outnam('admi201') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM dmb_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i201_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i201_co CURSOR FOR i201_p1
#
#    START REPORT i201_rep TO l_name
 
#    FOREACH i201_co INTO l_dmb.*
#        IF SQLCA.sqlcode THEN
#           CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#           EXIT FOREACH
#           END IF
#        OUTPUT TO REPORT i201_rep(l_dmb.*)
#    END FOREACH
 
#    FINISH REPORT i201_rep
 
#    CLOSE i201_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
 
#REPORT i201_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680097 VARCHAR(1)
#        sr RECORD LIKE dmb_file.*,
#        l_chr           LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
 
#    ORDER BY sr.dmb01
 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT 
#            PRINT g_dash
#            PRINT g_x[31],g_x[32]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
 
#        ON EVERY ROW
#            IF sr.dmbacti = 'N' THEN PRINT '*'; END IF
#            PRINT COLUMN g_c[31],sr.dmb01,
#                  COLUMN g_c[32], sr.dmb02 
 
#        ON LAST ROW
#            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc2,'dmb01,dmb02,dmbacti')
#                    RETURNING g_sql
#               PRINT g_dash
#               #TQC-630166
#               #IF g_sql[001,080] > ' ' THEN
#               #        PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               #IF g_sql[071,140] > ' ' THEN
#               #        PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               #IF g_sql[141,210] > ' ' THEN
#               #        PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#                CALL cl_prt_pos_wc(g_sql)
#               #END TQC-630166
#            END IF
#            PRINT g_dash
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len -9), g_x[7] CLIPPED     #No.TQC-660147 modify
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len -9), g_x[6] CLIPPED     #No.TQC-660147 modify
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-780037---End
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i201_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("dmb01",TRUE)                                                                                           
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i201_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680097 VARCHAR(1)
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                               
     CALL cl_set_comp_entry("dmb01",FALSE)                                                                                          
  END IF                                                                                                                            
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--     
