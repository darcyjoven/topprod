# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axct510.4gl
# Descriptions...: 當站下線成本單價作業
# Date & Author..: 99/12/13 By Kammy
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-970254 09/07/24 By dxfwo  單價產生做完要重新查詢，才能看到單身所有新的單價
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No.TQC-B70162 11/07/21 By Carrier 单身单价修改时,要更新tlf21
# Modify.........: No.TQC-BA0128 11/10/24 By houlia 單價產生不成功時報錯
# Modify.........: No.FUN-B90029 11/10/24 By jason 當站下線成本改善
# Modify.........: No.MOD-C30601 12/03/16 By tanxc 請將shd08改為必填欄位
# Modify.........: No.FUN-C80092 12/12/05 By fengrui 增加寫入日誌功能

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE
           g_yy,g_mm       LIKE type_file.num5,           #No.FUN-680122 SMALLINT             #
           b_shd   RECORD LIKE shd_file.*,
           g_shd           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shd01     LIKE shd_file.shd01,
                    shd02     LIKE shd_file.shd02,
                    shd06     LIKE shd_file.shd06,
                    ima02     LIKE ima_file.ima02,
                    shd03     LIKE shd_file.shd03,
                    shd04     LIKE shd_file.shd04,
                    shd05     LIKE shd_file.shd05,
                    shd07     LIKE shd_file.shd07,
                    shd08     LIKE shd_file.shd08,
                    shd082    LIKE shd_file.shd082,   #FUN-B90029
                    shd083    LIKE shd_file.shd083,   #FUN-B90029
                    shd084    LIKE shd_file.shd084,   #FUN-B90029
                    shd085    LIKE shd_file.shd085,   #FUN-B90029
                    shd086    LIKE shd_file.shd086,   #FUN-B90029
                    shd087    LIKE shd_file.shd087,   #FUN-B90029
                    shd088    LIKE shd_file.shd088,   #FUN-B90029                    
                    shd09     LIKE shd_file.shd09
                    END RECORD,
             g_shd_t         RECORD
                    shd01     LIKE shd_file.shd01,
                    shd02     LIKE shd_file.shd02,
                    shd06     LIKE shd_file.shd06,
                    ima02     LIKE ima_file.ima02,
                    shd03     LIKE shd_file.shd03,
                    shd04     LIKE shd_file.shd04,
                    shd05     LIKE shd_file.shd05,
                    shd07     LIKE shd_file.shd07,
                    shd08     LIKE shd_file.shd08,
                    shd082    LIKE shd_file.shd082,   #FUN-B90029
                    shd083    LIKE shd_file.shd083,   #FUN-B90029
                    shd084    LIKE shd_file.shd084,   #FUN-B90029
                    shd085    LIKE shd_file.shd085,   #FUN-B90029
                    shd086    LIKE shd_file.shd086,   #FUN-B90029
                    shd087    LIKE shd_file.shd087,   #FUN-B90029
                    shd088    LIKE shd_file.shd088,   #FUN-B90029
                    shd09     LIKE shd_file.shd09
                    END RECORD,
             g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
             g_t1            LIKE type_file.chr4,          #No.FUN-680122CHAR(04)
             g_buf           LIKE type_file.chr20,         #No.FUN-680122char(20)
             g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680122 SMALLINT
             l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_cka00         LIKE cka_file.cka00     #No.FUN-C80092

MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0146
DEFINE   p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW t510_w AT p_row,p_col WITH FORM "axc/42f/axct510"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    CALL t510_menu()
    CLOSE WINDOW t510_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t510_menu()
 
   WHILE TRUE
      CALL t510_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t510_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t510_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #@WHEN "單價產生"
         WHEN "gen_u_p"
            IF cl_chk_act_auth() THEN
               CALL t510_g()
               CALL t510_b_fill(g_wc2)  #No.TQC-970254  dxfwo  add
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shd),'','')
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t510_q()
    CALL cl_opmsg('q')
    CALL t510_b_askkey()
END FUNCTION
 
FUNCTION t510_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680122SMALLINT	  #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用               #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否               #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態                 #No.FUN-680122 VARCHAR(1)
    l_b2      		LIKE type_file.chr1000,         #No.FUN-680122CHAR(30)
    l_ima35,l_ima36	LIKE ima_file.ima35,            #No.FUN-680122CHAR(10)
  #  l_qty		LIKE ima_file.ima26,            #No.FUN-680122DECIMAL(15,3)#FUN-A20044
    l_qty		LIKE type_file.num15_3,            #No.FUN-680122DECIMAL(15,3)#FUN-A20044
    l_flag          LIKE type_file.num10,               #No.FUN-680122INTEGER
    l_allow_insert  LIKE type_file.chr1,                #No.FUN-680122CHAR(01)
    l_allow_delete  LIKE type_file.chr1,                #No.FUN-680122CHAR(01)
    l_msg           STRING                              #No.FUN-C80092
 
    LET g_action_choice = ""
 
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM shd_file WHERE shd01=? AND shd02=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t510_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
      INPUT ARRAY g_shd WITHOUT DEFAULTS FROM s_shd.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET g_shd_t.* = g_shd[l_ac].*  #BACKUP
               LET p_cmd='u'
               #FUN-C80092 ---------Begin--------------
               LET l_msg = "g_shd[l_ac].shd01='",g_shd [l_ac].shd01,"'",";","g_shd_t.shd02='",g_shd_t.shd02,"'"
               CALL s_log_ins(g_prog,'','','',l_msg) RETURNING g_cka00
               #FUN-C80092 ---------End----------------
               BEGIN WORK
               OPEN t510_bcl USING g_shd_t.shd01,g_shd_t.shd02
               IF STATUS THEN
                  CALL cl_err("OPEN t510_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t510_bcl INTO b_shd.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock shd',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t510_b_move_to()

                #MOD-C30601--add--
                IF cl_null(g_shd[l_ac].shd08) THEN
                   LET g_shd[l_ac].shd08 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd082) THEN
                   LET g_shd[l_ac].shd082 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd083) THEN
                   LET g_shd[l_ac].shd083 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd084) THEN
                   LET g_shd[l_ac].shd084 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd085) THEN
                   LET g_shd[l_ac].shd085 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd086) THEN
                   LET g_shd[l_ac].shd086 = 0
                END IF
                IF cl_null(g_shd[l_ac].shd087) THEN
         	       LET g_shd[l_ac].shd087 = 0
         	   END IF
          	 IF cl_null(g_shd[l_ac].shd088) THEN
                	LET g_shd[l_ac].shd088 = 0
                END IF
  	          #MOD-C30601--end--
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_shd[l_ac].* TO NULL      #900423
            INITIALIZE g_shd_t.* TO NULL
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shd08
 
        BEFORE DELETE                            #是否取消單身
            IF g_shd_t.shd02 > 0 AND g_shd_t.shd02 IS NOT NULL THEN
                CALL cl_err(g_shd_t.shd02,'axct001',0)
            END IF
 
        BEFORE FIELD shd08
            IF cl_null(g_shd[l_ac].shd08) THEN
               LET g_shd[l_ac].shd08 = 0
            END IF
 
        AFTER FIELD shd08
            IF NOT cl_null(g_shd[l_ac].shd08) THEN
               #LET g_shd[l_ac].shd09 = g_shd[l_ac].shd07 * g_shd[l_ac].shd08   #FUN-B90029 mark 
               #------MOD-5A0095 START----------
               #DISPLAY BY NAME g_shd[l_ac].shd09   #FUN-B90029 mark
               CALL t510_sum_shd09()   #FUN-B90029
               #------MOD-5A0095 END------------
            END IF
 
        #FUN-B90029 --START--
        AFTER FIELD shd082
           CALL t510_sum_shd09()
           
        AFTER FIELD shd083
           CALL t510_sum_shd09()   

        AFTER FIELD shd084
           CALL t510_sum_shd09()

        AFTER FIELD shd085
           CALL t510_sum_shd09()

        AFTER FIELD shd086
           CALL t510_sum_shd09()

        AFTER FIELD shd087
           CALL t510_sum_shd09()

        AFTER FIELD shd088
           CALL t510_sum_shd09()           
        #FUN-B90029 --END--    
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_shd[l_ac].* = g_shd_t.*
              CLOSE t510_bcl
              ROLLBACK WORK
              CALL s_log_upd(g_cka00,'N')           #FUN-C80092
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_shd[l_ac].shd01,-263,1)
              LET g_shd[l_ac].* = g_shd_t.*
              CALL s_log_upd(g_cka00,'N')           #FUN-C80092
           ELSE
             CALL t510_b_move_back()
             CALL t510_b_else()
             IF g_shd[l_ac].shd02 > 0 AND g_shd[l_ac].shd02 IS NOT NULL THEN
                IF g_shd[l_ac].shd08 IS NOT NULL AND g_shd[l_ac].shd08 !=0 AND
                   g_shd[l_ac].shd09 IS NOT NULL AND g_shd[l_ac].shd09 !=0 THEN
                    IF g_shd_t.shd02 IS NOT NULL THEN
                        UPDATE shd_file SET shd08=b_shd.shd08,shd09=b_shd.shd09
                         ,shd082 = b_shd.shd082,shd083 = b_shd.shd083,shd084 = b_shd.shd084   #FUN-B90029
                         ,shd085 = b_shd.shd085,shd086 = b_shd.shd086,shd087 = b_shd.shd087   #FUN-B90029
                         ,shd088 = b_shd.shd088                                               #FUN-B90029
                         WHERE shd01=g_shd[l_ac].shd01 AND shd02=g_shd_t.shd02
                        IF SQLCA.sqlcode THEN
#                          CALL cl_err('upd shd',SQLCA.sqlcode,0)   #No.FUN-660127
                           CALL cl_err3("upd","shd_file",g_shd[l_ac].shd01,g_shd_t.shd02,SQLCA.sqlcode,"","upd shd",1)  #No.FUN-660127
                           LET g_shd[l_ac].* = g_shd_t.*
                           CALL s_log_upd(g_cka00,'N')           #FUN-C80092
                        ELSE
                           #No.TQC-B70162  --Begin
                           #UPDATE tlf_file SET tlf21 = b_shd.shd08   #FUN-B90029 mark
                           UPDATE tlf_file SET tlf21 = b_shd.shd09    #FUN-B90029
                            ,tlf221  = b_shd.shd08,  tlf222  = b_shd.shd082, tlf2231 = b_shd.shd083    #FUN-B90029
                            ,tlf2232 = b_shd.shd084, tlf224  = b_shd.shd085, tlf2241 = b_shd.shd086    #FUN-B90029
                            ,tlf2242 = b_shd.shd087, tlf2243 = b_shd.shd088                            #FUN-B90029
                            WHERE tlf905 = g_shd[l_ac].shd01 AND tlf906 = g_shd_t.shd02
                           IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","tlf_file",g_shd[l_ac].shd01,g_shd_t.shd02,SQLCA.sqlcode,"","upd tlf21",1)
                              LET g_shd[l_ac].* = g_shd_t.*
                              CALL s_log_upd(g_cka00,'N')           #FUN-C80092
                           ELSE
                           #No.TQC-B70162  --End  
                              MESSAGE 'UPDATE O.K'
                              CLOSE t510_bcl
			      COMMIT WORK
                              CALL s_log_upd(g_cka00,'Y')           #FUN-C80092
                           END IF   #No.TQC-B70162
                        END IF
                    END IF
                END IF
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_shd[l_ac].* = g_shd_t.*
               END IF
               CLOSE t510_bcl
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')           #FUN-C80092
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE t510_bcl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL t510_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
    CLOSE t510_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t510_b_move_to()
   LET g_shd[l_ac].shd01 = b_shd.shd01
   LET g_shd[l_ac].shd02 = b_shd.shd02
   LET g_shd[l_ac].shd06 = b_shd.shd06
   LET g_shd[l_ac].shd03 = b_shd.shd03
   LET g_shd[l_ac].shd04 = b_shd.shd04
   LET g_shd[l_ac].shd05 = b_shd.shd05
   LET g_shd[l_ac].shd07 = b_shd.shd07
   LET g_shd[l_ac].shd08 = b_shd.shd08
   LET g_shd[l_ac].shd082 = b_shd.shd082   #FUN-B90029
   LET g_shd[l_ac].shd083 = b_shd.shd083   #FUN-B90029
   LET g_shd[l_ac].shd084 = b_shd.shd084   #FUN-B90029
   LET g_shd[l_ac].shd085 = b_shd.shd085   #FUN-B90029
   LET g_shd[l_ac].shd086 = b_shd.shd086   #FUN-B90029
   LET g_shd[l_ac].shd087 = b_shd.shd087   #FUN-B90029
   LET g_shd[l_ac].shd088 = b_shd.shd088   #FUN-B90029   
   LET g_shd[l_ac].shd09 = b_shd.shd09
END FUNCTION
 
FUNCTION t510_b_move_back()
   LET b_shd.shd01 = g_shd[l_ac].shd01
   LET b_shd.shd02 = g_shd[l_ac].shd02
   LET b_shd.shd06 = g_shd[l_ac].shd06
   LET b_shd.shd03 = g_shd[l_ac].shd03
   LET b_shd.shd04 = g_shd[l_ac].shd04
   LET b_shd.shd05 = g_shd[l_ac].shd05
   LET b_shd.shd07 = g_shd[l_ac].shd07
   LET b_shd.shd08 = g_shd[l_ac].shd08
   LET b_shd.shd082 = g_shd[l_ac].shd082   #FUN-B90029
   LET b_shd.shd083 = g_shd[l_ac].shd083   #FUN-B90029
   LET b_shd.shd084 = g_shd[l_ac].shd084   #FUN-B90029
   LET b_shd.shd085 = g_shd[l_ac].shd085   #FUN-B90029
   LET b_shd.shd086 = g_shd[l_ac].shd086   #FUN-B90029
   LET b_shd.shd087 = g_shd[l_ac].shd087   #FUN-B90029
   LET b_shd.shd088 = g_shd[l_ac].shd088   #FUN-B90029   
   LET b_shd.shd09 = g_shd[l_ac].shd09
END FUNCTION
 
FUNCTION t510_b_else()
   IF g_shd[l_ac].shd03 IS NULL THEN LET g_shd[l_ac].shd03 =' ' END IF
   IF g_shd[l_ac].shd04 IS NULL THEN LET g_shd[l_ac].shd04 =' ' END IF
   IF g_shd[l_ac].shd05 IS NULL THEN LET g_shd[l_ac].shd05 =' ' END IF
END FUNCTION
 
#---單價產生
FUNCTION t510_g()
  DEFINE  l_cmd     LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_cmd2    LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          x_cnt     LIKE type_file.num5,          #No.FUN-680122smallint
          l_bdate,l_edate LIKE type_file.dat,     #No.FUN-680122DATE
          l_za05    LIKE type_file.chr1000,       #No.FUN-680122CHAR(40)
          l_name    LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
          tm RECORD
               x          LIKE type_file.chr1,    #No.FUN-680122CHAR(01)
               yy         LIKE type_file.num5,    #No.FUN-680122SMALLINT
               mm         LIKE type_file.num5,    #No.FUN-680122SMALLINT
               plant      LIKE azp_file.azp01
          END RECORD,
          l_fromplant like azp_file.azp03,
          l_flag  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          sr RECORD
               shd01 like shd_file.shd01,
               shd02 like shd_file.shd02,
               shd06 like shd_file.shd06,
               shd07 like shd_file.shd07
          END RECORD,
          #l_uprice like ccc_file.ccc23,   #FUN-BA0029 mark
          l_uprice_a like ccc_file.ccc23a,   #FUN-BA0029
          l_uprice_b like ccc_file.ccc23b,   #FUN-BA0029
          l_uprice_c like ccc_file.ccc23c,   #FUN-BA0029 
          l_uprice_d like ccc_file.ccc23d,   #FUN-BA0029 
          l_uprice_e like ccc_file.ccc23e,   #FUN-BA0029 
          l_uprice_f like ccc_file.ccc23f,   #FUN-BA0029 
          l_uprice_g like ccc_file.ccc23g,   #FUN-BA0029 
          l_uprice_h like ccc_file.ccc23h,   #FUN-BA0029     
          l_amount  like shd_file.shd09
  DEFINE l_plant  LIKE type_file.chr20    #FUN-A50102
  DEFINE l_s      LIKE type_file.chr1     #TQC-BA0128
  
  OPEN WINDOW t510_g AT 4,27 WITH FORM "axc/42f/axct510_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axct510_g")
 
 
  DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02
  WHILE TRUE
     CONSTRUCT BY NAME g_wc ON shd01,shd06,ima08
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('shduser', 'shdgrup') #FUN-980030
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',1) CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW t510_g
     RETURN
  END IF
  IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF
 
  LET tm.plant = g_plant
  # return 上期年月
  CALL s_lsperiod(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.yy,tm.mm
 
  LET tm.x = 'N'
  INPUT BY NAME tm.x,tm.plant,tm.yy,tm.mm WITHOUT DEFAULTS
 
    AFTER FIELD plant
      IF tm.x = 'N' THEN
         IF cl_null(tm.plant) THEN NEXT FIELD plant END IF
         SELECT COUNT(*) INTO x_cnt
         FROM azp_file
         WHERE azp01=tm.plant
         IF x_cnt=0 THEN
            NEXT FIELD plant
         END IF
      END IF
 
    AFTER FIELD yy
      IF tm.x = 'N' THEN IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
      END IF
    AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
      IF tm.x = 'N' THEN IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
      END IF
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
    AFTER INPUT
       IF int_flag THEN EXIT INPUT END IF
       CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
            RETURNING l_flag, l_bdate, l_edate #得出起始日與截止日
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW t510_g RETURN END IF
 
   IF tm.x = 'N' THEN
      SELECT azp03 INTO l_fromplant FROM azp_file WHERE azp01=tm.plant
      LET l_plant = tm.plant   #FUN-A50102
      IF cl_null(l_fromplant) THEN
         SELECT azp03 into l_fromplant from azp_file where azp01 = g_plant
         LET l_plant = g_plant   #FUN-A50102
      END IF
      #LET l_fromplant = s_dbstring(l_fromplant) #FUN-A50102
      #LET l_cmd ="SELECT ccc23 ",   #FUN-B90029 mark
                   #"FROM ",l_fromplant clipped,"ccc_file ",
      LET l_cmd ="SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h ",   #FUN-B90029                   
                   "FROM ",cl_get_target_table(l_plant,'ccc_file'),  #FUN-A50102
                 " WHERE ccc01 = ?  ",
                   " AND ccc02 = ",tm.yy ,
                   " and ccc03 = ",tm.mm clipped
      CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
      CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102               
      PREPARE t510_preccc FROM l_cmd
      DECLARE t510_cuccc SCROLL CURSOR WITH HOLD FOR t510_preccc
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('axct510') RETURNING l_name
   START REPORT axct510_rep TO l_name
 
   LET l_cmd2 ="SELECT shd01,shd02,shd06,shd07 ",
               " FROM shd_file,shb_file ,ima_file,smy_file ",
               " WHERE shd06 = ima01 AND shd01=shb01 ",
               "   AND shbconf = 'Y' ",     #FUN-A70095  
             # " AND shb03 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
   #No.FUN-550025 --start--
   #            " AND smyslip = shb01[1,3] ",
                " AND shb01 like ltrim(rtrim(smyslip)) || '-%' ",
   #No.FUN-550025 --end--
               " AND ",g_wc clipped
 
   PREPARE t510_pregen FROM l_cmd2
   DECLARE t510_cugen SCROLL CURSOR WITH HOLD FOR t510_pregen
    IF NOT  cl_sure(10,20) THEN
       CLOSE WINDOW t510_g
       RETURN
    END IF
    
    LET l_s = 'N'             #TQC-BA0128
   #------------------------------
   #掃單據的單身,並更改單價及金額
   #------------------------------
   
   FOREACH t510_cugen into sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach :t510_cugen',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      
      LET l_s = 'Y'      #TQC-BA0128
      MESSAGE sr.shd01,'-',sr.shd02
 
      #FUN-B90029 --START mark--
      #IF tm.x = 'N' THEN          
      #   LET l_uprice= 0
      #   OPEN t510_cuccc USING sr.shd06
      #   FETCH t510_cuccc INTO l_uprice
      #   IF SQLCA.sqlcode then
      #      OUTPUT TO REPORT axct510_rep(sr.*)
      #      LET l_flag = 'Y'
      #      LET l_uprice = 0
      #   END IF      
      #ELSE   
      #   LET l_uprice = 0
      #   LET l_amount = 0
      #END IF
      #LET l_amount  = l_uprice * sr.shd07
      #UPDATE shd_file SET shd08  = l_uprice,
      #                    shd09  = l_amount
      # WHERE shd01 = sr.shd01 AND shd02 = sr.shd02
      #IF SQLCA.sqlcode  THEN
      #   MESSAGE "UPDATE ERROR!"
      #   EXIT FOREACH
      #END IF
      #  
      #UPDATE tlf_file SET tlf21 = l_amount
      # WHERE tlf905 = sr.shd01 AND tlf906 = sr.shd02      
      #FUN-B90029 --END mark--
      #FUN-B90029 --START--
      IF tm.x = 'N' THEN
         LET l_uprice_a= 0
         OPEN t510_cuccc USING sr.shd06
         FETCH t510_cuccc INTO l_uprice_a,l_uprice_b,l_uprice_c,l_uprice_d,
                               l_uprice_e,l_uprice_f,l_uprice_g,l_uprice_h  
         IF SQLCA.sqlcode then
            OUTPUT TO REPORT axct510_rep(sr.*)
            LET l_flag = 'Y'
            LET l_uprice_a = 0
         END IF
      ELSE
         LET l_uprice_a = 0
         LET l_uprice_b = 0
         LET l_uprice_c = 0
         LET l_uprice_d = 0
         LET l_uprice_e = 0
         LET l_uprice_f = 0
         LET l_uprice_g = 0
         LET l_uprice_h = 0
         LET l_amount = 0
      END IF
      LET l_amount  = l_uprice_a * sr.shd07
      IF NOT cl_null(l_uprice_b) THEN LET l_amount  = l_amount + (l_uprice_b * sr.shd07) END IF
      IF NOT cl_null(l_uprice_c) THEN LET l_amount  = l_amount + (l_uprice_c * sr.shd07) END IF
      IF NOT cl_null(l_uprice_d) THEN LET l_amount  = l_amount + (l_uprice_d * sr.shd07) END IF  
      IF NOT cl_null(l_uprice_e) THEN LET l_amount  = l_amount + (l_uprice_e * sr.shd07) END IF  
      IF NOT cl_null(l_uprice_f) THEN LET l_amount  = l_amount + (l_uprice_f * sr.shd07) END IF  
      IF NOT cl_null(l_uprice_g) THEN LET l_amount  = l_amount + (l_uprice_g * sr.shd07) END IF  
      IF NOT cl_null(l_uprice_h) THEN LET l_amount  = l_amount + (l_uprice_h * sr.shd07) END IF
 
      UPDATE shd_file SET shd08  = l_uprice_a,
                          shd082 = l_uprice_b,
                          shd083 = l_uprice_c,
                          shd084 = l_uprice_d,
                          shd085 = l_uprice_e,
                          shd086 = l_uprice_f,
                          shd087 = l_uprice_g,
                          shd088 = l_uprice_h,
                          shd09  = l_amount
       WHERE shd01 = sr.shd01 AND shd02 = sr.shd02
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE ERROR!"
         EXIT FOREACH
      END IF
 
      UPDATE tlf_file SET tlf21 = l_amount,
                          tlf221  = l_uprice_a,
                          tlf222  = l_uprice_b,
                          tlf2231 = l_uprice_c,
                          tlf2232 = l_uprice_d,
                          tlf224  = l_uprice_e,
                          tlf2241 = l_uprice_f,
                          tlf2242 = l_uprice_g,
                          tlf2243 = l_uprice_h
       WHERE tlf905 = sr.shd01 AND tlf906 = sr.shd02
      #FUN-B90029 --END--    
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE tlf ERROR!"
         EXIT FOREACH
      END IF
 
      CLOSE t510_cuccc
 
   END FOREACH
   
   #TQC-BA0128  --begin
   IF l_s = 'N' THEN 
      CALL cl_err('','axc-304',0)
   END IF 
   #TQC-BA0128  --end 
 
   FINISH REPORT axct510_rep
   IF l_flag = 'Y' THEN CALL cl_prt(l_name,g_prtway,g_copies,g_len) END IF
 
   CLOSE WINDOW t510_g
 
END FUNCTION
 
REPORT axct510_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,           #No.FUN-680122CHAR(01)
        #  l_row3,l_row6    LIKE ima_file.ima26,       #No.FUN-680122DEC(15,3)#FUN-A20044
          l_row3,l_row6    LIKE type_file.num15_3,       #No.FUN-680122DEC(15,3)#FUN-A20044
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          sr RECORD
               shd01 LIKE shd_file.shd01,
               shd02 LIKE shd_file.shd02,
               shd06 LIKE shd_file.shd06,
               shd07 LIKE shd_file.shd07
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.shd01,sr.shd02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01=sr.shd06
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.shd01,' - ',
            COLUMN g_c[32],sr.shd02 USING '###&',
            COLUMN g_c[33],sr.shd06,g_x[9],
            COLUMN g_c[34],l_ima02,
            COLUMN g_c[35],l_ima021
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION t510_b_askkey()
    CLEAR FORM                             #清除畫面
    CALL g_shd.clear()
    CONSTRUCT g_wc2 ON shd01,shd02,shd06,shd03,shd04,shd05,shd07,
                       shd08,shd082,shd083,shd084,shd085,shd086,shd087,shd088,shd09   #FUN-B90029 add shd82~shd88
            FROM s_shd[1].shd01, s_shd[1].shd02, s_shd[1].shd06,
                 s_shd[1].shd03, s_shd[1].shd04, s_shd[1].shd05,
                 s_shd[1].shd07, s_shd[1].shd08, s_shd[1].shd082,   #FUN-B90029 add shd82~shd88
                 s_shd[1].shd083,s_shd[1].shd084,s_shd[1].shd085,   #FUN-B90029 add shd82~shd88
                 s_shd[1].shd086,s_shd[1].shd087,s_shd[1].shd088,   #FUN-B90029 add shd82~shd88
                 s_shd[1].shd09                                     #FUN-B90029 add shd82~shd88
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
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND shduser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND shdgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    CALL t510_b_fill(g_wc2)
END FUNCTION
 
FUNCTION t510_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    LET g_sql =
        "SELECT shd01,shd02,shd06,ima02,shd03,shd04,shd05,shd07,",
        "       shd08,shd082,shd083,shd084,shd085,shd086,shd087,shd088,shd09",   #FUN-B90029 add shd82~shd88
        " FROM shd_file LEFT OUTER JOIN ima_file ON shd06 = ima_file.ima01 ",
        " WHERE ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t510_pb FROM g_sql
    DECLARE shd_curs CURSOR FOR t510_pb
 
    CALL g_shd.clear()
    LET g_cnt = 1
    FOREACH shd_curs INTO g_shd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_shd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
 
FUNCTION t510_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_shd TO s_shd.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      #@ON ACTION 單價產生
      ON ACTION gen_u_p
         LET g_action_choice="gen_u_p"
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
 
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

#FUN-B90029 --START--
FUNCTION t510_sum_shd09()
DEFINE l_shd09 LIKE shd_file.shd09
DEFINE l_shd07 LIKE shd_file.shd07
   LET l_shd09 = 0
   LET l_shd07 = g_shd[l_ac].shd07
   #材料成本   
   IF NOT cl_null(g_shd[l_ac].shd08) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd08 * l_shd07) 
   END IF
   #人工單價
   IF NOT cl_null(g_shd[l_ac].shd082) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd082 * l_shd07) 
   END IF
   #製費一單價
   IF NOT cl_null(g_shd[l_ac].shd083) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd083 * l_shd07) 
   END IF
   #加工單價
   IF NOT cl_null(g_shd[l_ac].shd084) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd084 * l_shd07) 
   END IF
   #製費二單價
   IF NOT cl_null(g_shd[l_ac].shd085) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd085 * l_shd07) 
   END IF
   #製費三單價
   IF NOT cl_null(g_shd[l_ac].shd086) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd086 * l_shd07) 
   END IF
   #製費四單價
   IF NOT cl_null(g_shd[l_ac].shd087) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd087 * l_shd07) 
   END IF
   #製費五單價
   IF NOT cl_null(g_shd[l_ac].shd088) THEN 
      LET l_shd09 = l_shd09 + (g_shd[l_ac].shd088 * l_shd07) 
   END IF
   LET g_shd[l_ac].shd09 = l_shd09
   DISPLAY BY NAME g_shd[l_ac].shd09   
END FUNCTION 
#FUN-B90029 --END--
#Patch....NO.MOD-5A0095 <001> #
