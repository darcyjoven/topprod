# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: apmp610_sub.4gl
# Description....: 提供apmp610.4gl使用的sub routine
# Date & Author..: 10/09/17 By kim (FUN-A80102)
# Modify.........: No.FUN-AA0015 10/10/07 By Nicola 預設pmh25 
# Modify.........: No.MOD-AA0030 10/10/22 By Smapmin 委外採購發出回寫pmh_file時,單價為0時不回寫
# Modify.........: No.FUN-B50046 11/05/19 By abby APS GP5.25追版 str-------------------------------
# Modify.........: No.FUN-9A0066 09/10/28 By Mandy 當有串APS時,(1)委外工單(2)製程委外 採購發出後需做的處理
# Modify.........: No.FUN-B50046 11/05/19 By abby APS GP5.25追版 end-------------------------------
# Modify.........: No.MOD-B80260 11/09/02 By johung ICD行業時回寫pmniicd03到pmh21

DATABASE ds
 
#GLOBALS "../../config/top.global"  #mark by guanyao160512
GLOBALS "../../../tiptop/config/top.global"   #add by guanyao160512

#FUN-A80102
DEFINE g_pmm22     LIKE pmm_file.pmm22      # Curr
DEFINE g_pmm42     LIKE pmm_file.pmm42      # Ex.Rate
DEFINE g_ima53     LIKE ima_file.ima53 
DEFINE g_ima531    LIKE ima_file.ima531 
DEFINE g_ima532    LIKE ima_file.ima532 

FUNCTION p610sub_update(p_pmm01,p_CALL_transaction)
   DEFINE
      p_pmm01   LIKE pmm_file.pmm01,    #採購單號
      l_pmn20   LIKE pmn_file.pmn20,    #訂購量
      l_pmn04   LIKE pmn_file.pmn04,    #料件編號　
      l_pmn31   LIKE pmn_file.pmn31,    #單價
      l_pmn31t  LIKE pmn_file.pmn31t,   #No.FUN-610018
      l_pmn43   LIKE pmn_file.pmn43,    #No.FUN-670099
      l_pmn18   LIKE pmn_file.pmn18,    #MOD-870163
      l_pmm21   LIKE pmm_file.pmm21,    #No.FUN-610018
      l_pmm43   LIKE pmm_file.pmm43,    #No.FUN-610018
      l_pmn41   LIKE pmn_file.pmn41,    #工單號碼
      l_pmn09   LIKE pmn_file.pmn09,    #轉換因子
      l_sql     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(300)
     #MOD-730044-begin-add
      l_pmn07     LIKE pmn_file.pmn07,      #採購單位
      l_pmn86     LIKE pmn_file.pmn86,      #計價單位
      l_pmn012    LIKE pmn_file.pmn012,     #FUN-A60027
      l_pmniicd03        LIKE pmni_file.pmniicd03,        #MOD-B80260 add
      l_pmn31_u_exp_p   LIKE pmn_file.pmn31,
      l_pmn31t_u_exp_p  LIKE pmn_file.pmn31t,  
      l_ima44     LIKE ima_file.ima44,    
      l_ima908    LIKE ima_file.ima908,    
      l_unitrate  LIKE pmn_file.pmn121,  
      l_sw        LIKE type_file.num10,               
     #MOD-730044-end-add
      l_pmm	RECORD LIKE pmm_file.*,
      p_CALL_transaction LIKE type_file.num5  #FUN-A80102
DEFINE l_tc_sfp01    LIKE tc_sfp_file.tc_sfp01
 
   IF p_CALL_transaction THEN
      BEGIN WORK
   END IF

   SELECT * INTO l_pmm.* FROM pmm_file WHERE pmm01 = p_pmm01
   #==>更改採購單頭狀況碼,為(已發出)
      UPDATE pmm_file SET pmm25 = '2'
       WHERE pmm01 = p_pmm01
      IF SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
#        CALL cl_err('(apmp610:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pmm_file",p_pmm01,"",SQLCA.sqlcode,"","(apmp610:ckp#1)",1)  #No.FUN-660129
         RETURN
      END IF
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err(p_pmm01,SQLCA.sqlcode,1)
         RETURN
     END IF
   {ckp#2}
   #==>更改採購單身狀況碼,為(已發出)
   UPDATE pmn_file SET pmn16 = '2'
    WHERE pmn01 = p_pmm01
      AND pmn16<'6'            #MOD-630039 不包括6,7,8(結案);9(作廢)
   IF SQLCA.sqlerrd[3] = 0 THEN
      LET g_success = 'N'
#     CALL cl_err('(apmp610:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660129
      CALL cl_err3("upd","pmn_file",p_pmm01,"",SQLCA.sqlcode,"","(apmp610:ckp#2)",1)  #No.FUN-660129
      RETURN
   END IF
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(p_pmm01,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   {ckp#3}
   #==>更改廠商資料檔中的最近採購日期
   UPDATE pmc_file SET pmc40 = l_pmm.pmm04   #最近採購日期
       WHERE pmc01 = l_pmm.pmm09
      IF SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
#        CALL cl_err('(apmp610:ckp#3)',SQLCA.sqlcode,1)   #No.FUN-660129
         CALL cl_err3("upd","pmc_file",l_pmm.pmm09,"",SQLCA.sqlcode,"","(apmp610:ckp#3)",1)  #No.FUN-660129
         RETURN
      END IF
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         CALL cl_err(p_pmm01,SQLCA.sqlcode,1)
         RETURN
      END IF
 
   #==>更新[料件主檔]最近採購單價,在外量
   LET l_sql = " SELECT pmn04,pmn31,pmn31t,pmn41,pmn20,pmn09,",  #No.FUN-610018
               "        ima53,ima531,ima532,pmm22,pmm42,pmn43 ", #No.FUN-670099
               "       ,pmn07,ima44,ima908,pmn86,pmn18,pmn012 ",              #MOD-730044 modify   #MOD-870163增加pmn18  #FUN-A60027 add pmn012
               "       ,pmniicd03 ",                             #MOD-B80260 add
#              " FROM pmn_file,ima_file,pmm_file",               #MOD-B80260 mark
#MOD-B80260 -- begin --
               " FROM pmn_file LEFT OUTER JOIN pmni_file",
               "   ON pmn01 = pmni01 AND pmn02 = pmni02",
               " ,ima_file,pmm_file",
#MOD-B80260 -- end --
               " WHERE pmn01 = '",p_pmm01,"'",
               " AND pmn01 = pmm01 AND ima01 = pmn04 "
 
   PREPARE p610_pl FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare p610_p1 :',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE p610_cur2  CURSOR FOR p610_pl
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare p610_cur2 :',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH p610_cur2 INTO l_pmn04,l_pmn31,l_pmn31t,l_pmn41,l_pmn20,l_pmn09,    #No.FUN-610018
                          g_ima53,g_ima531,g_ima532,
                          g_pmm22,g_pmm42,l_pmn43           #No.FUN-670099
                         ,l_pmn07,l_ima44,l_ima908,l_pmn86,l_pmn18,l_pmn012  #MOD-730044   #MOD-870163增加pmn18  #FUN-A60027 add pmn012
                         ,l_pmniicd03                                        #MOD-B80260 add
      IF SQLCA.sqlcode THEN
#No.FUN-710030 -- begin --
#         CALL cl_err('Foreach p610_cur2 :',SQLCA.sqlcode,1)
         IF g_bgerr THEN
            CALL s_errmsg("","","Foreach p610_cur2 :",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","Foreach p610_cur2 :",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
 
      #轉換成庫存單位
      LET l_pmn20 = l_pmn20*l_pmn09
      #更改單價,委外量
      SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43
        FROM pmm_file
       WHERE pmm01 = p_pmm01
       #MOD-730044-begin-add
        IF cl_null(l_ima908) THEN LET l_ima908 = l_ima44  END IF
        IF g_sma.sma116 MATCHES '[13]' THEN   
           LET l_ima44 = l_ima908
        END IF   
        IF NOT cl_null(l_pmn86) AND l_pmn86 <> l_ima44 THEN
           LET l_unitrate = 1
           CALL s_umfchk(l_pmn04,l_pmn86,l_ima44)
           RETURNING l_sw,l_unitrate
           IF l_sw THEN
              #單位換算率抓不到 ---#
              CALL cl_err(l_pmn04,'abm-731',1)
              IF NOT cl_confirm('lib-005') THEN 
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF
           LET l_pmn31_u_exp_p  = l_pmn31/l_unitrate
           LET l_pmn31t_u_exp_p = l_pmn31t/l_unitrate
        ELSE 
           LET l_pmn31_u_exp_p = l_pmn31
           LET l_pmn31t_u_exp_p = l_pmn31t
        END IF
 
#     CALL p610sub_up_price(l_pmn04,l_pmn20,l_pmn31_u_exp_p,l_pmn31t_u_exp_p,l_pmm.pmm09,l_pmn41,l_pmm21,l_pmm43,l_pmn43,l_pmn18,l_pmn012)  #No.FUN-610018  #No.FUN-670099   #MOD-870163增加pmn18  #FUN-A60027 add pmn012   #MOD-B80260 mark
#MOD-B80260 -- modify begin --
#換行及增加p,pmm01,l_pmniicd03
      CALL p610sub_up_price(l_pmn04,l_pmn20,l_pmn31_u_exp_p,l_pmn31t_u_exp_p,l_pmm.pmm09,
                            l_pmn41,l_pmm21,l_pmm43,l_pmn43,l_pmn18,
                            l_pmn012,p_pmm01,l_pmniicd03)
#MOD-B80260 -- modify end --
     #CALL p610sub_up_price(l_pmn04,l_pmn20,l_pmn31,l_pmn31t,l_pmm.pmm09,l_pmn41,l_pmm21,l_pmm43,l_pmn43)  #No.FUN-610018  #No.FUN-670099
       #MOD-730044-end-add
#No.FUN-710030 -- begin --
#      IF g_success = 'N' THEN
#         EXIT FOREACH
#      END IF
      IF g_bgerr = FALSE THEN
          IF g_success = 'N' THEN
             EXIT FOREACH
          END IF
      END IF
#No.FUN-710030 -- end --
   END FOREACH
#str-------add by guanyao160512
   IF g_success = 'Y' THEN 
      LET l_tc_sfp01 = ''
      DECLARE p610_sub_tc_sfp_1 CURSOR FOR 
         SELECT tc_sfp01 FROM tc_sfp_file,pmn_file 
          WHERE tc_sfp03 = pmn01 
            AND tc_sfp04 = pmn02
            AND pmn01=p_pmm01
            AND tc_sfp00 = '1'
            AND tc_sfp13 = '0'
      FOREACH p610_sub_tc_sfp_1 INTO l_tc_sfp01
         IF NOT cl_null(l_tc_sfp01) THEN 
            CALL p610_ins(l_tc_sfp01)
         END IF 
         IF g_success = 'N' THEN 
            LET g_totsuccess="N"
            EXIT FOREACH 
         END IF 
      END FOREACH 
   END IF 
#end-------add by guanyao160512
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
END FUNCTION
 
#FUNCTION p610sub_up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmn41,p_pmm21,p_pmm43,p_pmn43,p_pmn18,p_pmn012)    #No.FUN-610018  #No.FUN-670099   #MOD-870163增加pmn18  #FUN-A60027   #MOD-B80260 mark
FUNCTION p610sub_up_price(p_part,p_qty,p_price,pt_price,p_pmm09,p_pmn41,p_pmm21,p_pmm43,p_pmn43,p_pmn18,p_pmn012,p_pmm01,p_pmniicd03) #MOD-B80260 
   DEFINE
      p_part       LIKE pmn_file.pmn04,   #料件編號
      p_qty        LIKE pmn_file.pmn20,   #數量
      p_price      LIKE pmn_file.pmn31,   #本幣單價
      pt_price     LIKE pmn_file.pmn31t,  #本幣含稅單價 FUN-610018
      p_pmm09      LIKE pmm_file.pmm09,   #廠商編號
      p_pmn41      LIKE pmn_file.pmn41,   #工單號碼
      p_pmm21      LIKE pmm_file.pmm21,   #No.FUN-610018
      p_pmm43      LIKE pmm_file.pmm43,   #No.FUN-610018
      p_pmn43      LIKE pmn_file.pmn43,   #No.FUN-670099
      p_pmn18      LIKE pmn_file.pmn18,   #MOD-870163
      p_pmn012     LIKE pmn_file.pmn012,  #FUN-A60027
#MOD-B80260 -- begin --
      p_pmm01      LIKE pmm_file.pmm01,
      p_pmniicd03  LIKE pmni_file.pmniicd03,
      l_pmm02      LIKE pmm_file.pmm02,
#MOD-B80260 -- end --
      l_ecm04      LIKE ecm_file.ecm04,   #No.FUN-670099
      l_stat       LIKE sfb_file.sfb04,   #工單狀態
      l_new        LIKE pmn_file.pmn31,   # 更新後 Price
      lt_new       LIKE pmn_file.pmn31t,  # 更新後 Tax Price FUN-610018
      l_curr       LIKE pmm_file.pmm22,   #No.FUN-680136 VARCHAR(4)  # 更新後 Currency
      l_rate       LIKE pmm_file.pmm42,
      l_date       LIKE type_file.dat,    #No.FUN-680136 DATE
      l_pmh12      LIKE pmh_file.pmh12,
      l_pmh17      LIKE pmh_file.pmh17,   #No.FUN-610018
      l_pmh18      LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh19      LIKE pmh_file.pmh19,   #No.FUN-610018
      ln_pmh17     LIKE pmh_file.pmh17,   #No.FUN-610018
      ln_pmh18     LIKE pmh_file.pmh18,   #No.FUN-610018
      l_pmh13      LIKE pmh_file.pmh13,
      l_pmh14      LIKE pmh_file.pmh14,
      l_fac        LIKE ima_file.ima44_fac, #採購對庫存轉換率
      l_price1     LIKE ima_file.ima53,
      l_price2     LIKE ima_file.ima531
    DEFINE l_pmh    RECORD LIKE pmh_file.* #MOD-4B0190
    DEFINE l_ima926 LIKE ima_file.ima926   #NO.FUN-930108
 
   #-----No.FUN-670099-----
   IF p_pmn43 = 0 OR cl_null(p_pmn43) THEN
#MOD-B80260 -- begin --
      IF s_industry('icd') THEN
         SELECT pmm02 INTO l_pmm02 FROM pmm_file WHERE pmm01=p_pmm01
         IF l_pmm02='SUB' THEN
            LET l_ecm04 = p_pmniicd03
         ELSE
            LET l_ecm04 = " "
         END IF
      ELSE
#MOD-B80260 -- end --
         LET l_ecm04 = " "
      END IF   #MOD-B80260 add
   ELSE
      IF cl_null(p_pmn18) THEN    #MOD-870163
         SELECT ecm04 INTO l_ecm04 FROM ecm_file
          WHERE ecm01 = p_pmn41   #MOD-870163
            AND ecm03 = p_pmn43
            AND ecm012 = p_pmn012      #FUN-A60027      
      #-----MOD-870163---------
      ELSE
         SELECT sgm04 INTO l_ecm04 FROM sgm_file
          WHERE sgm01 = p_pmn18
            AND sgm03 = p_pmn43
            AND sgm012 = p_pmn012     #FUN-A60076
      END IF
      #-----END MOD-870163-----
   END IF
   #-----No.FUN-670099 END-----
 
   SELECT sfb04 INTO l_stat FROM sfb_file where sfb01 = p_pmn41 AND sfb87!='X'
   IF SQLCA.sqlcode THEN
#     CALL cl_err(p_pmn41,SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#      CALL cl_err3("sel","sfb_file",p_pmn41,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      IF g_bgerr THEN
         CALL s_errmsg("sfb01",p_pmn41,"",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("sel","sfb_file",p_pmn41,"",SQLCA.sqlcode,"","",1)
      END IF
#No.FUN-710030 -- end --
      LET g_success ='N'
      RETURN
   END IF
  #MOD-730044-begin-modify
  #SELECT ima44_fac INTO l_fac FROM ima_file WHERE ima01 = p_part
  # IF SQLCA.sqlcode THEN
      LET l_fac = 1
  # END IF
  #MOD-730044-end-modify
   LET l_price1 =0
   LET l_price2 =0
   CASE  g_sma.sma843
      WHEN '1'
            IF g_sma.sma114 = 'N' THEN
                #NO:7231
                #委外採購是否影響料件最近採購單價='N'
                #所以不更新料件最近採購單價
                LET l_price1 = g_ima53
            ELSE
                LET l_price1 = p_price/l_fac
               #----------No.TQC-690085 add
                IF l_price1 < 0 THEN
                   LET l_price1 = g_ima53
                END IF   
               #----------No.TQC-690085 end
            END IF
      WHEN '2'
            IF g_sma.sma114 = 'N' THEN
                #NO:7231
                #委外採購是否影響料件最近採購單價='N'
                #所以不更新料件最近採購單價
                LET l_price1 = g_ima53
            ELSE
                #MOD-760015-begin-add
                 IF cl_null(g_ima53) THEN
                     LET g_ima53 = 0
                 END IF
                #MOD-760015-end-add
                IF p_price < g_ima53 OR g_ima53=0 THEN   #MOD-760015 modify
                   LET l_price1 = p_price/l_fac
                  #----------No.TQC-690085 add
                   IF l_price1 < 0 THEN
                      LET l_price1 = g_ima53
                   END IF   
                  #----------No.TQC-690085 end
                ELSE
                   LET l_price1 = g_ima53
                END IF
            END IF
      OTHERWISE
         LET l_price1 = g_ima53
   END CASE
   CASE  g_sma.sma844
      WHEN '1'      #無條件
         LET l_price2 = p_price/l_fac
         LET l_date   = g_today
        #----------No.TQC-690085 add
         IF l_price2 < 0 THEN
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
         END IF
        #----------No.TQC-690085 end
      WHEN '2'      #較低
         #MOD-760015-begin-add
          IF cl_null(g_ima531) THEN
              LET g_ima531 = 0
          END IF
         #MOD-760015-end-add
         IF (p_price < g_ima531) OR (g_ima531=0) THEN   #MOD-760015 modify
            LET l_price2 = p_price/l_fac
            LET l_date   = g_today
         ELSE       #不更新
            LET l_price2 = g_ima531
            LET l_date   = g_ima532
           #----------No.TQC-690085 add
            IF l_price2 < 0 THEN
               LET l_price2 = g_ima531
               LET l_date   = g_ima532
            END IF
           #----------No.TQC-690085 end
         END IF
      OTHERWISE  #不更新
         LET l_price2 = g_ima531
         LET l_date   = g_ima532
   END CASE
 
   #IF l_stat='1' THEN   #MOD-910113
   {ckp#4}
   #==>更新料件主檔中的
      UPDATE ima_file SET ima53  = l_price1,
                          ima531 = l_price2,
                          ima532 = l_date
                         {ima81  = ima81  - p_qty,
                          ima101 = ima101 + p_qty}  ##應利用sfb08 Update
        WHERE ima01  = p_part
      IF SQLCA.sqlerrd[3] = 0 THEN
         LET g_success = 'N'
#        CALL cl_err('(apmp610:ckp#4)','mfg3442',1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("upd","ima_file",p_part,"",SQLCA.sqlcode,"","(apmp610:ckp#4)",1)  #No.FUN-660129
         IF g_bgerr THEN
            CALL s_errmsg("ima01",p_part,"(apmp610:ckp#4)","mfg3442",1)
         ELSE
            CALL cl_err3("upd","ima_file",p_part,"","mfg3442","","(apmp610:ckp#4)",1)
         END IF
#No.FUN-710030 -- end --
         RETURN
      END IF
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
#No.FUN-710030 -- begin --
#         CALL cl_err('(apmp610:ckp#4)',SQLCA.sqlcode,1)
         IF g_bgerr THEN
            CALL s_errmsg("","","(apmp610:ckp#4)",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","(apmp610:ckp#4)",1)
         END IF
#No.FUN-710030 -- end --
         RETURN
      END IF
   {ckp#5}
   #==>如存在[料件/供應商檔]中則更新其最近採購單價
     SELECT pmh12,pmh17,pmh18,pmh19,pmh13,pmh14  #No.FUN-610018
        INTO l_pmh12,l_pmh17,l_pmh18,l_pmh19,l_pmh13,l_pmh14
        FROM pmh_file
      WHERE pmh01 = p_part AND pmh02 = p_pmm09 AND pmh13=g_pmm22
        AND pmh21 = l_ecm04 AND pmh22 ="2"  #No.FUN-670099
        AND pmh23 = ' '                     #No.CHI-960033
        AND pmhacti = 'Y'                                           #CHI-910021
      IF SQLCA.sqlcode = 0 THEN
         CASE
            WHEN g_sma.sma842 = '1'
               LET l_new = p_price
               LET lt_new = pt_price  #No.FUN-610018
               LET ln_pmh17 = p_pmm21  #No.FUN-610018
               LET ln_pmh18 = p_pmm43  #No.FUN-610018
               LET l_curr= g_pmm22
               LET l_rate= g_pmm42
             #------------No.TQC-690085 add
              IF l_new <= 0 THEN   #MOD-AA0030 加上等號
                 LET l_new = l_pmh12
                 LET lt_new = l_pmh19                            
                 LET ln_pmh17=l_pmh17                            
                 LET ln_pmh18=l_pmh18       
                 LET l_curr= l_pmh13
                 LET l_rate= l_pmh14
              END IF
             #------------No.TQC-690085 end
            #WHEN g_sma.sma842 = '2' AND g_pmm22 != l_curr   #MOD-850188
            WHEN g_sma.sma842 = '2' AND g_pmm22 != l_pmh13   #MOD-850188
               IF p_price*g_pmm42 < l_pmh12*l_pmh14 THEN
                  LET l_new = p_price
                  LET lt_new = pt_price  #No.FUN-610018
                  LET ln_pmh17 = p_pmm21  #No.FUN-610018
                  LET ln_pmh18 = p_pmm43  #No.FUN-610018
                  LET l_curr= g_pmm22
                  LET l_rate= g_pmm42
                 #------------No.TQC-690085 add
                  IF l_new <= 0 THEN   #MOD-AA0030 加上等號
                     LET l_new = l_pmh12
                     LET lt_new = l_pmh19                            
                     LET ln_pmh17=l_pmh17                            
                     LET ln_pmh18=l_pmh18       
                     LET l_curr= l_pmh13
                     LET l_rate= l_pmh14
                  END IF
                 #------------No.TQC-690085 end
               ELSE
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  #No.FUN-610018
                  LET ln_pmh17=l_pmh17  #No.FUN-610018
                  LET ln_pmh18=l_pmh18  #No.FUN-610018
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            #WHEN g_sma.sma842 = '2' AND g_pmm22 = l_curr   #MOD-850188
            WHEN g_sma.sma842 = '2' AND g_pmm22 = l_pmh13   #MOD-850188
               IF p_price < l_pmh12 THEN
                  LET l_new = p_price
                  LET lt_new = pt_price  #No.FUN-610018
                  LET ln_pmh17 = p_pmm21  #No.FUN-610018
                  LET ln_pmh18 = p_pmm43  #No.FUN-610018
                  LET l_curr= g_pmm22
                  LET l_rate= g_pmm42
                 #------------No.TQC-690085 add
                  IF l_new <= 0 THEN   #MOD-AA0030 加上等號
                     LET l_new = l_pmh12
                     LET lt_new = l_pmh19                            
                     LET ln_pmh17=l_pmh17                            
                     LET ln_pmh18=l_pmh18       
                     LET l_curr= l_pmh13
                     LET l_rate= l_pmh14
                  END IF
                 #------------No.TQC-690085 end
               ELSE
                  LET l_new = l_pmh12
                  LET lt_new = l_pmh19  #No.FUN-610018
                  LET ln_pmh17=l_pmh17  #No.FUN-610018
                  LET ln_pmh18=l_pmh18  #No.FUN-610018
                  LET l_curr= l_pmh13
                  LET l_rate= l_pmh14
               END IF
            OTHERWISE
               LET l_new = l_pmh12
               LET lt_new = l_pmh19  #No.FUN-610018
               LET ln_pmh17=l_pmh17  #No.FUN-610018
               LET ln_pmh18=l_pmh18  #No.FUN-610018
               LET l_curr= l_pmh13
               LET l_rate= l_pmh14
         END CASE
## No:2929 modify 1998/12/17 -------
         IF p_part[1,4] <>'MISC' THEN
            UPDATE pmh_file SET pmh12 = l_new,
                                pmh17 = ln_pmh17, #No.FUN-610018
                                pmh18 = ln_pmh18, #No.FUN-610018
                                pmh19 = lt_new,  #No.FUN-610018
                                pmh13 = l_curr,
                                pmh14 = l_rate
             WHERE pmh01 = p_part
               AND pmh02 = p_pmm09
               AND pmh13 = g_pmm22
               AND pmh21 = l_ecm04  #No.FUN-670099
               AND pmh22 = "2"   #No.FUN-670099  
               AND pmh23 = ' '                     #No.CHI-960033
            IF SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N'
#              CALL cl_err('(apmp610:ckp#5)','mfg3442',1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","pmh_file",p_part,p_pmm09,"mfg3442","","(apmp610:ckp#5)",1)  #No.FUN-660129
               IF g_bgerr THEN
                  LET g_showmsg = p_part,"/",p_pmm09,"/",g_pmm22,"/",l_ecm04
                  CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(apmp610:ckp#5)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","pmh_file",p_part,p_pmm09,"mfg3442","","(apmp610:ckp#5)",1)
               END IF
#No.FUN-710030 -- end --
            END IF
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
#No.FUN-710030 -- begin --
#               CALL cl_err('(apmp610:ckp#5)',SQLCA.sqlcode,1)
               IF g_bgerr THEN
                  CALL s_errmsg("","","(apmp610:ckp#5)",SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("","","","",SQLCA.sqlcode,"","(apmp610:ckp#5)",1)
               END IF
#No.FUN-710030 -- end --
            END IF
         END IF
       ELSE #MOD-4B0190
          #MOD-4B0190 增加 INSERT INTO pmh_file
         LET l_pmh.pmh01=p_part
         LET l_pmh.pmh02=p_pmm09
         LET l_pmh.pmh03='N'
         IF g_sma.sma102 = 'Y' THEN
#FUN-930108------start-- 
            SELECT ima926 INTO l_ima926 FROM ima_file
             WHERE ima01 = p_part
            IF l_ima926 ='Y' THEN
               LET l_pmh.pmh05='1'
            ELSE
               LET l_pmh.pmh05='0'
            END IF
#FUN-930108------end----
         ELSE
            LET l_pmh.pmh05='0'
         END IF
         LET l_pmh.pmh06=NULL
         LET l_pmh.pmh10=NULL
         LET l_pmh.pmh11=0
         LET l_pmh.pmh12=p_price
         LET l_pmh.pmh19=pt_price  #No.FUN-610018
         LET l_pmh.pmh17=p_pmm21   #No.FUN-610018
         LET l_pmh.pmh18=P_pmm43   #No.FUN-610018
         LET l_pmh.pmh13=g_pmm22
         LET l_pmh.pmh14=g_pmm42
         LET l_pmh.pmh21=l_ecm04  #No.FUN-670099
         LET l_pmh.pmh22="2"      #No.FUN-670099
         LET l_pmh.pmhacti='Y'
         LET l_pmh.pmhuser=g_user
         LET l_pmh.pmhgrup=g_grup
         LET l_pmh.pmhdate = g_today
         SELECT ima100,ima24,ima101,ima102
           INTO l_pmh.pmh09,l_pmh.pmh08,l_pmh.pmh15,l_pmh.pmh16
           FROM ima_file
          WHERE ima01=p_part
         #No.CHI-790003 START
         IF cl_null(l_pmh.pmh13) THEN LET l_pmh.pmh13=' ' END IF
         #No.CHI-790003 END    
         IF cl_null(l_pmh.pmh23) THEN LET l_pmh.pmh23=' ' END IF  #No.FUN-870124
         LET l_pmh.pmhoriu = g_user      #No.FUN-980030 10/01/04
         LET l_pmh.pmhorig = g_grup      #No.FUN-980030 10/01/04
         LET l_pmh.pmh25='N'   #No:FUN-AA0015
         INSERT INTO pmh_file VALUES (l_pmh.*)
         IF STATUS THEN
            LET g_success='N'
#           CALL cl_err('(apmp610:ins#)',STATUS,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("ins","pmh_file","","",STATUS,"","(apmp610:ins#)",1)  #No.FUN-660129
            IF g_bgerr THEN
               LET g_showmsg = l_pmh.pmh01,"/",l_pmh.pmh02,"/",l_pmh.pmh13,"/",l_pmh.pmh21,"/",l_pmh.pmh22
               CALL s_errmsg("pmh01,pmh02,pmh13,pmh21,pmh22",g_showmsg,"(apmp610:ins#)",STATUS,1)
            ELSE
               CALL cl_err3("ins","pmh_file",l_pmh.pmh01,l_pmh.pmh02,STATUS,"","(apmp610:ins#)",1)
            END IF
#No.FUN-710030 -- end --
         END IF
          #MOD-4B0190(end)
      END IF
   #END IF   #MOD-910113
END FUNCTION

###
FUNCTION p610sub_sfb(p_no)
   DEFINE
      l_sfb      RECORD LIKE sfb_file.*,
      l_pmn41    LIKE pmn_file.pmn41,
      p_no       LIKE pmm_file.pmm01,
      l_minopseq LIKE ecb_file.ecb03,
      l_pmn01    LIKE pmn_file.pmn01,
      l_sql      LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
      l_cnt      LIKE type_file.num10,  #FUN-A80102
      l_unalc    LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE          l_pmn      RECORD LIKE pmn_file.*     #FUN-9A0066 add
   DEFINE          l_vnd07    DATETIME YEAR TO MINUTE    #FUN-9A0066 add
   DEFINE          l_vnd08    DATETIME YEAR TO MINUTE    #FUN-9A0066 add
   DEFINE          l_tmp      LIKE type_file.chr20       #FUN-9A0066 add
   DEFINE          l_to_char_vnd07  LIKE type_file.chr20 #FUN-9A0066 add
   DEFINE          l_to_char_vnd08  LIKE type_file.chr20 #FUN-9A0066 add
   DEFINE          l_to_char_ecm50  LIKE type_file.chr10 #FUN-9A0066 add
   DEFINE          l_to_char_ecm51  LIKE type_file.chr10 #FUN-9A0066 add
   DEFINE l_date   LIKE type_file.dat                    #FUN-9A0066 add
   DEFINE l_date1  LIKE type_file.dat                    #FUN-9A0066 add
   DEFINE l_month1 LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_day1   LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_year1  LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_hh1    LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_mm1    LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_hhmm1  LIKE type_file.num20                  #FUN-9A0066 add
   DEFINE l_date2  LIKE type_file.dat                    #FUN-9A0066 add
   DEFINE l_hh2    LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_mm2    LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_hhmm2  LIKE type_file.num20                  #FUN-9A0066 add
   DEFINE l_month2 LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_day2   LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_year2  LIKE type_file.num5                   #FUN-9A0066 add
   DEFINE l_vnd11  LIKE vnd_file.vnd11                   #FUN-9A0066 add
   DEFINE l_sql1   STRING                                #FUN-9A0066 add
   DEFINE l_sql2   STRING                                #FUN-9A0066 add

   DECLARE upsfb_cs CURSOR WITH HOLD FOR
        SELECT UNIQUE sfb_file.* FROM pmn_file,sfb_file
               WHERE pmn01=p_no AND pmn41=sfb01 AND sfb87!='X'
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH upsfb_cs INTO l_sfb.*
      IF SQLCA.sqlcode THEN
#No.FUN-710030 -- begin --
#         CALL cl_err(p_no,'apm-186',1)   #No.FUN-660129
         IF g_bgerr THEN
            CALL s_errmsg("","",p_no,"apm-186",1)
         ELSE
            CALL cl_err3("","","","","apm-186","",p_no,1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
      IF l_sfb.sfb23 NOT MATCHES '[Yy]' OR l_sfb.sfb23 IS NULL THEN
         CALL s_minopseq(l_sfb.sfb05,l_sfb.sfb06,l_sfb.sfb071)
           RETURNING l_minopseq
         SELECT COUNT(*) INTO l_cnt FROM bmb_file
            WHERE bmb01 = l_sfb.sfb05
         IF l_cnt IS NULL OR l_cnt =0 THEN
            LET l_cnt = 0
         END IF
         IF l_cnt = 0 THEN
            CALL cl_err(l_sfb.sfb05,'apm-210',1)
         END IF
         IF l_cnt > 1 THEN
            CALL s_alloc(l_sfb.sfb01,l_sfb.sfb02,l_sfb.sfb05,
           #--------No.FUN-670041 modify
           #g_sma.sma29,l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
            'Y',l_sfb.sfb08,l_sfb.sfb071,'Y',g_sma.sma71,
           #--------No.FUN-670041 end
            l_sfb.sfb42,l_minopseq) RETURNING l_unalc
            IF NOT l_unalc THEN
               LET g_success = 'N'
               EXIT FOREACH
            ELSE
               UPDATE sfb_file SET sfb23='Y'
                 WHERE sfb01 = l_sfb.sfb01 AND sfb87!='X'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('Update sfb_file 1 :',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 1 :",1)  #No.FUN-660129
#                  LET g_success = 'N'
#                  EXIT FOREACH
                  LET g_success = 'N'
                  IF g_bgerr THEN
                     CALL s_errmsg("sfb01",l_sfb.sfb01,"Update sfb_file 1 :",SQLCA.sqlcode,1)
                     CONTINUE FOREACH
                  ELSE
                     CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 1 :",1)
                     EXIT FOREACH
                  END IF
#No.FUN-710030 -- end --
               END IF
               IF l_sfb.sfb04 < 2 THEN
                  UPDATE sfb_file SET sfb04 = '2',
                                      sfb251=g_today
                  WHERE sfb01 = l_sfb.sfb01 AND sfb87!='X'
                  IF SQLCA.sqlcode THEN
#                    CALL cl_err('Update sfb_file 1 :',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                     CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 1 :",1)  #No.FUN-660129
#                     LET g_success = 'N'
#                     EXIT FOREACH
                     LET g_success = 'N'
                     IF g_bgerr THEN
                        CALL s_errmsg("sfb01",l_sfb.sfb01,"Update sfb_file 1 :",SQLCA.sqlcode,1)
                        CONTINUE FOREACH
                     ELSE
                        CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 1 :",1)
                        EXIT FOREACH
                     END IF
#No.FUN-710030 -- end --
                  END IF
               END IF
            END IF
         ELSE
            IF l_sfb.sfb04 < 2 THEN
               UPDATE sfb_file SET sfb04 = '2',
                                   sfb251=g_today
               WHERE sfb01 = l_sfb.sfb01 AND sfb87!='X'
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('Update sfb_file 2 :',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#                  CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 2 :",1)  #No.FUN-660129
#                  LET g_success = 'N'
#                  EXIT FOREACH
                 IF g_bgerr THEN
                    CALL s_errmsg("sfb01",l_sfb.sfb01,"",SQLCA.sqlcode,1)
                    CONTINUE FOREACH
                 ELSE
                    CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 2 :",1)
                    EXIT FOREACH
                 END IF
#No.FUN-710030 -- end --
               END IF
            END IF
         END IF
      ELSE
         IF l_sfb.sfb04 < 2 THEN
            UPDATE sfb_file SET sfb04 = '2',
                                sfb251=g_today
              WHERE sfb01 = l_sfb.sfb01 AND sfb87!='X'
            IF SQLCA.sqlcode THEN
#              CALL cl_err('Update sfb_file 3 :',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#               CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 3 :",1)  #No.FUN-660129
#               LET g_success = 'N'
#               EXIT FOREACH
               IF g_bgerr THEN
                  CALL s_errmsg("sfb01",l_sfb.sfb01,"Update sfb_file 3 :",SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  CALL cl_err3("upd","sfb_file",l_sfb.sfb01,"",SQLCA.sqlcode,"","Update sfb_file 3 :",1)
                  EXIT FOREACH
               END IF
#No.FUN-710030 -- end --
            END IF
         END IF
      END IF
   {ckp#9}
   #==>更新料件主檔中的
      #IF l_sfb.sfb04 = '1' THEN
        #   UPDATE ima_file SET ima81  = ima81  - l_sfb.sfb08,
        #                       ima101 = ima101 + l_sfb.sfb08
        #     WHERE ima01  = l_sfb.sfb05
        #   IF SQLCA.sqlerrd[3] = 0 THEN
        #      LET g_success = 'N'
        #      CALL cl_err('(apmp610:ckp#9)','mfg3442',1)
        #      EXIT FOREACH
        #   END IF
        #   IF SQLCA.sqlcode THEN
        #      LET g_success = 'N'
        #      CALL cl_err('(apmp610:ckp#9)',SQLCA.sqlcode,1)
        #      EXIT FOREACH
        #   END IF
        # END IF
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --

   #FUN-9A0066----add-----str----
   #跟APS串時
   IF NOT cl_null(g_sma.sma901) AND g_sma.sma901 = 'Y' THEN
       DECLARE up_aps_cs CURSOR WITH HOLD FOR
           SELECT pmn_file.*
             FROM pmn_file,sfb_file
            WHERE pmn01  = p_no
              AND pmn41  = sfb01
              AND sfb87 != 'X'
            ORDER BY pmn02,pmn41,pmn46
       CALL s_showmsg_init()
       FOREACH up_aps_cs INTO l_pmn.*
           IF SQLCA.sqlcode THEN
               IF g_bgerr THEN
                   CALL s_errmsg("","",p_no,"apm-186",1)
               ELSE
                   CALL cl_err3("","","","","apm-186","",p_no,1)
               END IF
               LET g_success = 'N'
               EXIT FOREACH
           END IF
           IF g_success="N" THEN
               LET g_totsuccess="N"
               LET g_success="Y"
           END IF

           IF NOT cl_null(l_pmn.pmn46) AND l_pmn.pmn46 <> 0 THEN
               #製程委外
               SELECT vnd07,vnd08,vnd07 vd07,vnd08 vd08 INTO l_vnd07,l_vnd08,l_to_char_vnd07,l_to_char_vnd08
                 FROM vnd_file
                WHERE vnd01 = l_pmn.pmn41 #工單編號
                  AND vnd03 = l_pmn.pmn46 #製程序號
              #---mod---str--
              #SELECT cl_tp_tochar(ecm50,'YYYY-MM-DD'),cl_tp_tochar(ecm51,'YYYY-MM-DD')
              #  INTO l_to_char_ecm50,l_to_char_ecm51
              #  FROM ecm_file
              # WHERE ecm01 = l_pmn.pmn41 #工單編號
              #   AND ecm03 = l_pmn.pmn46 #製程序號
               LET l_sql1 = cl_tp_tochar('ecm50','YYYY-MM-DD')
               LET l_sql2 = cl_tp_tochar('ecm51','YYYY-MM-DD')
               LET l_sql = "SELECT ",l_sql1 CLIPPED," , ",l_sql2 CLIPPED,
                           "  FROM ecm_file ",
                           " WHERE ecm01 = '",l_pmn.pmn41,"'", #工單編號
                           "   AND ecm03 =  ",l_pmn.pmn46      #製程序號
               PREPARE p610_sel_p1 FROM l_sql
               EXECUTE p610_sel_p1 INTO l_to_char_ecm50,l_to_char_ecm51
              #---mod---end--
               IF cl_null(l_vnd07) THEN
                   LET l_tmp = l_to_char_ecm50,' ','00:00'
                   LET l_vnd07 = l_tmp
                   LET l_to_char_vnd07 = l_tmp
               END IF
               IF cl_null(l_vnd08) THEN
                   LET l_tmp = l_to_char_ecm51,' ','00:00'
                   LET l_vnd08 = l_tmp
                   LET l_to_char_vnd08 = l_tmp
               END IF
               LET l_date = DATE('1899/12/31')

               LET l_year1 = l_to_char_vnd07[1,4]
               LET l_month1= l_to_char_vnd07[6,7]
               LET l_day1  = l_to_char_vnd07[9,10]
               LET l_hh1   = l_to_char_vnd07[12,13]
               LET l_mm1   = l_to_char_vnd07[15,16]
               LET l_date1 = MDY(l_month1,l_day1,l_year1)

               LET l_year2 = l_to_char_vnd08[1,4]
               LET l_month2= l_to_char_vnd08[6,7]
               LET l_day2  = l_to_char_vnd08[9,10]
               LET l_hh2   = l_to_char_vnd08[12,13]
               LET l_mm2   = l_to_char_vnd08[15,16]
               LET l_date2 = MDY(l_month2,l_day2,l_year2)

               LET l_hhmm1=(l_date1-l_date)*1440+l_hh1*60+l_mm1
               LET l_hhmm2=(l_date2-l_date)*1440+l_hh2*60+l_mm2

               LET l_vnd11= (l_hhmm2-l_hhmm1)*60 #秒 #

               UPDATE vnd_file
                  SET vnd06 = '3',        #鎖定碼=>3:鎖定開始結束時間
                      vnd07 = l_vnd07,
                      vnd08 = l_vnd08,
                      vnd11 = l_vnd11
                WHERE vnd01 = l_pmn.pmn41 #工單編號
                  AND vnd03 = l_pmn.pmn46 #製程序號
               IF SQLCA.sqlcode THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("vnd01",l_pmn.pmn41,"",SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err3("upd","vnd_file",l_pmn.pmn41,"",SQLCA.sqlcode,"","Update vnd_file:",1)
                      EXIT FOREACH
                   END IF
               END IF
           ELSE
               #委外工單
               UPDATE sfb_file
                  SET sfb41 = 'Y'         #凍結碼
               WHERE sfb01 = l_pmn.pmn41  #工單編號
               IF SQLCA.sqlcode THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("sfb01",l_pmn.pmn41,"",SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err3("upd","sfb01",l_pmn.pmn41,"",SQLCA.sqlcode,"","Update sfb41:",1)
                      EXIT FOREACH
                   END IF
               END IF

               UPDATE vnf_file
                  SET vnf03 = '2'         #外包類型=>2:固定開始結束時間
                WHERE vnf01 = l_pmn.pmn41 #工單編號
               IF SQLCA.sqlcode THEN
                   IF g_bgerr THEN
                      CALL s_errmsg("vnf01",l_pmn.pmn41,"",SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                   ELSE
                      CALL cl_err3("upd","vnf01",l_pmn.pmn41,"",SQLCA.sqlcode,"","Update vnf03:",1)
                      EXIT FOREACH
                   END IF
               END IF
           END IF
       END FOREACH
   END IF
   #FUN-9A0066----add-----end---- 
END FUNCTION
#FUN-B50046

#str----add by guanyao160512
FUNCTION p610_ins(p_tc_sfp01)
DEFINE l_tc_sfs    RECORD LIKE tc_sfs_file.*
DEFINE l_ina       RECORD LIKE ina_file.*
DEFINE l_inb       RECORD LIKE inb_file.*
DEFINE li_result   LIKE type_file.num5
DEFINE p_tc_sfp01  LIKE tc_sfp_file.tc_sfp01
DEFINE l_slip      LIKE smy_file.smyslip
DEFINE l_i         LIKE type_file.num5
DEFINE l_to_prog   LIKE type_file.chr10
DEFINE l_x         LIKE type_file.num5

   LET g_success = 'Y'
   #SELECT smyslip INTO l_slip FROM smy_file WHERE smysys = 'aim' AND smykind = '1'  #mark by guanyao160523
   SELECT smyslip INTO l_slip FROM smy_file WHERE smysys = 'aim' AND smykind = '2'   #add by guanyao160523
   IF cl_null(l_slip) THEN 
      CALL cl_err('','cpm-008',0)
      LET g_success = 'N'
      RETURN 
   END IF 
   CALL s_check_no("aim",l_slip,'','2',"ina_file","ina01","")
      RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-009',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina02  =g_today
   LET l_ina.ina03  =g_today
   #CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,'1',"ina_file","ina01","","","") #mark by guanyao160523
   CALL s_auto_assign_no("aim",l_ina.ina01,l_ina.ina03,'2',"ina_file","ina01","","","")  #add by guanyao160523
     RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
      CALL cl_err('','cpm-010',0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET l_ina.ina00  ='3'
   LET l_ina.ina04  =g_grup  
   LET l_ina.inapost='N'
   LET l_ina.inaconf='N'     #FUN-660079
   LET l_ina.inaspc ='0'     #FUN-680010
   LET l_ina.inauser=g_user
   LET l_ina.inaoriu = g_user 
   LET l_ina.inaorig = g_grup 
   LET l_ina.inagrup=g_grup
   LET l_ina.inadate=g_today
   LET l_ina.ina08 = '0'           #開立  #FUN-550047
   LET l_ina.inamksg = 'N'         #簽核否#FUN-550047
   LET l_ina.ina12='N'       #No.FUN-870100
   LET l_ina.inapos='N'       #No.FUN-870100
   LET l_ina.inacont=''       #No.FUN-870100
   LET l_ina.inaconu=''       #No.FUN-870100
   LET l_ina.ina11=g_user
   LET l_ina.ina08 = 'N'
   LET l_ina.ina13 = ' '
   LET l_ina.ina10=p_tc_sfp01
   LET l_ina.inaplant = g_plant #FUN-980004 add
   LET l_ina.inalegal = g_legal
   INSERT INTO ina_file VALUES(l_ina.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",l_ina.ina01,"",SQLCA.sqlcode,"","ins ina",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   #str----add by guanyao160518
   UPDATE tc_sfp_file SET tc_sfp10 = l_ina.ina01
    WHERE tc_sfp01 = l_ina.ina10
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","tc_sfp_file",l_ina.ina10,"",SQLCA.sqlcode,"","ins tc_sfp",1)
      LET g_success = 'N'
      RETURN 
   END IF 
   #end----add by guanyao160518
   LET l_i = 1
   DECLARE p610_sub_tc_sfp CURSOR FOR 
         SELECT * FROM tc_sfs_file 
          WHERE tc_sfs01 =p_tc_sfp01 
     FOREACH p610_sub_tc_sfp INTO l_tc_sfs.*
        LET l_inb.inb01= l_ina.ina01
        LET l_inb.inb03= l_i
        LET l_inb.inb04= l_tc_sfs.tc_sfs03
        LET l_inb.inb05='S.0248'
        LET l_inb.inb06=' '
        LET l_inb.inb07=' '
        LET l_inb.inb08=l_tc_sfs.tc_sfs06
        LET l_inb.inb08_fac = '1'
        LET l_inb.inb09 =l_tc_sfs.tc_sfs05
        LET l_inb.inb16 =l_tc_sfs.tc_sfs05
        LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)
        LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)
        SELECT ima24 INTO l_inb.inb10 FROM ima_file WHERE ima01 = l_inb.inb04
        LET l_inb.inb11 = p_tc_sfp01
        LET l_inb.inb12 = ''
        LET l_inb.inb13 = 0
        LET l_inb.inb15 ='002'
        LET l_inb.inb908 = ''
        LET l_inb.inb909 = ''
        LET l_inb.inb132 = 0
        LET l_inb.inb133 = 0
        LET l_inb.inb134 = 0
        LET l_inb.inb135 = 0
        LET l_inb.inb136 = 0
        LET l_inb.inb137 = 0
        LET l_inb.inb138 = 0
        LET l_inb.inblegal = g_legal   #MOD-A50144 add
        LET l_inb.inbplant = g_plant
        INSERT INTO inb_file VALUES(l_inb.*)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","inb_file","","",SQLCA.sqlcode,"","ins inb",1) 
           LET g_success = 'N' 
           CONTINUE FOREACH 
        END IF 
        LET l_x = 0
        SELECT COUNT(*) INTO l_x FROM img_file 
         WHERE img01=l_inb.inb04
           AND img02=l_inb.inb05
           AND img03=l_inb.inb06
           AND img04=l_inb.inb07
        IF cl_null(l_x) OR l_x = 0 THEN 
           CALL s_add_img(l_inb.inb04,l_inb.inb05,
                          l_inb.inb06,l_inb.inb07,
                          l_ina.ina01,l_inb.inb03,l_ina.ina02)
           IF g_errno='N' THEN
              CALL cl_err('','cpm-011',1)
              LET g_success = 'N'    
           END IF
        END IF 
        LET l_i = l_i +1
     END FOREACH

     LET l_to_prog = g_prog
     #LET g_prog = 'aimt301'  #mark by guanyao160523 
     LET g_prog = 'aimt302'   #add by guanyao160523
     IF g_success = 'Y' THEN
        CALL t370sub_y_chk(l_ina.ina01,'3','Y') #FUN-B50138  #TQC-C40079 add Y
        IF g_success = "Y" THEN
           CALL t370sub_y_upd(l_ina.ina01,'Y',TRUE) #FUN-B50138
           IF g_success = "Y" THEN
              CALL t370sub_s_chk(l_ina.ina01,'Y',TRUE,'')    #CALL 原確認的 check 段 #FUN-B50138
              IF g_success = "Y" THEN
                   CALL t370sub_s_upd(l_ina.ina01,'3',TRUE)       #CALL 原確認的 update 段#FUN-B50138
              END IF
           END IF
        END IF
     END IF 
     LET g_prog=l_to_prog

   
END FUNCTION 
#end----add by guanyao160512
