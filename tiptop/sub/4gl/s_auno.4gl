# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: s_auto.4gl
# Descriptions...: 自動編碼
# Date & Author..: 03/09/29 By Danny
# Usage..........: CALL s_auto(p_no,p_type)
# Input Parameter: p_no    編碼原則   #No.MOD-840294
#                  p_type  1.料號 2.客戶 3.供應商 4.固定資產 5.生產批號 6.序號
# Return code....: p_no    編號
# Memo...........: 檢查g_errno看是否成功, 及錯誤原因
# Modify.........: No.MOD-510010 05/01/05 By Carrier 
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.MOD-7A0199 07/10/31 By Pengu l_desc變數長度不夠長造成組出來的品名異常
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7C0084 08/01/23 By Mandy 走申請流程時,取MAX(申請編號,正式編號)
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.MOD-830187 08/03/25 By Pengu 若所有區段均是"獨立段"時則組出的編號最前面一碼會被截掉
# Modify.........: No.MOD-840294 08/04/20 By Nicola 編碼方式修改
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-860255 08/06/23 By claire 第二段後是"獨立段"時則組出的編號最前面一碼會被截掉
# Modify.........: No.FUN-9B0050 09/11/06 By wujie  5.2SQL转标准语法
# Modify.........: No:MOD-A60113 10/07/16 By Pengu 取最大號會異常
# Modify.........: No:FUN-B30202 11/04/07 By huangtao p_type新增“8.會員編號(流通)” 
# Modify.........: No:MOD-B40147 11/04/18 By huangtao p_type新增“8.會員編號(流通)”
# Modify.........: No:MOD-B30637 11/07/17 By Pengu 當未設獨立段時，無法產生資料
# Modify.........: No:FUN-B90056 11/09/08 By shiwuying p_type新增 9.场地编号(流通),A.摊位编号(流通),B.商户编号(流通)
#                                                      p_type对应的编码类型，编码性质如果只有一笔资料，不开窗选择
# Modify.........: No:FUN-B80141 11/12/12 By baogc 流水號查詢添加跨庫
# Modify.........: No:FUN-D10021 13/01/08 By dongsz p_type新增 C.倉庫編號(流通)
# Modify.........: No:FUN-CA0082 13/01/09 By zhangweib 新增FUNCTION s_auno1 afai100調用,當固定值小於2時,開創將資料一次性帶出
# Modify.........: No.DEV-D30026 13/03/18 By Nina GP5.3 追版:DEV-CA0006、DEV-CB0002以上為GP5.25 的單號
# Modify.........: No.DEV-D40015 13/04/15 By Nina 修正apmt540產生條碼時未完整代出條碼組成相關資料的問題
# Modify.........: No.MOD-D60089 13/06/11 By Lori s_auno1多宣告g_geh為local變數緣故,造成財產編號無法自動編碼,故mark

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE  g_geh         RECORD LIKE geh_file.*
DEFINE  g_type        LIKE type_file.chr1   	#FUN-7C0084 add
DEFINE  g_iba03       LIKE iba_file.iba03       #DEV-D40015 add
 
FUNCTION s_auno(p_no,p_type,p_itemno)
   DEFINE p_no,l_no     LIKE geg_file.geg03 	#No.FUN-680147 VARCHAR(20)
   DEFINE p_type        LIKE type_file.chr1   	#No.FUN-680147 VARCHAR(1)
   DEFINE p_itemno      LIKE ima_file.ima01  #No.FUN-850100
   DEFINE l_cnt,l_i,l_j LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_geh01       LIKE geh_file.geh01
   DEFINE l_gei01       LIKE gei_file.gei01
   DEFINE l_gei         RECORD LIKE gei_file.*
   DEFINE l_gel         RECORD LIKE gel_file.*
   DEFINE l_geg05       LIKE geg_file.geg05
   DEFINE l_gef04       LIKE gef_file.gef04
   DEFINE l_geg05_old   LIKE geg_file.geg05
   DEFINE l_gel04_old   LIKE gel_file.gel04
   DEFINE l_desc        LIKE ima_file.ima02       #No.MOD-7A0199 modify 	#No.FUN-680147 VARCHAR(40)
   DEFINE l_flag        LIKE type_file.chr1                 	#No.FUN-680147 VARCHAR(1)
   DEFINE l_gff03       LIKE gff_file.gff03  #No.FUN-810036
   DEFINE l_date        LIKE type_file.chr10  #No.FUN-810036
   DEFINE l_no1         LIKE type_file.chr2   #No.MOD-840294
   DEFINE l_length      LIKE type_file.num5   #No.MOD-840294
   DEFINE l_ima         LIKE type_file.chr1000  #No.FUN-850100
   DEFINE l_itemno      LIKE ima_file.ima01  #No.FUN-850100
   DEFINE l_sql         STRING    #No.FUN-850100
#DEV-D30026---add--begin-----------
   DEFINE l_ima930      LIKE ima_file.ima930
   DEFINE  l_iba   DYNAMIC ARRAY OF RECORD
                iba03    LIKE iba_file.iba03   #接收段次的值動態數組
                END RECORD
   DEFINE l_iba_t  RECORD
       iba03_1  LIKE iba_file.iba03,
       iba03_2  LIKE iba_file.iba03,
       iba03_3  LIKE iba_file.iba03,
       iba03_4  LIKE iba_file.iba03,
       iba03_5  LIKE iba_file.iba03,
       iba03_6  LIKE iba_file.iba03,
       iba03_7  LIKE iba_file.iba03,
       iba03_8  LIKE iba_file.iba03,
       iba03_9  LIKE iba_file.iba03,
       iba03_10 LIKE iba_file.iba03
                END RECORD
#DEV-D30026---add--end-------------
   DEFINE l_no2         LIKE type_file.chr1000 #No:DEV-D30026--add
   DEFINE l_buf         STRING                 #No:DEV-D30026--add
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET g_errno=' '
   SELECT ima930 INTO l_ima930 FROM ima_file WHERE ima01 = p_itemno #DEV-D30026--add
 
   WHILE TRUE
      LET l_no = ''
      LET l_desc = ''
      SELECT COUNT(*) INTO l_cnt FROM geh_file WHERE geh04 = p_type
      #若有相同類別的性質, 則需挑選
 #     IF p_type MATCHES '[1234]' THEN  #No.MOD-840294    #FUN-B30202 mark
      #IF p_type MATCHES '[12348]' THEN                   #FUN-B30202 add
       IF p_type MATCHES '[123489ABC]' THEN                #FUN-B90056 Add 9AB    #FUN-D10021 add C
         IF l_cnt > 0 THEN
           #FUN-B90056 Begin---
            IF l_cnt = 1 AND p_type MATCHES '[9ABC]' THEN                         #FUN-D10021 add C
               SELECT geh01 INTO l_geh01 FROM geh_file WHERE geh04 = p_type
            ELSE
           #FUN-B90056 End-----
               CALL cl_init_qry_var()                                        
               LET g_qryparam.form     = "q_geh"                            
               LET g_qryparam.default1 = l_geh01
               LET g_qryparam.construct= "N"
               LET g_qryparam.arg1     = p_type
               LET g_qryparam.where    = " geh04 = '",g_qryparam.arg1,"'"
               CALL cl_create_qry() RETURNING l_geh01
            END IF  #FUN-B90056 Add
            IF cl_null(l_geh01) THEN RETURN l_no,l_desc EXIT WHILE END IF
         END IF
         LET g_type = p_type #FUN-7C0084 add
        #挑選編碼類別
        #FUN-B90056 Begin---
         SELECT COUNT(*) INTO l_cnt FROM gei_file
          WHERE gei03 = l_geh01
         IF l_cnt =1 AND p_type MATCHES '[9ABC]' THEN         #FUN-D10021 add C
            SELECT gei01 INTO l_gei01 FROM gei_file
             WHERE gei03 = l_geh01
         ELSE
        #FUN-B90056 End-----
            CALL cl_init_qry_var()                                        
            LET g_qryparam.form     = "q_gei"                            
            LET g_qryparam.default1 = l_gei01
            LET g_qryparam.construct= "N"
            LET g_qryparam.arg1     = l_geh01
            LET g_qryparam.where    = " gei03 = '",g_qryparam.arg1,"'"
            CALL cl_create_qry() RETURNING l_gei01
         END IF  #FUN-B90056 Add
         IF cl_null(l_gei01) THEN RETURN l_no,l_desc EXIT WHILE END IF
      ELSE
         LET l_gei01 = p_no
      END IF  #No.MOD-840294
      #分段挑選
      SELECT * INTO l_gei.* FROM gei_file WHERE gei01 = l_gei01
      SELECT * INTO g_geh.* FROM geh_file WHERE geh01 = l_gei.gei03
      LET l_geg05 = ' '
      LET l_geg05_old = ' '
      LET l_desc = ' '
      LET l_flag = 'N'
      LET l_gel04_old = ' '
 
      SELECT COUNT(*) INTO l_cnt FROM gel_file
       WHERE gel01 = l_gei01 
         AND (gel04 IS NULL OR gel04 = ' ' OR gel04 = '2') 
 
      FOR l_i = 1 TO l_gei.gei04
          SELECT * INTO l_gel.* FROM gel_file
           WHERE gel01 = l_gei.gei01 AND gel02 = l_i
 
          #如果連續幾段皆為固定值,獨立段,流水號
          IF NOT cl_null(l_gel.gel04) THEN 
             IF l_flag = 'N' AND l_cnt > 0 THEN      #最前段
                SELECT MAX(gef04) INTO l_geg05 FROM gef_file
                 WHERE gef01 = l_gei.gei01 
                  #AND gef02 = (SELECT MIN(gef02) FROM gef_file    #No:MOD-B30637 mark
                  #              WHERE gef01 = l_gei.gei01)        #No:MOD-B30637 mark
             END IF 
          ELSE
             LET l_flag = 'Y'
          END IF
 
          #若整段只有固定及流水時處理
          IF l_cnt = 0 THEN
             CASE
               WHEN l_gel.gel04 = '1'    #固定值
                    LET l_geg05 = l_geg05 CLIPPED,l_gel.gel05
                    LET l_iba[l_i].iba03 = l_gel.gel05 #No:DEV-D30026--add
               WHEN l_gel.gel04 = '3'    #流水號
                    FOR l_j=1 TO l_gel.gel03
                        LET l_geg05 = l_geg05 CLIPPED,"*"
                        LET l_iba[l_i].iba03 = l_iba[l_i].iba03,"*" #No:DEV-D30026--add
                    END FOR 
                    #No:DEV-D30026--add--begin
                    IF l_ima930 = 'Y' THEN
                       #為了產生流水號，因此仿照產生單據編號
                       CALL q_gef_p1(l_iba[l_i].iba03,l_gel.gel03,l_iba[l_i].iba03)
                          RETURNING l_iba[l_i].iba03 
                       LET l_iba[l_i].iba03 = g_iba03      #DEV-D40015 add
                    END IF
                    #No:DEV-D30026--add--end
             END CASE
          END IF

         #FUN-D10021--add--str---
          IF p_type = 'C' AND l_gel.gel04 = '4' THEN
             LET l_itemno = p_itemno[1,l_gel.gel03]
             LET l_geg05 = l_geg05 CLIPPED,l_itemno
          END IF
         #FUN-D10021--add--end--- 
         #IF p_type MATCHES '[56]' THEN  #No.MOD-840294 #No:DEV-D30026--mark
          IF p_type MATCHES '[56FGH]' THEN              #No:DEV-D30026--add
             CASE
                #-----No.FUN-850100-----
                WHEN l_gel.gel04 = '4'    #欄位值
                   LET l_sql ="SELECT ",l_gel.gel05, 
                              "  FROM ima_file", 
                              " WHERE ima01 ='",p_itemno,"'"
                   PREPARE ima_pre FROM l_sql
                   IF STATUS THEN CALL cl_err('ima_pre',STATUS,0) END IF
 
                   DECLARE ima_curs CURSOR FOR ima_pre
 
                   OPEN ima_curs
                   IF SQLCA.sqlcode = "-263" THEN
                      CALL cl_err('ima_curs:',SQLCA.sqlcode,1)
                      LET g_success = 'N' #No:DEV-D30026--add
                   END IF
 
                   FETCH ima_curs INTO l_ima
                   IF SQLCA.sqlcode = "-263" THEN
                      CALL cl_err('fetch ima_curs:',SQLCA.sqlcode,1)
                      LET g_success = 'N' #No:DEV-D30026--add
                   END IF
 
                   LET l_itemno = l_ima[1,l_gel.gel03]
                   LET l_geg05 = l_geg05 CLIPPED,l_itemno
                #-----No.FUN-850100 END----- 
                   LET l_iba[l_i].iba03 = l_itemno #No:DEV-D30026--add
                WHEN l_gel.gel04 = '5'    #年
                     SELECT gff03 INTO l_gff03 FROM gff_file
                      WHERE gff01 = YEAR(g_today)
                        AND gff02 = l_gel.gel03
                     LET l_geg05 = l_geg05 CLIPPED,l_gff03
                     LET l_iba[l_i].iba03 = l_gff03 #No:DEV-D30026--add   
                WHEN l_gel.gel04 = '6'    #季
                     CALL s_season(YEAR(g_today),MONTH(g_today)) RETURNING l_date
                     LET l_date = "00" CLIPPED,l_date
                     LET l_length = LENGTH(l_date)
                     LET l_no1 = l_date[l_length-1,l_length]
                     LET l_geg05 = l_geg05 CLIPPED,l_no1
                     LET l_iba[l_i].iba03 = l_no1 #No:DEV-D30026--add
                WHEN l_gel.gel04 = '7'    #月
                     LET l_date = MONTH(g_today)
                     LET l_date = "00" CLIPPED,l_date
                     LET l_length = LENGTH(l_date)
                     LET l_no1 = l_date[l_length-1,l_length]
                     LET l_geg05 = l_geg05 CLIPPED,l_no1
                     LET l_iba[l_i].iba03 = l_no1 #No:DEV-D30026--add
                WHEN l_gel.gel04 = '8'    #週
                     LET l_date = WEEKDAY(g_today)
                     LET l_date = "00" CLIPPED,l_date
                     LET l_length = LENGTH(l_date)
                     LET l_no1 = l_date[l_length-1,l_length]
                     LET l_geg05 = l_geg05 CLIPPED,l_no1
                     LET l_iba[l_i].iba03 = l_no1 #No:DEV-D30026--add
                WHEN l_gel.gel04 = '9'    #日
                     LET l_date = DAY(g_today)
                     LET l_date = "00" CLIPPED,l_date
                     LET l_length = LENGTH(l_date)
                     LET l_no1 = l_date[l_length-1,l_length]
                     LET l_geg05 = l_geg05 CLIPPED,l_no1
                     LET l_iba[l_i].iba03 = l_no1 #No:DEV-D30026--add
                #No:DEV-D30026--add--begin
                WHEN l_gel.gel04 = 'A'    #包裝結構號
                     LET l_buf = ''
                     FOR l_j = 1 TO l_gel.gel03
                         LET l_buf = l_buf CLIPPED,"0"
                     END FOR
                     LET l_no2 = ''
                     LET l_sql = "SELECT trim(",cl_tp_tochar(g_barcode_packing,l_buf),") FROM dual"
                     PREPARE s_auno_gel04_pre1 FROM l_sql
                     EXECUTE s_auno_gel04_pre1 INTO l_no2
                     LET l_geg05 = l_geg05 CLIPPED, l_no2
                     LET l_iba[l_i].iba03 = l_no2
                WHEN l_gel.gel04 = 'B'    #單據單號
                     LET l_no2 = g_barcode_no[1,l_gel.gel03]
                     LET l_geg05 = l_geg05 CLIPPED, l_no2
                     LET l_iba[l_i].iba03 = l_no2
                WHEN l_gel.gel04 = 'C'    #單據項次
                     LET l_buf = ''
                     FOR l_j = 1 TO l_gel.gel03
                         LET l_buf = l_buf CLIPPED,"0"
                     END FOR
                     LET l_no2 = ''
                     LET l_sql = "SELECT trim(",cl_tp_tochar(g_barcode_ln,l_buf),") FROM dual"
                     PREPARE s_auno_gel04_pre2 FROM l_sql
                     EXECUTE s_auno_gel04_pre2 INTO l_no2
                     LET l_geg05 = l_geg05 CLIPPED, l_no2
                     LET l_iba[l_i].iba03 = l_no2
                #No:DEV-D30026--add--end 
             END CASE
          END IF  #No.MOD-840294
 
          #如果最後的幾段為固定值，流水號應當要處理
          IF l_gel.gel04 MATCHES '[13]'  THEN 
             IF l_gel.gel07 = 'Y' THEN
                LET l_desc = l_desc CLIPPED,l_gel.gel06 CLIPPED
             END IF
          END IF
 
          IF cl_null(l_gef04) THEN
             CALL s_geg05(l_gef04,l_gei01,l_i,l_gei.gei04,'2')
                  RETURNING l_gef04
          END IF
         
          IF cl_null(l_gel.gel04) OR l_gel.gel04 = '2' THEN 
 #            IF p_type MATCHES '[1234]' THEN  #No.MOD-840294      #MOD-B40147 mark
             #IF p_type MATCHES '[12348]' THEN                     #MOD-B40147 add
              IF p_type MATCHES '[123489ABC]' THEN                  #FUN-B90056 Add 9AB    #FUN-D10021 add C
                CALL q_gef(FALSE,FALSE,l_no,l_gei01,l_i,l_geg05,
                           l_gef04,l_geg05_old,l_desc)
                     RETURNING l_geg05,l_no,l_desc,l_gef04
             END IF    #No.MOD-840294
          END IF
 
          IF INT_FLAG THEN
             LET INT_FLAG = 0 LET l_no = '' LET l_desc = ''
             RETURN l_no,l_desc 
             EXIT WHILE 
          END IF
 
          #若前段為獨立段, 則需用獨立段之前一段的geg05
         #-----------No.MOD-830187 modify
         #IF cl_null(l_gel.gel04) OR l_gel.gel04 != '2' THEN
         # IF cl_null(l_gel.gel04) OR l_gel.gel04 = '2' THEN  #MOD-860255 mark
         #-----------No.MOD-830187 end
 #            IF p_type MATCHES '[1234]' THEN  #No.MOD-840294      #MOD-B40147 mark
             #IF p_type MATCHES '[12348]' THEN                     #MOD-B40147 add
              IF p_type MATCHES '[123489ABC]' THEN                  #FUN-B90056 Add 9AB    #FUN-D10021 add C
                LET l_geg05_old = l_geg05
             END IF    #No.MOD-840294
         #END IF   #MOD-860255 mark
 
          #如果最後一段是流水號和固定值的話，應該要處理,因為
          IF l_i = l_gei.gei04 THEN   
             CALL q_gef_p1(l_geg05,l_gel.gel03,l_no) RETURNING l_no
             IF cl_null(l_no) THEN LET l_desc = '' END IF
            #DEV-D40015 add str-------
             IF l_gel.gel04 = '3' THEN   #流水號
                LET l_iba[l_i].iba03 = g_iba03      
             END IF
            #DEV-D40015 add end-------
          END IF
          LET l_gel04_old = l_gel.gel04
      END FOR
      #DEV-D30026--add--begin------------
      IF l_ima930 = 'Y' THEN
         LET l_iba_t.iba03_1 = l_iba[1].iba03
         LET l_iba_t.iba03_2 = l_iba[2].iba03
         LET l_iba_t.iba03_3 = l_iba[3].iba03
         LET l_iba_t.iba03_4 = l_iba[4].iba03
         LET l_iba_t.iba03_5 = l_iba[5].iba03
         LET l_iba_t.iba03_6 = l_iba[6].iba03
         LET l_iba_t.iba03_7 = l_iba[7].iba03
         LET l_iba_t.iba03_8 = l_iba[8].iba03
         LET l_iba_t.iba03_9 = l_iba[9].iba03
         LET l_iba_t.iba03_10 = l_iba[10].iba03
      END IF
      #DEV-D30026--add--end--------------
      EXIT WHILE
   END WHILE
   #DEV-D30026--add--begin------------
   IF l_ima930 = 'Y' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM iba_file
       WHERE iba01 = l_no
      IF NOT(l_cnt > 0 AND p_type MATCHES '[5FGH]') THEN

         INSERT INTO iba_file VALUES(l_no,l_iba_t.*)   #新增條碼資料主檔
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           IF g_bgerr THEN
              CALL s_errmsg('iba01',l_no,'ins iba_file',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
           END IF
           LET g_success = 'N'
         END IF

      END IF
   END IF
   #DEV-D30026--add--end-------------- 
   RETURN l_no,l_desc
END FUNCTION
 
#處理編碼結果(最後一段時處理)
FUNCTION q_gef_p1(p_geg05,p_geg03,p_no)
   DEFINE l_no,p_no     LIKE geg_file.geg03
   DEFINE l_i,l_j,l_k   LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE p_geg05       LIKE geg_file.geg05
   DEFINE l_sql         STRING     
   DEFINE l_max_no      LIKE geg_file.geg03
   DEFINE l_max_no1     LIKE geg_file.geg03     #FUN-7C0084 add
   DEFINE l_max_no2     LIKE geg_file.geg03     #FUN-7C0084 add
   DEFINE l_apply       LIKE type_file.chr1   	#FUN-7C0084 add
   DEFINE p_geg03,l_m1  LIKE type_file.num5    	#No.FUN-680147 SMALLINT
   DEFINE l_first_po    LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_flag,l_len  LIKE type_file.num5   	#No.FUN-680147 SMALLINT
   DEFINE l_f,l_m,l_l   LIKE geg_file.geg05
   DEFINE l_format      LIKE geg_file.geg05
   DEFINE l_in1         LIKE geg_file.geg03     #只是為了方便oracle實現而做的
   DEFINE l_in3         LIKE geg_file.geg03
   DEFINE l_nn1,l_nn2   STRING                  #No.MOD-510010
   DEFINE l_in_sql      STRING
 
   LET l_no = p_no
 
   LET g_iba03 = 0     #DEV-D40015 add
   LET l_flag = 0
   LET l_first_po = 1
   LET l_k = 0
   LET l_j = 1  #add 031027
   FOR l_i = 1 TO 30       #將所有的流水號*-->?
      IF p_geg05[l_i,l_i] = '*' THEN   #流水號
         LET l_no[l_i,l_i] = '?'
         IF l_flag = 0 THEN
            LET l_first_po = l_i
            LET l_flag = 1
         END IF
         LET l_k = l_k + 1
      ELSE
         IF p_geg05[l_i,l_i] NOT MATCHES '[*%]' THEN
            LET l_no[l_i,l_i]=p_geg05[l_i,l_i]  #若在中間，將其余內容補上
         END IF
         IF l_flag = 0 THEN    #add 031028 
            LET l_in1 = l_in1 CLIPPED,l_no[l_i,l_i]
         ELSE
            LET l_in3 = l_in3 CLIPPED,l_no[l_i,l_i]
         END IF
      END IF
   END FOR
 
   LET l_in_sql= " 1=1"                  #No.MOD-510010
 
   IF l_k > 0 THEN
      LET l_i = LENGTH(l_in1)
      IF l_i > 0 THEN
         LET l_in_sql = l_in_sql CLIPPED,
                        " AND ",g_geh.geh05 CLIPPED,
                        "[1,",l_i,"] = '",l_in1 CLIPPED,"'"                  #No.MOD-510010
      END IF
 
      #No.MOD-510010  --begin
      FOR l_j = 1 TO l_k 
         LET l_nn1=l_nn1 CLIPPED,'0'
         LET l_nn2=l_nn2 CLIPPED,'9'
#         IF l_j = 1 THEN
#            LET l_in_sql = l_in_sql CLIPPED,
#            " "," substring(",g_geh.geh05 CLIPPED,",",l_i+l_j,",",l_i+l_j,") IN (",'0',',','1',',','2',',','3',',','4',',','5',',','6',',','7',',','8',',','9',")"
#         ELSE
#            LET l_in_sql = l_in_sql CLIPPED,
#            " AND "," substring(",g_geh.geh05 CLIPPED,",",l_i+l_j,",",l_i+l_j,") IN (",'0',',','1',',','2',',','3',',','4',',','5',',','6',',','7',',','8',',','9',")"
#         END IF
      END FOR
 
      IF l_k > 0 THEN
        #-----------------No:MOD-A60113 modify
        #LET l_in_sql=l_in_sql CLIPPED," AND ",
#       #    " substring(",g_geh.geh05 CLIPPED,",",l_first_po,",",l_first_po+l_k-1,")",
        #    " ",g_geh.geh05 CLIPPED,"[",l_first_po,",",l_first_po+l_k-1,"]",    #No.FUN-9B0050
        #    " BETWEEN '",l_nn1,"' AND '",l_nn2,"'"
         LET l_in_sql=l_in_sql CLIPPED," AND (",
             g_geh.geh05 CLIPPED,"[",l_first_po,",",l_first_po+l_k-1,"] >= '",l_nn1,"' OR ",
             g_geh.geh05 CLIPPED,"[",l_first_po,",",l_first_po+l_k-1,"] <= '",l_nn2,"' ) "
        #-----------------No:MOD-A60113 end
      END IF
 
      #No.MOD-510010  --end    
      LET l_j = LENGTH(l_in3)
      IF l_j > 0 THEN
         LET l_in_sql = l_in_sql CLIPPED,
#            " AND "," substring(",g_geh.geh05 CLIPPED,",",l_i+l_k+1,",",l_i+l_k+l_j,") ='",
             " AND "," ",g_geh.geh05 CLIPPED,"[",l_i+l_k+1,",",l_i+l_k+l_j,"] ='",    #No.FUN-9B0050
             l_in3 CLIPPED,"'"
      END IF
 
      LET l_sql ="SELECT MAX(",g_geh.geh05 CLIPPED,") ",
                #"  FROM ",g_geh.geh03 CLIPPED,                       #FUN-B80141 Mark
                 "  FROM ",cl_get_target_table(g_plant,g_geh.geh03),  #FUN-B80141 Add
                 " WHERE ",l_in_sql CLIPPED
      PREPARE max_pre FROM l_sql
      IF STATUS THEN CALL cl_err('max_pre',STATUS,0) END IF
      DECLARE max_curs CURSOR FOR max_pre
       OPEN max_curs                              # MOD-510143
      IF SQLCA.sqlcode = "-263" THEN
         CALL cl_err('max_curs:',SQLCA.sqlcode,1)
         LET g_success = 'N' #No:DEV-D30026--add
      END IF
      FETCH max_curs INTO l_max_no
      IF SQLCA.sqlcode = "-263" THEN
         CALL cl_err('fetch max_curs:',SQLCA.sqlcode,1)
         LET g_success = 'N' #No:DEV-D30026--add
      END IF
      #FUN-7C0084---add----str---
      LET l_max_no1 = l_max_no
      #走申請流程時,取MAX(申請編號,正式編號)
      #g_type  1.料號 2.客戶 3.供應商 4.固定資產
      LET l_apply = 'N'
      IF g_aza.aza60 = 'Y' AND g_type = '1' THEN 
          CALL cl_replace_str(l_sql, "ima", "####") RETURNING l_sql
          CALL cl_replace_str(l_sql, "####", "imaa") RETURNING l_sql
          LET l_apply = 'Y'
      END IF
      IF g_aza.aza61 = 'Y' AND g_type = '2' THEN
          CALL cl_replace_str(l_sql, "occ", "####") RETURNING l_sql
          CALL cl_replace_str(l_sql, "####", "occa") RETURNING l_sql
          LET l_apply = 'Y'
      END IF
      IF g_aza.aza62 = 'Y' AND g_type = '3' THEN
          CALL cl_replace_str(l_sql, "pmc", "####") RETURNING l_sql
          CALL cl_replace_str(l_sql, "####", "pmca") RETURNING l_sql
          LET l_apply = 'Y'
      END IF
      IF l_apply = 'Y' THEN
          PREPARE max_pre2 FROM l_sql
          IF STATUS THEN CALL cl_err('max_pre2',STATUS,0) END IF
          DECLARE max_curs2 CURSOR FOR max_pre2
           OPEN max_curs2                              # MOD-510143
          IF SQLCA.sqlcode = "-263" THEN
             CALL cl_err('max_curs2:',SQLCA.sqlcode,1)
             LET g_success = 'N' #No:DEV-D30026--add
          END IF
          FETCH max_curs2 INTO l_max_no2 
          IF SQLCA.sqlcode = "-263" THEN
             CALL cl_err('fetch max_curs2:',SQLCA.sqlcode,1)
             LET g_success = 'N' #No:DEV-D30026--add
          END IF
          IF cl_null(l_max_no1) THEN
              LET l_max_no = l_max_no2
          ELSE
              IF cl_null(l_max_no2) THEN
                  LET l_max_no = l_max_no1
              ELSE
                  IF l_max_no2 > l_max_no1 THEN
                      LET l_max_no = l_max_no2
                  END IF
              END IF
          END IF
      END IF
      #FUN-7C0084---add----end---
 
      LET l_format = ''
      FOR l_i = 1 TO l_k
          LET l_format = l_format CLIPPED,"&"
      END FOR
 
      LET l_len = LENGTH(l_no)
      LET l_f = '' LET l_m = '' LET l_l = ''
 
      IF l_first_po > 1 THEN              #前面部份
         LET l_f = l_no[1,l_first_po-1]
      END IF
      IF cl_null(l_max_no) THEN           #流水號部份
         LET l_m = 1 USING l_format
      ELSE
         LET l_m1 = l_max_no[l_first_po,l_first_po+l_k-1] + 1 
         IF LENGTH(l_m1) > l_k THEN          #如果流水號的長度已經超過設置的長度
            CALL cl_err('','aoo-126',0)
            LET g_success = 'N' #No:DEV-D30026--add
            RETURN '',''
         END IF
         LET l_m = l_max_no[l_first_po,l_first_po+l_k-1] + 1 USING l_format
      END IF
      IF l_first_po + l_k <= l_len THEN   #最後部份
         LET l_l = l_no[l_first_po+l_k,l_len]
      END IF
      LET g_iba03 = l_m                              #DEV-D40015 add
      LET l_no = l_f CLIPPED,l_m CLIPPED,l_l CLIPPED
   END IF
 
   RETURN l_no
END FUNCTION
  #No.FUN-810036

#No.FUN-CA0082   ---start--- Add
FUNCTION s_auno1(p_no,p_type,p_itemno)
   DEFINE p_no,l_no,l_p LIKE geg_file.geg03 	
   DEFINE p_type        LIKE type_file.chr1   	
   DEFINE p_itemno      LIKE ima_file.ima01 
   DEFINE l_cnt,l_i,l_j LIKE type_file.num5 
   DEFINE l_geh01       LIKE geh_file.geh01
   DEFINE l_gei01       LIKE gei_file.gei01
   DEFINE l_gei         RECORD LIKE gei_file.*
   DEFINE l_gel         RECORD LIKE gel_file.*
   DEFINE l_geg05       LIKE geg_file.geg05
   DEFINE l_gef04       LIKE gef_file.gef04
   DEFINE l_geg05_old   LIKE geg_file.geg05
   DEFINE l_gel04_old   LIKE gel_file.gel04
   DEFINE l_desc        LIKE ima_file.ima02  
   DEFINE l_flag        LIKE type_file.chr1  
   DEFINE l_gff03       LIKE gff_file.gff03  
   DEFINE l_date        LIKE type_file.chr10 
   DEFINE l_no1         LIKE type_file.chr2  
   DEFINE l_length      LIKE type_file.num5  
   DEFINE l_ima         LIKE type_file.chr1000 
   DEFINE l_itemno      LIKE ima_file.ima01 
   DEFINE l_sql         STRING 
   DEFINE l_cnt1,l_cnt2 LIKE type_file.num5
  #DEFINE g_geh         RECORD LIKE geh_file.*  #MOD-D60089 mark
   DEFINE g_type        LIKE type_file.chr1
 
   WHENEVER ERROR CALL cl_err_msg_log
   LET g_errno=' '
 
   WHILE TRUE
      LET l_no = ''
      LET l_desc = ''

      LET l_sql = "SELECT geh01,COUNT(*) FROM gel_file,gei_file,geh_file",
                  " WHERE gel01 = gei01",
                  "   AND gei03 = geh01",
                  "   AND geh04 = '4'",
                  "   AND (gel04 IS NULL OR gel04 = ' ' OR gel04 = '2')",
                  " GROUP BY geh01"
      PREPARE sel_gel_prep FROM l_sql
      DECLARE sel_gel_del  CURSOR FOR sel_gel_prep
      FOREACH sel_gel_del INTO l_geh01,l_cnt1
         IF l_cnt1 > 1 THEN
            LET l_cnt2 = l_cnt1
         END IF
      END FOREACH
        SELECT COUNT(*) INTO l_cnt FROM geh_file WHERE geh04 = p_type
          #挑選編碼類別
           IF l_cnt2 > 1 THEN
              CALL cl_init_qry_var()                                        
              LET g_qryparam.form = "q_gei3"                            
              LET g_qryparam.arg1 = p_type
              CALL cl_create_qry() RETURNING l_gei01
           ELSE
              CALL q_geg1('FALSE','TURE','') RETURNING l_gei01,l_p
           END IF
       #分段挑選
        SELECT * INTO l_gei.* FROM gei_file WHERE gei01 = l_gei01
        SELECT * INTO g_geh.* FROM geh_file WHERE geh01 = l_gei.gei03
        LET l_geg05 = ' '
        LET l_geg05_old = ' '
        LET l_desc = ' '
        LET l_flag = 'N'
        LET l_gel04_old = ' '
 
        SELECT COUNT(*) INTO l_cnt FROM gel_file
         WHERE gel01 = l_gei01 
           AND (gel04 IS NULL OR gel04 = ' ' OR gel04 = '2') 
 
        FOR l_i = 1 TO l_gei.gei04
           SELECT * INTO l_gel.* FROM gel_file
           WHERE gel01 = l_gei.gei01 AND gel02 = l_i
 
          #如果連續幾段皆為固定值,獨立段,流水號
           IF NOT cl_null(l_gel.gel04) THEN 
              IF l_flag = 'N' AND l_cnt > 0 THEN      #最前段
                 SELECT MAX(gef04) INTO l_geg05 FROM gef_file
                  WHERE gef01 = l_gei.gei01 
              END IF 
           ELSE
              LET l_flag = 'Y'
           END IF
 
          #若整段只有固定及流水時處理
           IF l_cnt = 0 THEN
              CASE
                WHEN l_gel.gel04 = '1'    #固定值
                     LET l_geg05 = l_geg05 CLIPPED,l_gel.gel05
                WHEN l_gel.gel04 = '3'    #流水號
                     FOR l_j=1 TO l_gel.gel03
                        LET l_geg05 = l_geg05 CLIPPED,"*"
                     END FOR 
              END CASE
           END IF
 
           IF p_type MATCHES '[56]' THEN 
              CASE
                 WHEN l_gel.gel04 = '4'    #欄位值
                    LET l_sql ="SELECT ",l_gel.gel05, 
                               "  FROM ima_file", 
                               " WHERE ima01 ='",p_itemno,"'"
                    PREPARE ima_pre1 FROM l_sql
                    IF STATUS THEN CALL cl_err('ima_pre1',STATUS,0) END IF
 
                    DECLARE ima_curs1 CURSOR FOR ima_pre1
  
                    OPEN ima_curs1
                    IF SQLCA.sqlcode = "-263" THEN
                       CALL cl_err('ima_curs1:',SQLCA.sqlcode,1)
                    END IF
 
                    FETCH ima_curs1 INTO l_ima
                    IF SQLCA.sqlcode = "-263" THEN
                       CALL cl_err('fetch ima_curs1:',SQLCA.sqlcode,1)
                    END IF
 
                    LET l_itemno = l_ima[1,l_gel.gel03]
                    LET l_geg05 = l_geg05 CLIPPED,l_itemno
                 WHEN l_gel.gel04 = '5'    #年
                    SELECT gff03 INTO l_gff03 FROM gff_file
                     WHERE gff01 = YEAR(g_today)
                       AND gff02 = l_gel.gel03
                    LET l_geg05 = l_geg05 CLIPPED,l_gff03
                 WHEN l_gel.gel04 = '6'    #季
                    CALL s_season(YEAR(g_today),MONTH(g_today)) RETURNING l_date
                    LET l_date = "00" CLIPPED,l_date
                    LET l_length = LENGTH(l_date)
                    LET l_no1 = l_date[l_length-1,l_length]
                    LET l_geg05 = l_geg05 CLIPPED,l_no1
                 WHEN l_gel.gel04 = '7'    #月
                    LET l_date = MONTH(g_today)
                    LET l_date = "00" CLIPPED,l_date
                    LET l_length = LENGTH(l_date)
                    LET l_no1 = l_date[l_length-1,l_length]
                    LET l_geg05 = l_geg05 CLIPPED,l_no1
                 WHEN l_gel.gel04 = '8'    #週
                    LET l_date = WEEKDAY(g_today)
                    LET l_date = "00" CLIPPED,l_date
                    LET l_length = LENGTH(l_date)
                    LET l_no1 = l_date[l_length-1,l_length]
                    LET l_geg05 = l_geg05 CLIPPED,l_no1
                 WHEN l_gel.gel04 = '9'    #日
                    LET l_date = DAY(g_today)
                    LET l_date = "00" CLIPPED,l_date
                    LET l_length = LENGTH(l_date)
                    LET l_no1 = l_date[l_length-1,l_length]
                    LET l_geg05 = l_geg05 CLIPPED,l_no1
              END CASE
           END IF
 
          #如果最後的幾段為固定值，流水號應當要處理
           IF l_gel.gel04 MATCHES '[13]'  THEN 
              IF l_gel.gel07 = 'Y' THEN
                 LET l_desc = l_desc CLIPPED,l_gel.gel06 CLIPPED
              END IF
           END IF
 
           IF cl_null(l_gef04) THEN
              CALL s_geg05(l_gef04,l_gei01,l_i,l_gei.gei04,'2') RETURNING l_gef04
           END IF
         
           IF cl_null(l_gel.gel04) OR l_gel.gel04 = '2' THEN 
              IF p_type MATCHES '[12348]' THEN     
                 IF l_cnt2 > 1 THEN
                    CALL q_gef(FALSE,FALSE,l_no,l_gei01,l_i,l_geg05,
                              l_gef04,l_geg05_old,l_desc)
                        RETURNING l_geg05,l_no,l_desc,l_gef04
                 ELSE
                    LET l_no = l_no CLIPPED,l_p
                 END IF
              END IF  
           END IF
 
           IF INT_FLAG THEN
              LET INT_FLAG = 0 LET l_no = '' LET l_desc = ''
              RETURN l_no,l_desc 
              EXIT WHILE 
           END IF
 
          #若前段為獨立段, 則需用獨立段之前一段的geg05
           IF p_type MATCHES '[12348]' THEN  
              LET l_geg05_old = l_geg05
           END IF
 
          #如果最後一段是流水號和固定值的話，應該要處理,因為
           IF l_i = l_gei.gei04 THEN   
              CALL q_gef_p1(l_geg05,l_gel.gel03,l_no) RETURNING l_no
              IF cl_null(l_no) THEN LET l_desc = '' END IF
           END IF
           LET l_gel04_old = l_gel.gel04
        END FOR
      EXIT WHILE
   END WHILE
 
   RETURN l_no,l_desc
END FUNCTION
#No.FUN-CA0082   ---end  --- Add
