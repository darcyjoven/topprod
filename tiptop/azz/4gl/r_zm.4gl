# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: r_zm.4gl
# Descriptions...: 目錄程式資料查詢及執行
# Date & Author..: 91/10/14 By LYS
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10050 10/01/11 By Hiko 更正編譯不過的問題
# Modify.........: No.FUN-B80037 11/08/04 By fanbj EXIT PROGRAM 前加cl_used(2)
# Modify.........: No.FUN-BB0047 11/11/08 By fengrui  調整時間函數重複關閉問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE   g_cmd           LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(100)
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose #No.FUN-680135 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(72)
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680135 SMALLINT 
DEFINE   g_rec_b         LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
DEFINE   g_forupd_sql STRING
DEFINE   g_before_input_done LIKE type_file.num5      #No.FUN-680135 SMALLINT
DEFINE   mi_curs_index   LIKE type_file.num10         #No.FUN-680135 INTEGER
 DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-580092 HCN #No.FUN-680135 INTEGER
DEFINE   mi_jump         LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680135 SMALLINT
 
END GLOBALS
 
MAIN
   OPTIONS #FUN-A10050
      INPUT NO WRAP        
   DEFER INTERRUPT  
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-B80037--add--
    CALL r_zm(0,0,'')
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80037
END MAIN
 
FUNCTION r_zm(p_row,p_col,p_key)
         DEFINE p_row,p_col     LIKE type_file.num5,          #No.FUN-680135 SMALLINT 
                p_key           LIKE zz_file.zz01,
                l_begin_key     LIKE zz_file.zz01,
                l_zm DYNAMIC ARRAY of RECORD
                                x     LIKE type_file.num5,    #No.FUN-680135 SMALLINT
                                zm01  LIKE zm_file.zm01,      # 程式代號
                                zz02m LIKE zz_file.zz02,      # 程式代號
                                zm03 LIKE zm_file.zm03,       # 程式代號
                                zm04 LIKE zm_file.zm04,       # 程式代號
                                zz02 LIKE zz_file.zz02,       # 程式名稱
                                zzuser LIKE zz_file.zzuser,   # OWNER
                                zz09 LIKE zz_file.zz09        # GROUP
                        END RECORD,
                l_n,l_ac,l_sl   LIKE type_file.num10,         #No.FUN-680135 INTEGER
                l_exit_sw       LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
                l_wc            LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(200)
                l_cmd           LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(200)
                l_sql           LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(200)
                l_priv          LIKE type_file.chr8            #No.FUN-680135 VARCHAR(10)
#       l_time                LIKE type_file.chr8              #No.FUN-6A0096
 
   #No.FUN-BB0047--mark--Begin---
   #  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   #No.FUN-BB0047--mark--End-----
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW r_zm_w AT p_row,p_col
         WITH FORM "azz/42f/r_zm"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF p_key IS NULL  # 沒有傳參數(程式代號)時
      THEN LET l_begin_key = ' '
      ELSE LET l_begin_key = p_key
   END IF
 
   WHILE TRUE
     CALL l_zm.clear()
     LET l_exit_sw = "y"
     LET l_ac = 1
     CALL cl_opmsg('q')  #顯示查詢的操作方式
     CONSTRUCT l_wc ON zm01,zm03,zm04,zz02,zzuser,zz09 FROM
               s_zm[1].zm01,s_zm[1].zm03,s_zm[1].zm04,
               s_zm[1].zz02,
               s_zm[1].zzuser,s_zm[1].zz09
#TQC-860017 start
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
     END CONSTRUCT
     LET l_wc = l_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#TQC-860017 end
     LET l_sql = "SELECT '',zm01,'',zm03,zm04,'',zzuser,zz09 ",
                 "  FROM zm_file,zz_file",
                 " WHERE zm04=zz01 ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY zm01,zm03"
     IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
 
     CALL cl_opmsg('w')
     PREPARE r_zm_prepare FROM l_sql
     DECLARE zm_curs CURSOR FOR r_zm_prepare
     FOREACH zm_curs INTO l_zm[l_ac].*
        LET l_zm[l_ac].x=l_ac
        SELECT gaz03 INTO l_zm[l_ac].zz02m FROM gaz_file
         WHERE gaz01=l_zm[l_ac].zm01
           AND gaz02=g_lang
        SELECT gaz03 INTO l_zm[l_ac].zz02 FROM gaz_file
         WHERE gaz01=l_zm[l_ac].zm04
           AND gaz02=g_lang
        LET l_ac = l_ac + 1
     END FOREACH
     CALL l_zm.deleteElement(l_ac)
     LET g_rec_b = l_ac - 1
     IF STATUS THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
     IF g_rec_b=0 THEN
        CALL cl_err('',100,1)
        CONTINUE WHILE
     END IF
 
     DISPLAY ARRAY l_zm TO s_zm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
          BEFORE ROW
             LET l_ac = ARR_CURR()
             LET l_sl = SCR_LINE()
             IF l_zm[l_ac].zm01 IS NOT NULL  THEN
                DISPLAY l_zm[l_ac].x,l_zm[l_ac].zm01 TO
                        s_zm[l_sl].x,s_zm[l_sl].zm01
             END IF
          AFTER ROW
             DISPLAY l_zm[l_ac].x,l_zm[l_ac].zm01 TO
                     s_zm[l_sl].x,s_zm[l_sl].zm01
          ON ACTION controln LET l_exit_sw = 'n'
                             CLEAR FORM
                             EXIT DISPLAY
          ON ACTION execute  LET l_ac = ARR_CURR()
                             CALL cl_cmdrun(l_zm[l_ac].zm04)
          ON ACTION controle LET l_ac = ARR_CURR()
                             CALL cl_cmdrun(l_zm[l_ac].zm04)
          ON ACTION controlp LET l_ac = ARR_CURR()
                             LET l_cmd="udm_tree '",l_zm[l_ac].zm04,"' "
                             CALL cl_cmdrun(l_cmd)
          ON ACTION controlg CALL cl_cmdask()
 
          ON ACTION exporttoexcel       #FUN-4B0049
             CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                  base.TypeInfo.create(l_zm),'','')
 
             EXIT DISPLAY
 
 
         #ON IDLE g_idle_seconds
         #   CALL cl_on_idle()
         #   CONTINUE DISPLAY
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
#TQC-860017 end
     END DISPLAY
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     IF l_exit_sw = "y" THEN EXIT WHILE  END IF
   END WHILE
   CLOSE WINDOW r_zm_w
   #No.FUN-BB0047--mark--Begin---
   #  CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0096
   #No.FUN-BB0047--mark--End-----
END FUNCTION
 
#Patch....NO.TQC-610037 <001> #
