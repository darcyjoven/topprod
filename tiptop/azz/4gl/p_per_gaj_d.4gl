# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_per_gaj_d.4gl
# Descriptions...: 畫面設定維護作業
# Date & Author..: 03/12/04 alex
# Modify.........: No.MOD-470041 04/07/19 By Wiky 修改INSERT INTO...
# Modify.........: No.TQC-590028 05/09/26 By alex 修改開窗為 construct
# Modify.........: No.FUN-660081 06/06/14 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-860033 08/06/06 By alex 修正 ON IDLE區段
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION p_per_gaj_d(p_gaj01,p_gaj02)
 
    DEFINE l_count     LIKE type_file.num5    #FUN-680135 SMALLINT
    DEFINE p_gaj01     LIKE gaj_file.gaj01 
    DEFINE p_gaj02     LIKE gaj_file.gaj02 
    DEFINE l_gaj       RECORD LIKE gaj_file.*
    DEFINE l_gaj_t     RECORD LIKE gaj_file.*
    DEFINE l_cmd       LIKE type_file.chr1    #No.FUN-680135 VARCHAR(1)
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF cl_null(p_gaj01) OR cl_null(p_gaj02) THEN
       RETURN
    END IF
 
    SELECT * INTO l_gaj.* FROM gaj_file 
     WHERE gaj01=p_gaj01 AND gaj02=p_gaj02
 
    IF STATUS=100 THEN
       LET l_cmd='a'
       LET l_gaj.gaj01 = p_gaj01
       LET l_gaj.gaj02 = p_gaj02
    ELSE
       LET l_cmd='u'
    END IF
    LET INT_FLAG = 0
 
    IF l_gaj.gaj03 IS NULL THEN LET l_gaj.gaj03 = " " END IF  
    IF l_gaj.gaj04 IS NULL THEN LET l_gaj.gaj04 = " " END IF
    IF l_gaj.gaj05 IS NULL THEN LET l_gaj.gaj05 = " " END IF
    IF l_gaj.gaj06 IS NULL THEN LET l_gaj.gaj06 = " " END IF
 
    OPEN WINDOW p_per_gaj_d_w WITH FORM "azz/42f/p_per_gaj_d"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("p_per_gaj_d")
 
    DISPLAY l_gaj.gaj01,l_gaj.gaj02,l_gaj.gaj03,l_gaj.gaj04,l_gaj.gaj05,
            l_gaj.gaj06
         TO gaj01,gaj02,gaj03,gaj04,gaj05,gaj06
 
    LET l_gaj_t.* = l_gaj.*
    INPUT l_gaj.gaj03,l_gaj.gaj04,l_gaj.gaj05,l_gaj.gaj06
     WITHOUT DEFAULTS
     FROM gaj03,gaj04,gaj05,gaj06
 
       AFTER FIELD gaj03
          IF l_gaj.gaj03 IS NULL THEN LET l_gaj.gaj03 = " " END IF  
       AFTER FIELD gaj04
          IF l_gaj.gaj04 IS NULL THEN LET l_gaj.gaj04 = " " END IF
       AFTER FIELD gaj05
          IF l_gaj.gaj05 IS NULL THEN LET l_gaj.gaj05 = " " END IF
       AFTER FIELD gaj06
          IF l_gaj.gaj06 IS NULL THEN LET l_gaj.gaj06 = " " END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
             LET INT_FLAG = 0
          END IF
          IF l_gaj_t.gaj03 != l_gaj.gaj03 OR l_gaj_t.gaj04 != l_gaj.gaj04 OR
             l_gaj_t.gaj05 != l_gaj.gaj05 OR l_gaj_t.gaj06 != l_gaj.gaj06 THEN
             IF l_cmd='a' THEN  #新增模式
                 INSERT INTO gaj_file(gaj01,gaj02,gaj03,gaj04,gaj05,gaj06) #No.MOD-470041
                             VALUES (l_gaj.gaj01,l_gaj.gaj02,l_gaj.gaj03,
                                     l_gaj.gaj04,l_gaj.gaj05,l_gaj.gaj06)
                IF STATUS THEN
                   #CALL cl_err("INSERT gaj:",STATUS,1)  #No.FUN-660081
                   CALL cl_err3("ins","gaj_file",l_gaj.gaj01,l_gaj.gaj02,STATUS,"","INSERT gaj",1)   #No.FUN-660081
                END IF
             ELSE
                UPDATE gaj_file
                   SET gaj03 = l_gaj.gaj03,
                       gaj04 = l_gaj.gaj04,
                       gaj05 = l_gaj.gaj05,
                       gaj06 = l_gaj.gaj06
                 WHERE gaj01 = l_gaj.gaj01 AND gaj02=l_gaj.gaj02
                IF STATUS THEN
                   #CALL cl_err("UPDATE gaj:",STATUS,1)  #No.FUN-660081
                   CALL cl_err3("upd","gaj_file",l_gaj.gaj01,l_gaj.gaj02,STATUS,"","UPDATE gaj",1)   #No.FUN-660081
                END IF
             END IF
          END IF
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(gaj03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zw"
                LET g_qryparam.state = "c"   #TQC-590028
                LET g_qryparam.default1 = l_gaj.gaj03
                CALL cl_create_qry() RETURNING l_gaj.gaj03
#               CALL FGL_DIALOG_SETBUFFER( l_gaj.gaj03 )
                DISPLAY l_gaj.gaj03 TO gaj03
                NEXT FIELD gaj03
 
             WHEN INFIELD(gaj04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zw"
                LET g_qryparam.state = "c"   #TQC-590028
                LET g_qryparam.default1 = l_gaj.gaj04
                CALL cl_create_qry() RETURNING l_gaj.gaj04
#               CALL FGL_DIALOG_SETBUFFER( l_gaj.gaj04 )
                DISPLAY l_gaj.gaj04 TO gaj04
                NEXT FIELD gaj04
 
             WHEN INFIELD(gaj05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"
                LET g_qryparam.state = "c"   #TQC-590028
                LET g_qryparam.default1 = l_gaj.gaj05
                CALL cl_create_qry() RETURNING l_gaj.gaj05
#               CALL FGL_DIALOG_SETBUFFER( l_gaj.gaj05 )
                DISPLAY l_gaj.gaj05 TO gaj05
                NEXT FIELD gaj05
 
             WHEN INFIELD(gaj06)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_zx"
                LET g_qryparam.state = "c"   #TQC-590028
                LET g_qryparam.default1 = l_gaj.gaj06
                CALL cl_create_qry() RETURNING l_gaj.gaj06
#               CALL FGL_DIALOG_SETBUFFER( l_gaj.gaj06 )
                DISPLAY l_gaj.gaj06 TO gaj06
                NEXT FIELD gaj06
       END CASE
 
       ON ACTION about         #FUN-860033
          CALL cl_about()      #FUN-860033
 
       ON ACTION controlg      #FUN-860033
          CALL cl_cmdask()     #FUN-860033
 
       ON ACTION help          #FUN-860033
          CALL cl_show_help()  #FUN-860033
 
       ON IDLE g_idle_seconds  #FUN-860033
          CALL cl_on_idle()
          CONTINUE INPUT 
 
    END INPUT
 
    CLOSE WINDOW p_per_gaj_d_w
 
    RETURN 
END FUNCTION
 
