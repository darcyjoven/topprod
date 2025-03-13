# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: p_zta_q.4gl
# Descriptions...: 選擇 Table 欄位
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60022 09/06/04 By Echo GP5.2 SQL Server 移植-p_zta 工具調整(含集團架構)
# Modify.........: No.FUN-A90024 10/11/30 By Jay 調整各DB利用sch_file取得table與field等資訊
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION p_zta_select(p_zta01,p_zta02,p_zta10)
  DEFINE
    p_zta01     LIKE zta_file.zta01,
    p_zta02     LIKE zta_file.zta02,
    p_zta10     LIKE zta_file.zta10,
#    l_ztb DYNAMIC ARRAY of RECORD
#             ztb03     LIKE  ztb_file.ztb03,
#             ztb04     LIKE  ztb_file.ztb04,
#             ztb08     LIKE  ztb_file.ztb08,
#             ztb06     LIKE  ztb_file.ztb06,
#             ztb07     LIKE  ztb_file.ztb07,
#             ztb05     LIKE  ztb_file.ztb05,
#             gaq03     LIKE  gaq_file.gaq03
#          END RECORD,
    g_db_type       LIKE type_file.chr3,          #No.FUN-680135 VARCHAR(3)
    l_rec_b         LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_max_rec       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT  #No.FUN-680135 SMALLINT 
    l_serial        LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用 #No.FUN-680135 SMALLINT
    l_serial_da     DYNAMIC ARRAY OF LIKE type_file.num5,     #No.FUN-680135 SMALLINT
    l_check         DYNAMIC ARRAY OF RECORD
                    a      LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
                    ztb03  LIKE ztb_file.ztb03
                    END RECORD,
    l_check_t       RECORD
                    a      LIKE type_file.chr1,   #No.FUN-680135 VARCHAR(1)
                    ztb03  LIKE ztb_file.ztb03
                    END RECORD,
    l_i             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_j             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_max           LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ztc04         LIKE ztc_file.ztc04,
    l_str           STRING,
    l_allow_insert  LIKE type_file.num5,          #可新增否 #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否 #No.FUN-680135 SMALLINT
 
    OPEN WINDOW p_zta_select AT 10,10
    WITH FORM "azz/42f/p_zta_q"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    WHENEVER ERROR CONTINUE
    DEFER INTERRUPT
 
    CALL cl_ui_locale("p_zta_select")
 
    LET g_db_type=cl_db_get_database_type()
    IF p_zta10='N' THEN
       LET l_str="SELECT ztb03 FROM ztb_file ",
                 " WHERE ztb01='",p_zta01 CLIPPED,"'",
                 "   AND ztb02='",p_zta02 CLIPPED,"'"
    ELSE
       #No.FUN-A60022 -- start --
       #IF g_db_type="IFX" THEN
       #   LET l_str="select colname from syscolumns c,systables t",
       #             " where c.tabid=t.tabid",
       #             "   and t.tabname='",p_zta01 CLIPPED,"'"
       #ELSE
       #   LET l_str="SELECT lower(column_name) FROM user_tab_columns ",
       #             " WHERE lower(table_name)='",p_zta01 CLIPPED,"'"
       #END IF
       #---FUN-A90024---start-----
       #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
       #目前統一用sch_file紀錄TIPTOP資料結構
       #CASE g_db_type
       #  WHEN "IFX"
       #     LET l_str="select colname from syscolumns c,systables t",
       #               " where c.tabid=t.tabid",
       #               "   and t.tabname='",p_zta01 CLIPPED,"'"
       #  WHEN "ORA"
       #     LET l_str="SELECT lower(column_name) FROM user_tab_columns ",
       #               " WHERE lower(table_name)='",p_zta01 CLIPPED,"'"
       #  WHEN "MSV"
       #     LET l_str="SELECT b.name FROM sys.tables a,sys.columns b ",
       #               " WHERE a.object_id=b.object_id and a.name='",p_zta01 CLIPPED,"'"
       #END CASE
       LET l_str = "SELECT sch02 FROM sch_file ",
                   "  WHERE sch01 = '", p_zta01 CLIPPED, "'"
       #---FUN-A90024---end------- 
       #No.FUN-A60022 -- end --
    END IF
    DECLARE a CURSOR FROM l_str
    LET l_i=1
    FOREACH a INTO l_check[l_i].ztb03
        LET l_check[l_i].a='N'
        lET l_i=l_i+1
    END FOREACH
    LET l_max=l_i-1
    CALL l_check.deleteElement(l_i)
 
    LET l_serial=0
    CALL cl_opmsg('b')
#    LET l_allow_insert = cl_detail_input_auth("insert")
#    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY l_check WITHOUT DEFAULTS FROM s_check.*
          ATTRIBUTE(COUNT=l_max,MAXCOUNT=l_max,UNBUFFERED,
                    INSERT ROW=0,DELETE ROW=0,APPEND ROW=0)
 
        BEFORE INPUT
           CALL fgl_set_arr_curr(l_ac)
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_check_t.* = l_check[l_ac].*  #BACKUP
           LET l_n  = ARR_COUNT()
 
        AFTER ROW
           IF l_check[l_ac].a='Y' THEN
              IF l_check_t.a='N' THEN
                 LET l_serial=l_serial+1
                 LET l_serial_da[l_ac]=l_serial
              END IF
           ELSE
              LET l_serial_da[l_ac]=0
           END IF
display l_check[l_ac].ztb03,":",l_serial_da[l_ac]
        AFTER INPUT
           FOR l_i=1 TO l_serial
               FOR l_j=1 TO l_check.getLength()
                   IF l_serial_da[l_j]=0 OR l_serial_da[l_j] is null THEN
                      CONTINUE FOR
                   END IF 
                   IF l_serial_da[l_j]=l_i THEN
                      IF cl_null(l_ztc04) THEN
                         LET l_ztc04=l_check[l_j].ztb03 CLIPPED
                      ELSE 
                         LET l_ztc04=l_ztc04 CLIPPED,",",l_check[l_j].ztb03 CLIPPED
                      END IF
                   END IF
               END FOR
           END FOR
#          FOR l_i=1 TO l_max
#              IF cl_null(l_check[l_i].ztb03) THEN
#                 EXIT FOR
#              END IF 
#              IF l_check[l_i].a="Y" THEN
#                 IF cl_null(l_ztc04) THEN
#                    LET l_ztc04=l_check[l_i].ztb03 CLIPPED
#                 ELSE 
#                    LET l_ztc04=l_ztc04 CLIPPED,",",l_check[l_i].ztb03 CLIPPED
#                 END IF
#              END IF
#          END FOR
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
    CLOSE WINDOW p_zta_select
    RETURN l_ztc04
END FUNCTION
