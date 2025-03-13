# Prog. Version..: '5.30.06-13.03.26(00008)'     #
#
# Pattern name...: s_sizechk.4gl
# Descriptions...: 數量的建議
# Date & Author..: 90/12/27 By Wu 
# Usage..........: CALL s_sizechk(p_item,p_qty,p_lang)
# Input Parameter: p_item   料件編號
#                  p_qty    數量
#                  p_lang   語言別
# Return code....: l_qty    建議數量
# Modify.........: No.TQC-610105 06/03/24 By pengu 若參數設使用雙單位，純粹show出建議的數量不需詢問是否接受建議的數量
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.CHI-690051 06/11/15 By pengu 當"最小採購量"小於"採購批量"時，應default"採購批量
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-7C0175 07/12/29 By judy l_no定義量擴大
# Modify.........: No.MOD-820119 08/02/22 By chenl 修正MOD運算
# Modify.........: No.FUN-860106 08/08/06 By xiaofeizhu 多單位時的提示訊息改為"單據數量為xxx，建議數量為yyy，差異數量為yyy-xxx"
# Modify.........: NO.MOD-880192 08/08/25 By liuxqa l_no 修改其變量的定義 
# Modify.........: No.MOD-890207 08/09/22 By chenyu 計算建議數量的算法有誤
# Modify.........: No:MOD-AA0131 10/10/22 By Smapmin 使用MOD語法取餘數,若數值超過integer就會錯,故改寫取餘數的寫法
# Modify.........: No:MOD-B10029 11/01/05 By Summer 調整計算建議數量的算法
# Modify.........: No:CHI-B60077 11/08/26 By johung 新增g_confirm變數用來判斷是否提示建議數量訊息
# Modify.........: No:CHI-C10037 13/03/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS 
   DEFINE g_chr    LIKE type_file.chr1          #No.FUN-680147 VARCHAR(1)
END GLOBALS
 
#FUNCTION s_sizechk(p_item,p_qty,g_lang) #CHI-C10037 mark
FUNCTION s_sizechk(p_item,p_qty,g_lang,p_unit)  #CHI-C10037 add
DEFINE
    p_item     LIKE ima_file.ima01,
    p_qty      LIKE pml_file.pml20,
    p_unit     LIKE ima_file.ima25,          #CHI-C10037 add
    g_lang     LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
    l_ima45    LIKE ima_file.ima45,
    l_ima46    LIKE ima_file.ima46,
    l_ima44    LIKE ima_file.ima44,  #No.TQC-610105 add
    l_ima25    LIKE ima_file.ima25,          #CHI-C10037 add
    g_msg      LIKE zaa_file.zaa08,          #No.FUN-680147 VARCHAR(60)
    l_msg      LIKE zaa_file.zaa08,          #No.FUN-680147 VARCHAR(60)            #No.TQC-610105 add
    l_qty      LIKE ima_file.ima46,          #No.FUN-680147 DECIMAL(11,3)
    l_test     LIKE ima_file.ima46,          #No.FUN-680147 DECIMAL(11,3) 
#   l_no       LIKE type_file.num10          #No.FUN-680147 INTEGER #TQC-7C0175
#   l_no       LIKE pml_file.pml20,          #TQC-7C0175 No.MOD-880192 mark by liuxqa
    l_no       LIKE type_file.num20,         #No.MOD-880192 modify by liuxqa
#   l_no1      LIKE type_file.chr20,         #No.MOD-820119  #No.MOD-890207 mark
#   l_no2      LIKE type_file.chr20,         #No.MOD-820119  #No.MOD-890207 mark
    l_no1      LIKE type_file.num20,         #No.MOD-820119  #No.MOD-890207 add
    l_no2      LIKE type_file.num20,         #No.MOD-820119  #No.MOD-890207 add
    l_no3      LIKE type_file.num20,         #MOD-AA0131
    l_qty1     LIKE ima_file.ima46,          #No.FUN-860106
    l_msg1     LIKE zaa_file.zaa08,          #No.FUN-860106
    l_msg2     LIKE zaa_file.zaa08           #No.FUN-860106
DEFINE l_mod   LIKE type_file.num20          #No.MOD-890207
DEFINE l_factor LIKE pml_file.pml09          #CHI-C10037 add
DEFINE l_result LIKE type_file.num5          #CHI-C10037 add
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET g_chr = ' '
   #SELECT ima45,ima46,ima44 INTO l_ima45,l_ima46,l_ima44 FROM ima_file    #No.TQC-610105 add ima44 #CHI-C10037 mark
    SELECT ima45,ima46,ima44,ima25 INTO l_ima45,l_ima46,l_ima44,l_ima25 FROM ima_file    #CHI-C10037 add ima25
                  WHERE ima01 = p_item
    IF SQLCA.sqlcode!=0  THEN 
       #CALL cl_err('cannot select ima_file',SQLCA.sqlcode,0) #FUN-670091
        CALL cl_err3("sel","ima_file",p_item,"",SQLCA.sqlcode,"","",0) #FUN-670091
    END IF
    #CHI-C10037 add start -----
    LET l_factor = 1
    CALL s_umfchk(p_item,l_ima25,p_unit) RETURNING l_result,l_factor
    IF l_result = 1 THEN
       LET l_factor = 1
    END IF
    LET l_ima45 = l_ima45 * l_factor
    LET l_ima46 = l_ima46* l_factor
    #CHI-C10037 add start -----
    IF l_ima45 IS NULL OR l_ima45 = ' ' OR l_ima46 IS NULL OR l_ima46 = ' ' 
      THEN  CALL cl_err(l_ima45,'mfg0045',1)
			RETURN p_qty
    END IF
    IF p_qty < l_ima46 THEN
      #--------No.CHI-690051 add
       #當"最小採購數量"小於"採購批量"時，建議default"採購批量"
       IF l_ima46 < l_ima45 THEN
          LET l_ima46 = l_ima45
       END IF
      #--------No.CHI-690051 end
      #---------No.TQC-610105 add
       IF g_sma.sma115 = 'Y' THEN
          #LET l_msg = trimleft( cstr(l_ima46)) CLIPPED,l_ima44 CLIPPED                  #FUN-860106 Mark    
          LET l_msg = l_ima46 USING '<<<<',l_ima44 CLIPPED                               #FUN-860106
          LET l_msg1 = p_qty USING '<<<<',l_ima44 CLIPPED                                #FUN-860106  
          LET l_qty1 = l_ima46 - p_qty                                                   #FUN-860106
          LET l_msg2 = l_qty1 USING '<<<<',l_ima44 CLIPPED                               #FUN-860106     
#         CALL cl_err(l_msg,'mfg0052',1)                                                 #FUN-860106 Mark
          CALL cl_err_msg("","apm-205",l_msg1 CLIPPED|| "|" || l_msg CLIPPED|| "|" || l_msg2 CLIPPED,5)  #FUN-860106
          LET l_qty = p_qty
       ELSE
     #--------No.TQC-610105 end
          IF cl_null(g_confirm) OR g_confirm = '0' THEN   #CHI-B60077 add
             LET g_msg='(',l_ima46,')',':'
             IF cl_confirm2('mfg0047',g_msg) THEN  #MOD-4A0154
               LET l_qty = l_ima46
#CHI-B60077 -- begin --
                IF g_prog[1,7] = 'apmp570' THEN
                   LET g_confirm = '1'
                END IF
#CHI-B60077 -- end --
             ELSE
                LET l_qty = p_qty
#CHI-B60077 -- begin --
                IF g_prog[1,7] = 'apmp570' THEN
                   LET g_confirm = '2'
                END IF
#CHI-B60077 -- end --
             END IF
#CHI-B60077 -- begin --
          ELSE
             IF g_confirm = '1' THEN
                LET l_qty = l_ima46
             END IF
          END IF
#CHI-B60077 -- end --
       END IF      #----No.TQC-610105 add
    ELSE 
         IF l_ima45 = 0 THEN 
              LET l_no = 0
        #No.+197 010614 plum mod 
        #ELSE LET l_no = p_qty MOD l_ima45 
         ELSE 
           LET l_no1= p_qty*1000        #No.MOD-820119  
           LET l_no2= l_ima45*1000      #No.MOD-820119 
           #-----MOD-AA0131---------
           #LET l_no = l_no1 MOD l_no2   #No.MOD-820119 
           LET l_no3 = (l_no1 / l_no2) + 0.5 - 1
           LET l_no = l_no1 - (l_no3 * l_no2)
           #-----END MOD-AA0131-----
          #LET l_no = (p_qty*1000) MOD (l_ima45*1000) #No.MOD-820119
        #No.+197..end
         END IF
         IF l_no != 0 THEN 
           #-----------No.TQC-610105 add
             IF g_sma.sma115 = 'Y' THEN
                LET l_msg = l_qty CLIPPED,l_ima44 CLIPPED
                CALL cl_err(l_msg,'mfg0052',1)
                LET l_qty = p_qty
             ELSE
          #-----------No.TQC-610105 end
               #No.MOD-890207 modify --begin
               #原來的算法是四舍五入的，這樣算出來的就不是最小倍數
               #LET l_no = p_qty / l_ima45
               #MOD-B10029 mod --start--
               #LET l_mod = p_qty MOD l_ima45
               #LET l_no = (p_qty-l_mod)/l_ima45
                LET l_no1 = p_qty * 1000
                LET l_no2 = l_ima45 * 1000
                LET l_no3 = (l_no1 / l_no2) + 0.5 - 1
                LET l_mod = l_no1 - (l_no3 * l_no2)
                LET l_no = (l_no1 - l_mod)/l_no2
               #MOD-B10029 mod --end--
               #No.MOD-890207 modify --end
                LET l_qty = ( l_no + 1 ) * l_ima45
                IF cl_null(g_confirm) OR g_confirm = 0 THEN   #CHI-B60077 add
                   LET g_msg='(',l_qty,')',':'
                   IF NOT cl_confirm2('mfg0047',g_msg) THEN  #MOD-4A0154
                      LET l_qty = p_qty
#CHI-B60077 -- begin --
                      IF g_prog[1,7] = 'apmp570' THEN
                         LET g_confirm = '2'
                      END IF
                   ELSE
                      IF g_prog[1,7] = 'apmp570' THEN
                         LET g_confirm = '1'
                      END IF
#CHI-B60077 -- end --
                   END IF
                END IF                       #CHI-B60077 add
             END IF       #--No.TQC-610105 add
         ELSE LET l_qty = p_qty
         END IF
    END IF
   RETURN l_qty
END FUNCTION
