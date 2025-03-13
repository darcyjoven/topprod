# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: s_dismantle.4gl
# Descriptions...: 多單位拆箱作業
# Date & Author..: 05/07/04 By Carrier
# Input Parameter: 
# Return code....: 
# Memo...........: 本作業僅供拆箱用                                             
#              運行時機:當原來的單位數量不能滿足要求,且庫存總量滿足,通過拆合
#                       其他單位的數量提高原來單位的數量,以滿足出貨/調撥/退 
#                       貨之用                                              
#                       本作業不實現出貨/調撥/退貨等的扣減庫存              
#              本作業提供多個單位的拆箱需求,以矩陣方式傳入,                 
#              只須滿足是相同的料/倉/儲/批即可,以矩陣方式比較一個單位傳入的 
#              優點,會減少拆箱過程中的零頭等.效果會比較好,但是需要用戶在CALL
#              本作業之前,進行一定的GROUP動作                               
#              但也有個不好的地方就是只要有一個拆箱失敗,全部rollback        
# Modify.........: 06/01/12 By Carrier TQC-610038 對imgg_file做LOCK
# Modify.........: No.FUN-610090 06/01/25 By Nicola 改從調撥單執行拆箱動作
# Modify.........: No.FUN-610090 06/01/25 By Nicola 改從調撥單執行拆箱動作
# Modify.........: No.TQC-630079 05/03/06 By kim RETURN 需傳回p_imm01
# Modify.........: NO.TQC-620156 06/03/15 By kim GP3.0庫存不足err_log
# Modify.........: NO.TQC-640199 06/05/08 By Claire 產生的s_o_process段的imn_file imn21轉換率應為1
# Modify.........: NO.FUN-660029 06/06/13 By kim 新增immconf欄位
# Modify.........: NO.TQC-670045 06/07/12 BY yiting 現在拆拼箱是把數量轉換成庫存單位，需在新增一筆轉換成需求單位
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0083 06/12/05 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-790089 07/09/17 By jamie 重複的錯誤碼-239在5X的informix錯誤代碼會變成-268 Constraint
# Modify.........: No.MOD-790069 07/09/19 By Pengu 產生跳撥單的日期應該是用過帳日期而不是用g_today
# Modify.........: No.MOD-7A0144 07/10/25 By Pengu 產生調撥單時其imn10,imn22,imn41的值異常
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No:MOD-A90191 10/10/22 By Smapmin 產生調撥單時,針對資料所有者等資訊也要一併產生
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No.FUN-B70074 11/07/25 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-BB0084 11/12/07 By lixh1 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE g_imh         RECORD LIKE imh_file.*
DEFINE g_imi         RECORD LIKE imi_file.*
DEFINE g_item        LIKE ima_file.ima01
DEFINE g_ware        LIKE img_file.img02
DEFINE g_loc         LIKE img_file.img03
DEFINE g_lot         LIKE img_file.img04
DEFINE g_ima25       LIKE ima_file.ima25
DEFINE g_sql         STRING  #No.FUN-580092 HCN
DEFINE g_unit_arr    DYNAMIC ARRAY OF RECORD
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                     END RECORD
DEFINE x_imgg        RECORD LIKE imgg_file.*  #No.TQC-610038
DEFINE g_forupd_sql  STRING                #No.TQC-610038
DEFINE g_imm01       LIKE imm_file.imm01  #No.FUN-610090
DEFINE gi_dismantle_logerr LIKE type_file.num5
 
#No.TQC-610038 --Begin
# Descriptions...: Lock imgg_file   
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_lck_imgg()
# Modify.........:
 
FUNCTION s_lck_imgg()
 
   LET g_forupd_sql = " SELECT * FROM imgg_file ",
                      "  WHERE imgg01= ?  AND imgg02= ?  AND imgg03= ? ",
                      "    AND imgg04= ?  AND imgg09= ?  FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE lock_imgg_cur1 CURSOR FROM g_forupd_sql
 
END FUNCTION
#No.TQC-610038 --End  
 
# Descriptions...: 拆箱作業
# Input parameter: p_no        來源單號
#                  p_lineno    來源項次
#                  p_date      單據日期
#                  p_item      料件
#                  p_ware      倉庫
#                  p_loc       儲位
#                  p_lot       批號
#                  p_unit_arr  單位列表
# Return.........: NULL
# Usage..........: CALL s_dismantle('C20-570001',1,'C001','3001',' ',' ',..)
# Modify.........:
 
FUNCTION s_dismantle(p_no,p_lineno,p_date,p_item,p_ware,p_loc,p_lot,p_unit_arr,p_imm01)  #No.FUN-610090
   DEFINE p_no       LIKE inb_file.inb01
   DEFINE p_lineno   LIKE inb_file.inb03
   DEFINE p_date     LIKE type_file.dat           #No.FUN-680147 DATE
   DEFINE p_item     LIKE img_file.img01
   DEFINE p_ware     LIKE img_file.img02
   DEFINE p_loc      LIKE img_file.img03
   DEFINE p_lot      LIKE img_file.img04
   DEFINE p_unit_arr DYNAMIC ARRAY OF RECORD
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                     END RECORD
   DEFINE tot        LIKE img_file.img10
   DEFINE tot_o      LIKE img_file.img10
   DEFINE l_reqqty   LIKE img_file.img10
   DEFINE l_flag     LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_stat     LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_unit     LIKE img_file.img09
   DEFINE l_qty      LIKE img_file.img10
   DEFINE l_set      LIKE img_file.img10
   DEFINE l_i        LIKE type_file.num10         #No.FUN-680147 INTEGER
   DEFINE l_odd      LIKE img_file.img10
   DEFINE l_imgg     RECORD
                        stat   LIKE type_file.chr1,   #No.FUN-680147 VARCHAR(01)
                        imgg09 LIKE imgg_file.imgg09,
                        imgg21 LIKE imgg_file.imgg21,
                        imgg10 LIKE imgg_file.imgg10
                     END RECORD
   DEFINE p_imm01    LIKE imm_file.imm01  #No.FUN-610090
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_item = p_item
   LET g_ware = p_ware
   LET g_loc = p_loc
   LET g_lot = p_lot
   LET g_imm01 = p_imm01   #No.FUN-610090
 
   SELECT ima25 INTO g_ima25 FROM ima_file
    WHERE ima01 = g_item
 
   IF SQLCA.sqlcode THEN
      LET g_success = 'N' 
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('ima01',g_item,'select ima25',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('select ima25',SQLCA.sqlcode,1)
      END IF
      #-----No.FUN-6C0083 END-----
      RETURN p_imm01 #TQC-630079
   END IF
 
   #-----No.FUN-610090-----
   CALL s_cre_tmp_tab()
  #DELETE FROM dis_table;
  #DELETE FROM odd_table;
  #DELETE FROM req_table;
  #DELETE FROM dis_tot;  
   #-----No.FUN-610090 END-----
 
   #No.TQC-610038  --Begin
#  CALL s_lck_imgg()   #No.FUN-610090 Mark
   #No.TQC-610038  --End  
 
   CALL s_pre_work(p_unit_arr) RETURNING tot_o
 
   IF g_success = 'N' THEN
      RETURN p_imm01 #TQC-630079
   END IF
 
   #在此處檢查總量是否滿足這次的全部需求
   CALL s_chk_tot_qty(tot_o) RETURNING l_flag
   IF l_flag = '0' THEN
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('ima01',g_item,tot_o,'asm-381',1)
      ELSE
         CALL cl_err(tot_o,'asm-381',1)
      END IF
      #-----No.FUN-6C0083 END-----
      LET g_success = 'N'
      RETURN p_imm01 #TQC-630079
   END IF
 
   #每個單位為自己保留所需數量
   CALL s_hold_qty()
 
   IF g_success = 'N' THEN
      RETURN p_imm01 #TQC-630079
   END IF
 
   FOR l_i = 1 TO g_unit_arr.getLength()
      LET tot = 0
      #為自身保留的數量
      SELECT stat,qty INTO l_stat,l_qty FROM dis_table
       WHERE stat IN ('0','1')
         AND hierarchy = l_i
         AND unit = g_unit_arr[l_i].unit
 
      IF cl_null(l_qty) THEN
         LET l_qty = 0
      END IF
 
      IF l_stat = '0' THEN   #不用拆箱,自身數量就夠了
         CONTINUE FOR
      ELSE                   #要拆
         #qty_req本層需求數量=當前單位需求數量*imgg21(以ima25角度來看)
         LET l_reqqty = (g_unit_arr[l_i].qty-l_qty) * g_unit_arr[l_i].fac
         #已累計的量
         #LET tot = l_reqqty
         LET tot = 0
 
         #看零頭表里的零頭是否可以滿足其他單位噢
         IF l_i <> 1 THEN   #第一次拆,當然沒有零頭表羅
            LET g_sql = "SELECT * FROM odd_table"
            PREPARE odd_p FROM g_sql
            DECLARE odd_cur CURSOR FOR odd_p
 
            FOREACH odd_cur INTO l_unit,l_qty  #零頭表的數量本身就是for ima25的
               IF SQLCA.sqlcode THEN
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('','','foreach unit_cur',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err('foreach unit_cur',SQLCA.sqlcode,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  EXIT FOREACH
               END IF
 
               IF cl_null(l_qty) THEN
                  LET l_qty = 0 
               END IF
               LET tot_o = tot
               LET tot = tot+l_qty
 
               #零頭是否滿足當前單位的需求數量?
               IF tot >= l_reqqty THEN
                  CALL s_set_compute(1,l_reqqty-tot_o)
                           RETURNING l_set,l_odd
 
                  UPDATE odd_table SET qty = l_qty - l_set
                   WHERE unit = l_unit
                  IF SQLCA.sqlcode THEN
                     LET g_success = 'N'
                     #-----No.FUN-6C0083-----
                     IF g_bgerr THEN
                        CALL s_errmsg('ima01',p_item,'','abm-731',1)
                     ELSE
                        CALL cl_err('update odd_tab',SQLCA.sqlcode,1)
                     END IF
                     #-----No.FUN-6C0083 END-----
                     RETURN p_imm01 #TQC-630079
                  END IF
                  CONTINUE FOR
               ELSE   #還不夠
                  DELETE FROM odd_table WHERE unit = l_unit
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                     LET g_success = 'N'
                     #-----No.FUN-6C0083-----
                     IF g_bgerr THEN
                        CALL s_errmsg('','','delete odd_tab',SQLCA.sqlcode,1)
                     ELSE
                        CALL cl_err('delete odd_tab',SQLCA.sqlcode,1)
                     END IF
                     #-----No.FUN-6C0083 END-----
                     RETURN p_imm01 #TQC-630079
                  END IF
               END IF
            END FOREACH
         END IF
 
         #從其他的單位中去拆箱了
         #先從大于等于當前單位轉換率的單位開始做拆箱,如是不滿足再做組箱的動作
         #'1'--拆箱  '2'--合箱
         LET g_sql = "SELECT '1',imgg09,imgg21,imgg10 FROM imgg_file",
                     " WHERE imgg01= '",g_item,"'",
                     "   AND imgg02= '",g_ware,"'",
                     "   AND imgg03= '",g_loc,"'",
                     "   AND imgg04= '",g_lot,"'",
                     "   AND imgg09<>'",g_unit_arr[l_i].unit,"'",
                     "   AND imgg21>= ",g_unit_arr[l_i].fac,
                     " UNION ",
                     "SELECT '2',imgg09,imgg21,imgg10 FROM imgg_file",
                     " WHERE imgg01= '",g_item,"'",
                     "   AND imgg02= '",g_ware,"'",
                     "   AND imgg03= '",g_loc,"'",
                     "   AND imgg04= '",g_lot,"'",
                     "   AND imgg09<>'",g_unit_arr[l_i].unit,"'",
                     "   AND imgg21<  ",g_unit_arr[l_i].fac
 
         #IF 參數=從小開始拆 THEN
         IF g_sma.sma903[1,1] = '2' THEN
            LET g_sql = g_sql CLIPPED," ORDER BY 1,3"
         ELSE
            LET g_sql = g_sql CLIPPED," ORDER BY 1,3 DESC"
         END IF
 
         PREPARE imgg_p FROM g_sql
         DECLARE imgg_cur CURSOR FOR imgg_p
         FOREACH imgg_cur INTO l_imgg.*
            IF SQLCA.sqlcode THEN
               #-----No.FUN-6C0083-----
               IF g_bgerr THEN
                  CALL s_errmsg('','','foreach imgg_cur',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err('foreach imgg_cur',SQLCA.sqlcode,1)
               END IF
               #-----No.FUN-6C0083 END-----
               EXIT FOREACH
            END IF
 
            #已經拆過的量
            LET l_qty = 0
            SELECT SUM(qty) INTO l_qty FROM dis_table
             WHERE unit = l_imgg.imgg09
            IF cl_null(l_qty) THEN LET l_qty = 0 END IF
 
            #以下imgg10均指已經扣去以前的拆箱數量了
            LET l_imgg.imgg10 = l_imgg.imgg10 - l_qty
 
            #以ima25的角度,庫存中的剩余量
            LET l_qty = l_imgg.imgg10*l_imgg.imgg21
            IF l_qty = 0 THEN CONTINUE FOREACH END IF
 
            LET tot_o = tot
 
            IF l_qty >= l_reqqty THEN   #這個單位就可以滿足需求了
               CALL s_set_compute(l_imgg.imgg21,l_reqqty)
                        RETURNING l_set,l_odd
               #為了避免多拆箱,如果其中有一個單位可以滿足本次拆箱,
               #則除了自身的需求單位外,其他的單位就可以不拆了
               DELETE FROM dis_table WHERE stat = '2' AND hierarchy = l_i
               IF SQLCA.sqlcode THEN
                  LET g_success = 'N'
                  #-----No.FUN-6C0083-----
                  IF g_bgerr THEN
                     CALL s_errmsg('','','update dis_tot',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err('update dis_tot',SQLCA.sqlcode,1)
                  END IF
                  #-----No.FUN-6C0083 END-----
                  RETURN p_imm01 #TQC-630079
               END IF
 
               #?是否也要刪零頭表? 應該不用了,因為零頭是上幾層的零頭,不能刪
               #但是要把這個單位自身插入到拆箱的table中去
               IF l_set <> 0 THEN
                  CALL s_ins_dis_table(l_i,'2',l_imgg.imgg09,l_imgg.imgg21,l_set)
                  IF g_success = 'N' THEN
                     RETURN p_imm01 #TQC-630079
                  END IF
               END IF
 
               #將被拆剩的零頭放至零頭表中,如果已經前幾次有過拆此單位了.就update
               IF l_odd <> 0 THEN
                  CALL s_ins_odd_table(l_imgg.imgg09,l_odd)
                  IF g_success = 'N' THEN
                     RETURN p_imm01 #TQC-630079
                  END IF
               END IF
               CONTINUE FOR
            ELSE  #不夠拆
               #IF 是否是逐層累加 THEN
               IF g_sma.sma903[2,2] = 'Y' THEN
                  LET tot = tot+l_qty
                  #當前累加的tot是否夠拆
                  IF tot > l_reqqty THEN   #夠拆
                     CALL s_set_compute(l_imgg.imgg21,l_reqqty-tot_o)
                          RETURNING l_set,l_odd
                     IF l_set <> 0 THEN
                        CALL s_ins_dis_table(l_i,'2',l_imgg.imgg09,
                                             l_imgg.imgg21,l_set)
                        IF g_success = 'N' THEN
                           RETURN p_imm01 #TQC-630079
                        END IF
                     END IF
                     IF l_odd <> 0 THEN
                        CALL s_ins_odd_table(l_imgg.imgg09,l_odd)
                        IF g_success = 'N' THEN
                           RETURN p_imm01 #TQC-630079
                        END IF
                     END IF
                     CONTINUE FOR
                  ELSE
                     #insert 臨時表當前imgg資料,且層次=i,數量=全部imgg10
                     CALL s_ins_dis_table(l_i,'2',l_imgg.imgg09,
                                          l_imgg.imgg21,l_imgg.imgg10)
                     IF g_success = 'N' THEN
                        RETURN p_imm01 #TQC-630079
                     END IF
                  END IF
               END IF
            END IF
         END FOREACH
 
         #如果拆了也滿足不了..錯誤退出
         IF tot < l_reqqty THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('ima01',g_item,'','asm-382',1)
            ELSE
               CALL cl_err('','asm-382',1)
            END IF
            #-----No.FUN-6C0083 END-----
            LET g_success = 'N'
            RETURN p_imm01 #TQC-630079
         END IF
      END IF
   END FOR
 
   #其他調整單/異動明細檔等的處理
   IF g_success = 'Y' THEN
      CALL s_o_process(p_no,p_lineno,p_date) RETURNING g_imm01  #No.FUN-610090
      #-----No.FUN-610090-----
      DROP TABLE dis_table;
      DROP TABLE odd_table;
      DROP TABLE req_table;
      DROP TABLE dis_tot;  
      #-----No.FUN-610090 END-----
      IF g_success = 'N' THEN
         RETURN ""
      ELSE
         RETURN g_imm01   #No.FUN-610090
      END IF
   END IF
 
  CALL s_aft_work()
  #IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
# Descriptions...: 檢查是否要進行拆箱
# Input parameter: p_unit   需求單位
#                  p_reqqty 需求數量
# Return.........: 1.要拆箱  0.不要拆箱
# Usage..........: CALL s_chk_dismantle()
#                  RETURNING 1  要拆箱
# Modify.........:
 
FUNCTION s_chk_dismantle(p_unit,p_reqty)
   DEFINE p_unit   LIKE img_file.img09
   DEFINE p_reqty  LIKE img_file.img10
   DEFINE l_imgg10 LIKE imgg_file.imgg10
 
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
    WHERE imgg01 = g_item
      AND imgg02 = g_ware
      AND imgg03 = g_loc
      AND imgg04 = g_lot
      AND imgg09 = p_unit
 
   #夠發,無須拆箱
   IF l_imgg10 < p_reqty THEN
      RETURN '1'
   END IF
   RETURN '0'
 
END FUNCTION
 
# Descriptions...: 調整單/異動明細等insert/update處理
# Input parameter: p_no     來源單號
#                  p_lineno 來源項次
#                  p_date   單據日期
# Return.........: NULL
# Usage..........: CALL s_o_process(p_no,p_lineno,p_date)
# Modify.........:
 
FUNCTION s_o_process(p_no,p_lineno,p_date)
   DEFINE p_no     LIKE inb_file.inb01
   DEFINE p_lineno LIKE inb_file.inb03
   DEFINE p_date   LIKE type_file.dat           #No.FUN-680147 DATE
   DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_flag1  LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_unit   LIKE ima_file.ima25
   DEFINE l_fac    LIKE img_file.img21
   DEFINE l_fac_t    LIKE img_file.img21   #NO.TQC-670045 ADE
   DEFINE l_qty    LIKE img_file.img10
   DEFINE l_reqqty LIKE img_file.img10
   DEFINE l_factor LIKE img_file.img21
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sw      LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE l_i      LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_stat   LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_imgg   RECORD
                   stat    LIKE type_file.chr1,     #No.FUN-680147 VARCHAR(01)
                   imgg09  LIKE imgg_file.imgg09,
                   imgg10  LIKE imgg_file.imgg10
                   END RECORD
#NO.TQC-670045 add---
   DEFINE t_imgg   RECORD
                   stat    LIKE type_file.num5,     #No.FUN-680147 SMALLINT
                   imgg09  LIKE imgg_file.imgg09,
                   imgg10  LIKE imgg_file.imgg10
                   END RECORD
#NO.TQC-670045 add---
   DEFINE l_imm    RECORD LIKE imm_file.*   #No.FUN-610090
   DEFINE l_imn    RECORD LIKE imn_file.*   #No.FUN-610090
   DEFINE li_result  LIKE type_file.num5                 #No.FUN-610090        #No.FUN-680147 SMALLINT
#NO.TQC-670045 add---
   DEFINE t_imm    RECORD LIKE imm_file.*   #No.TQC-670045
   DEFINE t_imn    RECORD LIKE imn_file.*   #No.TQC-670045
   DEFINE l_unit_arr  LIKE img_file.img09   #NO.TQC-670045
   DEFINE t_qty1    LIKE img_file.img10
   DEFINE t_unit    LIKE ima_file.ima25
   DEFINE t_qty2     LIKE img_file.img10
   DEFINE t_reqqty   LIKE img_file.img10  #TQC-670045
#NO.TQC-670045 add---
   DEFINE l_imni   RECORD LIKE imni_file.*     #FUN-B70074 

   LET l_flag = 'N'
   
   LET l_imm.imm01=g_imm01 #TQC-620156
   
   SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_ware
   
   #臨時表數量合計 by單位
   DECLARE dis_tot_cur CURSOR FOR
    SELECT stat,unit,SUM(qty) FROM dis_table
     GROUP BY stat,unit
     ORDER BY stat,unit
   
   FOREACH dis_tot_cur INTO l_imgg.*
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach dis_tot_cur',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach dis_tot_cur',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         EXIT FOREACH
      END IF
   
      IF cl_null(l_imgg.imgg10) THEN LET l_imgg.imgg10 = 0 END IF
   
      INSERT INTO dis_tot VALUES(l_imgg.*)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','insert dis_tot',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('insert dis_tot',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         RETURN
      END IF
      LET l_flag = 'Y'
   END FOREACH
   
   #1.增加庫存調整單   #要先于update imgg10前做
   #need modify
   #IF l_flag = 'Y' THEN
   #   CALL s_ins_imh()
   #   IF g_success = 'N' THEN RETURN END IF
   #   insert into imh_file;
   #   insert into imi_file;
   #END IF
   
   #-----No.FUN-610090-----
   DECLARE ins_imm CURSOR FOR SELECT * FROM dis_tot
                               WHERE stat = "2"
 
   FOREACH ins_imm INTO l_imgg.*
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach ins_imm',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach ins_imm',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         EXIT FOREACH
      END IF
 
      SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_item
 
      SELECT imgg211 INTO l_fac FROM imgg_file
       WHERE imgg01 = g_item
         AND imgg02 = g_ware
         AND imgg03 = g_loc
         AND imgg04 = g_lot
         AND imgg09 = l_imgg.imgg09
 
      IF cl_null(l_imm.imm01) THEN
         IF cl_null(g_imm01) THEN
            CALL s_auto_assign_no("aim",g_sma.sma123,g_today,"","imm_file",
                                  "imm01","","","")
                        RETURNING li_result,l_imm.imm01
            IF (NOT li_result) THEN
               LET g_success = "N"
            END IF
            LET g_imm01 = l_imm.imm01
         ELSE
            LET l_imm.imm01 = g_imm01
         END IF
         LET l_imm.imm02 = p_date             #No.MOD-790069 modify
         LET l_imm.immconf="N" #FUN-660029 
         LET l_imm.imm03 = "N"
         LET l_imm.imm10 = "1"
         LET l_imm.imm14 =g_grup #FUN-680006
 
         LET l_imm.immplant =g_plant #FUN-980012 add
         LET l_imm.immlegal =g_legal #FUN-980012 add

         #-----MOD-A90191---------
         LET l_imm.immuser=g_user
         LET l_imm.immgrup=g_grup
         LET l_imm.immdate=g_today
         #-----END MOD-A90191-----
         #FUN-A60034--add---str---
         #FUN-A70104--mod---str---
         LET l_imm.immmksg = g_smy.smyapr #是否簽核
         LET l_imm.imm15 = '0'            #簽核狀況
         LET l_imm.imm16 = g_user         #申請人
         #FUN-A70104--mod---end---
         #FUN-A60034--add---end---
         INSERT INTO imm_file VALUES (l_imm.*)
         IF STATUS THEN
            LET g_success = "N"
         END IF
      END IF
 
      LET l_imn.imn01 = l_imm.imm01
      SELECT MAX(imn02) + 1 INTO l_imn.imn02
        FROM imn_file WHERE imn01 = l_imm.imm01
      IF l_imn.imn02 IS NULL THEN
         LET l_imn.imn02 = 1
      END IF
      LET l_imn.imn03 = g_item
      LET l_imn.imn04 = g_ware
      LET l_imn.imn05 = g_loc
      LET l_imn.imn06 = g_lot
      LET l_imn.imn09 = g_ima25
      LET l_imn.imn10 = l_imgg.imgg10 * l_fac 
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)  #FUN-BB0084  
      LET l_imn.imn15 = g_ware 
      LET l_imn.imn16 = g_loc  
      LET l_imn.imn17 = g_lot  
      LET l_imn.imn20 = g_ima25
     #LET l_imn.imn21 = l_fac     #TQC-640199 mark
      LET l_imn.imn21 = 1         #TQC-640199 imn09/imn20 的轉換率
      LET l_imn.imn22 = l_imn.imn10 * l_imn.imn21
      LET l_imn.imn22 = s_digqty(l_imn.imn22,l_imn.imn20)   #FUN-BB0084 
      LET l_imn.imn28 = " "
      LET l_imn.imn29 = "N"
      LET l_imn.imn30 = l_imgg.imgg09
      LET l_imn.imn31 = l_fac
      LET l_imn.imn32 = l_imgg.imgg10
      LET l_imn.imn32 = s_digqty(l_imn.imn32,l_imn.imn30)   #FUN-BB0084
      LET l_imn.imn33 = ""
      LET l_imn.imn34 = 0
      LET l_imn.imn35 = 0
      LET l_imn.imn40 = g_ima25 
      LET l_imn.imn41 = 1
      LET l_imn.imn42 = l_imn.imn32 * l_fac
      LET l_imn.imn42 =s_digqty(l_imn.imn42,l_imn.imn40)    #FUN-BB0084 
      LET l_imn.imn43 = ""
      LET l_imn.imn44 = 0
      LET l_imn.imn45 = 0
      LET l_imn.imn51 = l_fac
      LET l_imn.imn52 = 0
      LET l_imn.imn9301=s_costcenter(l_imm.imm14)  #FUN-680006
      LET l_imn.imn9302=l_imn.imn9301  #FUN-680006
      LET l_imn.imnplant =g_plant #FUN-980012 add
      LET l_imn.imnlegal =g_legal #FUN-980012 add
 
      INSERT INTO imn_file VALUES (l_imn.*)
      IF STATUS THEN
         LET g_success = "N"
      #FUN-B70074-add-str--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_imni.* TO NULL
            LET l_imni.imni01 = l_imn.imn01
            LET l_imni.imni01 = l_imn.imn02
            IF s_ins_imni(l_imni.*,l_imn.imnplant) THEN
               LET g_success = 'N'
            END IF
         END IF
      #FUN-B70074-add-str--
      END IF
   END FOREACH
 
   #-----No.TQC-670045-----
   DECLARE ins_imm1 CURSOR FOR SELECT * FROM dis_tot
                               WHERE stat = "1"
 
   FOREACH ins_imm1 INTO t_imgg.*
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach ins_imm',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach ins_imm',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         EXIT FOREACH
      END IF
      SELECT qty INTO t_qty1 FROM dis_table
       WHERE stat IN ('0','1')
         #AND hierarchy = l_i
         AND unit = t_imgg.imgg09
      IF cl_null(l_qty) THEN
         LET l_qty = 0
      END IF
      SELECT unit,qty INTO t_unit,t_qty2
        FROM req_table
       WHERE unit = t_imgg.imgg09
      LET t_reqqty = t_qty2 - t_qty1
 
      SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_item
 
      SELECT imgg211 INTO l_fac_t FROM imgg_file
       WHERE imgg01 = g_item
         AND imgg02 = g_ware
         AND imgg03 = g_loc
         AND imgg04 = g_lot
         AND imgg09 = t_imgg.imgg09
 
      LET t_imn.imn01 = l_imm.imm01
      SELECT MAX(imn02) + 1 INTO t_imn.imn02
        FROM imn_file WHERE imn01 = l_imm.imm01
      IF t_imn.imn02 IS NULL THEN
         LET t_imn.imn02 = 1
      END IF
      LET t_imn.imn03 = g_item
      LET t_imn.imn04 = g_ware
      LET t_imn.imn05 = g_loc
      LET t_imn.imn06 = g_lot
      LET t_imn.imn09 = g_ima25
     #----------------No.MOD-7A0144 modify
     #LET t_imn.imn10 = t_imgg.imgg10 * l_fac_t
      LET t_imn.imn10 = t_reqqty * l_fac_t     #單位一數量(來源)
      LET t_imn.imn10 = s_digqty(t_imn.imn10,t_imn.imn09)   #FUN-BB0084
     #----------------No.MOD-7A0144 end
      LET t_imn.imn15 = g_ware
      LET t_imn.imn16 = g_loc
      LET t_imn.imn17 = g_lot
      LET t_imn.imn20 = g_ima25
      LET t_imn.imn21 = 1
      LET t_imn.imn22 = t_imn.imn10* t_imn.imn21
      LET t_imn.imn22 = s_digqty(t_imn.imn22,t_imn.imn20)   #FUN-BB0084 
      LET t_imn.imn28 = " "
      LET t_imn.imn29 = "N"
      LET t_imn.imn30 = g_ima25                      #單位一(來源)
      LET t_imn.imn31 = 1                            #單位一換算率(來源)
#      LET t_imn.imn32 = t_imgg.imgg10 * l_fac_t     #單位一數量(來源)
      LET t_imn.imn32 = t_reqqty * l_fac_t     #單位一數量(來源)
      LET t_imn.imn32 = s_digqty(t_imn.imn32,t_imn.imn30)   #FUN-BB0084
      LET t_imn.imn33 = ""
      LET t_imn.imn34 = 0
      LET t_imn.imn35 = 0
      LET t_imn.imn40 = t_imgg.imgg09                #單位一(目的)
     #----------------No.MOD-7A0144 modify
     #LET t_imn.imn41 = 1                            #單位一換算率(與庫存單位)
      LET t_imn.imn41 = l_fac_t                      #單位一換算率(與庫存單位)
     #----------------No.MOD-7A0144 end
#      LET t_imn.imn42 = t_imgg.imgg10               #單位一數量(目的)
      LET t_imn.imn42 = t_reqqty                     #單位一數量(目的)
      LET t_imn.imn42 = s_digqty(t_imn.imn42,t_imn.imn40)   #FUN-BB0084
      LET t_imn.imn43 = ""
      LET t_imn.imn44 = 0
      LET t_imn.imn45 = 0
      LET t_imn.imn51 = l_fac_t                      #來源單位一與目的單位一的轉
      LET t_imn.imn52 = 0
      LET t_imn.imn9301=l_imn.imn9301 #FUN-680006
      LET t_imn.imn9302=l_imn.imn9302 #FUN-680006
      LET t_imn.imnplant =g_plant #FUN-980012 add
      LET t_imn.imnlegal =g_legal #FUN-980012 add
 
      INSERT INTO imn_file VALUES (t_imn.*)
      IF STATUS THEN
         LET g_success = "N"
      #FUN-B70074-add-str--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_imni.* TO NULL
            LET l_imni.imni01 = t_imn.imn01
            LET l_imni.imni01 = t_imn.imn02
            IF s_ins_imni(l_imni.*,t_imn.imnplant) THEN
               LET g_success = 'N'
            END IF
         END IF
      #FUN-B70074-add-str--
      END IF
   END FOREACH
#NO.TQC-670045 end--
 
   RETURN l_imm.imm01
 
  ##2.被拆箱單位的imgg10數量減扣
  #LET l_flag1 = 'N'
  #SELECT ima25 INTO g_ima25 FROM ima_file WHERE ima01 = g_item
  #DECLARE deduct_imgg CURSOR FOR
  # SELECT * FROM dis_tot
  #FOREACH deduct_imgg INTO l_imgg.*
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err('foreach deduct_imgg',SQLCA.sqlcode,1)
  #      EXIT FOREACH
  #   END IF
  #   #stat = 0為自身可以滿足需求數量的,不用拆箱,不寫tlff
  #   IF l_imgg.stat = '0' THEN
  #      CONTINUE FOREACH
  #   END IF
  #   SELECT imgg211 INTO l_fac FROM imgg_file
  #    WHERE imgg01 = g_item
  #      AND imgg02 = g_ware
  #      AND imgg03 = g_loc
  #      AND imgg04 = g_lot
  #      AND imgg09 = l_imgg.imgg09
  #   #stat = 1為自身滿足不了需求數量的, 自身不用拆箱,
  #   #需求數量-自身數量為其他單位拆給它的.要增加imgg,寫tlff
  #   IF l_imgg.stat = '1' THEN
  #      SELECT qty INTO l_reqqty FROM req_table
  #       WHERE unit = l_imgg.imgg09
  #      IF cl_null(l_reqqty) THEN LET l_reqqty = 0 END IF
  #      IF g_ima25 = l_imgg.imgg09 THEN
  #         SELECT SUM(qty) INTO l_qty FROM odd_table
  #         IF cl_null(l_qty) THEN LET l_qty = 0 END IF
  #         IF l_qty <> 0 THEN  #是有拆剩零頭的
  #            LET l_reqqty = l_reqqty+l_qty
  #            LET l_flag1 = 'Y'
  #         END IF
  #      END IF
 
  #      #No.TQC-610038  --Begin
  #      OPEN lock_imgg_cur1 USING g_item,g_ware,g_loc,g_lot,l_imgg.imgg09
  #      IF STATUS THEN
  #         CALL cl_err("OPEN lock_imgg_cur1:", STATUS, 1)
  #         LET g_success = 'N'
  #         CLOSE lock_imgg_cur1
  #         RETURN
  #      END IF
 
  #      FETCH lock_imgg_cur1 INTO x_imgg.*
  #      IF STATUS THEN
  #         CALL cl_err('fetch lock_imgg_cur1',STATUS,1)
  #         LET g_success = 'N'
  #         CLOSE lock_imgg_cur1
  #         RETURN
  #      END IF
  #      #No.TQC-610038  --End  
 
  #      UPDATE imgg_file SET imgg10 = l_reqqty
  #       WHERE imgg01 = g_item
  #         AND imgg02 = g_ware
  #         AND imgg03 = g_loc
  #         AND imgg04 = g_lot
  #         AND imgg09 = l_imgg.imgg09
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err('ckp#2-1(update imgg10)',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         RETURN
  #      END IF
  #      CLOSE lock_imgg_cur1  #TQC-610038
  #      CALL s_ins_tlff(p_no,p_lineno,p_date,g_item,g_ware,
  #                      g_loc,g_lot,l_imgg.imgg09,l_fac,
  #                      l_reqqty-l_imgg.imgg10,+1)
  #      IF g_success = 'N' THEN
  #         RETURN
  #      END IF
  #   END IF
 
  #   #stat=2為他人犧牲的單位啊,了不起.要減少imgg,寫tlff
  #   IF l_imgg.stat = '2' THEN
  #      IF g_ima25 = l_imgg.imgg09 THEN
  #         SELECT SUM(qty) INTO l_qty FROM odd_table
  #         IF cl_null(l_qty) THEN LET l_qty = 0 END IF
  #         IF l_qty <> 0 THEN  #是有拆剩零頭的
  #            LET l_imgg.imgg10 = l_imgg.imgg10 - l_qty
  #            LET l_flag1 = 'Y'
  #         END IF
  #      END IF
  #      #No.TQC-610038  --Begin
  #      OPEN lock_imgg_cur1 USING g_item,g_ware,g_loc,g_lot,l_imgg.imgg09
  #      IF STATUS THEN
  #         CALL cl_err("OPEN lock_imgg_cur1:", STATUS, 1)
  #         LET g_success = 'N'
  #         CLOSE lock_imgg_cur1
  #         RETURN
  #      END IF
  #      FETCH lock_imgg_cur1 INTO x_imgg.*
  #      IF STATUS THEN
  #         CALL cl_err('fetch lock_imgg_cur1',STATUS,1)
  #         LET g_success = 'N'
  #         CLOSE lock_imgg_cur1
  #         RETURN
  #      END IF
  #      #No.TQC-610038  --End  
 
  #      UPDATE imgg_file SET imgg10 = imgg10 - l_imgg.imgg10
  #       WHERE imgg01 = g_item
  #         AND imgg02 = g_ware
  #         AND imgg03 = g_loc
  #         AND imgg04 = g_lot
  #         AND imgg09 = l_imgg.imgg09
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err('ckp#2-2(update imgg10)',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         RETURN
  #      END IF
  #      CLOSE lock_imgg_cur1  #TQC-610038
  #      CALL s_ins_tlff(p_no,p_lineno,p_date,g_item,g_ware,
  #                      g_loc,g_lot,l_imgg.imgg09,l_fac, 
  #                      l_imgg.imgg10,-1)
  #      IF g_success = 'N' THEN 
  #         RETURN
  #      END IF
  #   END IF
  #END FOREACH
  #
  ##3.是否有零頭,有則ima25的imgg10增加
  ##之所以這樣處理是有可能tlff重復
  #IF l_flag1 = 'N' THEN
  #   SELECT SUM(qty) INTO l_qty FROM odd_table
  #   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
  #   IF l_qty <> 0 THEN  #是有拆剩零頭的
  #      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_item
  #      CALL s_chk_imgg(g_item,g_ware,g_loc,g_lot,l_ima25)
  #            RETURNING l_stat
  #      IF l_stat = 1 THEN
  #         SELECT img09 INTO l_unit FROM img_file
  #          WHERE img01 = g_item
  #            AND img02 = g_ware
  #            AND img03 = g_loc
  #            AND img04 = g_lot
  #         LET l_factor = 1
  #         IF l_unit <> l_ima25 THEN
  #            CALL s_umfchk(g_item,l_ima25,l_unit )
  #                RETURNING l_sw,l_factor
  #            IF l_sw = 1 THEN
  #               CALL cl_err('ckp#3(img09/ima25)','mfg3075',1)
  #               LET g_success = 'N'
  #               RETURN
  #            END IF
  #         END IF
  #         CALL s_add_imgg(g_item,g_ware,g_loc,g_lot,
  #                         l_ima25,l_factor,p_no,p_lineno,1)
  #               RETURNING l_stat
  #         IF l_stat = 1 THEN
  #            CALL cl_err('ckp#3(add_imgg)',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #            RETURN
  #         END IF
  #      END IF
  #       #No.TQC-610038  --Begin
  #       OPEN lock_imgg_cur1 USING g_item,g_ware,g_loc,g_lot,l_ima25
  #       IF STATUS THEN
  #          CALL cl_err("OPEN lock_imgg_cur1:", STATUS, 1)
  #          LET g_success = 'N'
  #          CLOSE lock_imgg_cur1
  #          RETURN
  #       END IF
  #       FETCH lock_imgg_cur1 INTO x_imgg.*
  #       IF STATUS THEN
  #          CALL cl_err('fetch lock_imgg_cur1',STATUS,1)
  #          LET g_success = 'N'
  #          CLOSE lock_imgg_cur1
  #          RETURN
  #       END IF
  #       #No.TQC-610038  --End  
  #      UPDATE imgg_file SET imgg10 = imgg10 + l_qty
  #       WHERE imgg01 = g_item
  #         AND imgg02 = g_ware
  #         AND imgg03 = g_loc
  #         AND imgg04 = g_lot
  #         AND imgg09 = l_ima25
  #      IF SQLCA.sqlcode THEN
  #         CALL cl_err('ckp#3(update imgg10)',SQLCA.sqlcode,1)
  #         LET g_success = 'N'
  #         RETURN
  #      END IF
  #      CLOSE lock_imgg_cur1  #TQC-610038
  #      CALL s_ins_tlff(p_no,p_lineno,p_date,g_item,g_ware,
  #                      g_loc,g_lot,l_ima25,1,l_qty,+1)
  #      IF g_success = 'N' THEN
  #         RETURN
  #      END IF
  #   END IF
  #END IF
   #-----No.FUN-610090 END-----
 
END FUNCTION
 
# Descriptions...: 計算拆箱數量和拆開后剩余的零頭數量
# Input parameter: p_reqqty 需求數量
#                  p_fac    單位對ima25的轉換率
# Return.........: 拆箱的套數和拆開未使用完的零頭數量
# Usage..........: CALL s_set_compute(12,8)
#                  RETURNING 1,4  要拆1箱,剩余的零頭為4
# Modify.........:
 
FUNCTION s_set_compute(p_fac,p_reqqty)
   DEFINE p_reqqty   LIKE img_file.img10
   DEFINE p_fac      LIKE img_file.img21
   DEFINE l_sets     LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_odds     LIKE img_file.img10
 
   IF p_fac = 0 THEN 
      LET g_success = 'N'
      RETURN
   END IF
 
  #IF p_fac = 1 THEN RETURN p_reqqty,0 END IF
 
   LET l_sets = p_reqqty / p_fac
   LET l_odds = p_reqqty - l_sets * p_fac
 
   IF l_odds <> 0 THEN
      LET l_sets = l_sets + 1
      LET l_odds = p_fac - l_odds
   END IF
 
   RETURN l_sets,l_odds
 
END FUNCTION
 
# Descriptions...: 新增多單位庫存調整單單頭
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_ins_imh()
 
FUNCTION s_ins_imh()
 
END FUNCTION
 
# Descriptions...: 新增多單位異動紀錄檔tlff_file資料
# Input parameter: p_no     來源單號
#                  p_lineno 來源項次
#                  p_date   單據日期
#                  p_item   料件
#                  p_ware   倉庫
#                  p_loc    儲位
#                  p_lot    批號
#                  p_unit   異動單位
#                  p_fac    異動轉換率
#                  p_qty    異動數量
#                  p_flag   +1 撥入  -1 撥出
# Return.........: NULL
# Usage..........: CALL s_ins_tlff()
 
FUNCTION s_ins_tlff(p_no,p_lineno,p_date,p_item,p_ware,
                    p_loc,p_lot,p_unit,p_fac,p_qty,p_flag)
  DEFINE p_no     LIKE inb_file.inb01
  DEFINE p_lineno LIKE inb_file.inb03
  DEFINE p_date   LIKE type_file.dat           #No.FUN-680147 DATE
  DEFINE p_item   LIKE ima_file.ima01
  DEFINE p_ware   LIKE img_file.img02
  DEFINE p_loc    LIKE img_file.img03
  DEFINE p_lot    LIKE img_file.img04
  DEFINE p_unit   LIKE img_file.img09
  DEFINE p_fac    LIKE img_file.img21
  DEFINE p_qty    LIKE img_file.img10
  DEFINE p_flag   LIKE type_file.num5          #No.FUN-680147 SMALLINT
  DEFINE l_imgg10 LIKE imgg_file.imgg10
 
  IF cl_null(p_ware) THEN LET p_ware= ' ' END IF
  IF cl_null(p_loc) THEN LET p_loc = ' ' END IF
  IF cl_null(p_lot) THEN LET p_lot = ' ' END IF
  IF cl_null(p_qty) THEN LET p_qty = 0 END IF
 
  IF p_unit IS NULL THEN
     LET g_success = 'N'
     #-----No.FUN-6C0083-----
     IF g_bgerr THEN
        LET g_showmsg = p_item,'/',p_unit
        CALL s_errmsg('ima01,img09',g_showmsg,'p_unit null:','asf-031',1)
     ELSE
        CALL cl_err('p_unit null:','asf-031',1)
     END IF
     #-----No.FUN-6C0083 END-----
     RETURN
  END IF
 
  SELECT imgg10 INTO l_imgg10 FROM imgg_file
   WHERE imgg01 = p_item
     AND imgg02 = p_ware
     AND imgg03 = p_loc
     AND imgg04 = p_lot
     AND imgg09 = p_unit
 
  IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
 
  INITIALIZE g_tlff.* TO NULL
  LET g_tlff.tlff01  = p_item                   #異動料件編號
  IF p_flag = +1 THEN
     LET g_tlff.tlff02  = 0                     #來源狀況
     LET g_tlff.tlff03  = 50                    #目的狀況
     LET g_tlff.tlff907 = 1                     #出入庫
     LET g_tlff.tlff10  = p_qty                 #異動數量
     LET g_tlff.tlff030 = g_plant               #工廠別
     LET g_tlff.tlff031 = p_ware                #倉庫
     LET g_tlff.tlff032 = p_loc                 #儲位
     LET g_tlff.tlff033 = p_lot                 #批號
     LET g_tlff.tlff034 = l_imgg10              #異動後數量
     LET g_tlff.tlff035 = p_unit                #庫存單位
     LET g_tlff.tlff036 = p_no                  #發票編號
     LET g_tlff.tlff037 = p_lineno              #雜收項次
     LET g_tlff.tlff026 = ' '                   #發票編號
     LET g_tlff.tlff027 = ' '                   #雜收項次
     LET g_tlff.tlff13  = 'aimt3801'            #異動命令代號
  ELSE
     LET g_tlff.tlff02  = 50                    #來源狀況
     LET g_tlff.tlff03  = 0                     #目的狀況
     LET g_tlff.tlff907 = -1
     LET g_tlff.tlff10  = p_qty                 #異動數量
     LET g_tlff.tlff020 = g_plant               #工廠別
     LET g_tlff.tlff021 = p_ware                #倉庫
     LET g_tlff.tlff022 = p_loc                 #儲位
     LET g_tlff.tlff023 = p_lot                 #批號
     LET g_tlff.tlff024 = l_imgg10              #異動後數量
     LET g_tlff.tlff025 = p_unit                #庫存單位
     LET g_tlff.tlff026 = p_no                  #發票編號
     LET g_tlff.tlff027 = p_lineno              #雜收項次
     LET g_tlff.tlff036 = ' '                   #發票編號
     LET g_tlff.tlff037 = ' '                   #雜收項次
     LET g_tlff.tlff13  = 'aimt3802'            #異動命令代號
  END IF
  LET g_tlff.tlff906 = p_lineno                 #項次
  LET g_tlff.tlff04  = ' '                      #工作站
  LET g_tlff.tlff05  = ' '                      #作業序號
  LET g_tlff.tlff06  = p_date                   #發料日期
  LET g_tlff.tlff07  = g_today                  #異動資料產生日期
  LET g_tlff.tlff08  = TIME                     #異動資料產生時:分:秒
  LET g_tlff.tlff09  = g_user                   #產生人
  LET g_tlff.tlff11  = p_unit                   #發料單位
  LET g_tlff.tlff12  = p_fac                    #發料/庫存 換算率
  LET g_tlff.tlff14  = NULL                     #異動原因
  LET g_tlff.tlff17  = NULL                     #Remark
 
  CALL s_tlff('2','')
 
END FUNCTION
 
# Descriptions...: insert into dis_table
# Input parameter: p_stat 狀態
#                    0.當前單位就是需求單位,無須拆箱,原本的數量就足夠了
#                      這種情況無須產生調整單,無tlff_file
#                    1.當前單位就是需求單位,原本的數量不夠拆箱
#                      有調整單,調整數量為狀態為2.的數量總計-零頭,有tlff_file
#                    2.是拆箱過程中的其他單位
#                      有調整單,數量為dis_table中的數量,有tlff_file
#                  p_hierarchy   層次
#                  p_unit        單位
#                  p_fac         轉換率
#                  p_qty         數量
# Return.........: NULL
# Usage..........: CALL s_ins_dis_table(1,'0','PCS',1,21)
 
FUNCTION s_ins_dis_table(p_hierarchy,p_stat,p_unit,p_fac,p_qty)
   DEFINE p_hierarchy LIKE ima_file.ima25
   DEFINE p_stat      LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE p_unit      LIKE ima_file.ima25
   DEFINE p_fac       LIKE img_file.img21
   DEFINE p_qty       LIKE img_file.img10
 
   INSERT INTO dis_table VALUES(p_hierarchy,p_stat,p_unit,p_fac,p_qty)
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('','','insert dis_table',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('insert dis_table',SQLCA.sqlcode,1)
      END IF
      #-----No.FUN-6C0083 END-----
      RETURN
   END IF
 
END FUNCTION
 
# Descriptions...: insert into odd_table
# Input parameter: p_unit        單位
#                  p_qty         數量
# Return.........: NULL
# Usage..........: CALL s_ins_odd_table('PCS',1)
 
FUNCTION s_ins_odd_table(p_unit,p_qty)
   DEFINE p_unit    LIKE ima_file.ima25
   DEFINE p_qty     LIKE img_file.img10
 
   INSERT INTO odd_table VALUES(p_unit,p_qty)
   IF SQLCA.sqlcode THEN
     #IF SQLCA.sqlcode=-239 THEN               #TQC-790089 mark
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790089 mod
         UPDATE odd_table SET qty=qty+p_qty
          WHERE unit=p_unit
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','update odd',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('update odd',SQLCA.sqlcode,1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN
         END IF
      ELSE
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','insert odd',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('insert odd',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         LET g_success = 'N'
         RETURN
      END IF
   END IF
 
END FUNCTION
 
# Descriptions...: 檢查總庫存是否滿足需求數量
# Input parameter: p_reqqty 需求數量
# Return.........: 1.滿足,可以通過拆箱解決
#                  0.不滿足,勿須拆箱
# Usage..........: CALL s_chk_tot_qty(p_reqqty)
#                  RETURNING 0  不要拆箱了.總庫存都不滿足
 
FUNCTION s_chk_tot_qty(p_reqqty)
   DEFINE p_reqqty LIKE img_file.img10
   DEFINE l_img10  LIKE img_file.img10
   DEFINE l_img21  LIKE img_file.img21
 
   SELECT img10,img21 INTO l_img10,l_img21 FROM img_file
    WHERE img01 = g_item
      AND img02 = g_ware
      AND img03 = g_loc
      AND img04 = g_lot
 
   IF cl_null(l_img10) THEN LET l_img10 = 0 END IF
 
   IF cl_null(l_img21) THEN LET l_img21 = 1 END IF
 
   IF l_img10*l_img21 < p_reqqty THEN
      RETURN '0'
   END IF
 
   RETURN '1'
 
END FUNCTION
 
# Descriptions...: 每個單位都應該先滿足自己的需求數量,
#                  再去配合其他單位進行拆箱和并箱動作
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_hold_qty()
 
FUNCTION s_hold_qty()
   DEFINE l_i        LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_do       LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_imgg10   LIKE imgg_file.imgg10
 
  FOR l_i = 1 TO g_unit_arr.getLength()
     #檢查是否要拆箱
     CALL s_chk_dismantle(g_unit_arr[l_i].unit,g_unit_arr[l_i].qty)
                RETURNING l_do
     IF l_do = '0' THEN   #不用拆箱,自身數量就夠了
        CALL s_ins_dis_table(l_i,'0',g_unit_arr[l_i].unit,
                             g_unit_arr[l_i].fac,g_unit_arr[l_i].qty)
        IF g_success = 'N' THEN
           RETURN
        END IF
     ELSE                 #要拆
        SELECT imgg10 INTO l_imgg10 FROM imgg_file
         WHERE imgg01 = g_item
           AND imgg02 = g_ware
           AND imgg03 = g_loc
           AND imgg04 = g_lot
           AND imgg09 = g_unit_arr[l_i].unit
 
        IF cl_null(l_imgg10) THEN 
           LET l_imgg10 = 0
        END IF
 
       #IF l_imgg10 <> 0 THEN
           CALL s_ins_dis_table(l_i,'1',g_unit_arr[l_i].unit,
                                g_unit_arr[l_i].fac,l_imgg10)
           IF g_success = 'N' THEN
              RETURN
           END IF
       #END IF
     END IF
  END FOR
 
END FUNCTION
 
# Descriptions...: 前置作業
#                  create臨時表/合計.....
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_pre_work(p_unit_arr)
 
FUNCTION s_pre_work(p_unit_arr)
   DEFINE p_unit_arr DYNAMIC ARRAY OF RECORD
                        unit   LIKE ima_file.ima25,
                        fac    LIKE img_file.img21,
                        qty    LIKE img_file.img10
                     END RECORD
   DEFINE tot_o      LIKE img_file.img10
   DEFINE l_factor   LIKE img_file.img21
   DEFINE l_sw       LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_i        LIKE type_file.num5          #No.FUN-680147 SMALLINT 
   
   #合并單位數量  如果有這樣的情況的話
   LET tot_o = 0
 
   FOR l_i = 1 TO p_unit_arr.getLength()
      LET l_factor = 1
      IF p_unit_arr[l_i].unit <> g_ima25 THEN
         CALL s_umfchk(g_item,p_unit_arr[l_i].unit,g_ima25)
             RETURNING l_sw,l_factor
         IF l_sw = 1 THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               LET g_showmsg = g_item,"/",p_unit_arr[l_i].unit,"/",g_ima25
               CALL s_errmsg('ima01,img09,ima25',g_showmsg,'img09/ima25','mfg3075',1)
            ELSE
               CALL cl_err('img09/ima25','mfg3075',1)
            END IF
            #-----No.FUN-6C0083 END-----
            LET g_success = 'N'            
            RETURN
         END IF
      END IF
      LET tot_o = tot_o + p_unit_arr[l_i].qty * l_factor
      #借用這個table的
      INSERT INTO dis_table VALUES(0,0,p_unit_arr[l_i].unit,
                                   l_factor,p_unit_arr[l_i].qty)
   END FOR
 
   DECLARE unit_cur CURSOR FOR
    SELECT unit,fac,SUM(qty) FROM dis_table
     GROUP BY unit,fac
 
   LET l_i = 1
 
   FOREACH unit_cur INTO g_unit_arr[l_i].*
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach unit_cur',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach unit_cur',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         EXIT FOREACH
      END IF
 
      IF cl_null(g_unit_arr[l_i].unit) THEN
         CONTINUE FOREACH
      END IF
 
      IF cl_null(g_unit_arr[l_i].qty) THEN
         LET g_unit_arr[l_i].qty = 0
      END IF
 
      INSERT INTO req_table VALUES(g_unit_arr[l_i].unit,
                  g_unit_arr[l_i].fac,g_unit_arr[l_i].qty)
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','insert req',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('insert req',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         RETURN
      END IF
 
      LET l_i = l_i + 1
   END FOREACH
 
   CALL g_unit_arr.deleteElement(l_i)
 
   DELETE FROM dis_table;   #只是借用一下的..后面有用到這個table
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('','','delete from dis_tab',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('delete from dis_tab',SQLCA.sqlcode,1)
      END IF
      #-----No.FUN-6C0083 END-----
      RETURN
   END IF
 
   RETURN tot_o
 
END FUNCTION
 
# Descriptions...: 拆箱還原
# Input parameter: p_no     來源單號
#                  p_lineno 來源項次
# Return.........: NULL
# Usage..........: CALL s_undo_dismantle(p_no,p_lineno)
 
FUNCTION s_undo_dismantle(p_no,p_lineno)
   DEFINE p_no     LIKE inb_file.inb01
   DEFINE p_lineno LIKE inb_file.inb03
   DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_unit   LIKE ima_file.ima25
   DEFINE l_fac    LIKE img_file.img21
   DEFINE l_qty    LIKE img_file.img10
   DEFINE l_reqqty LIKE img_file.img10
   DEFINE l_factor LIKE img_file.img21
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sw     LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_stat   LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_tlff   RECORD LIKE tlff_file.*
   DEFINE l_imgg   RECORD LIKE imgg_file.*
 
   #No.TQC-610038  --Begin
   CALL s_lck_imgg()
   #No.TQC-610038  --End  
   
   DECLARE sel_tlff CURSOR FOR
    SELECT * FROM tlff_file
     WHERE tlff905=p_no
       AND tlff906=p_lineno
       AND tlff13 LIKE 'aimt380%'
    
   #1.imgg資料還原
   FOREACH sel_tlff INTO l_tlff.*
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','foreach sel_tlff',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach sel_tlff',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         EXIT FOREACH
      END IF
 
      IF cl_null(l_tlff.tlff10) THEN
         LET l_tlff.tlff10 = 0
      END IF
 
      SELECT * INTO l_imgg.* FROM imgg_file
       WHERE imgg01 = l_tlff.tlff01
         AND imgg02 = l_tlff.tlff902
         AND imgg03 = l_tlff.tlff903
         AND imgg04 = l_tlff.tlff904
         AND imgg09 = l_tlff.tlff11 
      IF SQLCA.sqlcode THEN
         #-----No.FUN-6C0083-----
         IF g_bgerr THEN
            CALL s_errmsg('','','select imgg',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('select imgg',SQLCA.sqlcode,1)
         END IF
         #-----No.FUN-6C0083 END-----
         #不敢rollback,因為有可能有些作業它就不更新庫存量的
         CONTINUE FOREACH
      END IF 
 
      IF l_tlff.tlff907 = 1 THEN
         #No.TQC-610038  --Begin
         OPEN lock_imgg_cur1 USING l_tlff.tlff01,l_tlff.tlff902,
                                   l_tlff.tlff903,l_tlff.tlff904,
                                   l_tlff.tlff11
         IF STATUS THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','OPEN lock_imgg_cur1:',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err("OPEN lock_imgg_cur1:", STATUS, 1)
            END IF
            #-----No.FUN-6C0083 END-----
            LET g_success = 'N'
            CLOSE lock_imgg_cur1
            RETURN
         END IF
 
         FETCH lock_imgg_cur1 INTO x_imgg.*
         IF STATUS THEN
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','fetch lock_imgg_cur1',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('fetch lock_imgg_cur1',STATUS,1)
            END IF
            #-----No.FUN-6C0083 END-----
            LET g_success = 'N'
            CLOSE lock_imgg_cur1
            RETURN
         END IF
         #No.TQC-610038  --End  
 
         UPDATE imgg_file set imgg10=imgg10-l_tlff.tlff10
          WHERE imgg01 = l_tlff.tlff01
            AND imgg02 = l_tlff.tlff902
            AND imgg03 = l_tlff.tlff903
            AND imgg04 = l_tlff.tlff904
            AND imgg09 = l_tlff.tlff11 
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','update imgg',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('update imgg',SQLCA.sqlcode,1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN 
         END IF
 
         CLOSE lock_imgg_cur1  #TQC-610038
      END IF
 
      IF l_tlff.tlff907 = -1 THEN
         #No.TQC-610038  --Begin
         OPEN lock_imgg_cur1 USING l_tlff.tlff01,l_tlff.tlff902,
                                   l_tlff.tlff903,l_tlff.tlff904,
                                   l_tlff.tlff11
         IF STATUS THEN
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','OPEN lock_imgg_cur1',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err("OPEN lock_imgg_cur1:", STATUS, 1)
            END IF
            #-----No.FUN-6C0083 END-----
            CLOSE lock_imgg_cur1
            RETURN
         END IF
 
         FETCH lock_imgg_cur1 INTO x_imgg.*
         IF STATUS THEN
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','fetch lock_imgg_cur1',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('fetch lock_imgg_cur1',STATUS,1)
            END IF
            #-----No.FUN-6C0083 END-----
            CLOSE lock_imgg_cur1
            RETURN
         END IF
         #No.TQC-610038  --End  
 
         UPDATE imgg_file set imgg10=imgg10+l_tlff.tlff10
          WHERE imgg01 = l_tlff.tlff01
            AND imgg02 = l_tlff.tlff902
            AND imgg03 = l_tlff.tlff903
            AND imgg04 = l_tlff.tlff904
            AND imgg09 = l_tlff.tlff11 
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            #-----No.FUN-6C0083-----
            IF g_bgerr THEN
               CALL s_errmsg('','','update imgg',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err('update imgg',SQLCA.sqlcode,1)
            END IF
            #-----No.FUN-6C0083 END-----
            RETURN 
         END IF
 
         CLOSE lock_imgg_cur1  #TQC-610038
      END IF
   END FOREACH
   
   #2.tlff_file delete
   DELETE FROM tlff_file
    WHERE tlff905=p_no
      AND tlff906=p_lineno
      AND tlff13 LIKE 'aimt380%'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      #-----No.FUN-6C0083-----
      IF g_bgerr THEN
         CALL s_errmsg('','','delete tlff',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('delete tlff',SQLCA.sqlcode,1)
      END IF
      #-----No.FUN-6C0083 END-----
      RETURN
   END IF
  
   #3.調整單資料delete
   #   CALL s_del_imh()
   #   CALL s_del_imi()
   #   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
# Descriptions...: DROP TABLE
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_aft_work()
 
FUNCTION s_aft_work()
 
   DROP TABLE dis_table;
     #mark by TQC-620156
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('drop dis',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
   
   DROP TABLE odd_table;
     #mark by TQC-620156
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('drop odd',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
   
   DROP TABLE req_table;
     #mark by TQC-620156
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('drop req',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
   
   
   DROP TABLE dis_tot;
    #mark by TQC-620156
  #IF SQLCA.sqlcode THEN
  #   CALL cl_err('drop tot',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
    
END FUNCTION
 
# Descriptions...: CREATE TEMP TABLE
# Input parameter: NULL
# Return.........: NULL
# Usage..........: CALL s_cre_tmp_tab()
 
FUNCTION s_cre_tmp_tab()
  #用于拆箱的臨時表
 #DELETE FROM dis_table;   #No.FUN-610090 Mark
  DROP TABLE dis_table;   #No.FUN-610090 Mark #TQC-620156解除mark
  #No.FUN-680147 begin
  CREATE TEMP TABLE dis_table(
      hierarchy LIKE type_file.num5,  
      stat      LIKE type_file.num5,  
      unit      LIKE ade_file.ade04,
      fac       LIKE tsc_file.tsc10,
      qty       LIKE aqc_file.aqc05)
  #No.FUN-680147 end 
  IF SQLCA.sqlcode THEN
     LET g_success = 'N'
     #-----No.FUN-6C0083-----
     IF g_bgerr THEN
        CALL s_errmsg('','','create dis_table',SQLCA.sqlcode,1)
     ELSE
        CALL cl_err('create dis_table',SQLCA.sqlcode,1)
     END IF
     #-----No.FUN-6C0083 END-----
     RETURN
  END IF
  #拆箱過程中的零頭表
 #DELETE FROM odd_table;   #No.FUN-610090 Mark
  DROP TABLE odd_table;   #No.FUN-610090 Mark #TQC-620156解除mark
             #No.FUN-680147begin
  CREATE TEMP TABLE odd_table(
      unit LIKE ade_file.ade04,
      qty LIKE aqc_file.aqc05)
         #No.FUN-680147end
  IF SQLCA.sqlcode THEN
     LET g_success = 'N'
     #-----No.FUN-6C0083-----
     IF g_bgerr THEN
        CALL s_errmsg('','','create odd_table',SQLCA.sqlcode,1)
     ELSE
        CALL cl_err('create odd_table',SQLCA.sqlcode,1)
     END IF
     #-----No.FUN-6C0083 END-----
     RETURN
  END IF
  #需求單位/數量表
 #DELETE FROM req_table;   #No.FUN-610090 Mark
  DROP TABLE req_table;   #No.FUN-610090 Mark #TQC-620156解除mark
       #No.FUN-680147begin
  CREATE TEMP TABLE req_table(
      unit LIKE ade_file.ade04,
      fac LIKE tsc_file.tsc10,
      qty LIKE aqc_file.aqc05)
         #No.FUN-680147 end
  IF SQLCA.sqlcode THEN
     LET g_success = 'N'
     #-----No.FUN-6C0083-----
     IF g_bgerr THEN
        CALL s_errmsg('','','create req_table',SQLCA.sqlcode,1)
     ELSE
        CALL cl_err('create req_table',SQLCA.sqlcode,1)
     END IF
     #-----No.FUN-6C0083 END-----
     RETURN
  END IF
 #DELETE FROM dis_tot;   #No.FUN-610090 Mark
  DROP TABLE dis_tot;   #No.FUN-610090 Mark #TQC-620156解除mark
               #No.FUN-680147begin
  CREATE TEMP TABLE dis_tot(
         stat LIKE type_file.chr1,  
         unit LIKE ade_file.ade04,
         qty LIKE aqc_file.aqc05)
                  #No.FUN-680147 end 
  IF SQLCA.sqlcode THEN
     LET g_success = 'N'
     #-----No.FUN-6C0083-----
     IF g_bgerr THEN
        CALL s_errmsg('','','create dis_tot',SQLCA.sqlcode,1)
     ELSE
        CALL cl_err('create dis_tot',SQLCA.sqlcode,1)
     END IF
     #-----No.FUN-6C0083 END-----
     RETURN
  END IF
END FUNCTION
 
