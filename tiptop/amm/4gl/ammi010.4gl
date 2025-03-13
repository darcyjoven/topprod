# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: ammi010.4gl
# Descriptions...: 加工碼維護作業
# Date & Author..: 00/11/29 By Chihming
# Modify.........: By Melody     
# Modify.........: No.FUN-4B0036 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.FUN-570110 05/07/13 By vivien KEY值更改控制 
# Modify.........: No.FUN-660094 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-810099 08/01/08 By Cockroach 報表改為p_query實現
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_mmc           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
        mmc01       LIKE mmc_file.mmc01,   #部門編號
        mmc02       LIKE mmc_file.mmc02,   #簡稱
        mmcacti     LIKE type_file.chr1    #No.FUN-680100 VARCHAR(1)
                    END RECORD,
    g_mmc_t         RECORD                 #程式變數 (舊值)
        mmc01       LIKE mmc_file.mmc01,   #部門編號
        mmc02       LIKE mmc_file.mmc02,   #簡稱
        mmcacti     LIKE type_file.chr1    #No.FUN-680100 VARCHAR(1)
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN         #No.FUN-680100
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680100 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680100 SMALLINT
    l_sl            LIKE type_file.num5                 #No.FUN-680100  SMALLINT#目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING    #SELECT ... FOR UPDATE SQL        #No.FUN-680100
 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5             #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5         #FUN-570110           #No.FUN-680100 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0076
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
    LET p_row = 3 LET p_col = 10
    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "amm/42f/ammi010"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
         RETURNING g_time    #No.FUN-6A0076
END MAIN
 
FUNCTION i010_menu()
 
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0036
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mmc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION
 
FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680100 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680100 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680100 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680100 VARCHAR(1)#可新增否
    l_allow_delete  LIKE type_file.chr1                 #No.FUN-680100 VARCHAR(1)#可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT mmc01,mmc02,mmcacti FROM mmc_file  ",
                       "  WHERE mmc01= ? FOR UPDATE     "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_mmc WITHOUT DEFAULTS FROM s_mmc.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_mmc_t.* = g_mmc[l_ac].*  #BACKUP
#No.FUN-570110 --start                                                                                                              
                LET g_before_input_done = FALSE                                                                                     
                CALL i010_set_entry(p_cmd)                                                                                          
                CALL i010_set_no_entry(p_cmd)                                                                                       
                LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110 --end   
                OPEN i010_bcl USING g_mmc_t.mmc01
                IF STATUS THEN
                   CALL cl_err("OPEN i010_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                END IF
                FETCH i010_bcl INTO g_mmc[l_ac].* 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_mmc_t.mmc01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD mmc01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110 --start                                                                                                              
            LET g_before_input_done = FALSE                                                                                     
            CALL i010_set_entry(p_cmd)                                                                                          
            CALL i010_set_no_entry(p_cmd)                                                                                       
            LET g_before_input_done = TRUE                                                                                      
#No.FUN-570110 --end   
            INITIALIZE g_mmc[l_ac].* TO NULL      #900423
            LET g_mmc[l_ac].mmcacti = 'Y'       #Body default
            LET g_mmc_t.* = g_mmc[l_ac].*         #新輸入資料
            DISPLAY g_mmc[l_ac].* TO s_mmc[l_sl].* 
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD mmc01
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i010_bcl
              CANCEL INSERT
           END IF
           INSERT INTO mmc_file(mmc01,mmc02,mmcacti,mmcuser,mmcdate,mmcoriu,mmcorig)
           VALUES(g_mmc[l_ac].mmc01,g_mmc[l_ac].mmc02,
                  g_mmc[l_ac].mmcacti,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_mmc[l_ac].mmc01,SQLCA.sqlcode,0) #No.FUN-660094
               CALL cl_err3("ins","mmc_file",g_mmc[l_ac].mmc01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
              LET g_mmc[l_ac].* = g_mmc_t.*
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD mmc01                        #check 編號是否重複
          IF g_mmc[l_ac].mmc01 != g_mmc_t.mmc01 OR
            (g_mmc[l_ac].mmc01 IS NOT NULL AND g_mmc_t.mmc01 IS NULL) THEN
                SELECT COUNT(*) INTO g_cnt FROM mmc_file
                    WHERE mmc01 = g_mmc[l_ac].mmc01
                  IF g_cnt >0 THEN
                    CALL cl_err('',-239,0)
                    LET g_mmc[l_ac].mmc01 = g_mmc_t.mmc01
                    NEXT FIELD mmc01
                  END IF
          END IF   
        
         AFTER FIELD mmc02
            IF g_mmc[l_ac].mmc01 IS NULL THEN NEXT FIELD mmc01 END IF
 
        AFTER FIELD mmcacti
            IF g_mmc[l_ac].mmcacti IS NULL OR
               g_mmc[l_ac].mmcacti NOT MATCHES '[YN]' THEN
               NEXT FIELD mmcacti
            END IF
 
        BEFORE DELETE                            #是否取消單身
           SELECT COUNT(*) INTO g_cnt FROM mmb_file 
            WHERE mmb05 = g_mmc_t.mmc01  
           IF g_cnt > 0 THEN 
               CALL cl_err('','amm-105',1) 
	       EXIT INPUT
           END IF
           IF g_mmc_t.mmc01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 CANCEL DELETE 
              END IF 
              DELETE FROM mmc_file WHERE mmc01 = g_mmc_t.mmc01
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_mmc_t.mmc01,SQLCA.sqlcode,0) #No.FUN-660094
                  CALL cl_err3("del","mmc_file",g_mmc_t.mmc01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2  
              MESSAGE "Delete OK"
              CLOSE i010_bcl
              COMMIT WORK
           END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mmc[l_ac].* = g_mmc_t.*
            CLOSE i010_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_mmc[l_ac].mmc01,-263,1)
             LET g_mmc[l_ac].* = g_mmc_t.*
         ELSE
             UPDATE mmc_file SET
                mmc01=g_mmc[l_ac].mmc01,
                mmc02=g_mmc[l_ac].mmc02,
                mmcacti=g_mmc[l_ac].mmcacti,
                mmcmodu=g_user,
                mmcdate=g_today
              WHERE CURRENT OF i010_bcl
             IF SQLCA.sqlcode THEN
#                CALL cl_err(g_mmc[l_ac].mmc01,SQLCA.sqlcode,0) #No.FUN-660094
                 CALL cl_err3("upd","mmc_file",g_mmc[l_ac].mmc01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
                LET g_mmc[l_ac].* = g_mmc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i010_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_mmc[l_ac].* = g_mmc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_mmc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i010_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i010_bcl
            COMMIT WORK
 
{       ON ACTION controlp
           CASE WHEN INFIELD(mmc03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_mmc[l_ac].mmc03
                   CALL cl_create_qry() RETURNING g_mmc[l_ac].mmc03
#                   CALL FGL_DIALOG_SETBUFFER( g_mmc[l_ac].mmc03 )
                   DISPLAY g_mmc[l_ac].mmc03 TO s_mmc[l_sl].mmc03
                   CALL i010_mmc03('a')
                OTHERWISE
                    EXIT CASE
            END CASE
}
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(mmc01) AND l_ac > 1 THEN
                LET g_mmc[l_ac].* = g_mmc[l_ac-1].*
                DISPLAY g_mmc[l_ac].* TO s_mmc[l_sl].* 
                NEXT FIELD mmc01
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
 
    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_mmc.clear()
    CONSTRUCT g_wc2 ON mmc01,mmc02,mmcacti
            FROM s_mmc[1].mmc01,s_mmc[1].mmc02,s_mmc[1].mmcacti
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('mmcuser', 'mmcgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i010_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2   LIKE type_file.chr1000       #No.FUN-680100 VARCHAR(200)
 
    LET g_sql =
        "SELECT mmc01,mmc02,mmcacti",
        " FROM mmc_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i010_pb FROM g_sql
    DECLARE mmc_curs CURSOR FOR i010_pb
    LET g_rec_b=0
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH mmc_curs INTO g_mmc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_mmc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i010_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mmc TO s_mmc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
      ON ACTION exporttoexcel       #FUN-4B0036
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#NO.FUN-810099  --BEGIN MARK--
FUNCTION i010_out()
    DEFINE
        l_mmc           RECORD LIKE mmc_file.*,
        l_i             LIKE type_file.num5,                  #No.FUN-680100 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name        #No.FUN-680100 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #        #No.FUN-680100 VARCHAR(40)
DEFINE   l_cmd      LIKE type_file.chr1000   #NO.FUN-810099                                                                         
    IF cl_null(g_wc2) THEN                                                                                                          
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "ammi010" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN   
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('',-400,0)
#      CALL cl_err('','9057',0)
#    RETURN 
#   END IF
#   CALL cl_wait()
#    LET l_name = 'ammi010.out'
#   CALL cl_outnam('ammi010') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM mmc_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i010_co                         # SCROLL CURSOR
#       CURSOR FOR i010_p1
 
#   START REPORT i010_rep TO l_name
 
#   FOREACH i010_co INTO l_mmc.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i010_rep(l_mmc.*)
#   END FOREACH
 
#   FINISH REPORT i010_rep
 
#   CLOSE i010_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i010_rep(sr)
#   DEFINE
#       l_trailer_sw    LIKE type_file.chr1,      #No.FUN-680100 VARCHAR(1)
#       sr RECORD LIKE mmc_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.mmc01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT 
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           IF sr.mmcacti = 'N' THEN PRINT '*'; END IF
#           PRINT COLUMN g_c[31],sr.mmc01,
#                 COLUMN g_c[32],sr.mmc02,
#                 COLUMN g_c[33],sr.mmcacti
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[33], g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
#No.FUN-570110 --start                                                                                                              
FUNCTION i010_set_entry(p_cmd)                                                                                                      
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680100 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                              
     CALL cl_set_comp_entry("mmc01",TRUE)                                                                                           
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i010_set_no_entry(p_cmd)                                                                                                   
  DEFINE p_cmd   LIKE type_file.chr1        #No.FUN-680100 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("mmc01",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570110 --end 
