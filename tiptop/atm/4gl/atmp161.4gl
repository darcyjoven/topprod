# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmp161.4gl
# Descriptions...: 集團銷售預測拋轉作業
# Date & Author..: 06/05/30 by Sarah
# Modify.........: No.FUN-640268 06/05/30 By Sarah 新增"集團銷售預測拋轉作業"
# Modify.........: No.FUN-660104 06/06/20 By cl  Error Message 調整
# Modify.........: No.FUN-680120 06/08/29 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-710033 07/01/17 By dxfwo  錯誤訊息匯總顯示修改
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting 如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                       不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/23 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No.FUN-A50102 10/06/12 By wangxin 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE tm          RECORD                       # Print condition RECORD
                    odb01     LIKE odb_file.odb01 
                   END RECORD
DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_t1	   LIKE oay_file.oayslip        #No.FUN-680120 VARCHAR(5)
DEFINE g_cnt       LIKE type_file.num10         #No.FUN-680120 INTEGER
DEFINE g_i         LIKE type_file.num5          #count/index for any purpose        #No.FUN-680120 SMALLINT
DEFINE g_msg       LIKE type_file.chr1000       #No.FUN-680120 VARCHAR(72)
DEFINE l_ac        LIKE type_file.num5          #No.FUN-680120 SMALLINT
DEFINE g_argv1     LIKE odb_file.odb01
DEFINE l_dbs_tra   LIKE type_file.chr21         #FUN-980092 
#     DEFINEl_time LIKE type_file.chr8          #No.FUN-6B0014
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
 
   LET g_argv1 = ARG_VAL(1)   #預測版本
 
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN
      CALL p161_p1()
   ELSE
      LET tm.odb01 = g_argv1
      LET g_success = 'Y'    #No.FUN-8A0086
      CALL p161_p2()
   END IF
 
   CLOSE WINDOW p161_w
 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124
END MAIN
 
FUNCTION p161_p1()
   DEFINE l_flag   LIKE type_file.num5             #No.FUN-680120 SMALLINT
   DEFINE l_odb02  LIKE odb_file.odb02
   DEFINE l_odb08  LIKE odb_file.odb08
 
   LET p_row = 4 LET p_col = 12
   OPEN WINDOW p161_w AT p_row,p_col WITH FORM "atm/42f/atmp161"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   
   WHILE TRUE
     LET g_action_choice = ''
     INPUT BY NAME tm.odb01 WITHOUT DEFAULTS
 
        #No.FUN-580031 --start--
        BEFORE INPUT
            CALL cl_qbe_init()
        #No.FUN-580031 ---end---
 
        AFTER FIELD odb01
           IF NOT cl_null(tm.odb01) THEN
              SELECT odb02,odb08 INTO l_odb02,l_odb08 FROM odb_file 
               WHERE odb01 = tm.odb01 
              DISPLAY l_odb02 TO odb02
              IF l_odb08 = 'Y' THEN
                 CALL cl_err(tm.odb01,'apm-019',1)
                 NEXT FIELD odb01
              END IF
           ELSE
              DISPLAY ' ' TO odb02
           END IF
 
        ON ACTION locale
           #CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
 
        ON ACTION controlp  
           CASE 
              WHEN INFIELD(odb01)   #預測版本
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = 'q_odb'
                 CALL cl_create_qry() RETURNING tm.odb01
                 DISPLAY BY NAME tm.odb01
                 NEXT FIELD odb01
           END CASE
           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
 
        #No.FUN-580031 --start--
        ON ACTION qbe_select
           CALL cl_qbe_select()
        #No.FUN-580031 ---end---
 
     END INPUT
 
     IF g_action_choice = 'locale' THEN
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
     IF cl_sure(0,0) THEN
        LET g_success = 'Y'
        BEGIN WORK
        CALL p161_p2()
        CALL s_showmsg()        #No.FUN-710033
        IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag
        END IF
        IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
     END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p161_p2()
   DEFINE l_sql    STRING
   DEFINE l_sql2   STRING
   DEFINE l_odb    RECORD LIKE odb_file.*   #集團銷售預測版本資料檔
   DEFINE l_tqd03  LIKE tqd_file.tqd03      #下級組織機構代碼
   DEFINE l_tqb04  LIKE tqb_file.tqb04      #是否記錄營運中心
   DEFINE l_tqb05  LIKE tqb_file.tqb05      #營運中心代碼
   DEFINE l_odc    RECORD LIKE odc_file.*   #集團銷售預測資料單頭檔
   DEFINE l_ode    RECORD LIKE ode_file.*   #集團銷售預測資料明細單身檔
   DEFINE l_opc    RECORD LIKE opc_file.*   #產品銷售預測單頭檔
   DEFINE l_odd03  LIKE odd_file.odd03      #序號
   DEFINE l_odd04  LIKE odd_file.odd04      #預測料號
   DEFINE l_opd    RECORD LIKE opd_file.*   #產品銷售預測單身檔
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_i      LIKE type_file.num5          #No.FUN-680120 SMALLINT
   DEFINE l_legal  LIKE oga_file.ogalegal   #FUN-980009
   DEFINE l_plant_new  LIKE oga_file.ogaplant   #FUN-980009
 
   CALL cl_wait() 
 
   SELECT odb_file.* INTO l_odb.*
     FROM odb_file,odc_file
    WHERE odb01  = tm.odb01
      AND odb01  = odc01
      AND odb07  = odc02 
      AND odb08  = 'N'   #還未拋轉
      AND odc12  = 'Y'
      AND odc121 = 'Y'
      AND odc13  = 'Y'
      AND odc131 = 'Y'
   IF SQLCA.SQLCODE THEN 
   #  CALL cl_err('',SQLCA.SQLCODE,1)   #No.FUN-660104
      CALL cl_err3("sel","odb_file,odc_file",tm.odb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
      LET g_success='N'
      RETURN
   END IF 
 
{
   LET l_sql = "SELECT tqd03,tqb04,tqb05,odc_file.* ",
               "  FROM tqd_file,tqb_file,odc_file ",
               " WHERE tqd01  = '",l_odb.odb07,"' ",   #最上層組織
               "   AND tqd03  = odc02 ",
               "   AND tqb01  = tqd03 ",
               "   AND odc12  = 'Y' ",
               "   AND odc121 = 'Y' ",
               "   AND odc13  = 'Y' ",
               "   AND odc131 = 'Y' "
}
 
   LET l_sql = "SELECT tqc01,tqb04,tqb05,odc_file.* ",
               "  FROM tqc_file,tqb_file,odc_file ",
               " WHERE odc01  = '",l_odb.odb01,"' ",   #
               "   AND odc02  = '",l_odb.odb07,"' ",   #
               "   AND tqc01  = '",l_odb.odb07,"' ",   #
               "   AND tqb01  = '",l_odb.odb07,"' ",   #
               "   AND odc12  = 'Y' ",
               "   AND odc121 = 'Y' ",
               "   AND odc13  = 'Y' ",
               "   AND odc131 = 'Y' "
 
   PREPARE p161_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('p161_p1',SQLCA.SQLCODE,1) 
      LET g_success='N'
      RETURN
   END IF
   DECLARE p161_c1 CURSOR FOR p161_p1
   CALL s_showmsg_init()           #NO. FUN-710033
   FOREACH p161_c1 INTO l_tqd03,l_tqb04,l_tqb05,l_odc.*
   #NO. FUN-710033--BEGIN          
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
   #NO. FUN-710033--END
      IF l_tqb04='N' THEN            #是否記錄營運中心
         LET g_plant_new = g_plant 
      ELSE 
         LET g_plant_new = l_tqb05   #營運中心代碼
      END IF 
 
     #CALL s_getdbs()
     #LET g_dbs_atm = g_dbs_new CLIPPED
 
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
     CALL s_gettrandbs()
     LET l_dbs_tra  = g_dbs_tra
     #--Begin FUN-980092 add----GP5.2 Modify #改抓Transaction DB
 
     #Begin-FUN-980009------------------------
      LET  l_plant_new = g_plant_new 
      CALL s_getlegal(l_plant_new) RETURNING l_legal
     #End --FUN-980009------------------------
 
      LET l_sql = "SELECT odd03,odd04 FROM odd_file ",
                  " WHERE odd01 = '",tm.odb01,"' ",
                  "   AND odd02 = '",l_tqd03,"' ",
                  " ORDER BY odd03,odd04"
      PREPARE p161_p2 FROM l_sql
      IF SQLCA.SQLCODE THEN 
#        CALL cl_err('p161_p2',SQLCA.SQLCODE,1)         # No.FUN-710033
         CALL s_errmsg('','','p161_p2',SQLCA.SQLCODE,1) # No.FUN-710033 
         LET g_success='N'
#        RETURN                                         # No.FUN-710033
         CONTINUE FOREACH                               # No.FUN-710033
      END IF
      DECLARE p161_c2 CURSOR FOR p161_p2
      FOREACH p161_c2 INTO l_odd03,l_odd04
         #先檢查axmi171裡是否已有相同key值的資料了,如果沒有才新增單頭
         LET l_i = 0
         #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"opc_file ", #FUN-A50102
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new, 'opc_file'), #FUN-A50102
                     " WHERE opc01='",l_odd04,"'",
                     "   AND opc02='all'",
                     "   AND opc03='",l_odb.odb03,"'",
                     "   AND opc04='",l_odc.odc07,"'"
 
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
         PREPARE p161_p3 FROM l_sql
         IF SQLCA.SQLCODE THEN 
#           CALL cl_err('p161_p3',SQLCA.SQLCODE,1)           # No.FUN-710033 
            CALL s_errmsg('','','p161_p3',SQLCA.SQLCODE,1)   # No.FUN-710033
         END IF
         DECLARE p161_c3 CURSOR FOR p161_p3
         OPEN p161_c3
         FETCH p161_c3 INTO l_i
         IF l_i = 0 THEN
            LET l_opc.opc01 = l_odd04                          #預測料件
            LET l_opc.opc02 = 'all'                            #客戶編號
            LET l_opc.opc03 = l_odb.odb03                      #計劃日期
            LET l_opc.opc04 = l_odc.odc07                      #業務員
            LET l_opc.opc05 = l_odc.odc08                      #業務部門
            CASE l_odc.odc04
               WHEN '5' LET l_opc.opc06 = '2'                  #提列方式   #天
               WHEN '3' LET l_opc.opc06 = '3'                              #週
               WHEN '3' LET l_opc.opc06 = '4'                              #旬
               WHEN '2' LET l_opc.opc06 = '5'                              #月
               WHEN '1' LET l_opc.opc06 = '5'                              #月
            END CASE
            SELECT COUNT(*) INTO l_opc.opc07 FROM ode_file     #產生期數
             WHERE ode01  = tm.odb01 
               AND ode02  = l_tqd03 
               AND ode031 = l_opc.opc01
            LET l_opc.opc08  = l_odc.odc09                     #幣別
            LET l_opc.opc09  = l_odc.odc10                     #匯率
            LET l_opc.opc11  =  'N'                            #業務確認 
            LET l_opc.opc12  =  'N'                            #生管確認
            LET l_opc.opcacti=  'Y'                            #資料有效碼
            LET l_opc.opcuser=  g_user                         #資料所有者
            LET l_opc.opcgrup=  g_grup                         #資料所有群
            LET l_opc.opcmodu=  NULL                           #資料更改者
            LET l_opc.opcdate=  g_today                        #最近修改日
            #------寫入產品銷售預測單頭檔------
            
            #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"opc_file ", #FUN-A50102
            LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new, 'opc_file'), #FUN-A50102
                         "       (opc01,opc02,opc03,opc04,opc05, ",
                         "        opc06,opc07,opc08,opc09,opc11, ",
                         "        opc12,opcacti,opcuser,opcgrup,opcdate,",
                         "        opcplant,opclegal,opcoriu,opcorig )" ,#FUN-980009  #FUN-A10036
                         "VALUES (?,?,?,?,?, ",
                         "        ?,?,?,?,?, ",
                         "        ?,?,?,?,?,",
                         "        ?,?,?,?)"  #FUN-A10036
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
 	          CALL cl_parse_qry_sql(l_sql2, l_plant_new) RETURNING l_sql2  #FUN-A50102
            PREPARE ins_opc FROM l_sql2
            EXECUTE ins_opc USING 
               l_opc.opc01,l_opc.opc02,l_opc.opc03,l_opc.opc04,l_opc.opc05,
               l_opc.opc06,l_opc.opc07,l_opc.opc08,l_opc.opc09,l_opc.opc11,
               l_opc.opc12,l_opc.opcacti,l_opc.opcuser,l_opc.opcgrup,l_opc.opcdate,
               l_plant_new,l_legal,g_user,g_grup  #FUN-980009  #FUN-A10036
            IF SQLCA.sqlcode THEN
#              CALL cl_err('ins opc',SQLCA.sqlcode,1)            # No.FUN-710033
               CALL s_errmsg('','','ins opc',SQLCA.sqlcode,1)    # No.FUN-710033
               LET g_success='N'
#              RETURN                                            # No.FUN-710033 
               EXIT FOREACH                                      # No.FUN-710033  
            END IF
         END IF
 
         LET l_cnt = 0
         LET l_sql = "SELECT * FROM ode_file ",
                     " WHERE ode01 = '",tm.odb01,"' ",
                     "   AND ode02 = '",l_tqd03,"' ",
                     "   AND ode03 = '",l_odd03,"' ",
                     " ORDER BY ode031,ode04"
         PREPARE p161_p4 FROM l_sql
         IF SQLCA.SQLCODE THEN 
#           CALL cl_err('p161_p4',SQLCA.SQLCODE,1)               # No.FUN-710033   
            CALL s_errmsg('','','p161_p4',SQLCA.SQLCODE,1)       # No.FUN-710033
            LET g_success='N'
            RETURN
         END IF
         DECLARE p161_c4 CURSOR FOR p161_p4
         FOREACH p161_c4 INTO l_ode.*
            IF l_cnt != 0 THEN
               #LET l_sql2 = "UPDATE ",l_dbs_tra CLIPPED,"opd_file ", #FUN-A50102
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new, 'opd_file'), #FUN-A50102
                            "   SET opd07 = ?-1",         #截止日期
                            " WHERE opd01 = ?",
                            "   AND opd02 = ?",
                            "   AND opd03 = ?",
                            "   AND opd04 = ?",
                            "   AND opd05 = ?"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE upd_opd1 FROM l_sql2
               EXECUTE upd_opd1 USING 
                  l_ode.ode04,l_odd04,'all',l_odb.odb03,l_odc.odc07,l_cnt
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd opd1',SQLCA.sqlcode,1)         # No.FUN-710033
                  CALL s_errmsg('','','upd opd1',SQLCA.sqlcode,1) # No.FUN-710033
                  LET g_success='N'
#                 RETURN                                          # No.FUN-710033 
                  EXIT FOREACH                                # No.FUN-710033  
               END IF
            END IF
            LET l_opd.opd01 = l_odd04                     #預測料件
            LET l_opd.opd02 = 'all'                       #客戶編號
            LET l_opd.opd03 = l_odb.odb03                 #計劃日期
            LET l_opd.opd04 = l_odc.odc07                 #業務員
            LET l_opd.opd05 = l_cnt + 1                   #序號
            LET l_opd.opd06 = l_ode.ode04                 #起始日期
            LET l_opd.opd08 = l_ode.ode09                 #計劃數量
            LET l_opd.opd09 = 0                           #確認數量
            LET l_opd.opd10 = l_ode.ode10                 #單價
            LET l_opd.opd11 = l_ode.ode09 * l_ode.ode10   #金額
            #先檢查axmi171裡是否已有相同key值的資料了,如果沒有才新增單身
            LET l_i = 0
            #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"opd_file ", #FUN-A50102
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new, 'opd_file'), #FUN-A50102
                        " WHERE opd01='",l_odd04,"'",
                        "   AND opd02='all'",
                        "   AND opd03='",l_odb.odb03,"'",
                        "   AND opd04='",l_odc.odc07,"'",
                        "   AND opd06='",l_ode.ode04,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
            PREPARE p161_p5 FROM l_sql
            IF SQLCA.SQLCODE THEN 
#              CALL cl_err('p161_p5',SQLCA.SQLCODE,1)          # No.FUN-710033
               CALL s_errmsg('','','p161_p5',SQLCA.SQLCODE,1)  # No.FUN-710033  
            END IF
            DECLARE p161_c5 CURSOR FOR p161_p5
            OPEN p161_c5
            FETCH p161_c5 INTO l_i
            IF l_i = 0 THEN
               #------寫入產品銷售預測單身檔------
               #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"opd_file ", #FUN-A50102
               LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new, 'opd_file'), #FUN-A50102
                            "       (opd01,opd02,opd03,opd04,opd05, ",
                            "        opd06,opd08,opd09,opd10,opd11, ",
                            "        opdplant,opdlegal) ", #FUN-980009
                            "VALUES (?,?,?,?,?, ",
                            "        ?,?,?,?,?,",
                            "        ?,?)"        #FUN-980009
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
 	 CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql #FUN-980092
               PREPARE ins_opd FROM l_sql2
               EXECUTE ins_opd USING
                  l_opd.opd01,l_opd.opd02,l_opd.opd03,l_opd.opd04,l_opd.opd05,
                  l_opd.opd06,l_opd.opd08,l_opd.opd09,l_opd.opd10,l_opd.opd11 ,
                  l_plant_new,l_legal  #FUN-980009
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('ins opd',SQLCA.sqlcode,1)         # No.FUN-710033 
                  CALL s_errmsg('','','ins opd',SQLCA.sqlcode,1) # No.FUN-710033
                  LET g_success='N'
#                 RETURN                                         # No.FUN-710033
                  EXIT FOREACH                                   # No.FUN-710033        
               END IF
               LET l_cnt = l_cnt + 1
            ELSE
               #LET l_sql2 = "UPDATE ",l_dbs_tra CLIPPED,"opd_file ", #FUN-A50102
               LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new, 'opd_file'), #FUN-A50102
                            "   SET opd08 = opd08+?,",         #計劃數量
                            "       opd11 = opd11+? ",         #金額
                            " WHERE opd01 = ?",
                            "   AND opd02 = ?",
                            "   AND opd03 = ?",
                            "   AND opd04 = ?",
                            "   AND opd06 = ?"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE upd_opd2 FROM l_sql2
               EXECUTE upd_opd2 USING 
                  l_opd.opd08,l_opd.opd11,
                  l_odd04,'all',l_odb.odb03,l_odc.odc07,l_ode.ode04
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('upd opd2',SQLCA.SQLCODE,1)        # No.FUN-710033
                  CALL s_errmsg('','','upd opd2',SQLCA.SQLCODE,1)# No.FUN-710033 
                  LET g_success='N'
#                 RETURN                                         # No.FUN-710033 
                  EXIT FOREACH                                   # No.FUN-710033
               END IF
            END IF
         END FOREACH
         #LET l_sql2 = "UPDATE ",l_dbs_tra CLIPPED,"opd_file ", #FUN-A50102
         LET l_sql2 = "UPDATE ",cl_get_target_table(l_plant_new, 'opd_file'), #FUN-A50102
                      "   SET opd07 = ?",         #截止日期
                      " WHERE opd01 = ?",
                      "   AND opd02 = ?",
                      "   AND opd03 = ?",
                      "   AND opd04 = ?",
                      "   AND opd05 = ?"
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
         PREPARE upd_opd3 FROM l_sql2
         EXECUTE upd_opd3 USING 
            l_odc.odc06,l_odd04,'all',l_odb.odb03,l_odc.odc07,l_cnt
         IF SQLCA.sqlcode THEN
#           CALL cl_err('upd opd3',SQLCA.SQLCODE,1)            # No.FUN-710033
            CALL s_errmsg('','','upd opd3',SQLCA.SQLCODE,1)    # No.FUN-710033
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END FOREACH
   #NO. FUN-710014--BEGIN
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
    #NO. FUN-710014--END 
 
   IF g_success = 'Y' THEN
      UPDATE odb_file SET odb08='Y' WHERE odb01=tm.odb01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      #  CALL cl_err('upd odb_file',SQLCA.SQLCODE,1)  #No.FUN-660104
         CALL cl_err3("upd","odb_file",tm.odb01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660104
         LET g_success='N'
         RETURN
      END IF
   END IF
END FUNCTION
