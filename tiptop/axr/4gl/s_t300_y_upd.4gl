# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: s_t300_y_upd.4gl
# Descriptions...: 应收账款整批审核
# Date & Author..: No.FUN-CB0094 12/11/21 By minpp
# Modify.........: No.FUN-D40089 13/04/23 By zhangweib 批次審核的報錯,加show單據編號
# Modify.........: No.MOD-D80127 13/08/20 By yinhy s_t300_omc_check函数增加传参

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_oma        RECORD LIKE oma_file.*
DEFINE m_oma        RECORD LIKE oma_file.*
DEFINE g_flag1      LIKE type_file.chr1
DEFINE g_flag2      LIKE type_file.chr1
DEFINE i            LIKE type_file.num5
DEFINE g_sql        STRING
DEFINE l_sql        STRING
DEFINE g_oma01_t    LIKE oma_file.oma01
DEFINE g_wc         STRING
DEFINE g_bookno1    LIKE aza_file.aza81
DEFINE g_bookno2    LIKE aza_file.aza82
DEFINE g_t1         LIKE ooy_file.ooyslip 
DEFINE g_cnt        LIKE type_file.num5
DEFINE g_forupd_sql STRING
DEFINE g_msg        STRING
DEFINE li_dbs       STRING
DEFINE g_wc_gl      STRING
DEFINE g_str        STRING

#FUN-CB0094
FUNCTION s_t300_y_upd(p_oma01,p_flag2)        # when g_oma.omaconf='N' (Turn to 'Y')
   DEFINE l_npq07     LIKE npq_file.npq07
   DEFINE l_npq07_1   LIKE npq_file.npq07      #FUN-670047
   DEFINE l_oma54x    LIKE oma_file.oma54x
   DEFINE l_slip      LIKE ooy_file.ooyslip
   DEFINE l_ooy10     LIKE ooy_file.ooy10
   DEFINE l_ooy11     LIKE ooy_file.ooy11
   DEFINE l_omb31     LIKE omb_file.omb31
   DEFINE l_oga07     LIKE oga_file.oga07      #MOD-AC0033
   DEFINE l_oga23     LIKE oga_file.oga23
   DEFINE l_oga24     LIKE oga_file.oga24
   DEFINE l_omb18t    LIKE omb_file.omb18t
   DEFINE l_cnt       LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE l_oot04t    LIKE oot_file.oot04t     #MOD-B30709 
   DEFINE l_oot05t    LIKE oot_file.oot05t
   DEFINE l_status    LIKE npq_file.npq06      #FUN-590100
   DEFINE l_ooa01     LIKE ooa_file.ooa01   
   DEFINE only_one    LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)     #FUN-530061
   DEFINE l_amt       LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)   #FUN-530061
   DEFINE l_ool       RECORD LIKE ool_file.*   #MOD-870331 add
   DEFINE l_npq03     LIKE npq_file.npq03      #MOD-870331 add
   DEFINE l_npq031    LIKE npq_file.npq03      #MOD-870331 add
   DEFINE l_buser     LIKE type_file.chr10     #No.MOD-920343
   DEFINE l_euser     LIKE type_file.chr10     #No.MOD-920343 
   DEFINE p_dbs       LIKE type_file.chr21     #FUN-9C0041
   DEFINE l_omb44     LIKE omb_file.omb44      #FUN-9C0041
   DEFINE l_rate      LIKE oma_file.oma58      #FUN-9A0036
   DEFINE l_npq07_amt LIKE npq_file.npq07      #FUN-9A0036
   DEFINE l_azi04_2   LIKE azi_file.azi04      #MOD-B30709
   DEFINE l_oma53     LIKE oma_file.oma53      #MOD-B60021
   DEFINE l_oga09     LIKE oga_file.oga09      #MOD-C30842 add
   DEFINE l_oga011    LIKE oga_file.oga011     #MOD-C30842 add
   DEFINE l_oga232    LIKE oga_file.oga23      #MOD-C30842 add
   DEFINE l_oga242    LIKE oga_file.oga24      #MOD-C30842 add
   DEFINE p_oma01     LIKE oma_file.oma01
   DEFINE p_flag2     LIKE type_file.chr1
   WHENEVER ERROR CONTINUE 
   LET g_success = 'Y'
   LET g_totsuccess='Y' #CHI-A80031 add
   LET only_one = '1'           #FUN-530061
   LET g_flag2 = p_flag2
   IF cl_null(p_oma01) THEN RETURN END IF
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_oma01
   #抓账套
#   CALL s_get_bookno(year(g_oma.oma02))         
#   RETURNING g_flag1,g_bookno1,g_bookno2      
#   IF g_flag1='1' THEN #抓不到帳別
#      CALL cl_err(g_oma.oma02,'aoo-081',1)
#   END IF
   #已审核不可再审核
   IF g_oma.omaconf <> 'N' THEN 
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm" OR     #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  THEN   #FUN-640246
      IF g_action_choice CLIPPED = "insert"  THEN   #CHI-B10042 add
         IF g_oma.omamksg='Y' THEN       #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
            IF g_oma.oma64 != '1' THEN
               CALL cl_err('','aws-078',1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF #CHI-B10042 add
 
      OPEN WINDOW t300_w6 WITH FORM "axr/42f/axrt300_6" ATTRIBUTE (STYLE = g_win_style CLIPPED)

      CALL cl_ui_locale("axrt300_6")
 
      LET only_one = '1'

      INPUT BY NAME only_one WITHOUT DEFAULTS

         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
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
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW t300_w6
         RETURN
      END IF
   ELSE
      IF g_action_choice CLIPPED = "insert" THEN 
         IF g_oma.omamksg='Y' THEN       #若簽核碼為'Y'且狀態碼不為'1'已同意
            IF g_oma.oma64 != '1' THEN
               CALL cl_err('','aws-078',1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " oma01 = '",g_oma.oma01,"' "
   ELSE
      CONSTRUCT BY NAME g_wc ON oma01,oma02,oma03

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oma01)
                  LET g_qryparam.state = 'c' #FUN-980030
                  LET g_qryparam.plant = g_plant #FUN-980030:預設為g_plant
                  CALL q_oma(TRUE,TRUE,g_oma.oma01,'','')  #NO:6842
                  RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oma01
               WHEN INFIELD(oma03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_oma.oma03
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oma03
                  NEXT FIELD oma03
               OTHERWISE EXIT CASE
            END CASE
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
         
         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG=0
         LET g_success = 'N'
         CLOSE WINDOW t300_w6
         RETURN
      END IF
   END IF
 
   LET g_sql = "SELECT SUM(oma56t) FROM oma_file",    #應收帳款本幣含稅金額
               " WHERE omaconf = 'N' AND omavoid !='Y' ",
               "   AND oma00='",g_oma.oma00,"' AND ",g_wc CLIPPED
   PREPARE t300_firm1_p2 FROM g_sql
   DECLARE t300_firm1_c2 CURSOR FOR t300_firm1_p2
 
   OPEN t300_firm1_c2
   FETCH t300_firm1_c2 INTO l_amt
 
   IF cl_null(l_amt) THEN
      LET l_amt = 0
   END IF

   DISPLAY BY NAME l_amt
 
   IF g_action_choice CLIPPED = "confirm" #按「確認」時
   OR g_action_choice CLIPPED = "insert"   #FUN-640246
   THEN
      IF NOT cl_confirm('aap-222') THEN   #是否進行確認
         LET g_success = 'N'
         CLOSE WINDOW t300_w6   #FUN-530061
         RETURN
      END IF
   END IF
 
   CALL cl_msg("WORKING !")                              #FUN-640246
 
   LET g_sql = "SELECT * FROM oma_file",
               " WHERE ",g_wc CLIPPED,   #MOD-5C0077
               "   AND omaconf = 'N' AND omavoid !='Y'"
   PREPARE t300_firm1_p3 FROM g_sql
   DECLARE t300_firm1_c3 CURSOR WITH HOLD FOR t300_firm1_p3 #FUN-AB0110
 
   SELECT azi04 INTO l_azi04_2 
     FROM aaa_file,azi_file
    WHERE azi01 = aaa03
      AND aaa01 = g_bookno2
      AND aziacti = 'Y'                  #MOD-C40039 add

   BEGIN WORK
 
   LET g_oma01_t = g_oma.oma01     #保留舊值 #CHI-A80031 add
   #重新抓取關帳日期
   SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
   FOREACH t300_firm1_c3 INTO m_oma.*  #-->逐筆確認   #FUN-530061
      IF STATUS THEN EXIT FOREACH END IF              #MOD-AC0233
      IF g_success='N' THEN                 
         LET g_totsuccess='N'              
         LET g_success="Y"                
      END IF                    

      #抓账套
      CALL s_get_bookno(year(m_oma.oma02))
      RETURNING g_flag1,g_bookno1,g_bookno2
      IF g_flag1='1' THEN #抓不到帳別
         CALL cl_err(g_oma.oma02,'aoo-081',1)
      END IF 

      LET l_cnt = 0
      LET l_oot04t = ''
      LET l_oot05t = ''
      SELECT COUNT(*),SUM(oot04t),SUM(oot05t) INTO l_cnt,l_oot04t,l_oot05t  #MOD-B30709 add oot04t
        FROM oot_file
       WHERE oot03 = m_oma.oma01   #FUN-530061 mod g_oma->m_oma
      IF cl_null(l_oot04t) THEN
         LET l_oot04t = 0
      END IF
      IF cl_null(l_oot05t) THEN
         LET l_oot05t = 0
      END IF
 
     LET g_oma.oma01=m_oma.oma01
     IF only_one = '2' THEN 
        CALL s_t300_y_chk() 
     END IF
     #抓单别
     LET g_t1 = '' 
     CALL s_get_doc_no(m_oma.oma01) RETURNING g_t1
     SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1

      IF m_oma.omavoid = 'Y' THEN   
        #CALL s_errmsg("omavoid","Y","","axr-103",1)            #No.FUN-D40089   Mark
         CALL s_errmsg("omavoid","Y",m_oma.oma01,"axr-103",1)   #No.FUN-D40089   Add         
         LET g_success = 'N'
         LET g_totsuccess='N' 
         CONTINUE FOREACH
      END IF
 
      IF m_oma.oma02 <= g_ooz.ooz09 THEN   
         LET g_success = 'N'
         LET g_totsuccess='N' 
        #CALL s_errmsg("oma02",m_oma.oma02,"","axr-164",1)             #No.FUN-D40089   Mark
         CALL s_errmsg("oma02",m_oma.oma02,m_oma.oma01,"axr-164",1)    #No.FUN-D40089   Add
         CONTINUE FOREACH
      END IF
 
      CALL s_get_doc_no(m_oma.oma01) RETURNING l_slip   
  
      LET l_ooy10 = ''
      LET l_ooy11 = ''
      SELECT ooy10,ooy11 INTO l_ooy10,l_ooy11
        FROM ooy_file
       WHERE ooyslip = l_slip
 
      IF g_aza.aza26='2' AND l_ooy10 = 'Y' THEN   #TQC-6B0003
         SELECT SUM(omb18t) INTO l_omb18t FROM omb_file
          WHERE omb01 = m_oma.oma01   #FUN-530061 mod g_oma->m_oma
         IF cl_null(l_omb18t) THEN
            LET l_omb18t = 0
         END IF
         IF l_omb18t > l_ooy11 THEN
           #CALL s_errmsg("omb18t",l_omb18t,"","axm-700",1)   #No.TQC-740094   #No.FUN-D40089   Mark
            CALL s_errmsg("omb18t",l_omb18t,m_oma.oma01,"axm-700",1)           #No.FUN-D40089   Add
            LET g_success = 'N'
            LET g_totsuccess='N' #CHI-A80031 add
            CONTINUE FOREACH
         END IF
      END IF
 
      IF g_aza.aza26 != '2' AND (m_oma.oma00 = '21' OR m_oma.oma00 = '25') THEN 
         CALL s_t300_y0()    #銷退總額不得超過發票金額-已銷退或折讓金額
         IF g_success='N' THEN
            CONTINUE FOREACH
         END IF  #021226
      END IF

      # 正常確認後，若存在直接付款，則需更新相應字段
      SELECT oma65 INTO m_oma.oma65 FROM oma_file WHERE oma01=m_oma.oma01 #No.TQC-7B0165
      IF m_oma.oma65='2' THEN   #FUN-530061
         SELECT ooa01 INTO l_ooa01 FROM ooa_file WHERE ooa01 = m_oma.oma01   #FUN-530061 mod g_oma->m_oma

         LET g_forupd_sql = "SELECT * FROM ooa_file WHERE ooa01 = ? FOR UPDATE "
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         DECLARE s_t300_ooa_cl CURSOR FROM g_forupd_sql

         OPEN s_t300_ooa_cl USING l_ooa01
         IF STATUS THEN
            CALL s_errmsg('ooa01',m_oma.oma01,"OPEN s_t300_ooa_cl:", STATUS, 1)     #NO.FUN-710050
            CLOSE s_t300_ooa_cl
            LET g_success = 'N'
            LET g_totsuccess='N' #CHI-A80031 add
            CONTINUE FOREACH
         END IF
         CALL s_t300_confirm(m_oma.oma01,'')   #No.FUN-9C0014 Add ''
      END IF

      IF g_ooy.ooydmy1 = 'Y' AND g_flag2 ='Y' THEN  #MOD-940069 #CHI-AC0046
         IF m_oma.oma65 != '2' THEN   #FUN-570099             #FUN-530061 mod g_oma->m_oma
            CALL s_chknpq(m_oma.oma01,'AR',1,'0',g_bookno1)   #-->NO:0151   #FUN-530061
            IF g_aza.aza63='Y' AND g_success='Y' THEN
               CALL s_chknpq(m_oma.oma01,'AR',1,'1',g_bookno2)   #-->NO:0151   #FUN-530061
            END IF
         END IF
 
         #抓取匯兌損失(ool52,ool521)、匯兌收益(ool53,ool531)
         INITIALIZE l_ool.* TO NULL
         LET l_npq03 = ''
         LET l_npq031 = ''
         SELECT * INTO l_ool.* FROM ool_file WHERE ool01=m_oma.oma13
         
         #檢查單頭金額與分錄金額借方科目是否相符
         IF m_oma.oma00 MATCHES '2*' THEN   #FUN-530061 mod g_oma->m_oma   #MOD-920110 mod
            LET l_status= '2'            #貸
            LET l_npq03 = l_ool.ool53    #匯兌收益科目     #MOD-870331 add
            LET l_npq031= l_ool.ool531   #匯兌收益科目二   #MOD-870331 add
         ELSE
            LET l_status= '1'            #借
            LET l_npq03 = l_ool.ool52    #匯兌損失科目     #MOD-870331 add
            LET l_npq031= l_ool.ool521   #匯兌損失科目二   #MOD-870331 add
         END IF

         IF cl_null(l_npq03)  THEN LET l_npq03 = ' ' END IF   #MOD-870331 add
         IF cl_null(l_npq031) THEN LET l_npq031= ' ' END IF   #MOD-870331 add

         IF m_oma.oma00 MATCHES '2*' THEN   #FUN-530061 mod g_oma->m_oma
            #贷方金额
            SELECT SUM(ABS(npq07)) INTO l_npq07 FROM npq_file
             WHERE npq01 = m_oma.oma01 
               AND npqsys= 'AR' AND npq011 = 1   
               AND npqtype= '0' 
               AND npq00 = 2   
               AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0 )
            IF cl_null(l_npq07) THEN LET l_npq07=0 END IF

            IF l_npq07<0 THEN LET l_npq07 = (-1)*l_npq07  END IF  #FUN-590100
            IF l_npq07 !=(m_oma.oma56t+m_oma.oma53) THEN   #FUN-530061     #MOD-860185
              #CALL s_errmsg("npq07",l_npq07,"","aap-278",1)            #No.FUN-D40089   Mark
               CALL s_errmsg("npq07",l_npq07,m_oma.oma01,"aap-278",1)   #No.FUN-D40089   Add
               LET g_success = 'N'
               LET g_totsuccess='N' #CHI-A80031 add
            END IF
            IF g_aza.aza63 = 'Y' THEN
               CALL s_newrate(g_bookno1,g_bookno2,m_oma.oma23,
                              m_oma.oma58,m_oma.oma02)
               RETURNING l_rate

               SELECT SUM(ABS(npq07f)) INTO l_npq07_1 FROM npq_file     #MOD-B60021 mod npq07f
                WHERE npq01 = m_oma.oma01 
                  AND npqsys= 'AR' AND npq011 = 1
                  AND npqtype= '1'
                  AND npq00 = 2 
                  AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0 )

               IF cl_null(l_npq07_1) THEN LET l_npq07_1=0 END IF
               IF l_npq07_1<0 THEN LET l_npq07_1 = (-1)*l_npq07_1  END IF  #FUN-590100
               LET l_npq07_amt = m_oma.oma54t+m_oma.oma52                   #MOD-B60059
               CALL cl_digcut(l_npq07_amt,l_azi04_2) RETURNING l_npq07_amt  #MOD-B30709
               IF l_npq07_1 !=l_npq07_amt THEN
                 #CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)            #No.FUN-D40089   Mark
                  CALL s_errmsg("npq07",l_npq07_1,m_oma.oma01,"aap-278",1)   #No.FUN-D40089   Add
                  LET g_success = 'N'
                  LET g_totsuccess='N' #CHI-A80031 add
               END IF
            END IF
         ELSE
            IF m_oma.oma65 != '2' THEN   #FUN-570099   #FUN-530061 mod g_oma->m_oma
               IF m_oma.oma00 = '12' AND NOT cl_null(m_oma.oma19) THEN 

                  SELECT SUM(ABS(npq07)) INTO l_npq07 FROM npq_file
                   WHERE npq01 = m_oma.oma01
                     AND npqsys= 'AR' AND npq011 = 1 
                     AND npqtype = '0' 
                     AND npq00 = 2   
                     AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0 )
               ELSE     
                  SELECT SUM(ABS(npq07)) INTO l_npq07 FROM npq_file
                   WHERE npq01 = m_oma.oma01 
                     AND npqsys= 'AR' AND npq011 = 1 
                     AND npqtype= '0' 
                    #AND npq03 != l_npq03      #MOD-BC0143 mark 
                     AND npq00 = 2  
                     AND (npq06 = '1' AND npq07 > 0 OR npq06 = '2' AND npq07 < 0)
                  #No.MOD-A90001  --End  
               END IF      #MOD-940226                                  

               IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
               LET l_oga07 = 'N'
               IF m_oma.oma00 = '12' AND NOT cl_null(m_oma.oma16) THEN
                  SELECT oga07 INTO l_oga07 
                    FROM oga_file
                   WHERE oga01 = m_oma.oma16
                  IF l_oga07 = 'Y' THEN 
                     LET m_oma.oma53 = 0
                  END IF 
               END IF 
               LET l_oma53 = m_oma.oma24 * m_oma.oma52             #MOD-B60021
               CALL cl_digcut(l_oma53,g_azi04) RETURNING l_oma53   #MOD-B60021
               IF l_cnt > 0 THEN
                  IF l_npq07 != (m_oma.oma56t+l_oma53-l_oot05t) THEN       #MOD-B60021
                    #CALL s_errmsg("npq07",l_npq07,"","aap-278",1)            #No.FUN-D40089   Mark
                     CALL s_errmsg("npq07",l_npq07,m_oma.oma01,"aap-278",1)   #No.FUN-D40089   Add 
                     LET g_success = 'N'
                     LET g_totsuccess='N' 
                  END IF
               ELSE
                  IF l_npq07 !=(m_oma.oma56t+l_oma53) THEN       
                    #CALL s_errmsg("npq07",l_npq07,"","aap-278",1)           #No.FUN-D40089   Mark
                     CALL s_errmsg("npq07",l_npq07,m_oma.oma01,"aap-278",1)  #No.FUN-D40089   Add
                     LET g_success = 'N'
                     LET g_totsuccess='N' 
                  END IF
               END IF

               IF g_aza.aza63 = 'Y' THEN
                  CALL s_newrate(g_bookno1,g_bookno2,m_oma.oma23,
                                 m_oma.oma58,m_oma.oma02)
                       RETURNING l_rate
                  IF m_oma.oma00 = '12' AND NOT cl_null(m_oma.oma19) THEN 
                     SELECT SUM(ABS(npq07f)) INTO l_npq07_1 FROM npq_file     #MOD-B60021 mod npq07f
                      WHERE npq01 = m_oma.oma01
                        AND npqsys= 'AR' AND npq011 = 1 
                        AND npqtype = '1' 
                       #AND npq03 != l_ool.ool531   #MOD-BC0143 mark
                        AND npq00 = 2   
                        AND (npq06 = '2' AND npq07 > 0 OR npq06 = '1' AND npq07 < 0)
                     #No.MOD-A90001  --End  
                  ELSE     
                     SELECT SUM(ABS(npq07f)) INTO l_npq07_1 FROM npq_file     #MOD-B60021 mod npq07f
                      WHERE npq01 = m_oma.oma01 
                        AND npqsys= 'AR' AND npq011 = 1 
                        AND npqtype= '1' 
                        AND npq00 = 2  
                        AND (npq06 = '1' AND npq07 > 0 OR npq06 = '2' AND npq07 < 0)
                  END IF      #MOD-940226                                     
               
                  IF cl_null(l_npq07_1) THEN LET l_npq07_1=0 END IF


                  IF l_cnt > 0 THEN
                     LET l_npq07_amt = m_oma.oma54t+m_oma.oma52-l_oot04t          #MOD-B60059
                     CALL cl_digcut(l_npq07_amt,l_azi04_2) RETURNING l_npq07_amt  #MOD-B30709
                     IF l_npq07_1 !=l_npq07_amt THEN
                     #--No.TQC-B10142 end----
                       #CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)            #No.FUN-D40089   Mark
                        CALL s_errmsg("npq07",l_npq07_1,m_oma.oma01,"aap-278",1)   #No.FUN-D40089   Add
                        LET g_success = 'N'
                        LET g_totsuccess='N' #CHI-A80031 add
                     END IF
                  ELSE
                     LET l_npq07_amt = m_oma.oma54t+m_oma.oma52          #MOD-B60059
                     CALL cl_digcut(l_npq07_amt,l_azi04_2) RETURNING l_npq07_amt  #MOD-B30709
                     IF l_npq07_1 !=l_npq07_amt THEN
                     #--No.TQC-B10142 end----
                       #CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)            #No.FUN-D40089   Mark
                        CALL s_errmsg("npq07",l_npq07_1,m_oma.oma01,"aap-278",1)   #No.FUN-D40089   Add
                        LET g_success = 'N'
                        LET g_totsuccess='N' #CHI-A80031 add
                     END IF
                  END IF
               END IF
            END IF
         END IF
         CALL s_t300_w1('+',m_oma.oma01)     #No.FUN-AB0034
         IF g_success='Y' THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM npp_file,oma_file
             WHERE oma01=m_oma.oma01   #FUN-530061 mod g_oma->m_oma
               AND npp01=oma01 AND nppsys='AR' AND npp011=1 AND npp00=2
               AND ( YEAR(oma02) != YEAR(npp02) OR
                   (YEAR(oma02)  = YEAR(npp02) AND MONTH(oma02) != MONTH(npp02)))
            IF g_cnt >0 THEN
               LET g_showmsg=m_oma.oma01,"/",'AR',"/",1,"/",2                  #NO.FUN-710050
              #CALL s_errmsg('oma01,nppsys,npp011,npp00',g_showmsg,'','aap-279',1)    #NO.FUN-710050  #No.TQC-740094   #NO.FUN-D40089   Mark
               CALL s_errmsg('oma01,nppsys,npp011,npp00',g_showmsg,m_oma.oma01,'aap-279',1)                            #No.FUN-D40089   Add
               LET g_success = 'N'
               LET g_totsuccess='N' #CHI-A80031 add
            END IF
         END IF

         IF g_success='Y' THEN
            IF m_oma.oma213='N' THEN
               LET l_oma54x=m_oma.oma54*m_oma.oma211/100
               CALL cl_digcut(l_oma54x,t_azi04) RETURNING l_oma54x  #No.TQC-750093 g_azi -> t_azi
            ELSE
               LET l_oma54x=m_oma.oma54t*m_oma.oma211/(100+m_oma.oma211)
               CALL cl_digcut(l_oma54x,t_azi04) RETURNING l_oma54x  #No.TQC-750093 g_azi -> t_azi
            END IF
            IF l_oma54x != m_oma.oma54x THEN
              #CALL s_errmsg("oma54x",l_oma54x,"","aap-757",0)            #No.FUN-D40089   Mark
               CALL s_errmsg("oma54x",l_oma54x,m_oma.oma01,"aap-757",0)   #No.FUN-D40089   Add
            END IF
         END IF
      END IF
 
      IF g_success = 'N' THEN
          CONTINUE FOREACH #CHI-A80031 add 
         #EXIT FOREACH           #No.TQC-7B0043 #CHI-A80031 mark
      END IF
 
      IF m_oma.oma10 IS NULL OR m_oma.oma10 = ' ' THEN   #FUN-530061 mod g_oma->m_oma
         SLEEP 0
      ELSE
         IF m_oma.oma00 MATCHES '1*' THEN    #2000/04/25 modify
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM oma_file
             WHERE oma10 = g_oma.oma10 AND oma01 != g_oma.oma01
            IF l_cnt = 0 THEN
               UPDATE ome_file SET ome21  = m_oma.oma21,
                                   ome211 = m_oma.oma211,
                                   ome212 = m_oma.oma212,
                                   ome213 = m_oma.oma213,
                                   ome59  = m_oma.oma59,
                                   ome59x = m_oma.oma59x,
                                   ome59t = m_oma.oma59t,
                                   ome17  = m_oma.oma17,
                                   ome171 = m_oma.oma171,
                                   ome172 = m_oma.oma172
                WHERE ome00 = '1'
                  AND ome01 = m_oma.oma10 
                  AND (ome03 = m_oma.oma75 OR ome03 =' ')    #No.FUN-B90130  
            END IF   #MOD-630103
         END IF
      END IF
 
      LET m_oma.oma64 = '1'   #FUN-530061 mod g_oma->m_oma
 
      UPDATE oma_file SET oma64 = m_oma.oma64 WHERE oma01 = m_oma.oma01   #FUN-530061 mod g_oma->m_oma
      IF STATUS THEN
         CALL s_errmsg("oma01",m_oma.oma01,"",STATUS,1)   #No.TQC-740094
         LET g_success = 'N'
         LET g_totsuccess='N' #CHI-A80031 add
      END IF
      IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN
         CALL s_t300_ins_oct(g_oma.oma01,g_oma.oma00,'0') RETURNING i
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
             CALL s_t300_ins_oct(g_oma.oma01,g_oma.oma00,'1') RETURNING i
         END IF
         IF i = 0 THEN
            LET g_success = 'N'
            CLOSE WINDOW t300_w6
            RETURN
         END IF
      END IF   #MOD-B30601 add
 
      CALL s_ar_conf('y',m_oma.oma01,'') RETURNING i   #No.FUN-9C0014 Add ''
      CALL s_get_doc_no(m_oma.oma01) RETURNING g_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
      #CALL s_t300_omc_check()   #MOD-820044  #MOD-D80127 mark
      CALL s_t300_omc_check(m_oma.oma01)   #MOD-D80127  
 
      IF i=0 THEN
         SELECT * INTO m_oma.* FROM oma_file WHERE oma01 = m_oma.oma01
      END IF
 
      IF g_flag2 ='Y' THEN  #CHI-AC0046 add
         IF g_ooy.ooydmy1 = 'Y' THEN   #MOD-940069
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM npq_file 
             WHERE npq01= m_oma.oma01
               AND npq00= 2  
               AND npqsys= 'AR'  
               AND npq011= 1
            IF l_cnt = 0 THEN
               CALL s_t300_gen_glcr(m_oma.*,g_ooy.*)
            END IF

            IF g_success = 'Y' THEN 
               IF m_oma.oma65 != '2' THEN
                  CALL s_chknpq(m_oma.oma01,'AR',1,'0',g_bookno1)
                  IF g_aza.aza63='Y' THEN
                     CALL s_chknpq(m_oma.oma01,'AR',1,'1',g_bookno2)
                  END IF
               END IF
            END IF
            IF g_success = 'N' THEN CONTINUE FOREACH END IF #No.FUN-670047
         END IF
 
         #BUGNO:4288 回寫出貨單匯率
         IF m_oma.omaconf ='Y' AND g_ooz.ooz10='Y' THEN   
            DECLARE t300_oga CURSOR FOR SELECT omb44,omb31 FROM omb_file    
              WHERE omb01=m_oma.oma01   
 
            FOREACH t300_oga INTO l_omb44,l_omb31   
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg("omb01",m_oma.oma01,"",SQLCA.sqlcode,0)
                  EXIT FOREACH
               END IF
 
               LET g_sql = "SELECT oga23,oga24,oga09,oga011 ",                   
                           "  FROM ",cl_get_target_table(l_omb44,'oga_file'),    
                           " WHERE oga01 = '",l_omb31,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql             							
               CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql            
               PREPARE sel_oga23_pre FROM g_sql
               EXECUTE sel_oga23_pre INTO l_oga23,l_oga24,l_oga09,l_oga011      
 
               IF l_oga23 = g_aza.aza17 THEN
                  CONTINUE FOREACH       #同為本國幣別不UPDATE
               END IF
               
               IF l_oga23 = m_oma.oma23 THEN   
                  LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oga_file'), #FUN-A50102
                              "   SET oga24 = '",m_oma.oma24,"' ",
                              " WHERE oga01 = '",l_omb31,"' " 
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102             
                  PREPARE upd_oga_pre7 FROM g_sql
                  EXECUTE upd_oga_pre7
               ELSE                      #不同幣別不UPDATE
                  CONTINUE FOREACH
               END IF
               IF l_oga09 = '8' THEN
                  LET g_sql = "SELECT oga23,oga24 ",
                              "  FROM ",cl_get_target_table(l_omb44,'oga_file'), 
                              " WHERE oga01 = '",l_oga011,"' "
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql 
                  PREPARE sel_oga232_pre FROM g_sql
                  EXECUTE sel_oga232_pre INTO l_oga232,l_oga242
   
                  IF l_oga232 = g_aza.aza17 THEN
                     CONTINUE FOREACH                     #同為本國幣別不UPDATE
                  END IF

                  IF l_oga232 = m_oma.oma23 THEN   #FUN-530061 mod g_oma->m_oma
                     LET g_sql = "UPDATE ",cl_get_target_table(l_omb44,'oga_file'), 
                                 "   SET oga24 = '",m_oma.oma24,"' ",
                                 " WHERE oga01 = '",l_oga011,"' "
                     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
                     CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql 
                     PREPARE upd_oga2_pre7 FROM g_sql
                     EXECUTE upd_oga2_pre7
                  ELSE                                     #不同幣別不UPDATE
                     CONTINUE FOREACH
                  END IF
               END IF
            END FOREACH
         END IF
      END IF  #CHI-AC0046 add
   END FOREACH   #FUN-530061
   LET g_oma.oma01 = g_oma01_t #CHI-A80031 add
   IF g_totsuccess="N" THEN                  
      LET g_success="N"                     
   END IF 

   IF g_action_choice CLIPPED = "confirm"  #執行 "確認" 功能(非簽核模式呼叫)
   OR g_action_choice CLIPPED = "insert"  
   THEN
      CLOSE WINDOW t300_w6   #FUN-530061
   END IF
 
   IF g_success = 'Y' THEN
      IF g_oma.omamksg = 'Y' THEN #簽核模式
         CASE aws_efapp_formapproval()#呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
               LET g_oma.omaconf="N"
               LET g_success = "N"
               ROLLBACK WORK
               RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
               LET g_oma.omaconf="N"
               ROLLBACK WORK
               RETURN
         END CASE
      END IF

      IF g_success='Y' THEN
         LET g_oma.oma64='1'#執行成功, 狀態值顯示為 '1' 已核准
         LET g_oma.omaconf='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         DISPLAY BY NAME g_oma.omaconf
         DISPLAY BY NAME g_oma.oma64
         COMMIT WORK
         CALL cl_flow_notify(g_oma.oma01,'Y')
      ELSE
         LET g_oma.omaconf='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET g_oma.omaconf='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN
      IF NOT cl_null(g_oma.oma99) THEN 
         LET l_buser = '0'  
         LET l_euser = 'z' 
      ELSE                 
         LET l_buser = g_oma.omauser 
         LET l_euser = g_oma.omauser  
      END IF                    
      LET g_wc_gl = 'npp01 = "',m_oma.oma01,'" AND npp011 = 1'
      LET g_str="axrp590 '",g_wc_gl CLIPPED,"' '",l_buser,"' '",l_euser,"' '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",m_oma.oma02,"' 'Y' '1' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"   #No.FUN-670047  #No.MOD-860075  #MOD-910250 #No.MOD-920343
      CALL cl_cmdrun_wait(g_str)
      SELECT oma33 INTO g_oma.oma33 FROM oma_file
       WHERE oma01 = m_oma.oma01
      DISPLAY BY NAME m_oma.oma33
   END IF
 
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = g_oma.oma01

END FUNCTION


FUNCTION s_t300_y0()
   DEFINE l_oha16 LIKE oha_file.oha16
   DEFINE l_ohb30 LIKE ohb_file.ohb30                      #canny(980824)
   DEFINE l_oha01 LIKE oha_file.oha01,
          l_omb   RECORD   LIKE omb_file.*,
          l_diff1,l_diff2,l_diff3  LIKE oma_file.oma56t
   DEFINE lb_oma01   LIKE oma_file.oma01
   DEFINE lb_omaconf LIKE oma_file.omaconf
   DEFINE lb_oma00   LIKE oma_file.oma00
   DEFINE lb_oma54t  LIKE oma_file.oma54t
   DEFINE lb_oma56t  LIKE oma_file.oma56t
   DEFINE lb_oma59t  LIKE oma_file.oma59t
   DEFINE l_ohb31    LIKE ohb_file.ohb31
   DEFINE l_oma54t,l_oma56t  LIKE oma_file.oma54t
   DEFINE l_oma59t           LIKE oma_file.oma59t
   DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5,l_tot6  LIKE type_file.num20_6   
   DEFINE l_tot22,l_tot42,l_tot62                    LIKE type_file.num20_6   
   DEFINE l_str3,l_str4   STRING    #No.FUN-570099
   DEFINE l_str           STRING    #MOD-750142
 
### 需考慮一張發票可能同時有銷退和折扣
   INITIALIZE l_omb.* TO NULL
   DECLARE t300_by_omb CURSOR FOR
    SELECT omb31,SUM(omb14t),SUM(omb16t),SUM(omb18t),omb44 FROM omb_file 
     WHERE omb01 = g_oma.oma01
     GROUP BY omb31,omb44      

   FOREACH t300_by_omb INTO l_omb.omb31,l_omb.omb14t,l_omb.omb16t,l_omb.omb18t,l_omb.omb44 
      IF STATUS THEN 
         CALL s_errmsg("omb01",g_oma.oma01,"foreach omb",STATUS,0)
         EXIT FOREACH
      END IF

      LET li_dbs = ''
      IF NOT cl_null(l_omb.omb44) THEN
         LET g_plant_new = l_omb.omb44
      ELSE
         LET g_plant_new = g_plant
      END IF

      LET l_tot1 = 0
      LET l_tot2 = 0   LET l_tot22 = 0
      LET l_tot3 = 0
      LET l_tot4 = 0   LET l_tot42 = 0
      IF g_oma.oma00 = '25' THEN
         ### 得多張銷折
         SELECT SUM(omb14t),SUM(omb16t),SUM(omb18t)
           INTO l_tot1,l_tot2,l_tot22
           FROM omb_file,oma_file
          WHERE omb31 = l_omb.omb31     ### 出貨單
            AND omb01 = oma01 AND omaconf ='Y'
            AND oma00 = '25'
         IF STATUS OR l_tot1 IS NULL THEN
            LET l_tot1 = 0
            LET l_tot2 = 0   LET l_tot22 = 0
         END IF

         LET g_sql = " SELECT oha01 FROM ",cl_get_target_table(g_plant_new,'oha_file'), #FUN-A50102
                     "  WHERE oha16 = '",l_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         DECLARE a_curs CURSOR FROM g_sql

         FOREACH a_curs INTO l_oha01
            IF STATUS THEN EXIT FOREACH END IF              #MOD-AC0233
            SELECT SUM(omb14t),SUM(omb16t),SUM(omb18t)
              INTO l_tot5,l_tot6,l_tot62
              FROM omb_file,oma_file
             WHERE omb31 = l_oha01
               AND omb01 = oma01 AND omaconf ='Y'
               AND oma00 = '21'
            IF STATUS OR l_tot5 IS NULL THEN
               LET l_tot5 = 0
               LET l_tot6 = 0  LET l_tot62 = 0
            END IF
            LET l_tot3  = l_tot3  + l_tot5
            LET l_tot4  = l_tot4  + l_tot6
            LET l_tot42 = l_tot42 + l_tot62
         END FOREACH
         SELECT oma54t,oma56t,oma59t INTO l_oma54t,l_oma56t,l_oma59t
           FROM oma_file
          WHERE oma01 = g_oma.oma16
            AND omaconf = 'Y'
            AND oma00 MATCHES '1*'
         IF STATUS OR l_oma54t IS NULL THEN
            LET l_oma54t = 0
            LET l_oma56t = 0
            LET l_oma59t = 0
         END IF
      ELSE
         LET g_sql = " SELECT UNIQUE ohb31,ohb30",
                     "   FROM ",cl_get_target_table(g_plant_new,'ohb_file'), #FUN-A50102
                     "  WHERE ohb01 = '",l_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE sel_ohb_pre83 FROM g_sql
         EXECUTE sel_ohb_pre83 INTO l_oha16,l_ohb30

         IF STATUS = 0 THEN
            LET g_sql = " SELECT unique oha01 ",
                        "   FROM ",cl_get_target_table(g_plant_new,'oha_file'),",", #FUN-A50102
                                   cl_get_target_table(g_plant_new,'ohb_file'),      #FUN-A50102
                        "  WHERE oha16 = '",l_oha16,"'",
                        "    AND oha01 = ohb01",
                        "    AND ohb30 = '",l_ohb30,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            DECLARE b_curs CURSOR FROM g_sql

            FOREACH b_curs INTO l_oha01
               IF STATUS THEN EXIT FOREACH END IF              #MOD-AC0233
               SELECT SUM(omb14t),SUM(omb16t),SUM(omb18t)
                 INTO l_tot3,l_tot4,l_tot42
                 FROM omb_file,oma_file
                WHERE omb31 = l_oha01
                  AND omb01 = oma01 AND omaconf ='Y'
                  AND oma00 = '21'
               IF STATUS OR l_tot3 IS NULL  THEN
                  LET l_tot3 = 0
                  LET l_tot4 = 0  LET l_tot42 = 0
               END IF
               IF cl_null(l_tot3)  THEN LET l_tot3 = 0 END IF
               IF cl_null(l_tot4)  THEN LET l_tot4 = 0 END IF
               IF cl_null(l_tot42) THEN LET l_tot42 = 0 END IF
               LET l_tot1  = l_tot1 + l_tot3
               LET l_tot2  = l_tot2 + l_tot4
               LET l_tot22 = l_tot22 + l_tot42
            END FOREACH
         END IF

         ### 得多張銷折
         LET l_tot3 = 0 LET l_tot4 = 0 LET l_tot42 = 0
         SELECT SUM(omb14t),SUM(omb16t),SUM(omb18t)
           INTO l_tot3,l_tot4,l_tot42
           FROM omb_file,oma_file
          WHERE omb31 = l_oha16     ### 出貨單
            AND omb01 = oma01 AND omaconf ='Y'
            AND oma00 = '25'
         IF STATUS OR l_tot3 IS NULL THEN
            LET l_tot3 = 0
            LET l_tot4 = 0
         END IF

         IF cl_null(l_tot3)  THEN LET l_tot3 = 0 END IF
         IF cl_null(l_tot4)  THEN LET l_tot4 = 0 END IF
         IF cl_null(l_tot42) THEN LET l_tot42 = 0 END IF
         IF cl_null(l_oma54t) THEN LET l_oma54t = 0 END IF  #原幣應收含稅金額
         IF cl_null(l_oma56t) THEN LET l_oma56t = 0 END IF  #本幣應收含稅金額
         IF cl_null(l_oma59t) THEN LET l_oma59t = 0 END IF  #本幣發票含稅金額

         LET g_sql = " SELECT ohb31 ",
                     "   FROM ",cl_get_target_table(g_plant_new,'oha_file'),",", #FUN-A50102
                                cl_get_target_table(g_plant_new,'ohb_file'),     #FUN-A50102
                     "  WHERE ohb01=oha01",
                     "    AND oha01='",l_oha01,"'",                              #MOD-A60017
                     "    AND ohaconf='Y'"                                       #MOD-A60017
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
         DECLARE cur_ohb CURSOR FROM g_sql

         FOREACH cur_ohb INTO l_ohb31
            IF SQLCA.SQLCODE THEN
              #CALL s_errmsg("oha01",l_oha01,"",SQLCA.sqlcode,1)            #No.FUN-D40089   Mark
               CALL s_errmsg("oha01",l_oha01,g_oma.oma01,SQLCA.sqlcode,1)   #No.FUN-D40089   Add 
               LET g_success='N'
            END IF
            
            SELECT sum(omb14t),sum(omb16t),sum(omb18t) INTO lb_oma54t,lb_oma56t,lb_oma59t
              FROM oma_file,omb_file
             WHERE omb31=l_ohb31
               AND oma01=omb01
               AND omaconf='Y'
               AND oma00='12'
            
            LET l_oma54t=lb_oma54t
            LET l_oma56t=lb_oma56t
            LET l_oma59t=lb_oma59t
            IF cl_null(l_oma54t) THEN LET l_oma54t = 0 END IF  #原幣應收含稅金額
            IF cl_null(l_oma56t) THEN LET l_oma56t = 0 END IF  #本幣應收含稅金額
            IF cl_null(l_oma59t) THEN LET l_oma59t = 0 END IF  #本幣發票含稅金額
            
            LET l_diff3 = l_oma59t - (l_tot22+l_tot42+l_omb.omb18t)
            IF l_diff3<0 THEN    #bugno:6244 021219
               SELECT SUM(amd06) INTO l_oma59t
                 FROM amd_file
                WHERE amd03=l_ohb30
                  AND amd30='Y'
               IF cl_null(l_oma59t) THEN
                  LET l_oma59t = 0 
               END IF
               LET l_oma54t = l_oma59t          #MOD-C20200 add 
               LET l_oma56t = l_oma59t          #MOD-C20200 add
               LET l_diff3 = l_oma59t - (l_tot22+l_tot42+l_omb.omb18t)
            END IF
            LET l_diff1 = l_oma54t - (l_tot1 +l_tot3 +l_omb.omb14t)  #MOD-C20200 add
            LET l_diff2 = l_oma56t - (l_tot2 +l_tot4 +l_omb.omb16t)  #MOD-C20200 add
            
            IF l_diff1 < 0 OR l_diff2 < 0 OR l_diff3 < 0 THEN
               CALL cl_getmsg('axr-305',g_lang) RETURNING l_str3
               CALL cl_getmsg('axr-306',g_lang) RETURNING l_str4
               LET l_str = l_str3,l_omb.omb31,l_str4,l_diff1,"/",l_diff2,"/",l_diff3
               CALL cl_err(l_str,'!',1) 
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END FOREACH   #no:4976 021227
      END IF
   END FOREACH
END FUNCTION 


FUNCTION s_t300_y_chk()              # when g_oma.omaconf='N' (Turn to 'Y')
   DEFINE l_occ     RECORD LIKE occ_file.*
   DEFINE l_cnt     LIKE type_file.num5   #No.FUN-680123 SMALLINT
   DEFINE l_oot05t  LIKE oot_file.oot05t
   DEFINE l_oov04f  LIKE oov_file.oov04f  #FUN-590100
   DEFINE l_oov04   LIKE oov_file.oov04   #FUN-590100
   DEFINE l_omc08   LIKE omc_file.omc08   #No.FUN-680022
   DEFINE l_omc09   LIKE omc_file.omc09   #No.FUN-680022
   DEFINE l_npq07f  LIKE npq_file.npq07f, #TQC-750177
          l_oob09   LIKE oob_file.oob09   #TQC-750177
   DEFINE l_errmsg  STRING                #No.MOD-920296 
 
   LET g_success = 'Y'
   SELECT * INTO g_oma.* FROM oma_file
    WHERE oma01 = g_oma.oma01
 
   IF g_oma.omaconf = 'Y' THEN
     #CALL s_errmsg('','','','axr-101',1)                 #NO.FUN-D40089   Mark 
      CALL s_errmsg('oma01',g_oma.oma01,'','axr-101',1)   #No.FUN-D40089   Add
      LET g_success = 'N'
   END IF
 
   IF g_oma.omavoid = 'Y' THEN
     #CALL s_errmsg('','','','axr-103',1) #CHI-A80031     #No.FUN-D40089   Mark
      CALL s_errmsg('oma01',g_oma.oma01,'','axr-103',1)   #No.FUN-D40089   Add 
      LET g_success = 'N'
   END IF
 
   LET l_errmsg = NULL 
   CALL s_t300_chk_omb31_32(g_oma.oma01) RETURNING l_errmsg
   IF NOT cl_null(l_errmsg) THEN 
     #CALL s_errmsg('',l_errmsg,'','axr-074',1) #CHI-A80031   #No.FUN-D40089   Mark
      CALL s_errmsg('',l_errmsg,g_oma.oma01,'axr-074',1)      #No.FUN-D40089   Add 
      LET g_success = 'N'
   END IF 

   LET g_flag2 = 'Y'
   IF g_oma.oma54t = 0  THEN
      CALL cl_getmsg('axr-083',g_lang) RETURNING g_msg
      LET g_msg = g_oma.oma01,g_msg
      IF cl_confirm(g_msg) THEN 
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt
           FROM omb_file 
          WHERE omb01 = g_oma.oma01
         IF l_cnt = 0 THEN
           #CALL s_errmsg('','','','amr-304',1)                 #No.FUN-D40089   Mark 
            CALL s_errmsg('oma01',g_oma.oma01,'','amr-304',1)   #No.FUN-D40089   Add 
            LET g_success = 'N'
         END IF
         LET g_flag2 = 'N' #不檢查,直接確認
      ELSE
         LET g_flag2 = 'Y'
         LET g_success = 'N'
      END IF
      RETURN
   END IF
 
   IF g_ooy.ooydmy2='Y' THEN
      LET l_cnt = 0   #MOD-BB0328
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_oma.oma01
         AND npq011 =  1
         AND npqsys = 'AR'
         AND npq00 = 2
         AND npqtype = '0'
         AND npq03 = g_oma.oma18
         AND npq06 = '1'
      
      IF l_cnt > 0 THEN 
         LET l_npq07f = 0
         LET l_oob09 = 0
         SELECT SUM(oob09) INTO l_oob09 FROM oob_file, ooa_file
          WHERE oob01=g_oma.oma01 AND oob01=ooa01 AND ooaconf<>'X'
            AND oob03='1'  AND oob04='2' 
            AND oob02 > 0 
         IF l_oob09 IS NULL THEN LET l_oob09 = 0 END IF       #MOD-A80138
        
         SELECT npq07f INTO l_npq07f FROM npq_file
          WHERE npq01 = g_oma.oma01
            AND npq011 =  1
            AND npqsys = 'AR'
            AND npq00 = 2
            AND npqtype = '0'
            AND npq03 = g_oma.oma18
            AND npq06 = '1'
         IF l_npq07f IS NULL THEN LET l_npq07f = 0 END IF     #MOD-A80138
         LET l_npq07f = l_npq07f * -1                         #No.MOD-A90003 
         IF l_npq07f <> (g_oma.oma54t - l_oob09) THEN
           #CALL s_errmsg('','','','axr-111',1) #CHI-A80031     #No.FUN-D40089   Mark
            CALL s_errmsg('oma01',g_oma.oma01,'','axr-111',1)   #No.FUN-D40089   Add
            LET g_success = 'N'
         END IF
      ELSE
        #CALL s_errmsg('','','','aap-995',1) #CHI-A80031        #No.FUN-D40089   Mark
         CALL s_errmsg('oma01',g_oma.oma01,'','aap-995',1)      #No.FUN-D40089   Add
         LET g_success = 'N'
      END IF

      IF g_aza.aza63 = 'Y' THEN
         LET l_cnt = 0   #MOD-BB0328
         SELECT COUNT(*) INTO l_cnt FROM npq_file
          WHERE npq01 = g_oma.oma01
            AND npq011 =  1
            AND npqsys = 'AR'
            AND npq00 = 2
            AND npqtype = '1'
            AND npq03 = g_oma.oma181
            AND npq06 = '1'
 
         IF l_cnt > 0 THEN 
            LET l_npq07f = 0
            LET l_oob09 = 0
            SELECT SUM(oob09) INTO l_oob09 FROM oob_file, ooa_file
             WHERE oob01=g_oma.oma01 AND oob01=ooa01 AND ooaconf<>'X'
               AND oob03='1'  AND oob04='2' 
               AND oob02 > 0 
            IF l_oob09 IS NULL THEN LET l_oob09 = 0 END IF       #MOD-A80138
            
            SELECT npq07f INTO l_npq07f FROM npq_file
             WHERE npq01 = g_oma.oma01
               AND npq011 =  1
               AND npqsys = 'AR'
               AND npq00 = 2
               AND npqtype = '1'
               AND npq03 = g_oma.oma181
               AND npq06 = '1'
            IF l_npq07f IS NULL THEN LET l_npq07f = 0 END IF     #MOD-A80138
            IF l_npq07f<0 THEN LET l_npq07f = (-1)*l_npq07f  END IF  #MOD-AB0174
            
            IF l_npq07f <> (g_oma.oma54t - l_oob09) THEN
              #CALL s_errmsg('','','','axr-112',1) #CHI-A80031   #No.FUN-D40089   Mark
               CALL s_errmsg('oma01',g_oma.oma01,'','axr-112',1) #No.FUN-D40089   Add 
               LET g_success = 'N'
            END IF
         ELSE
          #CALL s_errmsg('','','','aap-975',1) #CHI-A80031   #No.FUN-D40089   Mark
           CALL s_errmsg('oma01',g_oma.oma01,'','aap-975',1) #No.FUN-D40089   Add 
           LET g_success = 'N'
         END IF
      END IF
   END IF
 
   SELECT SUM(omc08),SUM(omc09) INTO l_omc08,l_omc09 FROM omc_file                                                            
    WHERE omc01 =g_oma.oma01                                                                                                  
   IF l_omc08 IS NULL THEN LET l_omc08 = 0 END IF     #MOD-A80138
   IF l_omc09 IS NULL THEN LET l_omc09 = 0 END IF     #MOD-A80138

   IF l_omc08 <>g_oma.oma54t OR l_omc09 <>g_oma.oma56t THEN                                                                   
     #CALL s_errmsg('','','','axr-025',1) #CHI-A80031   #No.FUN-D40089   Mark
      CALL s_errmsg('oma01',g_oma.oma01,'','axr-025',1) #No.FUN-D40089   Add
      LET g_success = 'N'
   END IF                

   SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = g_oma.oma03
   IF l_occ.occacti = 'N' THEN
     #CALL s_errmsg('occ01',l_occ.occ01,'','9028',1) #CHI-A80031   #No.FUN-D40089   Mark
      CALL s_errmsg('occ01',l_occ.occ01,g_oma.oma01,'9028',1)      #No.FUN-D40089   Add 
      LET g_success = 'N'
   END IF

   IF g_oma.oma00 = '12' or g_oma.oma00 = '13' or g_oma.oma00='21' THEN #來源類型為出貨及尾款或折讓
      IF g_bgjob='N' OR cl_null(g_bgjob) THEN       #FUN-890128
         IF g_oma.oma50 <0 or g_oma.oma50t<0 or g_oma.oma56 <0 or 
            g_oma.oma56t<0 or g_oma.oma59 <0 or g_oma.oma59t<0 THEN
            IF cl_confirm('axr-151') THEN         #繼續輸入單身
               CALL t300_b()
            END IF
         END IF
      END IF          #FUN-890128
   END IF


   IF g_action_choice CLIPPED = "confirm" OR     #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  THEN 
      IF g_oma.omamksg='Y' THEN       #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_oma.oma64 != '1' THEN
           #CALL s_errmsg('occ01',l_occ.occ01,'','aws-078',1)            #No.FUN-D40089   Mark 
            CALL s_errmsg('occ01',l_occ.occ01,g_oma.oma01,'aws-078',1)   #No.FUN-D40089   Add
            LET g_success = 'N'
         END IF
      END IF
   END IF

END FUNCTION   

FUNCTION s_t300_chk_omb31_32(p_oma01)
DEFINE   p_oma01   LIKE oma_file.oma01
DEFINE   l_omb38   LIKE omb_file.omb38
DEFINE   l_omb31   LIKE omb_file.omb31
DEFINE   l_omb32   LIKE omb_file.omb32
DEFINE   l_omb03   LIKE omb_file.omb03
DEFINE   l_cnt     LIKE type_file.num5
DEFINE   l_msg     STRING 
DEFINE   l_err     STRING
DEFINE   l_conf    LIKE type_file.chr1   
DEFINE   l_omb44   LIKE omb_file.omb44   #FUN-9C0041
DEFINE   p_dbs     LIKE type_file.chr21  #FUN-9C0041  
DEFINE   l_oha09   LIKE oha_file.oha09      #MOD-A80073
DEFINE   l_ohb12   LIKE ohb_file.ohb12      #MOD-A80073
DEFINE   l_qty     LIKE omb_file.omb12   
DEFINE   l_ogb917  LIKE ogb_file.ogb917 
DEFINE   l_ogb64   LIKE ogb_file.ogb64    
DEFINE   l_omb12   LIKE omb_file.omb12  
DEFINE   l_ohb917  LIKE ohb_file.ohb917 

   LET l_err   = NULL 

   IF cl_null(p_oma01) THEN 
      RETURN l_err
   END IF 

   DECLARE sel_omb_cs CURSOR FOR 
    SELECT omb44,omb38,omb31,omb32,omb03,omb12 FROM omb_file    
     WHERE omb01 = p_oma01

   FOREACH sel_omb_cs INTO l_omb44,l_omb38,l_omb31,l_omb32,l_omb03,l_omb12   
      IF STATUS THEN EXIT FOREACH END IF    
      LET l_msg   = NULL 

      IF cl_null(l_omb38) OR l_omb38 = '99' THEN   
         CONTINUE FOREACH
      END IF 
      CASE 
         WHEN l_omb38='1'
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_omb44,'oeb_file'), #FUN-A50102
                        " WHERE oeb01 = '",l_omb31,"' ",
                        "   AND oeb03 = '",l_omb32,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102             
            PREPARE sel_cou_oeb FROM g_sql
            EXECUTE sel_cou_oeb INTO l_cnt
            IF l_cnt = 0 THEN 
               LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
               LET l_msg = l_msg,'|',cl_getmsg('axs-002',g_lang),':',l_omb31,'-',l_omb32,'\n'
               LET l_err = l_msg
            ELSE
               #LET g_sql = "SELECT oeaconf FROM ",p_dbs CLIPPED,"oea_file ",
               LET g_sql = "SELECT oeaconf FROM ",cl_get_target_table(l_omb44,'oea_file'), #FUN-A50102
                           " WHERE oea01 = '",l_omb31,"' "
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102             
               PREPARE sel_oeaconf_pre FROM g_sql
               EXECUTE sel_oeaconf_pre INTO l_conf
               IF l_conf != 'Y' THEN 
                  LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
                  LET l_msg = l_msg,'|',cl_getmsg('axs-002',g_lang),':',l_omb31,'-',l_omb32,'\n'
                  LET l_err = l_msg
               END IF 
            END IF
         WHEN l_omb38='2' OR l_omb38='4'
            #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs CLIPPED,"ogb_file ",
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_omb44,'ogb_file'), #FUN-A50102
                        " WHERE ogb01 = '",l_omb31,"' ",
                        "   AND ogb03 = '",l_omb32,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102             
            PREPARE sel_cou_ogb FROM g_sql
            EXECUTE sel_cou_ogb INTO l_cnt
            IF l_cnt = 0 THEN 
               LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
               LET l_msg = l_msg,'|',cl_getmsg('aqc-991',g_lang),':',l_omb31,'-',l_omb32,'\n'
               LET l_err = l_msg
            ELSE 
               LET g_sql = "SELECT ogapost FROM ",cl_get_target_table(l_omb44,'oga_file'), #FUN-A50102
                           " WHERE oga01 = '",l_omb31,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102              
               PREPARE sel_ogapost_pre FROM g_sql
               EXECUTE sel_ogapost_pre INTO l_conf
               IF l_conf != 'Y' THEN 
                  LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
                  LET l_msg = l_msg,'|',cl_getmsg('aqc-991',g_lang),':',l_omb31,'-',l_omb32,'\n'
                  LET l_err = l_msg
               END IF
               IF l_omb38 ='2' THEN
                  SELECT abs(SUM(omb12)) INTO l_qty FROM omb_file,oma_file
                   WHERE oma00='12'
                     AND oma01=omb01
                     AND omavoid='N'
                     AND omb31=l_omb31
                     AND omb32=l_omb32

               SELECT ogb917,ogb64 INTO l_ogb917,l_ogb64
                 FROM ogb_file
                WHERE ogb01=l_omb31
                  AND ogb03=l_omb32

                  IF cl_null(l_qty) THEN LET l_qty=0 END IF
                     LET l_qty=(l_qty-abs(l_omb12)+abs(l_omb12))-
                               (l_ogb917-l_ogb64)
               END IF
               IF l_qty > 0 THEN
                  LET l_msg = cl_getmsg('axr-126',g_lang),':',l_omb03 USING '#####&'
                  LET l_msg = l_msg,'|',cl_getmsg('aqc-991',g_lang),':',l_omb31,'-',l_omb32,'\n'
                  LET l_err = l_msg
               END IF
            END IF
         WHEN l_omb38='3' OR l_omb38='5'
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_omb44,'ohb_file'), #FUN-A50102
                        " WHERE ohb01 = '",l_omb31,"' ",
                        "   AND ohb03 = '",l_omb32,"' "
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql #FUN-A50102                 
            PREPARE sel_cou_ohb FROM g_sql
            EXECUTE sel_cou_ohb INTO l_cnt
            IF l_cnt = 0 THEN 
               LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
               LET l_msg = l_msg,'|',cl_getmsg('axm-113',g_lang),':',l_omb31,'-',l_omb32,'\n'
               LET l_err = l_msg
            ELSE 
               LET g_sql = "SELECT oha09,ohapost FROM ",cl_get_target_table(l_omb44,'oha_file'), 
                           " WHERE oha01 = '",l_omb31,"' "
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              							
                  CALL cl_parse_qry_sql(g_sql,l_omb44) RETURNING g_sql              
               PREPARE sel_ohapost_pre FROM g_sql
               EXECUTE sel_ohapost_pre INTO l_oha09,l_conf       
               IF l_conf != 'Y' THEN 
                  LET l_msg = cl_getmsg('aap-417',g_lang),':',l_omb03 USING '#####&'
                  LET l_msg = l_msg,'|',cl_getmsg('axm-113',g_lang),':',l_omb31,'-',l_omb32,'\n'
                  LET l_err = l_msg
               END IF 
               IF l_omb38 = '3' THEN
                  LET l_sql = "SELECT ohb12  FROM ",cl_get_target_table(l_omb44,'ohb_file'), 
                              " WHERE ohb01='",l_omb31,"' AND ohb03='",l_omb32,"' ",                 
                             "   AND (ohb1005 !='2' OR ohb1005 IS NULL)"  
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql             
                  CALL cl_parse_qry_sql(l_sql,l_omb44) RETURNING l_sql                 
                  PREPARE sel_ohb_pre2 FROM l_sql
                  EXECUTE sel_ohb_pre2 INTO l_ohb12 
                  IF cl_null(l_oha09) THEN LET l_oha09=' ' END IF
                  LET l_cnt = 0 
                  SELECT count(*) INTO l_cnt
                    FROM oma_file,omb_file           #MOD-B90053
                   WHERE omb01 <> p_oma01 AND omb31 = l_omb31 
                     AND omb32 = l_omb32
                     AND oma01 = omb01               #MOD-B90053
                     AND omavoid = 'N'               #MOD-B90053
                  SELECT abs(SUM(omb12)) INTO l_omb12 FROM oma_file,omb_file
                   WHERE oma01=omb01 AND omavoid='N'
                     AND omb31=l_omb31 AND omb32=l_omb32
                  IF cl_null(l_omb12) THEN LET l_omb12=0 END IF
                  IF (l_oha09 = '5' AND l_cnt > 0) OR (l_oha09!='5' AND l_omb12 > l_ohb12) THEN     #MOD-A80163
                     LET l_msg = cl_getmsg('axr-390',g_lang),':',l_omb03 USING '#####&'
                     LET l_msg = l_msg,'|',cl_getmsg('axm-113',g_lang),':',l_omb31,'-',l_omb32,'\n'
                     LET l_err = l_msg
                  END IF 
                  SELECT abs(SUM(omb12)) INTO l_qty FROM omb_file,oma_file
                   WHERE oma00='12'
                     AND oma01=omb01
                     AND omavoid='N'
                     AND omb31=l_omb31
                     AND omb32=l_omb32

                  SELECT ohb917 INTO l_ohb917
                    FROM ohb_file
                   WHERE ohb01=l_omb31
                     AND ohb03=l_omb32

                      IF cl_null(l_qty) THEN LET l_qty=0 END IF
                         LET l_qty=(l_qty-abs(l_omb12)+abs(l_omb12))-l_ohb917

                  IF l_qty > 0 THEN
                     LET l_msg = cl_getmsg('axr-126',g_lang),':',l_omb03 USING '#####&'
                     LET l_msg = l_msg,'|',cl_getmsg('axm-113',g_lang),':',l_omb31,'-',l_omb32,'\n'
                     LET l_err = l_msg
                  END IF
               END IF   
            END IF
      END CASE 
   END FOREACH
  
   RETURN l_err
   
END FUNCTION

 
FUNCTION s_t300_gen_glcr(p_oma,p_ooy)
   DEFINE p_oma     RECORD LIKE oma_file.*
   DEFINE p_ooy     RECORD LIKE ooy_file.*
 
   IF cl_null(p_ooy.ooygslp) THEN
      CALL s_errmsg("oma01",p_oma.oma01,"","axr-070",1)
      LET g_success = 'N'
      RETURN
   END IF       
   CALL s_t300_v0()
   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION

FUNCTION s_t300_v()
   DEFINE l_wc         STRING   #MOD-870237 mod
   DEFINE l_oma01      LIKE oma_file.oma01
   DEFINE only_one     LIKE type_file.chr1    #No.FUN-680123 VARCHAR(1)
   DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680123 SMALLINT
   DEFINE ls_tmp       STRING
   DEFINE l_cnt        LIKE type_file.num5    #No.FUN-680123 SMALLINT   #FUN-530041
   DEFINE l_chr        LIKE type_file.chr1
   
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = g_oma.oma01
   IF g_oma.omaconf = 'Y' THEN RETURN END IF
   IF g_oma.omavoid = 'Y' THEN RETURN END IF
   IF g_ooy.ooydmy1 = 'N' THEN RETURN END IF
   IF g_oma.oma64 MATCHES '[1]' THEN      #FUN-8A0075 
      RETURN
   END IF
 
   LET p_row = 7 LET p_col = 11
   OPEN WINDOW t3009_w AT p_row,p_col WITH FORM "axr/42f/axrt3009"
   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axrt3009")
 
   LET only_one = '1'
   INPUT BY NAME only_one WITHOUT DEFAULTS
      AFTER FIELD only_one
         IF only_one NOT MATCHES "[12]" THEN 
            NEXT FIELD only_one 
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
   IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t3009_w RETURN END IF
   IF only_one = '1' THEN
      LET l_wc = " oma01 = '",g_oma.oma01,"' "
   ELSE
      CONSTRUCT BY NAME l_wc ON oma00,oma08,oma01,oma02,oma14,oma15
      BEFORE CONSTRUCT
      CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
    
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
    
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
  
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t3009_w RETURN END IF
   END IF
   CLOSE WINDOW t3009_w
   IF only_one = '1' THEN
      #重新抓取關帳日期
      SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
      #FUN-B50090 add -end--------------------------
      IF g_oma.oma02 <= g_ooz.ooz09 THEN
         CALL cl_err(g_oma.oma02,'axr-164',0) RETURN
      END IF
   END IF
   MESSAGE "WORKING !"
   BEGIN WORK
 
   #OPEN t300_cl USING g_oma.oma01
   #IF STATUS THEN
   #   CALL cl_err("OPEN t300_cl:", STATUS, 1)
   #   CLOSE t300_cl
   #   ROLLBACK WORK
   #   RETURN
   #END IF
   #FETCH t300_cl INTO g_oma.*          # 鎖住將被更改或取消的資料
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err(g_oma.oma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
   #   CLOSE t300_cl ROLLBACK WORK RETURN
   #END IF
   LET g_success = 'Y'
   LET g_sql = "SELECT oma01,oma20 FROM oma_file",
       " WHERE ",l_wc CLIPPED,
       " AND omaconf = 'N' ",   #MOD-710205
       " AND oma01 IN ",   #FUN-530041
       " (SELECT npq01 FROM npq_file WHERE npq00 = 2 AND npqsys = 'AR'",   #FUN-530041
       " AND npq011 = 1)"    #FUN-530041
   IF only_one <> '1' THEN
      #重新抓取關帳日期
      SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
      IF NOT cl_null(g_ooz.ooz09) THEN
         LET g_sql = g_sql CLIPPED," AND oma02 >'",g_ooz.ooz09,"'"
      END IF
   END IF
   PREPARE t300_v_p2 FROM g_sql
   DECLARE t300_v_c2 CURSOR FOR t300_v_p2
   LET l_cnt = 0   #FUN-530041
   CALL s_showmsg_init()              #NO.FUN-710050
   FOREACH t300_v_c2 INTO l_oma01,l_chr
      IF STATUS THEN LET g_success = 'N' EXIT FOREACH END IF   #No.FUN-8A0086
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
 
      IF l_chr='N' THEN
         CALL cl_err(g_oma.oma01,'axr-176',1)   #MOD-8A0018 add
         CONTINUE FOREACH
      END IF
      IF l_cnt = 0 THEN
         IF NOT s_ask_entry(l_oma01) THEN EXIT FOREACH END IF
         DELETE FROM npq_file WHERE npq01 = l_oma01 AND npq00 = 2
                                AND npqsys = 'AR'  AND npq011 = 1
         DELETE FROM tic_file WHERE tic04 = l_oma01
         IF g_oma.oma65 != '2' THEN
            CALL s_t300_gl(l_oma01,'0')     #No.FUN-A10104
            IF g_aza.aza63='Y' AND g_success='Y' THEN 
               CALL s_t300_gl(l_oma01,'1')  #No.FUN-A10104
            END IF  
         ELSE
            CALL s_t300_rgl(l_oma01,'0')    #No.FUN-A10104
            IF g_aza.aza63='Y' AND g_success='Y' THEN
              CALL s_t300_rgl(l_oma01,'1') #No.FUN-A10104
            END IF  
         END IF
         LET l_cnt = l_cnt + 1
      ELSE
         DELETE FROM npq_file WHERE npq01 = l_oma01 AND npq00 = 2
                                AND npqsys = 'AR'  AND npq011 = 1
         DELETE FROM tic_file WHERE tic04 = l_oma01
         IF g_oma.oma65 != '2' THEN
            CALL s_t300_gl(l_oma01,'0')     #No.FUN-A10104
            IF g_aza.aza63='Y' AND g_success='Y' THEN
               CALL s_t300_gl(l_oma01,'1')  #No.FUN-A10104
            END IF  
         ELSE
            CALL s_t300_rgl(l_oma01,'0')    #No.FUN-A10104
            IF g_aza.aza63='Y' AND g_success='Y' THEN
               CALL s_t300_rgl(l_oma01,'1')#No.FUN-A10104
            END IF  
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   LET g_sql = "SELECT oma01,oma20 FROM oma_file",
       " WHERE ",l_wc CLIPPED,
       " AND omaconf = 'N' ",   #MOD-710205
       " AND oma01 NOT IN ",    #FUN-530041
       " (SELECT npq01 FROM npq_file WHERE npq00 = 2 AND npqsys = 'AR'",   #FUN-530041
       " AND npq011 = 1)"    #FUN-530041
   IF only_one <> '1' THEN
      #重新抓取關帳日期
      SELECT ooz09 INTO g_ooz.ooz09 FROM ooz_file WHERE ooz00='0'
      IF NOT cl_null(g_ooz.ooz09) THEN
         LET g_sql = g_sql CLIPPED," AND oma02 >'",g_ooz.ooz09,"'"
      END IF
   END IF
   PREPARE t300_v_p FROM g_sql
   DECLARE t300_v_c CURSOR FOR t300_v_p
   FOREACH t300_v_c INTO l_oma01,l_chr
      IF STATUS THEN EXIT FOREACH END IF
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
 
      IF l_chr='N' THEN CONTINUE FOREACH END IF
      IF g_oma.oma65 != '2' THEN
         CALL s_t300_gl(l_oma01,'0')    #No.FUN-A10104
         IF g_aza.aza63='Y' AND g_success='Y' THEN
            CALL s_t300_gl(l_oma01,'1') #No.FUN-A10104
         END IF
      ELSE
         CALL s_t300_rgl(l_oma01,'0')   #No.FUN-A10104
         IF g_aza.aza63='Y' AND g_success='Y' THEN
            CALL s_t300_rgl(l_oma01,'1')#No.FUN-A10104
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   MESSAGE ""
   CALL s_showmsg()           #NO.FUN-710050
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION

FUNCTION s_t300_v0()
DEFINE l_oma01 LIKE oma_file.oma01   #MOD-BB0324
DEFINE l_cnt   LIKE type_file.num5   #MOD-C20096

   LET l_oma01 = g_oma.oma01         #MOD-BB0324
   INITIALIZE g_oma.* TO NULL        #MOD-BB0324

   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = l_oma01   #MOD-BB0324                          #MOD-AB0199 mark
   IF g_oma.omavoid = 'Y' THEN CALL cl_err('','9024',0) RETURN END IF     #MOD-AB0199
   IF g_ooy.ooydmy1 = 'N' THEN CALL cl_err('','mfg9310',0) RETURN END IF  #MOD-AB0199 
    
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt 
      FROM fbe_file,oma_file
     WHERE fbe01 = g_oma.oma16
    IF l_cnt > 0 THEN
       RETURN
    END IF

   DROP TABLE x
   SELECT * FROM npq_file WHERE 1=2 INTO TEMP x
   IF cl_null(g_oma.oma99) THEN
      CALL s_t300_v()
   ELSE
      #多角貿易單據一次只產生一張分錄
      #且已確認但未拋轉傳票，可重新產生分錄
      CALL s_t300_v2()
   END IF
END FUNCTION

FUNCTION s_t300_v2()
  DEFINE l_wc      STRING   
  DEFINE l_oma01   LIKE oma_file.oma01
  DEFINE only_one  LIKE type_file.chr1    
 
   IF NOT cl_null(g_oma.oma33) THEN CALL cl_err('','aap-925',0) RETURN END IF
   IF cl_confirm('axr-309') THEN
      IF g_oma.oma65 != '2' THEN
         CALL s_t300_gl(g_oma.oma01,'0')    #No.FUN-A10104
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_gl(g_oma.oma01,'1') #No.FUN-A10104
         END IF
      ELSE
         CALL s_t300_rgl(g_oma.oma01,'0')   #No.FUN-A10104
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_rgl(g_oma.oma01,'1')#No.FUN-A10104
         END IF
      END IF
   END IF
   MESSAGE ""
END FUNCTION
#FUN-CB0094---end
