# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: gisp100.4gl
# Descriptions...: 銷項發票底稿產生作業
# Date & Author..: 02/04/15 By Danny
# Modify.........: No.MOD-4C0084 04/12/13 By Elva 
# Modify.........: No.FUN-540006 05/04/25 By day  由axrt300傳入參數帳單編號  
# Modify.........: No.MOD-570128 05/07/06 By wujie 修正axrt300傳入時工廠別無法得到
# Modify.........: No.FUN-580006 05/08/11 By ice 修正傳入參數
# Modify.........: No.MOD-5A0156 05/10/21 By wujie 通過系統參數控制"應收審核后才可開立發票"
# Modify.........: No.TQC-5B0175 05/11/28 By ice 銷項發票底稿應包含負植顯示的待扺資料
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-690009 06/09/04 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.TQC-790089 07/09/18 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.TQC-940067 09/05/07 By mike l_dbs改為使用s_dbstring    
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/23 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-C60036 12/06/11 By xuxz 判斷oaz92='Y'時不運行本作業
# Modify.........: No:FUN-D50034 13/05/13 By zhangweib 发票咨询写入isg_file/ish_file,并调整负数行至正数行中
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE tm          RECORD 
                   wc           LIKE type_file.chr1000,   #NO.FUN-690009 VARCHAR(400)
                   a            LIKE type_file.chr1       #NO.FUN-690009 VARCHAR(01)
                   END RECORD,
       g_atot      LIKE type_file.num5,         #NO FUN-690009 SMALLINT
       plant       ARRAY[12] OF LIKE azp_file.azp01       #NO FUN-690009 VARCHAR(12)  #工廠編號
DEFINE g_argv1     LIKE oma_file.oma01    #No.FUN-540006
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-540006  #NO FUN-690009 SMALLINT
DEFINE g_oaz92     LIKE oaz_file.oaz92    #FUN-C60063 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT   
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF
   
   #FUN-C60036--add--str
   SELECT oaz92 INTO g_oaz92 FROM oaz_file 
   IF g_oaz92 = 'Y' THEN 
      CALL cl_err('','gis-001',1)
      EXIT PROGRAM
   END IF 
   #FUN-C60036--add--end
     
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
#No.FUN-540006-begin
   LET g_argv1=ARG_VAL(1) 
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 3 LET p_col = 20
      ELSE
         LET p_row = 5 LET p_col = 10
      END IF
      OPEN WINDOW p100_w AT p_row,p_col WITH FORM "gis/42f/gisp100" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
         CALL cl_ui_init()
 
         CALL cl_opmsg('p')
 
#No.FUN-580006 --start--
    IF NOT cl_null(g_argv1) THEN   #No.MOD-570128
      LET tm.wc=" oma01='",g_argv1,"'"                                          
       LET plant[1] = g_plant      #No.MOD-570128   
      DISPLAY g_argv1 TO oma01
      DISPLAY g_plant TO plant[1]
      IF cl_sure(18,0) THEN
         CALL cl_wait()
         CALL p100_g()
         IF STATUS THEN
            CALL cl_err('',STATUS,1) 
            LET g_success='N'
            ROLLBACK WORK
         END IF
         CALL cl_end(0,0)
      END IF
   ELSE
      CALL p100_tm()
   END IF 
#No.FUN-580006 --end--
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#No.FUN-540006-end
 
END MAIN
 
FUNCTION p100_tm()
   DEFINE   p_row,p_col   LIKE type_file.num5,      #NO FUN-690009 SMALLINT
            l_cmd         LIKE type_file.chr1000,   #NO FUN-690009 VARCHAR(400)
            l_ac,i        LIKE type_file.num5       #NO FUN-690009 SMALLINT
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON oma00,oma01,oma02,oma03,omb04
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
      
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup') #FUN-980030
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF tm.wc=" 1=1" THEN 
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF 
      #----- 工廠編號 ----#
      LET plant[1] = g_plant
      CALL SET_COUNT(1)    # initial array argument
 
      INPUT ARRAY plant WITHOUT DEFAULTS FROM s_plant.* 
         AFTER FIELD plant
            LET l_ac = ARR_CURR()
            IF NOT cl_null(plant[l_ac]) THEN
               SELECT azp01 FROM azp_file WHERE azp01 = plant[l_ac]
               IF STATUS THEN 
#                 CALL cl_err('sel azp',STATUS,1)   #No.FUN-660146
                  CALL cl_err3("sel","azp_file",plant[l_ac],"",STATUS,"","sel azp",1)   #No.FUN-660146
                  NEXT FIELD plant 
               END IF
               FOR i = 1 TO l_ac-1      # 檢查工廠是否重覆
                   IF plant[i] = plant[l_ac] THEN
                      CALL cl_err('','aom-492',1) NEXT FIELD plant
                   END IF
               END FOR
               IF NOT s_chkdbs(g_user,plant[l_ac],g_rlang) THEN
                  NEXT FIELD plant
               END IF
            END IF
 
         AFTER INPUT                    # 檢查至少輸入一個工廠
            IF INT_FLAG THEN
               EXIT INPUT 
            END IF
            LET g_atot = ARR_COUNT()
            FOR i = 1 TO g_atot
               IF NOT cl_null(plant[i]) THEN
                  EXIT INPUT
               END IF
            END FOR
            IF i = g_atot+1 THEN
               CALL cl_err('','aom-423',1) NEXT FIELD plant
            END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG
            CALL cl_cmdask()  
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM 
      END IF
      LET tm.a = 'N' 
 
      INPUT BY NAME tm.a WITHOUT DEFAULTS  
         AFTER FIELD a 
            IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
               NEXT FIELD a
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
          ON ACTION about         #MOD-4C0121
             CALL cl_about()      #MOD-4C0121
 
          ON ACTION help          #MOD-4C0121
             CALL cl_show_help()  #MOD-4C0121
 
          ON ACTION controlg      #MOD-4C0121
             CALL cl_cmdask()     #MOD-4C0121
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW p100_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      IF cl_sure(18,0) THEN
         CALL cl_wait()
         CALL p100_g()
         ERROR ''
         CALL cl_end(0,0)
      END IF
   END WHILE
 
   CLOSE WINDOW p100_w
END FUNCTION
 
FUNCTION p100_g() 
   DEFINE  l_sql      LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(1600)
           l_buf      LIKE type_file.chr1000,  #NO FUN-690009 VARCHAR(400)
           l_dbs      LIKE azp_file.azp03,     #NO FUN-690009 VARCHAR(20)
           l_oma      RECORD LIKE oma_file.*,
           l_omb      RECORD LIKE omb_file.*,
           l_isa      RECORD LIKE isa_file.*,
           l_isb      RECORD LIKE isb_file.*,
           l_occ11    LIKE occ_file.occ11,
           l_occ18    LIKE occ_file.occ18,
           l_occ231   LIKE occ_file.occ231,
           l_occ261   LIKE occ_file.occ261,
           l_ocj03    LIKE ocj_file.ocj03,
           l_nmt02    LIKE nmt_file.nmt02,
           l_ima021   LIKE ima_file.ima021,
           l_ima131   LIKE ima_file.ima131,
           l_oma01    LIKE oma_file.oma01,
           l_i        LIKE type_file.num5      #NO FUN-690009
   DEFINE  l1_omb     RECORD LIKE omb_file.*,  #No.TQC-5B0175 
           l1_isb03   LIKE isb_file.isb03,     #No.TQC-5B0175 發票待扺生成單身項次
           l1_ima021  LIKE ima_file.ima021,    #No.TQC-5B0175 規格
           l1_ima131  LIKE ima_file.ima131     #No.TQC-5B0175 商品類別
 #No.FUN-D50034 ---Add--- Start
   DEFINE  l_isg      RECORD LIKE isg_file.*
   DEFINE  l_ish      RECORD LIKE ish_file.*
   DEFINE  l_ish01    LIKE ish_file.ish01
   DEFINE  l_ish02    LIKE ish_file.ish02
   DEFINE  l_ish08    LIKE ish_file.ish08
   DEFINE  t_ish08    LIKE ish_file.ish08
   DEFINE  t_ish08_1  LIKE ish_file.ish08
   DEFINE  l_cnt      LIKE type_file.num5
   DEFINE  l_n        LIKE type_file.num5
  #No.FUN-D50034 ---Add--- End  
  
   BEGIN WORK 
   LET g_success = 'Y'

#No.FUN-D50034 ---Add--- Start
   CALL p100_ctreatetab()
   LET l_sql = "SELECT * FROM p100_tmpb WHERE ish08 < 0"
   PREPARE p100_sel_tmpb FROM l_sql
   DECLARE p100_tmpb_dec CURSOR FOR p100_sel_tmpb
   LET l_sql = "SELECT * FROM p100_tmpb ORDER BY ish01"
   PREPARE p100_sel_tmpb1 FROM l_sql
   DECLARE p100_tmpb_dec1 CURSOR FOR p100_sel_tmpb1
  #No.FUN-D50034 ---Add--- End   
 
   LET l_i = 1
    IF NOT cl_null(g_argv1) THEN LET g_atot = 1  LET tm.a = 'Y' END IF   #No.MOD-570128 
   FOR l_i = 1 TO g_atot
       IF cl_null(plant[l_i]) THEN CONTINUE FOR END IF    
       #SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = plant[l_i] #FUN-A50102
      #LET l_dbs = l_dbs CLIPPED,'.dbo.' #TQC-940067                                                                                    
       #LET l_dbs = s_dbstring(l_dbs CLIPPED) #TQC-940067     #FUN-A50102
       LET l_sql = "SELECT oma_file.*,omb_file.*,occ11,occ18,occ231,occ261,",
                   "       ima021,ima131 ",
                   #"  FROM ",l_dbs CLIPPED,"oma_file,",
                   #          l_dbs CLIPPED,"omb_file,OUTER ",
                   #          l_dbs CLIPPED,"ima_file,OUTER ",
                   #          l_dbs CLIPPED,"occ_file ",
                   "  FROM ",cl_get_target_table(plant[l_i],'oma_file'),",",       #FUN-A50102
                             cl_get_target_table(plant[l_i],'omb_file'),",OUTER ", #FUN-A50102                             
                             cl_get_target_table(plant[l_i],'ima_file'),",OUTER ", #FUN-A50102                             
                             cl_get_target_table(plant[l_i],'occ_file'),           #FUN-A50102
                   " WHERE oma01 = omb01 ",
                   "   AND (oma00 LIKE '1%' OR oma00='21' OR oma00='25')",
#No.MOD-5A0156--begin                                                                                                               
#                   "   AND omaconf = 'Y' AND omavoid = 'N' ",                                                                      
                   "   AND omavoid = 'N'",                                                                                         
#No.MOD-5A0156--end 
                   "   AND occ_file.occ01 = oma_file.oma03 AND ima_file.ima01 =omb_file.omb04 ",
                   "   AND (oma10 IS NULL OR oma10 = ' ')",
                   "   AND oma01 NOT IN (SELECT UNIQUE isa04 FROM isa_file",
                    "                      WHERE isa07 IN ('1','2')) ", #MOD-4C0084
                   "   AND ",tm.wc CLIPPED
#No.MOD-5A0156--begin                                                                                                               
        SELECT ooz20 INTO g_ooz.ooz20 FROM ooz_file                                                                                 
         WHERE ooz00 = '0'                                                                                                          
        IF g_ooz.ooz20 ='Y' THEN                                                                                                    
           LET l_sql = l_sql,"  AND omaconf = 'Y'"                                                                                  
        END IF                                                                                                                      
#No.MOD-5A0156--end 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE p100_pre FROM l_sql
       IF STATUS THEN 
          CALL cl_err('p100_pre',STATUS,0) LET g_success = 'N' EXIT FOR
       END IF
       DECLARE p100_curs CURSOR FOR p100_pre
       #銀行&帳號
       LET l_sql = "SELECT ocj03,nmt02 ",
                   #" FROM ",l_dbs CLIPPED,"ocj_file,OUTER ",
                   #         l_dbs CLIPPED,"nmt_file ",
                   " FROM ",cl_get_target_table(plant[l_i],'ocj_file'),",OUTER ",#FUN-A50102                   
                            cl_get_target_table(plant[l_i],'nmt_file'),           #FUN-A50102
                   " WHERE ocj01 = ? AND ocjacti = 'Y' ",
                   "   AND nmt_file.nmt01 = ocj_file.ocj02 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,plant[l_i]) RETURNING l_sql #FUN-A50102
       PREPARE p100_pre2 FROM l_sql
       IF STATUS THEN 
          CALL cl_err('p100_pre2',STATUS,0) LET g_success = 'N' EXIT FOR
       END IF
       DECLARE p100_curs2 CURSOR FOR p100_pre2
 
       LET l_oma01 = ' '
       FOREACH p100_curs INTO l_oma.*,l_omb.*,
                               l_occ11,l_occ18,l_occ231,l_occ261,l_ima021,l_ima131 #MOD-4C0084
          IF STATUS THEN 
             CALL cl_err('p100_curs',STATUS,0) LET g_success = 'N' EXIT FOR
          END IF
          IF l_oma01 != l_oma.oma01 THEN
             #銀行&帳號
             LET l_ocj03 = ''
             LET l_nmt02 = ''
             OPEN p100_curs2 USING l_oma.oma03
             IF STATUS THEN 
                CALL cl_err('p100_curs2',STATUS,0) LET g_success='N' EXIT FOR
             END IF
             FETCH p100_curs2 INTO l_ocj03,l_nmt02
 
             INITIALIZE l_isa.* TO NULL
             LET l_isa.isa00 = '0'
             LET l_isa.isa01 = ' '
             LET l_isa.isa02 = ' '   #No.FUN-D50034   Add
             LET l_isa.isa04 = l_oma.oma01              
             LET l_isa.isa05 = l_oma.oma03                         #客戶編號
             LET l_isa.isa051= l_occ18                             #全名
             LET l_isa.isa052= l_occ11                             #稅號
             LET l_isa.isa053= l_occ231 CLIPPED,l_occ261 CLIPPED   #地址電話
             LET l_isa.isa054= l_nmt02 CLIPPED,l_ocj03 CLIPPED     #銀行帳號
             LET l_isa.isa06 = l_oma.oma21
             LET l_isa.isa061= l_oma.oma211
             LET l_isa.isa062= l_oma.oma212
             LET l_isa.isa07 = '0'
             LET l_isa.isa08 = l_oma.oma59
             LET l_isa.isa08x= l_oma.oma59x
             LET l_isa.isa08t= l_oma.oma59t
             LET l_isa.isauser = g_user
             LET l_isa.isagrup = g_grup
             LET l_isa.isadate = g_today
             LET l_isa.isalegal= g_legal   #FUN-980011 add
             IF l_oma.oma00 MATCHES '2*' THEN
                LET l_isa.isa08 = l_isa.isa08 * -1
                LET l_isa.isa08x= l_isa.isa08x* -1
                LET l_isa.isa08t= l_isa.isa08t* -1
             END IF
             SELECT COUNT(*) INTO l_isa.isa09 FROM omb_file
              WHERE omb01 = l_oma.oma01
             IF cl_null(l_isa.isa09) THEN LET l_isa.isa09 = 0 END IF
             LET l_isa.isaoriu = g_user      #No.FUN-980030 10/01/04
             LET l_isa.isaorig = g_grup      #No.FUN-980030 10/01/04
             INSERT INTO isa_file VALUES(l_isa.*)
            #IF STATUS != 0 AND STATUS != -239 THEN                            #TQC-790089 mark
             IF STATUS != 0 AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) )  THEN  #TQC-790089 mod
               #CALL cl_err('ins isa',STATUS,1)   #No.FUN-660146
               #CALL cl_err3("ins","isa_file",l_isa.isa01,l_isa.isa04,STATUS,"","ins isa",1)         #TQC-790089 mark #No.FUN-660146
                CALL cl_err3("ins","isa_file",l_isa.isa01,l_isa.isa04,SQLCA.SQLCODE,"","ins isa",1)  #TQC-790089 mod  #No.FUN-660146
                LET g_success='N' EXIT FOR 
             END IF
            #IF STATUS = -239 AND tm.a = 'Y' THEN                     #TQC-790089 mark
             IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN   #TQC-790089 mod 
                UPDATE isa_file SET * = l_isa.* 
                 WHERE isa01 = l_isa.isa01 AND isa04 = l_isa.isa04
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                  CALL cl_err('upd isa',STATUS,1)   #No.FUN-660146
                   CALL cl_err3("upd","isa_file",l_isa.isa01,l_isa.isa04,STATUS,"","upd isa",1)   #No.FUN-660146
                   LET g_success='N' EXIT FOR 
                END IF
             END IF
 #No.FUN-D50034 ---Add--- Start
             IF tm.a = 'Y' THEN
                DELETE FROM isg_file WHERE isg01 = l_isa.isa04
             END IF
             INITIALIZE l_isg.* TO NULL
             LET l_isg.isg01 = l_isa.isa04
             LET l_isg.isg02 = l_isa.isa09
             LET l_isg.isg03 = l_isa.isa051
             LET l_isg.isg04 = l_isa.isa052
             LET l_isg.isg05 = l_isa.isa053
             LET l_isg.isg06 = l_isa.isa054
             LET l_isg.isg07 = l_isa.isa10
             LET l_isg.isg08 = Null
             LET l_isg.isg09 = Null
             LET l_isg.isg10 = Null
             LET l_isg.isg11 = l_isa.isa13
             LET l_isg.isg12 = l_isa.isa15
             LET l_isg.isg13 = NULL
             INSERT INTO isg_file VALUES(l_isg.*)
             IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
                CALL cl_err3("ins","isg_file",l_isg.isg01,"",SQLCA.SQLCODE,"","ins isg",1)
                LET g_success='N' EXIT FOR 
             END IF
            #No.FUN-D50034 ---Add--- End

             #No.TQC-5B0175 --start-- 
             #抓取待扺發票資料,生成發票底稿單身,金額以負值表示 
             LET l_sql = "SELECT omb_file.*,ima021,ima131 ",
                         #"  FROM ",l_dbs CLIPPED,"omb_file ", 
                         #" LEFT OUTER JOIN ",l_dbs CLIPPED,"ima_file ON omb_file.omb04 = ima_file.ima01",
                         "  FROM ",cl_get_target_table(plant[l_i],'omb_file'), #FUN-A50102
                         "  LEFT OUTER JOIN ",cl_get_target_table(plant[l_i],'ima_file'), #FUN-A50102
                         "    ON omb_file.omb04 = ima_file.ima01",
                         " WHERE omb01 IN (SELECT DISTINCT oot01 ",
                         #"  FROM ",l_dbs CLIPPED,"oot_file  ",
                         "  FROM ",cl_get_target_table(plant[l_i],'oot_file'), #FUN-A50102
                         " WHERE oot03 = '",l_oma.oma01,"') ", 
                         " ORDER BY omb_file.omb01,omb_file.omb03 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,plant[l_i]) RETURNING l_sql #FUN-A50102
             PREPARE p100_pre3 FROM l_sql 
             IF STATUS THEN
                CALL cl_err('p100_pre3',STATUS,0) 
                LET g_success = 'N'
                EXIT FOR
             END IF
             DECLARE p100_curs3 CURSOR FOR p100_pre3 
             LET l1_isb03 = l_isa.isa09 + 1
             FOREACH p100_curs3 INTO l1_omb.*,l1_ima021,l1_ima131 
                IF STATUS THEN 
                   CALL cl_err('p100_curs3',STATUS,0)
                   LET g_success = 'N'
                   EXIT FOR
                END IF
                INITIALIZE l_isb.* TO NULL
                LET l_isb.isb01 = ' ' 
                LET l_isb.isb02 = l_isa.isa04 
                LET l_isb.isb11 = l_isa.isa02 #FUN-C60036 add
                LET l_isb.isb03 = l1_isb03 
                LET l_isb.isb04 = l1_omb.omb04                   #料號
                LET l_isb.isb05 = l1_omb.omb06                   #品名
                LET l_isb.isb06 = l1_ima021                      #規格
                LET l_isb.isb07 = l1_omb.omb05                   #單位
                LET l_isb.isb08 = - l1_omb.omb12                 #數量
                LET l_isb.isb09 = - l1_omb.omb18                 #未稅金額 
                LET l_isb.isb09x= - (l1_omb.omb18t-l1_omb.omb18) #稅額
                LET l_isb.isb09t= - l1_omb.omb18t                #含稅金額
                LET l_isb.isb10 = l1_ima131                      #商品類別 
                LET l_isb.isblegal= g_legal   #FUN-980011 add
                INSERT INTO isb_file VALUES(l_isb.*) 
               #IF STATUS != 0 AND STATUS != -239 THEN      #TQC-790089 mark
                IF STATUS != 0 AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) )  THEN  #TQC-790089 mod
#                  CALL cl_err('ins isb',STATUS,1)   #No.FUN-660146
                  #CALL cl_err3("ins","isb_file",l_isb.isb01,l_isb.isb02,STATUS,"","ins isb",1)          #TQC-790089 mark #No.FUN-660146
                   CALL cl_err3("ins","isb_file",l_isb.isb01,l_isb.isb02,SQLCA.SQLCODE,"","ins isb",1)   #TQC-790089 mod  #No.FUN-660146
                   LET g_success='N'
                   EXIT FOR
                END IF
               #IF STATUS = -239 AND tm.a = 'Y' THEN                    #TQC-790089 mark
                IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN  #TQC-790089 mod
                   UPDATE isb_file SET * = l_isb.*
                    WHERE isb01 = l_isb.isb01 AND isb02 = l_isb.isb02 
                      AND isb03 = l_isb.isb03 AND isb11 = l_isb.isb11 #FUN-C60036 add isb11 
                   IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#                     CALL cl_err('upd isb',STATUS,1)   #No.FUN-660146
                      CALL cl_err3("upd","isb_file",l_isb.isb01,l_isb.isb02,STATUS,"","upd isb",1)   #No.FUN-660146
                      LET g_success='N'
                      EXIT FOR
                   END IF
                END IF
#No.FUN-D50034 ---Add--- Start
                INITIALIZE l_ish.* TO NULL
                LET l_ish.ish01 = l_isg.isg01
                LET l_ish.ish02 = l_isb.isb03
                LET l_ish.ish03 = l_isb.isb04
                LET l_ish.ish04 = l_isb.isb05
                LET l_ish.ish05 = l_isb.isb07
                LET l_ish.ish06 = l_isb.isb06
                LET l_ish.ish07 = l_isb.isb08
                LET l_ish.ish08 = l_isb.isb09
                LET l_ish.ish09 = l_isa.isa061
                LET l_ish.ish10 = l_isb.isb10
                LET l_ish.ish11 = 0
                LET l_ish.ish12 = l_isb.isb09x
                LET l_ish.ish13 = 0
                LET l_ish.ish14 = 0
                LET l_ish.ish15 = l_omb.omb15
                IF l_oma.oma213 = 'Y' THEN
                   LET l_ish.ish16 = '1'
                ELSE
                   LET l_ish.ish16 = '0'
                END IF
                INSERT INTO p100_tmpb VALUES(l_ish.*)
                IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
                   CALL cl_err3("ins","ish_file",l_ish.ish01,l_ish.ish02,SQLCA.SQLCODE,"","ins ish",1)
                   LET g_success='N' EXIT FOR 
                END IF
               #No.FUN-D50034 ---Add--- End

                LET l1_isb03 = l1_isb03 + 1
             END FOREACH
             LET l1_isb03 = l1_isb03 - 1
             #更新商品明細行數
             IF l1_isb03 != l_isa.isa09 THEN
                UPDATE isa_file SET isa09 = l1_isb03
                              WHERE isa01 = l_isa.isa01 
                                AND isa04 = l_isa.isa04
                IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                  CALL cl_err('upd isa',STATUS,1)   #No.FUN-660146
                   CALL cl_err3("upd","isa_file",l_isa.isa01,l_isa.isa04,STATUS,"","upd isa",1)   #No.FUN-660146
                   LET g_success='N'
                   EXIT FOR
                END IF 
             END IF
             #No.TQC-5B0175 --end--
          END IF
          LET l_oma01 = l_oma.oma01
          INITIALIZE l_isb.* TO NULL
          LET l_isb.isb01 = ' '
          LET l_isb.isb02 = l_omb.omb01
          LET l_isb.isb11 = l_isa.isa02 #FUN-C60036 add
          LET l_isb.isb03 = l_omb.omb03                  #項次
          LET l_isb.isb04 = l_omb.omb04                  #料號
          LET l_isb.isb05 = l_omb.omb06                  #品名
          LET l_isb.isb06 = l_ima021                     #規格
          LET l_isb.isb07 = l_omb.omb05                  #單位
          LET l_isb.isb08 = l_omb.omb12                  #數量
          LET l_isb.isb09 = l_omb.omb18                  #未稅金額
          LET l_isb.isb09x= l_omb.omb18t-l_omb.omb18     #稅額
          LET l_isb.isb09t= l_omb.omb18t                 #含稅金額
          LET l_isb.isb10 = l_ima131                     #商品類別
          IF l_oma.oma00 MATCHES '2*' THEN
             LET l_isb.isb08 = l_isb.isb08 * -1
             LET l_isb.isb09 = l_isb.isb09 * -1
             LET l_isb.isb09x= l_isb.isb09x* -1
             LET l_isb.isb09t= l_isb.isb09t* -1
          END IF
          LET l_isb.isblegal= g_legal   #FUN-980011 add
          INSERT INTO isb_file VALUES(l_isb.*)
         #IF STATUS != 0 AND STATUS != -239 THEN                         #TQC-790089 mark
          IF STATUS != 0 AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN  #TQC-790089 mod
#            CALL cl_err('ins isb',STATUS,1)   #No.FUN-660146
            #CALL cl_err3("ins","isb_file",l_isb.isb01,l_isb.isb02,STATUS,"","ins isb",1)          #TQC-790089 mark #No.FUN-660146
             CALL cl_err3("ins","isb_file",l_isb.isb01,l_isb.isb02,SQLCA.SQLCODE,"","ins isb",1)   #TQC-790089 mod  #No.FUN-660146
             LET g_success='N' EXIT FOR 
          END IF
         #IF STATUS = -239 AND tm.a = 'Y' THEN                    #TQC-790089 mark
          IF cl_sql_dup_value(SQLCA.SQLCODE) AND tm.a = 'Y' THEN  #TQC-790089 mod
             UPDATE isb_file SET * = l_isb.* 
              WHERE isb01 = l_isb.isb01 AND isb02 = l_isb.isb02 
                AND isb03 = l_isb.isb03 AND isb11 = l_isb.isb11 #FUN-C60036 add isb11
             IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#               CALL cl_err('upd isb',STATUS,1)  #No.FUN-660146
                CALL cl_err3("upd","isb_file",l_isb.isb01,l_isb.isb02,STATUS,"","upd isb",1)   #No.FUN-660146
                LET g_success='N' EXIT FOR 
             END IF
          END IF
#No.FUN-D50034 ---Add--- Start
          INITIALIZE l_ish.* TO NULL
          LET l_ish.ish01 = l_isg.isg01
          LET l_ish.ish02 = l_isb.isb03
          LET l_ish.ish03 = l_isb.isb04
          LET l_ish.ish04 = l_isb.isb05
          LET l_ish.ish05 = l_isb.isb07
          LET l_ish.ish06 = l_isb.isb06
          LET l_ish.ish07 = l_isb.isb08
          LET l_ish.ish08 = l_isb.isb09
          LET l_ish.ish09 = l_isa.isa061
          LET l_ish.ish10 = l_isb.isb10
          LET l_ish.ish11 = 0
          LET l_ish.ish12 = l_isb.isb09x
          LET l_ish.ish13 = 0
          LET l_ish.ish14 = 0
          LET l_ish.ish15 = l_omb.omb15
          IF l_oma.oma213 = 'Y' THEN
             LET l_ish.ish16 = '1'
          ELSE
             LET l_ish.ish16 = '0'
          END IF
          INSERT INTO p100_tmpb VALUES(l_ish.*)
          IF STATUS != 0 OR SQLCA.sqlerrd[3] < 1 THEN
             CALL cl_err3("ins","ish_file",l_ish.ish01,l_ish.ish02,SQLCA.SQLCODE,"","ins ish",1)
             LET g_success='N' EXIT FOR 
          END IF
         #No.FUN-D50034 ---Add--- End

       END FOREACH
#No.FUN-D50034 ---Add--- Start
   IF g_success = 'Y' THEN
     #是否有負數金額
      FOREACH p100_tmpb_dec INTO l_ish.*
         IF l_ish.ish03 = 'MISC' THEN
            SELECT MAX(ish08) INTO l_ish08 FROM p100_tmpb
             WHERE ish01 = l_ish.ish01
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p100_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish08 IN (SELECT MAX(ish08) FROM p100_tmpb WHERE ish01 = l_ish.ish01)
               DELETE FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p100_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                  UPDATE p100_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish08 IN (SELECT MAX(ish08) FROM p100_tmpb WHERE ish01 = l_ish.ish01)
                  DELETE FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         ELSE
            SELECT MAX(ish08) INTO l_ish08 FROM p100_tmpb
             WHERE ish01 = l_ish.ish01
               AND ish03 = l_ish.ish03
            IF cl_null(l_ish08) THEN LET l_ish08 = 0 END IF
            IF (l_ish08 + l_ish.ish08) > 0 THEN
               UPDATE p100_tmpb SET ish11 = (l_ish.ish08 + l_ish.ish12) * -1
                WHERE ish01 = l_ish.ish01
                  AND ish03 = l_ish.ish03
                  AND ish08 IN (SELECT MAX(ish08) FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
               DELETE FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03 AND ish08 > 0
               IF l_cnt > 0 THEN
                  LET t_ish08 = (l_ish.ish08 + l_ish.ish12) / l_cnt
                  LET t_ish08 =  cl_digcut(t_ish08,g_azi04)
                  LET t_ish08_1 = t_ish08 * l_cnt - (l_ish.ish08 + l_ish.ish12)
                  IF t_ish08_1 = 0 THEN LET t_ish08_1 = t_ish08 END IF
                  LET t_ish08 = t_ish08 * -1
                  LET t_ish08_1 = t_ish08_1 * -1
                  UPDATE p100_tmpb SET ish11 = t_ish08
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                  UPDATE p100_tmpb SET ish11 = t_ish08_1
                   WHERE ish01 = l_ish.ish01
                     AND ish03 = l_ish.ish03
                     AND ish08 IN (SELECT MAX(ish08) FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish03 = l_ish.ish03)
                  DELETE FROM p100_tmpb WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
               END IF
            END IF
         END IF
      END FOREACH
      LET l_ish01 = ' '
      FOREACH p100_tmpb_dec1 INTO l_ish.*
         IF l_ish01 != l_ish.ish01 THEN
            LET l_i = 1
         END IF
         LET l_ish.ish02 = l_i
         IF tm.a = 'Y' THEN
            DELETE FROM ish_file WHERE ish01 = l_ish.ish01 AND ish02 = l_ish.ish02
         END IF
         INSERT INTO ish_file VALUES(l_ish.*)
         UPDATE isg_file SET isg02 = l_ish.ish02
          WHERE isg01 = l_ish.ish01
         LET l_i = l_i + 1
         LET l_ish01 = l_ish.ish01
      END FOREACH
   END IF
  #No.FUN-D50034 ---Add--- End
   END FOR
   IF g_success = 'Y' THEN COMMIT WORK ELSE  ROLLBACK WORK END IF
END FUNCTION

#No.FUN-D50034 ---Add--- Start

#No.FUN-D50034 ---Add--- Start
FUNCTION p100_ctreatetab()

   DROP TABLE p100_tmpb
   SELECT * FROM ish_file WHERE 1 = 0 INTO TEMP p100_tmpb;

END FUNCTION
#No.FUN-D50034 ---Add--- End

