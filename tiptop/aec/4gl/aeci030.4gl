# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: aeci030.4gl
# Descriptions...: 留置原因維護作業
# Date & Author..: 99/06/28 By Apple 
# Modify.........: No.FUN-4B0012 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-510032 05/01/14 By pengu 報表轉XML
# Modify.........: No.FUN-570110 05/07/14 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.FUN-660091 05/06/14 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680073 06/08/21 By hongmei 欄位型態轉換
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-760085 07/07/10 By sherry 報表改由Crystal Report輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_sgg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        sgg01       LIKE sgg_file.sgg01,   
        sgg02       LIKE sgg_file.sgg02,  
        sggacti     LIKE sgg_file.sggacti      # No.FUN-680073  VARCHAR(1)  
                    END RECORD,
    g_sgg_t         RECORD                 #程式變數 (舊值)
        sgg01       LIKE sgg_file.sgg01,   
        sgg02       LIKE sgg_file.sgg02,  
        sggacti     LIKE sgg_file.sggacti      # No.FUN-680073 VARCHAR(1)   
                    END RECORD,
   #g_wc2,g_sql     VARCHAR(300),
    g_wc2,g_sql     LIKE type_file.chr1000,      #TQC-630166        #No.FUN-680073
    g_str           LIKE type_file.chr1000,      #No.FUN-760085   
    g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,         #No.FUN-680073 SMALLINT SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL    
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680073 INTEGER
 
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680073 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570110          #No.FUN-680073 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0100
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AEC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW i030_w AT p_row,p_col WITH FORM "aec/42f/aeci030"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i030_b_fill(g_wc2)
    CALL i030_menu()
    CLOSE WINDOW i030_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
END MAIN
 
FUNCTION i030_menu()
 
   WHILE TRUE
      CALL i030_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "detail"  
            IF cl_chk_act_auth() THEN 
               CALL i030_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i030_out()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sgg),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i030_q()
   CALL i030_b_askkey()
END FUNCTION
 
FUNCTION i030_b()
DEFINE
    l_ac_t          LIKE type_file.num5,            #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,            #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,            #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,            #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,            #No.FUN-680073   VARCHAR(01),
    l_allow_delete  LIKE type_file.chr1             #No.FUN-680073   VARCHAR(01),
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sgg01,sgg02,sggacti FROM sgg_file WHERE sgg01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i030_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_sgg WITHOUT DEFAULTS FROM s_sgg.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
                         UNBUFFERED, INSERT ROW = l_allow_insert,
                         DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
          IF g_rec_b!=0 THEN
             CALL fgl_set_arr_curr(l_ac) 
          END IF
            
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sgg_t.* = g_sgg[l_ac].*  #BACKUP
#No.FUN-570110 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i030_set_entry(p_cmd)                                                                                           
               CALL i030_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end-- 
               BEGIN WORK
               OPEN i030_bcl USING g_sgg_t.sgg01
               IF STATUS THEN
                  CALL cl_err("OPEN i030_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i030_bcl INTO g_sgg[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sgg_t.sgg01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i030_set_entry(p_cmd)                                                                                           
            CALL i030_set_no_entry(p_cmd)                                                                                        
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570110 --end-- 
            INITIALIZE g_sgg[l_ac].* TO NULL      #900423
            LET g_sgg_t.* = g_sgg[l_ac].*         #新輸入資料
            LET g_sgg[l_ac].sggacti='Y'
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgg01
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO sgg_file(sgg01,sgg02,sggacti,
                                sgguser,sggdate,sggoriu,sggorig)
           VALUES(g_sgg[l_ac].sgg01,g_sgg[l_ac].sgg02,
                  g_sgg[l_ac].sggacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_sgg[l_ac].sgg01,SQLCA.sqlcode,0) #No.FUN-660091
               CALL cl_err3("ins","sgg_file",g_sgg[l_ac].sgg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               COMMIT WORK
           END IF
 
        AFTER FIELD sgg01                        #check 編號是否重複
            IF NOT cl_null(g_sgg[l_ac].sgg01) THEN
               IF g_sgg[l_ac].sgg01 != g_sgg_t.sgg01 OR
                  cl_null(g_sgg_t.sgg01) THEN
                  SELECT COUNT(*) INTO l_n FROM sgg_file
                   WHERE sgg01 = g_sgg[l_ac].sgg01
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_sgg[l_ac].sgg01 = g_sgg_t.sgg01
                     NEXT FIELD sgg01
                  END IF
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_sgg_t.sgg01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
 
                DELETE FROM sgg_file WHERE sgg01 = g_sgg_t.sgg01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_sgg_t.sgg01,SQLCA.sqlcode,0) #No.FUN-660091
                   CALL cl_err3("del","sgg_file",g_sgg_t.sgg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i030_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_sgg[l_ac].* = g_sgg_t.*
              CLOSE i030_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_sgg[l_ac].sgg01,-263,1)
              LET g_sgg[l_ac].* = g_sgg_t.*
           ELSE
              UPDATE sgg_file SET sgg01=g_sgg[l_ac].sgg01,
                                  sgg02=g_sgg[l_ac].sgg02,
                                  sggacti=g_sgg[l_ac].sggacti,
                                  sggmodu=g_user,
                                  sggdate=g_today
               WHERE sgg01 = g_sgg_t.sgg01
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_sgg[l_ac].sgg01,SQLCA.sqlcode,0) #No.FUN-660091
                  CALL cl_err3("upd","sgg_file",g_sgg_t.sgg01,"",SQLCA.sqlcode,"","",1) #FUN-660091
                  LET g_sgg[l_ac].* = g_sgg_t.*
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
               IF p_cmd='u' THEN
                  LET g_sgg[l_ac].* = g_sgg_t.*                                    
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sgg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i030_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
            LET l_ac_t = l_ac                                                   
            CLOSE i030_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i030_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(sgg01) AND l_ac > 1 THEN
                LET g_sgg[l_ac].* = g_sgg[l_ac-1].*
                NEXT FIELD sgg01
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
 
    CLOSE i030_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i030_b_askkey()
    CLEAR FORM
    CALL g_sgg.clear()
    CONSTRUCT g_wc2 ON sgg01,sgg02,sggacti
            FROM s_sgg[1].sgg01,s_sgg[1].sgg02,s_sgg[1].sggacti 
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('sgguser', 'sgggrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i030_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i030_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000     #No.FUN-680073 VARCHAR(200)
 
    LET g_sql =
        "SELECT sgg01,sgg02,sggacti",
        " FROM sgg_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i030_pb FROM g_sql
    DECLARE sgg_curs CURSOR FOR i030_pb
 
    CALL g_sgg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH sgg_curs INTO g_sgg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
 
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_sgg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i030_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sgg TO s_sgg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i030_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680073 SMALLINT
        l_name          LIKE type_file.chr20,    # No.FUN-680073  VARCHAR(20),   # External(Disk) file name
        l_sgg   RECORD  LIKE sgg_file.*,
        l_za05          LIKE type_file.chr1000,  # No.FUN-680073 VARCHAR(40), 
        l_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
    IF g_wc2 IS NULL THEN
  #     CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aeci030.out'
#   CALL cl_outnam('aeci030') RETURNING l_name           #No.FUN-760085   
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#No.FUN-760085---Begin
#   LET g_sql="SELECT * FROM sgg_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i030_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i030_co                         # SCROLL CURSOR
#       CURSOR FOR i030_p1
 
#   START REPORT i030_rep TO l_name
 
#   FOREACH i030_co INTO l_sgg.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('Foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#          END IF
#       OUTPUT TO REPORT i030_rep(l_sgg.*)
#   END FOREACH
 
#   FINISH REPORT i030_rep
 
#   CLOSE i030_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
    IF g_zz05 = 'Y' THEN   
       CALL cl_wcchp(g_wc2,'sgg01,sgg02,sggacti')           
       RETURNING g_wc2
       LET g_str = g_str CLIPPED,";", g_wc2
    END IF  
    LET g_str =  g_wc2      
    LET g_sql= "SELECT sgg01,sgg02,sggacti FROM sgg_file ",
               " WHERE ",g_wc2 CLIPPED 
    CALL cl_prt_cs1('aeci030','aeci030',g_sql,g_str)       
#No.FUN-760085---End        
END FUNCTION
 
#No.FUN-760085---Begin
{
REPORT i030_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680073 VARCHAR(1),
        sr RECORD LIKE sgg_file.*,
        l_chr           LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.sgg01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED
            PRINT g_dash1
#                 01234567890123456789012345678901234567890
#11 0 heading 留置原因碼       留置原因                 
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            IF sr.sggacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
            PRINT COLUMN g_c[32],sr.sgg01,
                  COLUMN g_c[33],sr.sgg02 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc2,'sgg01,sgg02,sgg03,sgg04,sgg05')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
               #        PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
                CALL cl_prt_pos_wc(g_sql)  
               #END TQC-630166
            END IF
            PRINT g_dash2[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
}
#No.FUN-760085---End
#No.FUN-570110 --start--                                                                                                            
FUNCTION i030_set_entry(p_cmd)                                                                                                      
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1               #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("sgg01",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i030_set_no_entry(p_cmd)                                                                                                   
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1               #No.FUN-680073 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("sgg01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end--    
