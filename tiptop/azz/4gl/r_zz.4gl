# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: r_zz.4gl
# Descriptions...: 程式資料查詢及執行
# Date & Author..: 91/10/14 By LYS
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
#
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A10050 10/01/11 By Hiko 更正編譯不過的問題
# Modify.........: No.FUN-B80037 11/08/04 By fanbj r_zz 改用g_prog 

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS
DEFINE   g_cmd           LIKE type_file.chr1000       #No.FUN-680135 VARCHAR(100)
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680135 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680135 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose   #No.FUN-680135 SMALLINT
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
    CALL r_zz(0,0,'')
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80037--add--
END MAIN
 
FUNCTION r_zz(p_row,p_col,p_key)
   DEFINE p_row,p_col     LIKE type_file.num5,          #No.FUN-680135 SMALLINT 
          p_key           LIKE zz_file.zz01,
          l_begin_key     LIKE zz_file.zz01,
          l_zz DYNAMIC ARRAY of RECORD
                          x    LIKE type_file.num5,     #No.FUN-680135 SMALLINT
                          zz01 LIKE zz_file.zz01,       # 程式代號
                          zz02 LIKE zz_file.zz02,       # 程式名稱
                          zzuser LIKE zz_file.zzuser,   # OWNER
                          zz09 LIKE zz_file.zz09        # GROUP
                  END RECORD,
          l_arrno,l_maxac LIKE type_file.num5,          #No.FUN-680135 SMALLINT
          l_n,l_ac,l_sl   LIKE type_file.num5,          #No.FUN-680135 SMALLINT
          l_exit_sw       LIKE type_file.chr1,          #No.FUN-680135 VARCHAR(1)
          l_wc            LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(200)
          l_sql           LIKE type_file.chr1000,       #No.FUN-680135 VARCHAR(200)
          l_priv          LIKE cre_file.cre08           #No.FUN-680135 VARCHAR(10)
#       l_time          LIKE type_file.chr8              #No.FUN-6A0096
   DEFINE l_cnt           LIKE type_file.num5           #No.FUN-680135 SMALLINT
   DEFINE l_zln04         LIKE gzln_file.gzln04         #FUN-680135    VARCHAR(100)
   DEFINE l_zln05         LIKE gzln_file.gzln05         #FUN-680135    VARCHAR(100)
   DEFINE ls_zln05        STRING
   DEFINE ls_zln04        STRING
 
#   CALL cl_used('r_zz',l_time,1) RETURNING l_time   #No.FUN-6A0096

   # No.FUN-B80037--------------------------------------------------
   #CALL cl_used("r_zz",g_time,1) RETURNING g_time   #No.FUN-6A0096
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time
   # No.FUN-B80037--------------------------------------------------

   LET l_arrno = 500
   LET p_row = 6 LET p_col = 20
   OPEN WINDOW r_zz_w AT p_row,p_col
        WITH FORM "azz/42f/r_zz"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF p_key IS NULL  # 沒有傳參數(程式代號)時
      THEN LET l_begin_key = ' '
      ELSE LET l_begin_key = p_key
   END IF
 
   WHILE TRUE
     CALL l_zz.clear()
     LET l_exit_sw = "y"
     LET l_ac = 1
     CALL cl_opmsg('q')  #顯示查詢的操作方式
     INPUT l_wc FROM s_zz[1].zz01
         ON ACTION accept
            DISPLAY l_wc
            LET INT_FLAG=0
            EXIT INPUT
 #TQC-860017 start
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
#TQC-860017 end   
     END INPUT
     IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
     IF l_wc IS NOT NULL THEN
#No.FUN-680135 --start欄位類型修改
        DROP TABLE zln05_tmp
#       CREATE TEMP TABLE zln05_tmp (zln05 VARCHAR(20) )
        CREATE TEMP TABLE zln05_tmp(
           zln05 LIKE gzln_file.gzln05)
#No.FUN-680135 --end	
       #CREATE UNIQUE INDEX zln05_tmp01 ON zln05_tmp(zln05)
        DECLARE get_zln05_cs CURSOR FOR
           SELECT zln05,zln04 FROM zln_file WHERE zln01=l_wc
        FOREACH get_zln05_cs INTO l_zln05,l_zln04
           LET ls_zln05=l_zln05
           LET l_zln05=''
           LET l_cnt=''
           IF l_zln04='4gl' THEN
              LET l_cnt=ls_zln05.getIndexOF('.4gl',1)
           END IF
           IF l_zln04='per' THEN
              LET l_cnt=ls_zln05.getIndexOF('.per',1)
           END IF
           LET l_zln05=ls_zln05.subString(1,l_cnt-1)
           IF l_zln05 IS NOT NULL THEN
              INSERT INTO zln05_tmp VALUES(l_zln05)
           END IF
        END FOREACH
        SELECT COUNT(*) INTO g_cnt FROM zln05_tmp
        IF g_cnt=0 THEN
           LOAD FROM 'zln05.txt' INSERT INTO zln05_tmp
           RUN 'echo $PWD'
           DISPLAY STATUS,'-->',SQLCA.sqlerrd[3]
        END IF
 
        LET l_sql = "SELECT '',zln05,zz02,zzuser,zz09 ",
                    "  FROM OUTER zz_file,zln05_tmp",
                    " WHERE zz_file.zz01=zln05 ",
                    " ORDER BY zz01"
     ELSE
        CONSTRUCT l_wc ON zz01,zz02,zzuser,zz09 FROM
                  s_zz[1].zz01,s_zz[1].zz02,s_zz[1].zzuser,s_zz[1].zz09
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
        LET l_wc = l_wc CLIPPED,cl_get_extra_cond('zzuser', 'zzgrup') #FUN-980030
#TQC-860017 end
        IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
        LET l_sql = "SELECT '',zz01,zz02,zzuser,zz09 FROM zz_file",
                    " WHERE ",l_wc CLIPPED,
                   #" ORDER BY zz01"
                    " ORDER BY zz09"
     END IF
 
     CALL cl_opmsg('w')
     PREPARE r_zz_prepare FROM l_sql
     DECLARE zz_curs CURSOR FOR r_zz_prepare
     FOREACH zz_curs INTO l_zz[l_ac].*
        LET l_zz[l_ac].x=l_ac
        SELECT gaz03 INTO l_zz[l_ac].zz02 FROM gaz_file
         WHERE gaz01=l_zz[l_ac].zz01
           AND gaz02=g_lang
        LET l_ac = l_ac + 1
     END FOREACH
     CALL l_zz.deleteElement(l_ac)
 
     LET g_rec_b = l_ac - 1
     IF  g_rec_b=0 THEN
         CALL cl_err('',100,0)
         CONTINUE WHILE
     END IF
 
     IF STATUS THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
 
     DISPLAY ARRAY l_zz TO s_zz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
{
     INPUT   ARRAY l_zz  WITHOUT DEFAULTS FROM s_zz.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=FALSE,DELETE ROW=FALSE)
}
 
          BEFORE ROW
             LET l_ac = ARR_CURR()
             LET l_sl = SCR_LINE()
             IF l_zz[l_ac].zz01 IS NOT NULL AND l_ac <= l_maxac THEN
                DISPLAY l_zz[l_ac].x,l_zz[l_ac].zz01 TO
                        s_zz[l_sl].x,s_zz[l_sl].zz01
             END IF
          AFTER ROW
             DISPLAY l_zz[l_ac].x,l_zz[l_ac].zz01 TO
                     s_zz[l_sl].x,s_zz[l_sl].zz01
          ON ACTION controln LET l_exit_sw = 'n'
                             CLEAR FORM
                             EXIT DISPLAY
          ON ACTION execute  LET l_ac = ARR_CURR()
                             CALL cl_cmdrun(l_zz[l_ac].zz01)
          ON ACTION controle LET l_ac = ARR_CURR()
                             CALL cl_cmdrun(l_zz[l_ac].zz01)
          ON ACTION print_data IF l_maxac> 0 THEN CALL zz_print() END IF
          ON ACTION controlg CALL cl_cmdask()
 
        # ON IDLE g_idle_seconds
        #    CALL cl_on_idle()
        #    CONTINUE DISPLAY
 
      ON ACTION exporttoexcel       #FUN-4B0049
           CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                   base.TypeInfo.create(l_zz),'','')
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
   CLOSE WINDOW r_zz_w
   
   # No.FUN-B80037--------------------------------------------------
   #CALL cl_used("r_zz",g_time,2) RETURNING g_time   #No.FUN-6A0096
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   # No.FUN-B80037--------------------------------------------------
 
#  RETURN p_key
END FUNCTION
 
FUNCTION zz_print()    # 列印程式資料
DEFINE
        l_zz RECORD
                x     LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
                zz01 LIKE zz_file.zz01,       # 程式代號
                zz02 LIKE zz_file.zz02,       # 程式名稱
                zzuser LIKE zz_file.zzuser,   #OWNER
                zz09 LIKE zz_file.zz09        #GROUP
        END RECORD
 
        DISPLAY ' Wait ...' AT 2,50 ATTRIBUTE(REVERSE, BLINK)
        START REPORT zz_out TO 'zz.out'
        FOREACH zz_curs INTO l_zz.*
                IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                OUTPUT TO REPORT zz_out(l_zz.*)
        END FOREACH
        DISPLAY '         ' AT 2,50
        FINISH REPORT zz_out
END FUNCTION
 
REPORT zz_out(p_zz)
DEFINE
        p_zz RECORD
                x     LIKE type_file.chr1,    #No.FUN-680135 VARCHAR(1)
                zz01 LIKE zz_file.zz01,
                zz02 LIKE zz_file.zz02,
                zzuser LIKE zz_file.zzuser,
                zz09 LIKE zz_file.zz09
        END RECORD
 
        FORMAT
                ON EVERY ROW
                        PRINT p_zz.zz01,p_zz.zz02,p_zz.zzuser,p_zz.zz09
END REPORT
 
#Patch....NO.TQC-610037 <001> #
