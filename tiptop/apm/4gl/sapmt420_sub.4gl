# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name...: sapmt420_sub.4gl
# Description....: 提供sapmt420.4gl使用的sub routine
# Date & Author..: 07/03/20 by kim (FUN-730012)
# Modify.........: No.TQC-730022 07/03/23 By rainy 流程自動化(無修改，過單用)
# Modify.........: No.CHI-740014 07/04/16 By kim 確認前檢查參數錯誤
# Modify.........: No.TQC-740093 07/04/17 By bnlent 顯示錯誤信息（匯整）
# Modify.........: NO.TQC-740245 07/04/23 BY rainy 詢問"確認否"若按否則應g_success='N'
# Modify.........: No.MOD-780137 07/08/20 By kim cl_err3未傳參數
# Modify.........: No.TQC-830063 08/04/01 By lumx審核報錯信息不能顯示
# Modify.........: No.FUN-830161 08/04/09 By Carrier 項目預算修改
# Modify.........: NO.FUN-880016 08/08/22 By Yiting 增加GPM控管
# Modify.........: No.FUN-890128 08/10/08 By Vicky 確認段_chk()與異動資料_upd()若只需顯示提示訊息不可用cl_err()寫法,應改為cl_getmsg()
# Modify.........: No.FUN-8A0054 08/10/13 By sabrina 若沒有勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.MOD-950284 09/05/27 By Smapmin 使用利潤中心功能時,預算控管的部門應抓取利潤中心
# Modify.........: No.FUN-870007 09/07/16 By Zhangyajun 流通零售系統功能修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980046 09/09/10 By mike 錯誤訊息 apm-006 增加料件編號    
# Modify.........: No.MOD-990262 09/10/01 By Dido 增加確認段檢核交貨日及到庫日與開單日問題 
# Modify.........: No.FUN-9C0071 09/12/16 By huangrh 精簡程式
# Modify.........: No:MOD-A30154 10/03/23 By Smapmin 請購單做預算控管時,傳入的年月應為pmk31/pmk32
# Modify.........: No:CHI-A40021 10/06/04 By Summer 用agli102科目是否有做專案控管的參數,
#                                                   做為抓取預算資料時是否要以專案為條件
# Modify.........: No.FUN-A80087 10/08/31 By Lilan 當與EF整合時,確認人應是EF最後一關簽核人員
#                                                  但若EF最後一關簽核人員代號不存在於p_zx,則預設單據開單者
# Modify.........: No.MOD-B50174 11/05/19 By lixia 走預算的費用請購單單價不可為0
# Modify.........: No.TQC-B60102 11/06/21 By zhangweib 審核時加上對人員的檢查
# Modify.........: No.MOD-B90092 11/09/13 By suncx 如果請購單身有一筆資料作廢，則確認和取消確認時不應更新此筆單身
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No.MOD-C60180 12/06/20 By SunLM 審核卡控請購部門
# Modify.........: No.MOD-C80135 12/09/17 By jt_chen 請購單確認時,回寫訂單的已轉請購量有錯
# Modify.........: No.MOD-CA0086 12/11/16 By jt_chen 因apmt420單身數量異動時,皆會即時回寫oeb28的動作;故確認段可不需再更新
# Modify.........: No.FUN-CC0057 12/12/17 By xumeimei 將原程序段移植到sub程序中

DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION t420sub_y_chk(p_pmk01)
DEFINE p_pmk01       LIKE pmk_file.pmk01
DEFINE l_cnt         LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE l_str         LIKE type_file.chr4    #No.FUN-680136 VARCHAR(04)
DEFINE l_pml04       LIKE pml_file.pml04
DEFINE l_pml33       LIKE pml_file.pml33	#MOD-990262
DEFINE l_pml35       LIKE pml_file.pml35	#MOD-990262
DEFINE l_imaacti     LIKE ima_file.imaacti
DEFINE l_ima140      LIKE ima_file.ima140
DEFINE l_ima1401     LIKE ima_file.ima1401  #FUN-6A0036 add
DEFINE l_pmk         RECORD LIKE pmk_file.* #FUN-730012
DEFINE l_status      LIKE type_file.chr1    #FUN-880016
DEFINE l_t1          LIKE smy_file.smyslip  #FUN-880016
DEFINE l_genacti     LIKE gen_file.genacti    #TQC-B60102   Add
DEFINE l_pmlslk02    LIKE pmlslk_file.pmlslk02 #FUN-C70098
DEFINE l_pmlslk04    LIKE pmlslk_file.pmlslk04 #FUN-C70098
DEFINE l_pmlslk20    LIKE pmlslk_file.pmlslk20 #FUN-C70098
DEFINE l_gemacti     LIKE gem_file.gemacti #MOD-C60180
define l_flag        like type_file.chr1   #darcy:2022/11/15 
 
   LET g_success = 'Y'
   IF p_pmk01 IS NULL THEN RETURN END IF #CHI-740014
#CHI-C30107 ---------------- add ----------------- begin
   IF l_pmk.pmk18='Y' THEN                   ##當確認碼為 'Y' 時, RETURN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","9023",1) #MOD-780137
      ELSE
         CALL cl_err('','9023',1) #MOD-780137
      END IF
       LET g_success = 'N'
   END IF
   IF l_pmk.pmk18='X' THEN                    #當確認碼為 'X' 作廢時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","9024",1) #MOD-780137
     ELSE
        CALL cl_err('','9024',1) 
     END IF
     LET g_success = 'N'
   END IF
   IF l_pmk.pmkacti='N' THEN                  #當資料有效碼為 'N' 時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","mfg0301",1) 
     ELSE
        CALL cl_err('','mfg0301',1) #MOD-780137
     END IF
        LET g_success = 'N'
   END IF
   IF g_action_choice CLIPPED = "confirm" OR      #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"  THEN
      IF NOT cl_confirm('axm-108') THEN
         LET g_success = 'N'     
         RETURN
      END IF 
   END IF
#CHI-C30107 ---------------- add ----------------- end
   SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01=p_pmk01 #CHI-740014
   IF l_pmk.pmk18='Y' THEN                   ##當確認碼為 'Y' 時, RETURN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","9023",1) #MOD-780137
      ELSE
         CALL cl_err('','9023',1) #MOD-780137
      END IF
       LET g_success = 'N'
   END IF
   IF l_pmk.pmk18='X' THEN                    #當確認碼為 'X' 作廢時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","9024",1) #MOD-780137
     ELSE
        CALL cl_err('','9024',1) #MOD-780137
     END IF
     LET g_success = 'N'
   END IF
   IF l_pmk.pmkacti='N' THEN                  #當資料有效碼為 'N' 時, RETURN
     IF g_bgerr THEN
        CALL s_errmsg("pmk01",p_pmk01,"","mfg0301",1) #MOD-780137
     ELSE
        CALL cl_err('','mfg0301',1) #MOD-780137
     END IF
        LET g_success = 'N'
   END IF

#TQC-B60102   ---start   Add
      SELECT genacti INTO l_genacti FROM gen_file  WHERE gen01 = l_pmk.pmk12

      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
           WHEN l_genacti='N'        LET g_errno = '9028'
           OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF NOT cl_null(g_errno) THEN
         IF g_bgerr THEN
            CALL s_errmsg("pmk12",l_pmk.pmk12,"",g_errno,1) #MOD-780137
         ELSE
            CALL cl_err('',g_errno,0) #MOD-780137
         END IF
         LET g_success = 'N'
      END IF
# TQC-B60102   ---end     Add
#MOD-C60180 add begin---------------
      SELECT gemacti INTO l_gemacti FROM gem_file  WHERE gem01 = l_pmk.pmk13

      CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
           WHEN l_gemacti='N'        LET g_errno = '9028'
           OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
      IF NOT cl_null(g_errno) THEN
         IF g_bgerr THEN
            CALL s_errmsg("pmk13",l_pmk.pmk13,"",g_errno,1) #MOD-780137
         ELSE
            CALL cl_err('',g_errno,0) #MOD-780137
         END IF
         LET g_success = 'N'
      END IF
#MOD-C60180 add end----------------- 
#---MODNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM pml_file
    WHERE pml01=l_pmk.pmk01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","mfg-009",1) #MOD-780137
      ELSE
         CALL cl_err('','mfg-009',0) #MOD-780137
      END IF
      LET g_success = 'N'
   END IF

   #FUN-C70098----add----begin--------------
   IF s_industry("slk") AND g_azw.azw04 = '2' THEN
       DECLARE pmlslk04_curs CURSOR FOR
          SELECT pmlslk02,pmlslk04,pmlslk20 FROM pmlslk_file WHERE pmlslk01 = l_pmk.pmk01 
       CALL s_showmsg_init()
       FOREACH pmlslk04_curs INTO l_pmlslk02,l_pmlslk04,l_pmlslk20 
           IF cl_null(l_pmlslk20) OR l_pmlslk20 = 0 THEN
              CALL s_errmsg('', l_pmk.pmk01 ,l_pmlslk04 ,'wag-667',1)
              LET g_success = 'N'
           END IF
       END FOREACH
       CALL s_showmsg()
       IF g_success = 'N' THEN
          RETURN
       END IF
   END IF
   #FUN-C70098----add----end----------------
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM pml_file
    WHERE pml01=l_pmk.pmk01
      AND pml33 IS NULL
   IF l_cnt >=1 THEN
      #單身交貨日期尚有資料是空白的,請補齊.
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",p_pmk01,"","apm-421",1) #MOD-780137
      ELSE
         CALL cl_err('','apm-421',1) #MOD-780137
      END IF
      LET g_success = 'N'
   END IF
  
   LET l_t1 = s_get_doc_no(l_pmk.pmk01) 
   SELECT * INTO g_smy.* FROM smy_file
    WHERE smyslip=l_t1
 
   #--------------------------------- 請採購預算控管 00/03/28 By Melody
   IF g_smy.smy59='Y' AND g_success='Y' THEN CALL t420sub_budchk(l_pmk.*) END IF 
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      IF NOT cl_null(l_pmk.pmk09) THEN 
         IF g_smy.smy64 != '0' THEN    #要控管
            CALL s_showmsg_init()
            CALL aws_gpmcli_part(l_pmk.pmk01,l_pmk.pmk09,'','5')
                 RETURNING l_status
            IF l_status = '1' THEN   #回傳結果為失敗
               IF g_smy.smy64 = '2' THEN   
                  LET g_success = 'N'
                  CALL s_showmsg()
                  RETURN
               END IF
               IF g_smy.smy64 = '1' THEN
                  CALL s_showmsg()
               END IF
            END IF
         END IF
      END IF
   END IF       #FUN-8A0054
   
   let l_flag = 'N' #darcy:2022/11/15 add
   #Begin No:7225  無效料件或Phase Out者不可以請購
    DECLARE pml_cur1 CURSOR FOR
       SELECT pml04,pml33,pml35 FROM pml_file WHERE pml01=l_pmk.pmk01		#MOD-990262 add pml33,pml35
    CALL s_showmsg_init()        #No.FUN-710030
    FOREACH pml_cur1 INTO l_pml04,l_pml33,l_pml35 				#MOD-990262 add pml33,pml35
       IF g_success="N" THEN
          LET g_totsuccess="N"
          LET g_success="Y"
       END IF
       #darcy:2022/11/15 add s---
       if l_pml04 matches 'M.*' or l_pml04 matches 'E.*' THEN
         let l_flag = 'Y'
       end if
       #darcy:2022/11/15 add e---
       LET l_str = l_pml04[1,4]  #No:7225
       IF l_str = 'MISC' THEN CONTINUE FOREACH END IF #No:7225
       SELECT imaacti,ima140,ima1401 INTO l_imaacti,l_ima140,l_ima1401  #FUN-6A0036 add ima1401
         FROM ima_file
        WHERE ima01 = l_pml04
       IF SQLCA.sqlcode THEN
          IF l_pml04[1,4] <>'MISC' THEN  #NO:6808
              LET l_imaacti = 'N'
              LET l_ima140 = 'Y'
          END IF
       END IF
       IF l_imaacti = 'N' OR (l_ima140 = 'Y' AND l_ima1401 <= l_pmk.pmk04) THEN   #FUN-6A0036
          IF g_bgerr THEN
             CALL s_errmsg("pml04",l_pml04,"","apm-006",1) #FUN-980046   
          ELSE
             CALL cl_err(l_pml04,'apm-006',0) #MOD-780137
          END IF
          LET g_success = 'N'
       END IF
       IF l_pml33 < l_pmk.pmk04 THEN
          CALL s_errmsg("pml33",l_pml33,"","apm-027",1)    
          LET g_success = 'N'
       END IF       
       IF l_pml35 < l_pmk.pmk04 THEN
          CALL s_errmsg("pml35",l_pml35,"","apm-060",1)    
          LET g_success = 'N'
       END IF       
    END FOREACH
    #darcy:2022/11/15 add s---
    if l_flag = 'Y' then
      let l_cnt = 0
      select count(1) into l_cnt from smu_file where smu01 ='LIA' and smu02=g_user
      if l_cnt = 0 then
         call s_errmsg("gen01",g_user,"","cpm-067",1)
         let g_success = 'N'
      end if
    end if
    #darcy:2022/11/15 add e---
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    CALL s_showmsg()       #No.TQC-740093
END FUNCTION
 
#作用:lock cursor
#回傳值:無
FUNCTION t420sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM pmk_file WHERE pmk01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t420sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t420sub_y_upd(l_pmk01,p_action_choice)
   DEFINE l_pmk01 LIKE pmk_file.pmk01,
          p_action_choice STRING,
          l_pmk  RECORD LIKE pmk_file.*,
          l_pmkmksg LIKE pmk_file.pmkmksg,
          l_pmk25   LIKE pmk_file.pmk25          
 
   WHENEVER ERROR CONTINUE #FUN-730012
 
   LET g_success = 'Y'
 
   IF p_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      p_action_choice CLIPPED = "insert"     #FUN-640184 
   THEN 
      SELECT pmkmksg,pmk25 
        INTO l_pmkmksg,l_pmk25
        FROM pmk_file
       WHERE pmk01=l_pmk01
      IF l_pmkmksg='Y' THEN            #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF l_pmk25 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
#CHI-C30107 ------------- mark ----------- begin
#     IF NOT cl_confirm('axm-108') THEN 
#        LET g_success = 'N'     #TQC-740245
#        RETURN 
#     END IF  #詢問是否執行確認功能
#CHI-C30107 ------------ mark ------------ end
   END IF
 
   BEGIN WORK
 
   CALL t420sub_lock_cl() #FUN-730012
   OPEN t420sub_cl USING l_pmk01
   IF STATUS THEN
      LET g_success = 'N'
      CALL cl_err("OPEN t420sub_cl:", STATUS, 1)
      CLOSE t420sub_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t420sub_cl INTO l_pmk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err(l_pmk.pmk01,SQLCA.sqlcode,0)
      CLOSE t420sub_cl
      ROLLBACK WORK
      RETURN
   END IF 
   CALL t420sub_y1(l_pmk.*)
   IF g_success = 'Y' AND g_azw.azw04 = '2' THEN   #FUN-CC0057 add
      CALL t420sub_transfer(l_pmk.*)               #FUN-CC0057 add
   END IF                                          #FUN-CC0057 add
   IF g_success = 'Y' THEN
      IF l_pmk.pmkmksg = 'Y' THEN  #簽核模式
         CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
              WHEN 0  #呼叫 EasyFlow 簽核失敗
                   LET l_pmk.pmk18="N"
                   LET g_success = "N"
                   ROLLBACK WORK
                   RETURN
              WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                   LET l_pmk.pmk18="N"
                   ROLLBACK WORK
                   RETURN
         END CASE
      END IF
      IF g_success='Y' THEN
         LET l_pmk.pmk25='1'              #執行成功, 狀態值顯示為 '1' 已核准
         LET l_pmk.pmk18='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
         COMMIT WORK
         CALL cl_flow_notify(l_pmk.pmk01,'Y')
      ELSE
         LET l_pmk.pmk18='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
   ELSE
      LET l_pmk.pmk18='N'
      LET g_success = 'N'
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
#------- 請採購預算控管 00/03/28 By Melody
FUNCTION t420sub_budchk(l_pmk)
   DEFINE l_pmk    RECORD LIKE pmk_file.*
   DEFINE l_pml    RECORD LIKE pml_file.*
   DEFINE l_bud    LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE over_amt LIKE pml_file.pml44 #MOD-530190
   DEFINE last_amt LIKE pml_file.pml44 #MOD-530190
   DEFINE l_msg    LIKE ze_file.ze03   #MOD-530058
   DEFINE l_bud1   LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_msg1    LIKE ze_file.ze03
   DEFINE over_amt1 LIKE pml_file.pml44 
   DEFINE last_amt1 LIKE pml_file.pml44
   DEFINE p_sum1    LIKE afc_file.afc07
   DEFINE p_sum2    LIKE afc_file.afc07
   DEFINE l_flag    LIKE type_file.num5
   DEFINE l_over    LIKE afc_file.afc07
   DEFINE l_yy      LIKE type_file.num5
   DEFINE l_mm      LIKE type_file.num5
   DEFINE l_bookno1 LIKE aaa_file.aaa01
   DEFINE l_bookno2 LIKE aaa_file.aaa01
   DEFINE l_afb07   LIKE afb_file.afb07
 
   DECLARE bud_cur CURSOR FOR
      SELECT * FROM pml_file WHERE pml01=l_pmk.pmk01
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH bud_cur INTO l_pml.*
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
      IF g_aza.aza08 = 'N' THEN
         LET l_pml.pml12 = ' '
         LET l_pml.pml121= ' '
      END IF

      #MOD-B50174--add--str-- 
      IF l_pmk.pmk02 = 'EXP' THEN
         IF cl_null(l_pml.pml31) OR cl_null(l_pml.pml31t) OR l_pml.pml31 = 0 OR l_pml.pml31t = 0  THEN               
            IF g_bgerr THEN
               CALL s_errmsg("pml02",l_pml.pml02,"","axm-655",1)  
            ELSE
               CALL cl_err(l_pml.pml02,'axm-655',0)
            END IF
            LET g_success = 'N'
         END IF   
      END IF
      #MOD-B50174--add--str-

      #CALL s_get_bookno(YEAR(l_pml.pml33)) RETURNING l_flag,l_bookno1,l_bookno2   #MOD-A30154
      CALL s_get_bookno(YEAR(l_pmk.pmk31)) RETURNING l_flag,l_bookno1,l_bookno2   #MOD-A30154
      LET p_sum1 = l_pml.pml87 * l_pml.pml44
      LET p_sum2 = l_pml.pml87 * l_pml.pml44
      IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
      IF cl_null(p_sum2) THEN LET p_sum2 = 0 END IF
      #-----MOD-A30154---------
      #LET l_yy = YEAR(l_pml.pml33)
      #LET l_mm = MONTH(l_pml.pml33)
      LET l_yy = l_pmk.pmk31
      LET l_mm = l_pmk.pmk32
      #-----END MOD-A30154-----
      IF g_aaz.aaz90 = 'Y' THEN
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                          l_yy,l_pml.pml121,
                          l_pml.pml930,l_pml.pml12,
                          l_mm,'0','a',0,p_sum2,'1')
      ELSE
         CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                          l_yy,l_pml.pml121,                 
                          l_pml.pml67,l_pml.pml12,                        
                          l_mm,'0','a',0,p_sum2,'1')
      END IF    #MOD-950284 
      IF g_aza.aza63 = 'Y' THEN
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'1','a',0,p_sum2,'1')
         ELSE
            CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'1','a',0,p_sum2,'1')
         END IF        #MOD-950284
      END IF
      IF g_success = 'Y' THEN
         #同一筆單據中,有相同的預算資料
         #因為沒有確認..故耗用..會算不到其他單身中的金額,故此處卡總量
         #SELECT SUM(pml87*pml44) INTO p_sum1 FROM pml_file   #MOD-A30154
         SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   #MOD-A30154
          WHERE pml01 = l_pml.pml01
            AND pml90 = l_pml.pml90
            AND pml40 = l_pml.pml40
            AND pmk01 = pml01   #MOD-A30154
            #AND YEAR(pml33) = l_yy   #MOD-A30154
            AND pmk31 = l_yy   #MOD-A30154
            AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
            AND pml67 = l_pml.pml67
            AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
            #AND MONTH(pml33) = l_mm  #MOD-A30154
            AND pmk32 = l_mm   #MOD-A30154
         IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
         IF g_aaz.aaz90 = 'Y' THEN
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,
                             l_yy,l_pml.pml121,
                             l_pml.pml930,l_pml.pml12,
                             l_mm,'0','a',0,p_sum1,'2')
         ELSE
            CALL t420sub_bud(l_bookno1,l_pml.pml90,l_pml.pml40,              
                             l_yy,l_pml.pml121,                 
                             l_pml.pml67,l_pml.pml12,                        
                             l_mm,'0','a',0,p_sum1,'2')
         END IF      #MOD-950284
         IF g_aza.aza63 = 'Y' THEN
            #SELECT SUM(pml87*pml44) INTO p_sum1 FROM pml_file   #MOD-A30154
            SELECT SUM(pml87*pml44) INTO p_sum1 FROM pmk_file,pml_file   #MOD-A30154
             WHERE pml01 = l_pml.pml01
               AND pml90 = l_pml.pml90
               AND pml401= l_pml.pml401
               AND pmk01 = pml01   #MOD-A30154
               #AND YEAR(pml33) = l_yy   #MOD-A30154
               AND pmk31 = l_yy   #MOD-A30154
               AND (pml121 = l_pml.pml121 OR pml121 IS NULL)
               AND pml67 = l_pml.pml67
               AND (pml12 = l_pml.pml12 OR pml12 IS NULL)
               #AND MONTH(pml33) = l_mm   #MOD-A30154
               AND pmk32 = l_mm   #MOD-A30154
            IF cl_null(p_sum1) THEN LET p_sum1 = 0 END IF
            IF g_aaz.aaz90 = 'Y' THEN
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,
                                l_yy,l_pml.pml121,
                                l_pml.pml930,l_pml.pml12,
                                l_mm,'1','a',0,p_sum1,'2')
            ELSE
               CALL t420sub_bud(l_bookno2,l_pml.pml90,l_pml.pml401,              
                                l_yy,l_pml.pml121,                 
                                l_pml.pml67,l_pml.pml12,                        
                                l_mm,'1','a',0,p_sum1,'2')
            END IF      #MOD-950284
         END IF
      END IF
 
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()                   #TQC-740093
 
END FUNCTION
 
FUNCTION t420sub_y1(l_pmk)
   DEFINE l_cmd         LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
   DEFINE l_str         LIKE type_file.chr4    #No.FUN-680136 VARCHAR(04)
   DEFINE l_pml         RECORD LIKE pml_file.*
   DEFINE l_pml04       LIKE pml_file.pml04
   DEFINE l_imaacti     LIKE ima_file.imaacti
   DEFINE l_ima140      LIKE ima_file.ima140
   DEFINE l_pml20       LIKE pml_file.pml20
   DEFINE l_i           LIKE type_file.num5     #FUN-710019 #FUN-730012
   DEFINE l_cnt         LIKE type_file.num5     #FUN-710019
   DEFINE l_pmk         RECORD LIKE pmk_file.*
   DEFINE l_pml24       LIKE pml_file.pml24     #FUN-730012
   DEFINE l_pml25       LIKE pml_file.pml25     #FUN-730012
   DEFINE l_pml87       LIKE pml_file.pml87     #FUN-730012
   DEFINE l_sql         STRING    #FUN-730012
   DEFINE l_user        STRING                  #FUN-A80087 add
   DEFINE l_zx01        LIKE zx_file.zx01       #FUN-A80087 add 

   IF l_pmk.pmkmksg='N' AND (l_pmk.pmk25='0' OR l_pmk.pmk25='X') THEN
      LET l_pmk.pmk25='1'
      UPDATE pml_file SET pml16=l_pmk.pmk25
       WHERE pml01=l_pmk.pmk01
         AND pml16 != '9'   #MOD-B90092
      IF STATUS THEN
         IF g_bgerr THEN
            CALL s_errmsg("pml01",l_pmk.pmk01,"upd pml16",STATUS,1)
         ELSE
            CALL cl_err3("upd","pml_file",l_pmk.pmk01,"",STATUS,"","upd pml16",1)
         END IF
         LET g_success = 'N' RETURN
      END IF
   END IF
 
  #FUN-A80087 add str --------------
   IF g_action_choice = "efconfirm" THEN
      CALL aws_efapp_getEFLogonID() RETURNING l_user
      LET l_zx01 = l_user

      SELECT count(*) INTO l_cnt
        FROM zx_file
       WHERE zxacti = 'Y'
         AND zx01 = l_zx01
      IF l_cnt = 0 THEN
         LET l_zx01 = l_pmk.pmkuser
      END IF
   ELSE
      LET l_zx01 = g_user
   END IF
  #FUN-A80087 add end --------------

   LET l_pmk.pmkcond=g_today
   LET l_pmk.pmkconu=g_user   
   LET l_pmk.pmkcont=TIME
   UPDATE pmk_file SET
          pmk25=l_pmk.pmk25,
          pmkconu=l_pmk.pmkconu,      #No.FUN-870007
          pmkcond=l_pmk.pmkcond,      #No.FUN-870007
          pmkcont=l_pmk.pmkcont,      #No.FUN-870007
          pmk18='Y'
         ,pmk15 = l_zx01              #確認人 #FUN-A80087 add
    WHERE pmk01 = l_pmk.pmk01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg("pmk01",l_pmk.pmk01,"upd pmk18",STATUS,1)
      ELSE
         CALL cl_err3("upd","pmk_file",l_pmk.pmk01,"",STATUS,"","upd pmk18",1)
      END IF
      LET g_success = 'N' RETURN
   END IF
 
#NO.FUN-710019  S/O拋P/R時，如P/R數量有更動要回寫到S/O
   
   LET l_sql = "SELECT * FROM oeb_file WHERE oeb01 = ?  AND oeb03 = ? FOR UPDATE"
   LET l_sql=cl_forupd_sql(l_sql)

   DECLARE t420y1_cl CURSOR FROM l_sql
 
  #LET l_sql = "SELECT pml24,pml25,pml87 FROM pml_file ",                #MOD-C80135 mark
  #                                   " WHERE pml01='",l_pmk.pmk01,"'"   #MOD-C80135 mark
   LET l_sql = "SELECT pml24,pml25 FROM pml_file ",                      #MOD-C80135 add
                                      " WHERE pml01='",l_pmk.pmk01,"'"   #MOD-C80135 add
   DECLARE t420y2_cl CURSOR FROM l_sql
   FOREACH t420y2_cl INTO l_pml24,l_pml25,l_pml87
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pml_file",l_pmk.pmk01,"",STATUS,"","foreach",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      OPEN t420y1_cl USING l_pml24,l_pml25 #check DB 是否被他人鎖定
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err("OPEN t420y1_cl:", STATUS, 1)
         CLOSE t420y1_cl
         RETURN
      END IF
      CLOSE t420y1_cl  #無被鎖定就可以CLOSE
     #MOD-CA0086 -- mark start --
     #SELECT SUM(oeb28) INTO l_pml87 FROM oeb_file WHERE oeb01= l_pml24 AND oeb03 = l_pml25   #MOD-C80135 add
     #UPDATE oeb_file 
     #   SET oeb28 = l_pml87
     # WHERE oeb01 = l_pml24
     #   AND oeb03 = l_pml25
     #MOD-CA0086 -- mark end --
   END FOREACH
END FUNCTION
 
FUNCTION t420sub_refresh(p_pmk01)
  DEFINE p_pmk01 LIKE pmk_file.pmk01
  DEFINE l_pmk RECORD LIKE pmk_file.*
 
  SELECT * INTO l_pmk.* FROM pmk_file WHERE pmk01=p_pmk01
  RETURN l_pmk.*
END FUNCTION
 
FUNCTION t420sub_bud(p_afc00,p_afc01,p_afc02,p_afc03,p_afc04,p_afc041,
                     p_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2,p_flag1)
  DEFINE p_afc00     LIKE afc_file.afc00  #帳套編號
  DEFINE p_afc01     LIKE afc_file.afc01  #費用原因
  DEFINE p_afc02     LIKE afc_file.afc02  #會計科目
  DEFINE p_afc03     LIKE afc_file.afc03  #會計年度
  DEFINE p_afc04     LIKE afc_file.afc04  #WBS
  DEFINE p_afc041    LIKE afc_file.afc041 #部門編號
  DEFINE p_afc042    LIKE afc_file.afc042 #項目編號
  DEFINE p_afc05     LIKE afc_file.afc05  #期別
  DEFINE p_flag      LIKE type_file.chr1  #0.第一科目 1.第二科目
  DEFINE p_flag1     LIKE type_file.chr1  #1.單筆檢查 2.單身total檢查
  DEFINE p_cmd       LIKE type_file.chr1
  DEFINE p_sum1      LIKE afc_file.afc06 
  DEFINE p_sum2      LIKE afc_file.afc06 
  DEFINE l_flag      LIKE type_file.num5
  DEFINE l_afb07     LIKE afb_file.afb07
  DEFINE l_over      LIKE afc_file.afc07
  DEFINE l_msg       LIKE ze_file.ze03      #FUN-890128
  DEFINE l_aag23     LIKE aag_file.aag23  #CHI-A40021 add
  DEFINE l_afc04     LIKE afc_file.afc04  #CHI-A40021 add
  DEFINE l_afc042    LIKE afc_file.afc042 #CHI-A40021 add
 
  #CHI-A40021 add --start--
  SELECT aag23 INTO l_aag23 FROM  aag_file
   WHERE aag00=p_afc00
     AND aag01=p_afc02
  IF l_aag23='Y' THEN
     LET l_afc04 = p_afc04
     LET l_afc042 = p_afc042
  ELSE
     LET l_afc04 = ' '
     LET l_afc042 = ' '
  END IF
  #CHI-A40021 add --end--

      CALL s_budchk1(p_afc00,p_afc01,p_afc02,p_afc03,l_afc04,  #CHI-A40021 mod p_afc04->l_afc04        
                     p_afc041,l_afc042,p_afc05,p_flag,p_cmd,p_sum1,p_sum2)  #CHI-A40021 mod p_afc042->l_afc042
          RETURNING l_flag,l_afb07,l_over
      IF l_flag = FALSE THEN
         LET g_success = 'N'
         LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                         p_afc03 USING "<<<&",'/',l_afc04,'/',  #CHI-A40021 mod p_afc04->l_afc04
                         p_afc041,'/',l_afc042,'/',  #CHI-A40021 mod p_afc042->l_afc042
                         p_afc05 USING "<&",p_sum2,'/',l_over
         IF p_flag1 = '2' THEN
            LET g_errno = 'agl-232'
         END IF
         IF g_bgerr THEN
            CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
         ELSE
            CALL cl_err(g_showmsg,g_errno,1)
         END IF
      ELSE
         IF l_afb07 = '2' AND l_over < 0 THEN
            IF p_flag1 = '2' THEN
               LET g_errno = 'agl-232'
            END IF
            LET g_showmsg = p_afc00,'/',p_afc01,'/',p_afc02,'/',
                            p_afc03 USING "<<<&",'/',l_afc04,'/',  #CHI-A40021 mod p_afc04->l_afc04
                            p_afc041,'/',l_afc042,'/',  #CHI-A40021 mod p_afc042->l_afc042
                            p_afc05 USING "<&",p_sum2,'/',l_over
            IF g_bgerr THEN
               CALL s_errmsg('afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05,npl05,npl05',g_showmsg,'t420sub_bud',g_errno,1)
            ELSE
               LET l_msg = cl_getmsg(g_errno,g_lang)
               LET l_msg = g_showmsg CLIPPED, l_msg CLIPPED
               CALL cl_msgany(10,20,l_msg)
            END IF
            LET g_errno = ' '
         END IF
      END IF
END FUNCTION
#FUN-CC0057--------------add-----------str
FUNCTION t420sub_transfer(g_pmk)
DEFINE g_pmk      RECORD LIKE pmk_file.*
DEFINE l_ruc      RECORD LIKE ruc_file.*
DEFINE l_flag            LIKE type_file.chr1
DEFINE l_rate            LIKE ruc_file.ruc17
DEFINE l_sql             STRING 

   LET l_sql="SELECT '','',pml01,pml02,pml04,'','','',pml24,pml25,pml48,pml49,pml50,'',",
             " pml47,pml041,pml07,'',pml20,'','','','',",
             " pml51,pml52,pml53,'',pml33,pml54,'',pml191,pml55 ",
             " FROM pml_file WHERE pml01='",g_pmk.pmk01,"' ORDER BY pml02 "
   PREPARE t420_prepsel FROM l_sql
   DECLARE t420_curssel CURSOR FOR t420_prepsel
   FOREACH t420_curssel INTO l_ruc.*
      IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        LET g_success='N'
        EXIT FOREACH
      END IF
      SELECT ima25 INTO l_ruc.ruc13 FROM ima_file WHERE ima01=l_ruc.ruc04
      IF SQLCA.sqlcode=100 THEN LET l_ruc.ruc13=NULL END IF
      CALL s_umfchk(l_ruc.ruc04,l_ruc.ruc16,l_ruc.ruc13)
         RETURNING l_flag,l_rate
      IF l_flag='0' THEN
         LET l_ruc.ruc17=l_rate
      END IF
      LET l_ruc.ruc00='1'
      LET l_ruc.ruc01=g_pmk.pmkplant
      LET l_ruc.ruc05=g_today
      LET l_ruc.ruc06=g_pmk.pmk47
      LET l_ruc.ruc32=g_pmk.pmk50 
      IF cl_null(l_ruc.ruc06) THEN
         LET l_ruc.ruc06 = g_pmk.pmkplant
         LET l_ruc.ruc29 = 'Y'
      ELSE
         LET l_ruc.ruc29 = 'N'
      END IF
      SELECT rty04 INTO l_ruc.ruc26 FROM rty_file
       WHERE rty01=l_ruc.ruc06 AND rty02=l_ruc.ruc04
      LET l_ruc.ruc07=g_pmk.pmk46
      IF g_pmk.pmk46='1' THEN
         LET l_ruc.ruc08=g_pmk.pmk01
         LET l_ruc.ruc09=l_ruc.ruc03
      END IF
      LET l_ruc.ruc19='0'
      LET l_ruc.ruc20='0'
      LET l_ruc.ruc21='0'
      LET l_ruc.ruc22=NULL
      LET l_ruc.ruc33=' '
      IF l_ruc.ruc12='2' OR l_ruc.ruc12='3' OR l_ruc.ruc12 ='4' THEN
         INSERT INTO ruc_file VALUES(l_ruc.*)
         IF STATUS THEN
            CALL cl_err3("ins","ruc_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
      IF NOT cl_null(l_ruc.ruc23) AND l_ruc.ruc23<>g_plant THEN
         UPDATE pml_file SET pml11="Y" WHERE pml01=l_ruc.ruc02 AND pml02=l_ruc.ruc03
                                         AND pml930=g_plant
         IF STATUS THEN
            CALL cl_err3("upd","pml_file",g_pmk.pmk01,"",SQLCA.sqlcode,"","",1)
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
      INITIALIZE l_ruc.* TO NULL
   END FOREACH
END FUNCTION
#FUN-CC0057--------------add-----------end
#No.FUN-9C0071 ---------------------精簡程式------------------------
