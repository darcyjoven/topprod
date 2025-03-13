# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Program name...: s_shortqty.4gl
# Descriptions...: 欠料量計算
# Date & Author..: NO.FUN-940008 2009/04/09 By hongmei
# Usage..........: s_shortqty(p_sfa01,p_sfa03,p_sfa08,p_sfa12,p_sfa27)
# Input Parameter: p_sfa01     工單編號
#                  p_sfa03     料件編號 
#                  p_sfa08     作業編號 
#                  p_sfa12     發料單位   
#                  p_sfa27     被替代料號
#
# Memo...........:1、欠料量=已發套數*QPA-已發數量,在有替代料的情況下，
#                    要先將替代料的已發量折算為主料,然后加上主料的已發量，
#                    作為已發數量，去推算是否欠料，若不欠料，則主料和替代料的欠料量都為0，
#                    否則則把替代量優先給主料，主料不夠量，則依替代順序給于替代料
#                   (產品A:生產150套,那麼應發量為：
#                    主料應發100，替代料應發50，替代率為1
#                    實際成套發料了80套,回寫工單單頭的已發套數為80,
#                    因為欠料數量不會回寫工單單身，所以我們不知道欠料量，
#                    因為欠料量的計算公式為:QPA*已發套數-已發數量(不是應發-已發)
#                    實際發料的狀況：主料發料：50,替代料的發料為30，
#                    所以，在這個數字看來，折算回主料的發料量應該是不欠料的，
#                    但是單獨從主料，或者單獨從替代料的角度看都是欠料的，
#                    所以不能簡單的用減法
#                    如果實際發料的狀況:主料:40,替代料發料:20,
#                    那麼總的看來，應該總欠料量為20，
#                    但是這20個究竟是算做主料的欠料呢，還是算替代料的欠料呢,
#                    如果按照主料和替代料的應發配比來分攤，
#                    此例子中主料：替代料=2：1
#                    那麼主料在發料80套的情況下應發為80*2/3,
#                    會出現分攤出小數的問題，所以我先把這20個欠料先給主料，
#                    在已發40+20
#                    小于套數80的應發的情況下，那麼表示把欠料都歸在主料上！
#                    如果實際發料套數為120套,主料：90，替代料:10的情況下，
#                    那麼總的欠料量為20,但是由于主料的應發量為90，
#                    所以肯定主料不欠料了，就把這20個欠料量歸在替代料上
#                    所以原則是：替代量+發料量必須小于已發套數折合出的應發量，還必須小于此料的應發量)
#                 2、傳入sfa的新key:工單編號,BOM料號,發料料號,作業編號,發料單位
#                 3、返回值為欠料量
#                 4、舉例：
#                    成品 A 的下階 有兩原料 B 和 C，單位用量都是1，假設發料單位都相同。
#                    假設：
#                    1.A的生產數量(sfb08)為100
#                    2.打了張成套發料，發料量(sfq03)為50，將生成完的第二單身的C料刪掉，
#                      并更改B料的發料量，也就是sfq03 = 50，但 B 的發料量(sfs05) = 30,
#                      C 的發料量(sfs05)  = 0 (整筆刪除)，將此成套發料單過賬后(如果不走套數管理)，
#                      B 的sfa06 = 30 , C 的sfa06 = 0
#                      結果(如果不走套數管理)：
#                      最大發料套數 = 30 (推算  sfb081 =30 , sfq03 = 30 , sfq08 = 50)
#                      最小發料套數 = 0  (C未發料，故不足一套)
#                      如果B料的作業編號是制程首站的話：
#                          ecm301 = 0 (因為最小套數是0)
#                      另外如果B料有替代料B1，假設替代率是1:1，如果B1料單獨發了 5。
#                      則最大發料套數 = 30 + 5 =35
#                 5、步驟：
#                    1.計算總已發量(A)：
#                      將主料和替代料的已發量加總，直接用每顆料的sfa06加總：
#                      考慮每顆料的發料單位可能不同，先統一轉換為主料的發料單位后再加總
#                    2.計算總應發量(B)：
#                      將主料和替代料的應發量加總，加總時不可直接用sfa05加總，
#                      需逐顆料以sfb081*個別料的sfa161(實際QPA)，但因為替代料的 sfa161 會是0，
#                      所以需判斷當sfa161為0時，需以主料的sfa161來計算
#                    3.計算總欠料量(C)：
#                      總欠料量(C) = 總應發量(B) - 總已發量(A)
#                    4.將總欠料量分配到主料和替代料：
#                      總欠料量先分配給主料，分配量不可超過sfa05，若欠料量還有剩也就是沒分配完，
#                      再分配給其他替代料，在分配給各顆料時，
#                      需將欠料量單位轉換為該顆料的sfa12(因為先前加總欠料量時是以主料的ima55單位計)                      

# Modify.........: No.TQC-9A0194 09/10/30 By kim GP5.2發料改善測試修改
# Modify.........: No.TQC-9C0170 09/12/24 By kim GP5.2發料改善測試修改
# Modify.........: No.FUN-9C0040 10/01/28 By jan 回收料時欠料量為0
# Modify.........: No.FUN-A50066 10/06/22 By jan 加傳sfa012,sfa013及處理相關程式
# Modify.........: No:FUN-A60095 10/07/23 By kim 可發/可退量要考慮盤盈虧量
# Modify.........: No:TQC-AB0374 10/12/03 By kim 欠料量的計算考慮報廢量
# Modify.........: No:FUN-B50059 11/05/12 By kim 還原FUN-A60095中,和sfa064有關的所有調整
# Modify.........: No:MOD-B80169 11/08/17 By lilingyu工單中有未發料的料號,但是單身的欠料量顯示為0
# Modify.........: No:MOD-B80223 11/08/22 By zhangll 修改因qpa小数误差导致sfb081>sfb08,无法过账
# Modify.........: No:MOD-B80191 11/08/29 By suncx 欠料量的計算考慮超領部分
# Modify.........: No:TQC-BA0115 11/10/20 By suncx 還原MOD-B80191修改部分
# Modify.........: No.CHI-BA0050 11/10/24 By kim 計算最大套數時要排除消耗性料件
# Modify.........: No.CHI-C10004 12/01/04 By ck2yuan 報廢量不列入欠料量,應打超領單 故還原TQC-AB0374
# Modify.........: No:MOD-C30814 12/03/30 By ck2yuan 計算欠料量應扣除委外代買量
# Modify.........: No.MOD-C40147 12/03/30 By ck2yuan 錯誤代碼[abm-731]加show料,以便辯別
# Modify.........: No.MOD-C70023 12/07/03 By Sakura 修正MOD-C30814，計算欠料量應扣除委外代買量(包含替代料)
# Modify.........: No:MOD-C70191 12/07/18 By ck2yuan 欠料分配到主料與取替代料時應考慮委外代買量
# Modify.........: No:MOD-C70286 12/08/09 By ck2yuan 因委外入庫會回寫到sfa06,所以欠料應加回委外入庫量
# Modify.........: No:MOD-CC0013 12/12/26 BY Elise 過帳還原增加排除狀態X

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE g_asft803_flag  LIKE type_file.num5
DEFINE g_new_sfa05     LIKE sfa_file.sfa05
DEFINE g_new_sfa161    LIKE sfa_file.sfa161
DEFINE g_new_sfa03     LIKE sfa_file.sfa03
DEFINE g_new_sfa12     LIKE sfa_file.sfa12
 
FUNCTION s_shortqty(p_sfa01,p_sfa03,p_sfa08,p_sfa12,p_sfa27,p_sfa012,p_sfa013)   #FUN-A50066
    DEFINE l_issue_qty    LIKE sfa_file.sfa06    #暫存數量
    DEFINE l_short_qty    LIKE sfa_file.sfa06    #暫存數量
    DEFINE l_short_qty_t  LIKE sfa_file.sfa06    #add by guanyao160831 
    DEFINE l_qty          LIKE sfa_file.sfa06    #暫存數量
   #DEFINE l_qty1         LIKE sfa_file.sfa063   #暫存數量 #TQC-AB0374  #CHI-C10004 mark
    DEFINE l_i            LIKE type_file.num10
    DEFINE l_m_qpa        LIKE sfa_file.sfa161   #主料的實際QPA
    DEFINE l_m_gfe03      LIKE gfe_file.gfe03
    DEFINE l_m_ima55      LIKE ima_file.ima55
    DEFINE l_m_ima55_fac  LIKE ima_file.ima55_fac
    DEFINE lr_sfa     RECORD 
              sfb08       LIKE sfb_file.sfb08,
              sfb081      LIKE sfb_file.sfb081,
              sfa03       LIKE sfa_file.sfa03,
              sfa05       LIKE sfa_file.sfa05,
              sfa06       LIKE sfa_file.sfa06,
              sfa12       LIKE sfa_file.sfa12,
              sfa161      LIKE sfa_file.sfa161,
              sfa26       LIKE sfa_file.sfa26,
              sfa28       LIKE sfa_file.sfa28,
              ima55_fac   LIKE ima_file.ima55_fac, #(sfa12) 對(sfa27的ima55) 的單位轉換率
              gfe03       LIKE gfe_file.gfe03,
              sfa08       LIKE sfa_file.sfa08,
              sfa11       LIKE sfa_file.sfa11, #TQC-9A0194
              sfa065      LIKE sfa_file.sfa065, #MOD-C70191 add  #MOD-C70286 add,
              rvv17       LIKE rvv_file.rvv17   #MOD-C70286 add
             #sfa063      LIKE sfa_file.sfa063  #TQC-AB0374  #CHI-C10004 mark
              #sfa062      LIKE sfa_file.sfa062  #MOD-B80191   #TQC-BA0115 mark
                      END RECORD 
    DEFINE l_sfa      DYNAMIC ARRAY OF RECORD
              sfb08       LIKE sfb_file.sfb08,    
              sfb081      LIKE sfb_file.sfb081,   
              sfa03       LIKE sfa_file.sfa03,
              sfa05       LIKE sfa_file.sfa05,    
              sfa06       LIKE sfa_file.sfa06,    
              sfa12       LIKE sfa_file.sfa12,    
              sfa161      LIKE sfa_file.sfa161,   
              sfa26       LIKE sfa_file.sfa26,    
              sfa28       LIKE sfa_file.sfa28,    
              ima55_fac   LIKE ima_file.ima55_fac, #(sfa12) 對(sfa27的ima55) 的單位轉換率
              gfe03       LIKE gfe_file.gfe03,
              sfa08       LIKE sfa_file.sfa08,
              sfa11       LIKE sfa_file.sfa11, #TQC-9A0194
              sfa065      LIKE sfa_file.sfa065, #MOD-C70191 add  #MOD-C70286 add,
              rvv17       LIKE rvv_file.rvv17   #MOD-C70286 add
             #sfa063      LIKE sfa_file.sfa063 #TQC-AB0374   #CHI-C10004 mark
              #sfa062      LIKE sfa_file.sfa062  #MOD-B80191   #TQC-BA0115 mark
                      END RECORD 
    DEFINE l_msg          STRING
    DEFINE p_sfa01        LIKE sfa_file.sfa01
    DEFINE p_sfa03        LIKE sfa_file.sfa03
    DEFINE p_sfa08        LIKE sfa_file.sfa08
    DEFINE p_sfa12        LIKE sfa_file.sfa12
    DEFINE p_sfa27        LIKE sfa_file.sfa27
    DEFINE l_sql          STRING
    DEFINE l_cnt          LIKE type_file.num5
    DEFINE l_sfa03        LIKE sfa_file.sfa03
    DEFINE l_tot_sfa05    LIKE sfa_file.sfa05
    DEFINE l_sfa05        LIKE sfa_file.sfa05
    DEFINE l_tot_shortqty LIKE sfa_file.sfa07
    DEFINE p_sfa012       LIKE sfa_file.sfa012   #FUN-A50066
    DEFINE p_sfa013       LIKE sfa_file.sfa013   #FUN-A50066
    DEFINE l_sfa065       LIKE sfa_file.sfa065   #MOD-C30814 add
    DEFINE l_sfa065_qty   LIKE sfa_file.sfa065   #MOD-C70023 add
    DEFINE l_rvv17_qty    LIKE sfa_file.sfa065   #MOD-C70286 add
    DEFINE l_sfb05        LIKE sfb_file.sfb05    #MOD-C80130 add

      
      #主料的發料單位
      SELECT ima55,gfe03 INTO l_m_ima55,l_m_gfe03
        FROM ima_file 
        LEFT OUTER JOIN gfe_file ON (ima_file.ima55 = gfe_file.gfe01)
       WHERE ima01 = p_sfa27
      IF l_m_gfe03 IS NULL THEN
         LET l_m_gfe03 = 0
      END IF
      
      #計算主料+替代料的總已發量
      LET l_issue_qty=0
      #計算主料+替代料的總應發量 
      LET l_tot_sfa05 = 0 
      CALL l_sfa.clear()
      LET l_sql = "SELECT sfb08,sfb081,sfa03,sfa05,sfa06,sfa12,sfa161,",   #FUN-B50059
                  "       sfa26,sfa28,0,gfe03,sfa08,sfa11,", #TQC-9A0194 add sfa11 #FUN-A50066 #TQC-AB0374 #CHI-C10004 拿掉TQC-AB0374的sfa063  #mod-C30814 add ,
                  "       sfa065,0,sfb05 ",               #MOD-C30814 add  #MOD-C70286 add ,0,sfb05
                  "  FROM sfb_file,sfa_file",
                  "  LEFT OUTER JOIN gfe_file",
                  "    ON (sfa_file.sfa12 = gfe_file.gfe01)",
                  " WHERE sfb01 = sfa01 ", 
                  "    AND sfa01 = '",p_sfa01,"' ",   #工單編號
                  "    AND sfa27 = '",p_sfa27,"' ",   #被替代料號
                  "    AND sfa08 = '",p_sfa08,"' ",   #MOD-B80169
                  "    AND sfa012= '",p_sfa012,"' ",  #FUN-A50066
                  "    AND sfa013= '",p_sfa013,"' ",  #FUN-A50066
                  "  ORDER BY sfa26,sfa27"            #欠料量計算順序
      PREPARE s_shortqty_pre FROM l_sql
      DECLARE s_shortqty_c CURSOR FOR s_shortqty_pre
     #FOREACH s_shortqty_c INTO lr_sfa.*,l_sfa065       #MOD-C30814 add ,l_sfa065  #MOD-C70191 mark
      FOREACH s_shortqty_c INTO lr_sfa.*,l_sfb05        #MOD-C70191 add   #MOD-C80130 add ,l_sfb05
         #TQC-9A0194(S)
         IF lr_sfa.sfa11 MATCHES '[EXS]' THEN #消耗性料件及不發料料件欠料量為0 #FUN-9C0040
            RETURN 0
         END IF
         #TQC-9A0194(E)
         CALL s_umfchk(p_sfa27,lr_sfa.sfa12,l_m_ima55) 
              RETURNING l_cnt,l_m_ima55_fac
         IF l_cnt = 1 THEN
           #LET l_msg = '(',lr_sfa.sfa12,') to (',l_m_ima55,')'             #MOD-C40147 mark
            LET l_msg = p_sfa27,'(',lr_sfa.sfa12,') to (',l_m_ima55,')'     #MOD-C40147 add
            CALL cl_err(l_msg,'abm-731',0)
            RETURN 0
         END IF
         # #當替代料號=BOM料號時,視為主料,因替代料的sfa161會為0,
         #故需以主料的實際QPA(sfa161)來看
         IF lr_sfa.sfa03=p_sfa27 THEN
            IF g_asft803_flag THEN   #工單變更單(asft803)需以變更后的實際QPA來試算欠料量
               IF (g_new_sfa161 IS NOT NULL) AND (g_new_sfa161 > 0) THEN  #工單變更單(asft803)有變更實際QPA
                  LET l_m_qpa = g_new_sfa161
               ELSE
                  LET l_m_qpa = lr_sfa.sfa161
               END IF
            ELSE
               LET l_m_qpa = lr_sfa.sfa161
            END IF
         END IF
         IF lr_sfa.gfe03 IS NULL THEN LET lr_sfa.gfe03 = 0 END IF
         #TQC-9C0170(S)
         IF lr_sfa.sfa28 = 0 OR lr_sfa.sfa28 IS NULL THEN
            LET lr_sfa.sfa28 = 1
         END IF
         #TQC-9C0170(E)
         LET l_i = l_sfa.getlength() + 1
         LET l_sfa[l_i].* = lr_sfa.*
         LET l_sfa[l_i].ima55_fac = l_m_ima55_fac
         LET l_qty = lr_sfa.sfa06 * l_m_ima55_fac / lr_sfa.sfa28 #TQC-9C0170
        #LET l_qty1= lr_sfa.sfa063 * l_m_ima55_fac / lr_sfa.sfa28 #TQC-AB0374   #CHI-C10004 mark
         IF l_qty IS NULL THEN LET l_qty = 0 END IF
        #IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF #TQC-AB0374  #CHI-C10004 mark
         LET l_qty = cl_digcut(l_qty,l_m_gfe03)
        #LET l_qty1= cl_digcut(l_qty1,l_m_gfe03) #TQC-AB0374  #CHI-C10004 mark
        #LET l_issue_qty = l_issue_qty + l_qty    #總已發量 -> 轉換成主料的發料單位 #TQC-AB0374
        #LET l_issue_qty = l_issue_qty + l_qty - l_qty1    #總已發量 -> 轉換成主料的發料單位 #TQC-AB0374   #CHI-C10004 mark
         LET l_issue_qty = l_issue_qty + l_qty  #CHI-C10004 add
         IF cl_null(l_sfa065_qty) THEN LET l_sfa065_qty = 0 END IF #MOD-C70023 add
        #LET l_sfa065_qty = l_sfa065_qty + l_sfa065 #MOD-C70023 add      #MOD-C70191 mark
         LET l_sfa065_qty = l_sfa065_qty + l_sfa[l_i].sfa065             #MOD-C70191 add        
        #MOD-C70286 str add-----
         IF cl_null(l_rvv17_qty) THEN LET l_rvv17_qty= 0 END IF
         IF l_sfa[l_i].sfa03 <> l_sfb05 THEN
            SELECT SUM(rvv17) INTO l_sfa[l_i].rvv17 FROM rvv_file,rvu_file
             WHERE rvv18=p_sfa01
               AND rvv31=lr_sfa.sfa03
               AND rvv01=rvu01
               AND rvuconf = 'Y'
         END IF
         IF cl_null(l_sfa[l_i].rvv17) THEN LET l_sfa[l_i].rvv17= 0 END IF
         LET l_rvv17_qty=l_rvv17_qty+l_sfa[l_i].rvv17
        #MOD-C70286 end add-----

         #判斷是否為工單變更單試算sfa05變更后的欠料量
         IF g_asft803_flag THEN
            IF (g_new_sfa03 = l_sfa[l_i].sfa03) AND
               (g_new_sfa12 = l_sfa[l_i].sfa12) THEN
               LET l_sfa[l_i].sfa05 = g_new_sfa05
            END IF
         END IF
         LET l_sfa[l_i].sfa05 = l_sfa[l_i].sfa05 * l_m_ima55_fac #將各顆料sfa05轉換成以主料的ima55計
         LET l_sfa[l_i].sfa06 = l_sfa[l_i].sfa06 * l_m_ima55_fac #將各顆料sfa06轉換成以主料的ima55計
        #LET l_sfa[l_i].sfa063= l_sfa[l_i].sfa063* l_m_ima55_fac #將各顆料sfa063轉換成以主料的ima55計  #TQC-AB0374   #CHI-C10004 mark
      END FOREACH
    
      IF l_sfa.getlength() = 0 THEN
         RETURN 0
      END IF
      
      ##計算主料+替代料的總應發量
      LET l_tot_sfa05 = lr_sfa.sfb081 * l_m_qpa
      
      #計算主料+替代料的總欠料量 
     #LET l_tot_shortqty = l_tot_sfa05 - l_issue_qty               #MOD-C30814 mark
     #LET l_tot_shortqty = l_tot_sfa05 - l_issue_qty - l_sfa065    #MOD-C30814 add #MOD-C70023 mark
     #LET l_tot_shortqty = l_tot_sfa05 - l_issue_qty - l_sfa065_qty #MOD-C70023   #MOD-C70286 mark
      LET l_tot_shortqty = l_tot_sfa05 - l_issue_qty - l_sfa065_qty + l_rvv17_qty #MOD-C70286 add
       
      #總欠料量依序分配給主料和替代料,求得個別欠料量 
      FOR l_i = 1 TO l_sfa.getlength()
         LET l_short_qty = 0

         #TQC-9C0170 
         #l_tot_shortqty須是以主料計的數量,乘上替代率,才是目前計算的這顆替代料的相對應需求數量
         LET l_tot_shortqty = l_tot_shortqty * l_sfa[l_i].sfa28

         IF l_tot_shortqty > 0 THEN
            #若推算應發量 > 應發(sfa05),則以sfa05為准
           #IF l_tot_shortqty > l_sfa[l_i].sfa05 THEN                         #MOD-C70191 mark
           #IF l_tot_shortqty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa065) THEN   #MOD-C70191 add   #MOD-C70286 mark
            IF l_tot_shortqty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa065 + l_sfa[l_i].rvv17) THEN  #MOD-C70286 add
              #LET l_short_qty = l_tot_shortqty - l_sfa[l_i].sfa05  #TQC-9C0170
              #LET l_short_qty = l_sfa[l_i].sfa05  #TQC-9C0170          #MOD-C70191 mark
              #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa065   #MOD-C70191 add   #MOD-C70286 mark
               LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa065 + l_sfa[l_i].rvv17  #MOD-C70286 add
               LET l_tot_shortqty = l_tot_shortqty - l_short_qty
            ELSE
               LET l_short_qty = l_tot_shortqty
               LET l_tot_shortqty = 0
            END IF
         END IF
 
        #欠料量的值最多只能為（應發-已發）的量，若超過則計給下一顆替代料
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06) THEN  #TQC-AB0374
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063) THEN  #TQC-AB0374 
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063 - l_sfa[l_i].sfa062) THEN #MOD-B80191
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063) THEN  #TQC-BA0115  #CHI-C10004 mark
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06) THEN   #CHI-C10004 add     #MOD-C70191 mark
        #IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065) THEN   #MOD-C70191 add  #MOD-C70286 mark
         IF l_short_qty > (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065 + l_sfa[l_i].rvv17) THEN #MOD-C70286 add
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06))
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063))  #TQC-AB0374
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063 - l_sfa[l_i].sfa062))  #MOD-B80191
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063))  #TQC-BA0115 #CHI-C10004 mark
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06)) #CHI-C10004 add)   #MOD-C70191 mark
           #LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065))    #MOD-C70191 add   #MOD-C70286 mark
            LET l_tot_shortqty = l_tot_shortqty + (l_short_qty - (l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065 + l_sfa[l_i].rvv17))   #MOD-C70286 add 
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06  #TQC-AB0374
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063  #TQC-AB0374
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063 - l_sfa[l_i].sfa062 #MOD-B80191
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 + l_sfa[l_i].sfa063  #TQC-BA0115 #CHI-C10004 mark
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06  #CHI-C10004 add      #MOD-C70191 mark
           #LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065   #MOD-C70191 add   #MOD-C70286 mark
            LET l_short_qty = l_sfa[l_i].sfa05 - l_sfa[l_i].sfa06 - l_sfa[l_i].sfa065 + l_sfa[l_i].rvv17  #MOD-C70286 add
         END IF
 
         IF l_sfa[l_i].sfa03 = p_sfa03   #只抓到該筆替代料號為止
            AND l_sfa[l_i].sfa08= p_sfa08 
            AND l_sfa[l_i].sfa12= p_sfa12 THEN  
            EXIT FOR
         END IF
 
         #總欠料數量已分配完,表示此料之后的欠料量皆為0 
         IF l_tot_shortqty = 0 THEN 
            LET l_short_qty = 0
            EXIT FOR
         END IF
         
         #TQC-9C0170
         #l_tot_shortqty是以主料計的數量,計算本顆替代料時,
         #在FOR 迴圈一開始乘上替代率轉換為替代料的用量後,須轉換為主料的數量,以便計算下顆料
         LET l_tot_shortqty = l_tot_shortqty / l_sfa[l_i].sfa28 
      END FOR
      
      #轉換回此料的單位
      IF l_sfa.getlength() >= l_i THEN
         CALL s_umfchk(l_sfa[l_i].sfa03,l_m_ima55,l_sfa[l_i].sfa12)
              RETURNING l_cnt,l_m_ima55_fac
         IF l_cnt = 1 THEN
           #LET l_msg = '(',l_m_ima55,') to (',l_sfa[l_i].sfa12,')'                  #MOD-C40147 mark
            LET l_msg = l_sfa[l_i].sfa03,'(',l_m_ima55,') to (',l_sfa[l_i].sfa12,')' #MOD-C40147 add
            CALL cl_err(l_msg,'abm-731',0)
            RETURN 0
         END IF
         LET l_short_qty = l_short_qty * l_m_ima55_fac
         LET l_short_qty_t = l_short_qty   #add by guanyao160831
         LET l_short_qty = cl_digcut(l_short_qty,l_sfa[l_i].gfe03)
         #str----add by guanyao160831#欠料的时候要进一位
         IF l_short_qty_t >l_short_qty THEN 
            SELECT ceil(power(10,l_sfa[l_i].gfe03)*l_short_qty_t)/power(10,l_sfa[l_i].gfe03) INTO l_short_qty FROM dual
         END IF 
         #end----add by guanyao160831
      END IF
      RETURN l_short_qty
END FUNCTION
 
#由備料檔單一主料(含此主料的取替代料)的總已發數量推算回單頭已發套數(sfb081)
#傳入參數.dbo.sfa_file的key值(排除sfa03,sfa12)
#回傳值兩個: 成功(TRUE)or失敗(FALSE) , 工單單頭已發套數
FUNCTION s_shortqty_master_sfa06(p_sfa01,p_sfa03,p_sfa08,p_sfa12,p_sfa27,p_sfa012,p_sfa013)  #FUN-A50066
DEFINE p_sfa01        LIKE sfa_file.sfa01
DEFINE p_sfa03        LIKE sfa_file.sfa03
DEFINE p_sfa08        LIKE sfa_file.sfa08
DEFINE p_sfa12        LIKE sfa_file.sfa12
DEFINE p_sfa27        LIKE sfa_file.sfa27
DEFINE l_issue_qty    LIKE sfa_file.sfa06      #暫存數量
DEFINE l_short_qty    LIKE sfa_file.sfa06      #暫存數量
DEFINE l_qty          LIKE sfa_file.sfa06      #暫存數量
DEFINE l_i            LIKE type_file.num10
DEFINE l_m_qpa        LIKE sfa_file.sfa161     #主料的實際QPA
DEFINE l_m_gfe03      LIKE gfe_file.gfe03
DEFINE l_m_ima55      LIKE ima_file.ima55
DEFINE l_m_sfa12      LIKE sfa_file.sfa12
DEFINE l_sfa12_fac    LIKE ima_file.ima55_fac 
DEFINE l_res_sfb081   LIKE sfb_file.sfb081
DEFINE l_m_ima55_fac  LIKE ima_file.ima55_fac
DEFINE l_msg          STRING
DEFINE l_sql          STRING
DEFINE lr_sfa      RECORD
          sfb08       LIKE sfb_file.sfb08,
          sfb081      LIKE sfb_file.sfb081,
          sfa03       LIKE sfa_file.sfa03,
          sfa05       LIKE sfa_file.sfa05,
          sfa06       LIKE sfa_file.sfa06,
          sfa12       LIKE sfa_file.sfa12,
          sfa161      LIKE sfa_file.sfa161,
          sfa26       LIKE sfa_file.sfa26,
          sfa28       LIKE sfa_file.sfa28,
          ima55_fac   LIKE ima_file.ima55_fac, #(sfa12) 對(sfa27的ima55) 的單位轉換率
          gfe03       LIKE gfe_file.gfe03,
          sfa08       LIKE sfa_file.sfa08  
                   END RECORD
DEFINE l_flag         LIKE type_file.num5
DEFINE l_cnt          LIKE type_file.num5
DEFINE p_sfa012       LIKE sfa_file.sfa012   #FUN-A50066
DEFINE p_sfa013       LIKE sfa_file.sfa013   #FUN-A50066
DEFINE l_need_qty     LIKE sfa_file.sfa06      #暫存數量  #MOD-B80223 总应发量
DEFINE l_qty2         LIKE sfa_file.sfa06      #暫存數量  #MOD-B80223 总应发量的计算
DEFINE l_sfb08        LIKE sfb_file.sfb08    #MOD-B80223 add
 
  #主料的發料單位
  SELECT ima55,gfe03 INTO l_m_ima55,l_m_gfe03
    FROM ima_file 
    LEFT OUTER JOIN gfe_file ON (ima_file.ima55 = gfe_file.gfe01)
   WHERE ima01 = p_sfa27
  IF l_m_gfe03 IS NULL THEN
     LET l_m_gfe03 = 0
  END IF
  
  #計算主料+替代料的總已發量
  LET l_issue_qty=0
  LET l_need_qty=0  #MOD-B80223 add
  LET l_sql = "SELECT sfb08,sfb081,sfa03,sfa05,sfa06,sfa12,sfa161,",   #FUN-B50059
              "       sfa26,sfa28,0,gfe03,sfa08",
              "  FROM sfb_file,sfa_file",
              "  LEFT OUTER JOIN gfe_file ",
              "    ON (sfa_file.sfa12 = gfe_file.gfe01)",
              " WHERE sfb01 = sfa01  ",
              "   AND sfa01 = '",p_sfa01,"'",  #工單編號
              "   AND sfa27 = '",p_sfa27,"'",  #被替代料號
              "   AND sfa012 ='",p_sfa012,"'", #FUN-A50066
              "   AND sfa013 ='",p_sfa013,"'", #FUN-A50066
              "   AND sfa06 > 0",     #FUN-B50059
              " ORDER BY sfa26,sfa27"          #欠料量計算順序
  
  PREPARE s_shortqty_master_sfa06_pre FROM l_sql
  DECLARE s_shortqty_master_sfa06_c CURSOR FOR s_shortqty_master_sfa06_pre
  FOREACH s_shortqty_master_sfa06_c INTO lr_sfa.*
     CALL s_umfchk(p_sfa27,lr_sfa.sfa12,l_m_ima55) RETURNING l_cnt,l_m_ima55_fac
     IF l_cnt = 1 THEN
       #LET l_msg = '(',lr_sfa.sfa12,') to (',l_m_ima55,')'         #MOD-C40147 mark
        LET l_msg = p_sfa27,'(',lr_sfa.sfa12,') to (',l_m_ima55,')' #MOD-C40147 add
        CALL cl_err(l_msg,'abm-731',0)
        RETURN FALSE,0
     END IF
     #當替代料號=BOM料號時,視為主料,因替代料的sfa161會為0,
     #故需以主料的實際QPA(sfa161)來看
     IF lr_sfa.sfa03=p_sfa27 THEN
        LET l_m_qpa =lr_sfa.sfa161
        LET l_m_sfa12 = lr_sfa.sfa12  #主料的sfa12
     END IF
     IF lr_sfa.gfe03 IS NULL THEN LET lr_sfa.gfe03 = 0 END IF
     #TQC-9C0170(S)
     IF lr_sfa.sfa28 IS NULL OR lr_sfa.sfa28 = 0 THEN
        LET lr_sfa.sfa28 = 1
     END IF
     #TQC-9C0170(E)
    #LET l_qty = lr_sfa.sfa06 * l_m_ima55_fac  #TQC-9C0170
     LET l_qty = lr_sfa.sfa06 * l_m_ima55_fac / lr_sfa.sfa28  #TQC-9C0170
     IF l_qty IS NULL THEN LET l_qty = 0 END IF
     LET l_qty = cl_digcut(l_qty,l_m_gfe03)
     LET l_issue_qty = l_issue_qty + l_qty    #總已發量 -> 轉換成主料的發料單位
     #MOD-B80223 add
     LET l_qty2= lr_sfa.sfa05 * l_m_ima55_fac / lr_sfa.sfa28  #TQC-9C0170
     IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
     LET l_qty2 = cl_digcut(l_qty2,l_m_gfe03)
     LET l_need_qty = l_need_qty + l_qty2     #總应發量 -> 轉換成主料的發料單位
     #MOD-B80223 add---end
  END FOREACH
  
  #如果主料還沒有發料,替代料先發料,則l_m_qpa會是NULL
  IF cl_null(l_m_qpa) THEN   
     LET l_sql = "SELECT sfa161,sfa12 FROM sfa_file ",
                 " WHERE sfa01 = '",p_sfa01,"'",
                 "   AND sfa03 = '",p_sfa27,"'",
                 "   AND sfa27 = '",p_sfa27,"'",
                 "   AND sfa08 = '",p_sfa08,"'",
                 "   AND sfa012 ='",p_sfa012,"'", #FUN-A50066
                 "   AND sfa013 ='",p_sfa013,"'", #FUN-A50066
                 " ORDER BY sfa12" 
     PREPARE s_shortqty_master_sfa06_pre2 FROM l_sql
     DECLARE s_shortqty_master_sfa06_c2 CURSOR FOR s_shortqty_master_sfa06_pre2
     FOREACH s_shortqty_master_sfa06_c2 INTO l_m_qpa,l_m_sfa12
        EXIT FOREACH                        
     END FOREACH
  END IF
 
  #MOD-B80223 add
  SELECT sfb08 INTO l_sfb08 FROM sfb_file
   WHERE sfb01 = p_sfa01
  #MOD-B80223 add--end

  #未有任何備料或已發數量
  IF l_issue_qty=0 THEN
     RETURN TRUE,0
  END IF
  
  #將總已發量,轉換為主料的備料單位,并以主料的實際QPA推算求實際已發套數(sfb081)
  CALL s_umfchk(p_sfa27,l_m_ima55,l_m_sfa12) 
       RETURNING l_cnt,l_sfa12_fac
  IF l_cnt = 1 THEN
    #LET l_msg = '(',l_m_ima55,') to (',l_m_sfa12,')'          #MOD-C40147 mark
     LET l_msg = p_sfa27,'(',l_m_ima55,') to (',l_m_sfa12,')'  #MOD-C40147 add
     CALL cl_err(l_msg,'abm-731',0)
     RETURN 0
  END IF
  LET l_issue_qty =l_issue_qty * l_sfa12_fac
  LET l_need_qty =l_need_qty * l_sfa12_fac  #MOD-B80223 add
  IF l_m_qpa = 0 THEN
     LET l_flag = FALSE
     LET l_res_sfb081 = 0
  ELSE
     LET l_flag = TRUE
    #LET l_res_sfb081 = l_issue_qty / l_m_qpa
     LET l_res_sfb081 = l_issue_qty * l_sfb08 / l_need_qty   #MOD-B80223 mod
  END IF
  
  #主料的小數字數處理(依主料的備料單位)
  SELECT gfe03 INTO l_m_gfe03
               FROM gfe_file
              WHERE gfe01 = l_m_sfa12
  IF l_m_gfe03 IS NULL THEN
     LET l_m_gfe03 = 0
  END IF
 
  LET l_res_sfb081 = cl_digcut(l_res_sfb081,l_m_gfe03)
  
  IF cl_null(l_res_sfb081) THEN
     LET l_res_sfb081 = 0
  END IF
  RETURN l_flag,l_res_sfb081
 
END FUNCTION
 
 
#由備料檔全部主料(含各主料的取替代料)的各總已發數量推算"最大"已發套數(sfb081)
#傳入參數.dbo.sfb_file的key值
#回傳值兩個: 成功(TRUE)or失敗(FALSE) , 工單單頭"最大"已發套數
 
FUNCTION s_shortqty_max_sfb081(p_sfb01)
DEFINE lr_sfa    RECORD
          sfa01     LIKE sfa_file.sfa01, 
          sfa03     LIKE sfa_file.sfa03,
          sfa08     LIKE sfa_file.sfa08,
          sfa12     LIKE sfa_file.sfa12,
          sfa27     LIKE sfa_file.sfa27,
          sfa012    LIKE sfa_file.sfa012, #FUN-A50066
          sfa013    LIKE sfa_file.sfa013  #FUN-A50066
                 END RECORD
DEFINE l_flag       LIKE type_file.num5
DEFINE l_res_sfb081 LIKE sfb_file.sfb081
DEFINE l_max_sfb081 LIKE sfb_file.sfb081
DEFINE l_m_gfe03    LIKE gfe_file.gfe03
DEFINE p_sfb01      LIKE sfb_file.sfb01
DEFINE l_sql        STRING
  
  LET l_flag = TRUE
  LET l_max_sfb081 = 0
  LET l_sql = "SELECT sfa01,sfa03,sfa08,sfa12,sfa27,sfa012,sfa013",  #FUN-A50066
              "  FROM sfa_file",
              " WHERE sfa01= '",p_sfb01,"'",
              "   AND sfa11 NOT IN ('E','S','X') ", #CHI-BA0050  #MOD-CC0013 add X
              "    AND sfa06 > 0 "  #FUN-B50059
  PREPARE s_shortqty_max_sfb081_pre FROM l_sql            
  DECLARE s_shortqty_max_sfb081_c CURSOR FOR s_shortqty_max_sfb081_pre
  FOREACH s_shortqty_max_sfb081_c INTO lr_sfa.*
     CALL s_shortqty_master_sfa06(lr_sfa.sfa01,lr_sfa.sfa03,lr_sfa.sfa08,
                                  lr_sfa.sfa12,lr_sfa.sfa27,lr_sfa.sfa012,lr_sfa.sfa013)  #FUN-A50066
        RETURNING l_flag,l_res_sfb081
     IF NOT l_flag THEN
        LET l_max_sfb081 = 0
        EXIT FOREACH
     END IF
     IF l_res_sfb081 > l_max_sfb081 THEN
        LET l_max_sfb081 = l_res_sfb081
     END IF
  END FOREACH
 
  #過程中皆未有錯誤,則處理已發套數(sfb081)的小數取位,
  #因單身實際QPA對單頭已發套數,已包含單位轉換的成份,故不必進行單位轉換
  IF l_flag THEN
     SELECT gfe03 INTO l_m_gfe03
                  FROM sfb_file,ima_file
       LEFT OUTER JOIN gfe_file ON (ima_file.ima55 = gfe_file.gfe01)                                    
                 WHERE ima01 = sfb05
                   AND sfb01 = p_sfb01
     IF l_m_gfe03 IS NULL THEN
        LET l_m_gfe03 = 0
     END IF     
     LET l_max_sfb081 = cl_digcut(l_max_sfb081,l_m_gfe03)
  END IF
  RETURN l_flag,l_max_sfb081
END FUNCTION
 
FUNCTION s_shortqty_asft803_open(p_sfa03,p_sfa08,p_sfa12,p_new_sfa05,p_new_sfa161)
DEFINE p_sfa03      LIKE sfa_file.sfa03
DEFINE p_sfa08      LIKE sfa_file.sfa08
DEFINE p_sfa12      LIKE sfa_file.sfa12
DEFINE p_new_sfa05  LIKE sfa_file.sfa05
DEFINE p_new_sfa161 LIKE sfa_file.sfa161
 
   LET g_asft803_flag = TRUE
   LET g_new_sfa05  = p_new_sfa05
   LET g_new_sfa161 = p_new_sfa161
END FUNCTION
 
FUNCTION s_shortqty_asft803_close()
   LET g_asft803_flag = FALSE
END FUNCTION
#FUN-940008
