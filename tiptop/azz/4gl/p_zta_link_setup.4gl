# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_zta_link_setup.4gl
# Modify.........: No.FUN-680135 06/08/31 By Hellen  欄位類型修改
# Modify.........: No.FUN-6A0096 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION p_zta_link_setup()
  DEFINE
    l_rec_b         LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_max_rec       LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ac            LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ac_t          LIKE type_file.num5,          #未取消的ARRAY CNT #No.FUN-680135 SMALLINT
    l_n             LIKE type_file.num5,          #檢查重複用        #No.FUN-680135 SMALLINT
    l_link          DYNAMIC ARRAY OF RECORD
                    azp08  LIKE azp_file.azp08,
                    azp01  LIKE azp_file.azp01,
                    azp02  LIKE azp_file.azp02
                    END RECORD,
    l_link_t        RECORD
                    azp08  LIKE azp_file.azp08,
                    azp01  LIKE azp_file.azp01,
                    azp02  LIKE azp_file.azp02
                    END RECORD,
    l_i             LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_max           LIKE type_file.num5,          #No.FUN-680135 SMALLINT
    l_ztc04         LIKE ztc_file.ztc04,
    l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680135 SMALLINT
    l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680135 SMALLINT
 
    OPEN WINDOW p_zta_link_setup AT 10,10
    WITH FORM "azz/42f/p_zta_link_setup"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    WHENEVER ERROR CONTINUE
    DEFER INTERRUPT
 
    CALL cl_ui_locale("p_zta_link_setup")
 
    DECLARE a CURSOR FOR 
        SELECT azp08,azp01,azp02 
          FROM azp_file
         WHERE azp053='Y'
    LET l_i=1
    FOREACH a INTO l_link[l_i].*
        lET l_i=l_i+1
    END FOREACH
    LET l_max=l_i-1
    CALL l_link.deleteElement(l_i)
 
    CALL cl_opmsg('b')
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY l_link WITHOUT DEFAULTS FROM s_link_setup.*
          ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=l_max,UNBUFFERED,
                    INSERT ROW=false,DELETE ROW=false,APPEND ROW=false)
 
        BEFORE INPUT
           IF l_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_link_t.* = l_link[l_ac].*  #BACKUP 因只有update沒insert,so...
#           LET l_n  = ARR_COUNT()
 
#        BEFORE INSERT
           
 
        AFTER ROW
display "l_link_t.azp08:",l_link_t.azp08
display "l_link[l_ac].azp08:",l_link[l_ac].azp08
 
           IF l_link_t.azp08 != l_link[l_ac].azp08 THEN
              UPDATE azp_file SET azp08=l_link[l_ac].azp08
               WHERE azp01=l_link[l_ac].azp01
              IF SQLCA.SQLERRD[3]=0 THEN
                 LET l_link[l_ac].azp08 = l_link_t.azp08
                 DISPLAY BY NAME l_link[l_ac].azp08
              END IF
           END IF
 
#        AFTER INPUT
#           FOR l_i=1 TO l_max
#               IF cl_null(l_link[l_i].ztb03) THEN
#                  EXIT FOR
#               END IF 
#               IF l_check[l_i].a="Y" THEN
#                  IF cl_null(l_ztc04) THEN
#                     LET l_ztc04=l_check[l_i].ztb03 CLIPPED
#                  ELSE 
#                     LET l_ztc04=l_ztc04 CLIPPED,",",l_check[l_i].ztb03 CLIPPED
#                  END IF
#               END IF
#           END FOR
   
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
    CLOSE WINDOW p_zta_link_setup
#    RETURN l_ztc04
END FUNCTION
