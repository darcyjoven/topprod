# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: aimi100_sub.4gl
# Descriptions...: 將原aimi100.4gl確認段拆解至aimi100_sub.4gl中
# Date & Author..: #FUN-A70106 10/07/20 By Mandy
# Modify.........: #FUN-B20050 11/02/18 By Mandy MES整合無法連線時,應正確show出錯誤訊息
# Modify.........: #FUN-B60046 11/06/09 By Abby  修正"當有與MES整合且來源碼為[Z]時，資料無法進行確認"
#---------------------------------------------------------------------------------------------
# Modify.........: #FUN-A70106 11/06/28 By Mandy PLM GP5.1追版至GP5.25 以上為GP5.1單號
# Modify.........: #TQC-C20283 12/02/20 By zhuhao 確認時，加判斷，特性資料(imac_file)中，所有歸屬層級="1.料號"的時，皆需有值才可確認
# Modify.........: #MOD-C30124 12/03/09 By yuhuabao 母料加判斷，如未設定特性資料，則不可確認
# Modify.........: #MOD-C30164 12/03/10 By yuhuabao 母料為特性主料時不需要做aim1144的判斷
# Modify.........: #FUN-C50110 12/05/29 By bart ICD確認後需要自動拋轉
# Modify.........: #FUN-C60021 12/06/06 by xqzy 鞋服業暫不做特性料件
# Modify.........: #FUN-C90107 12/09/28 By Abby  無效段拆解至aimi100_sub.4gl並Service CALL FUNCTION調整
# Modify.........: #FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: #MOD-CC0187 13/01/11 By Elise 調整料在BOM有取替代關係時做無效的控卡
# Modify.........: #MOD-D30241 13/03/27 By bart 程式清單無資料

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"   

FUNCTION i100sub_lock_cl() #FUN-A70106
   DEFINE l_forupd_sql STRING                                                   

  #LET l_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE NOWAIT" #FUN-A70106 mark
   LET l_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE "       #FUN-A70106 add
   LET g_forupd_sql = cl_forupd_sql(l_forupd_sql)           #轉換不同資料庫語法  #FUN-A70106 add
   DECLARE i100sub_cl CURSOR FROM l_forupd_sql                                  
END FUNCTION

#FUN-C90107 add str-------------
FUNCTION i100sub_declare_curs()

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup')

   LET g_sql = "SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
             # " WHERE ",g_wc CLIPPED,                                                      #FUN-A90049 mark
               " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ",g_wc CLIPPED,    #FUN-A90049 add
               " ORDER BY ima01"
&ifdef ICD
   IF g_wc.getindexof('imaicd',1)>0 THEN
      LET g_sql = "SELECT ima_file.ima01 FROM ima_file,imaicd_file ", # 組合出 SQL 指令
                # " WHERE ima01=imaicd00 AND ",g_wc CLIPPED,                                                     #FUN-A90
                  " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaicd00 AND ",g_wc CLIPPED,   #FU
                  " ORDER BY ima01"
   END IF
&endif
   PREPARE aimi100sub_prepare FROM g_sql
   DECLARE aimi100sub_curs SCROLL CURSOR WITH HOLD FOR aimi100sub_prepare

   DECLARE aimi100sub_list_cur CURSOR FOR aimi100sub_prepare      

END FUNCTION
#FUN-C90107 add end---------------

FUNCTION i100sub_refresh(p_ima01)
   DEFINE p_ima01 LIKE ima_file.ima01
   DEFINE l_ima RECORD LIKE ima_file.*
   
   SELECT * INTO l_ima.* FROM ima_file WHERE ima01=p_ima01
   RETURN l_ima.*
END FUNCTION

FUNCTION i100sub_y_chk(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ima     RECORD LIKE ima_file.*
   DEFINE l_imac    RECORD LIKE imac_file.*  #TQC-C20283 add
   DEFINE l_n       LIKE type_file.num5      #MOD-C30124 add
   #darcy:2022/11/18 add s---
   define l_flag  like type_file.chr1
   define l_factor like type_file.num26_10
   define l_cnt      integer  #darcy:2024/03/15 add
   #darcy:2022/11/18 add e---
   LET g_success = 'Y'
   IF cl_null(p_ima01)THEN
      CALL cl_err("",-400,1)
      LET g_errno = '-400'
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = p_ima01

   IF NOT s_dc_ud_flag('1',l_ima.ima916,g_plant,'u') THEN 
      CALL cl_err(l_ima.ima916,'aoo-045',1) #參數設定:不可修改其他營運中心拋轉過來的資料
      LET g_errno = 'aoo-045'
      LET g_success = 'N'
      RETURN
   END IF

   IF l_ima.imaacti='Y' THEN
      CALL cl_err("",9023,1) #此筆資料已確認
      LET g_errno = '9023'
      LET g_success = 'N'
      RETURN
   END IF
   #darcy:2024/03/15 add s---
   # E.* 的料号不允许品名重复
   if p_ima01 matches 'E.*' then
      select count(*) into l_cnt from ima_file
      where ima02 = l_ima.ima02 and ima1010 ='1'
      if l_cnt > 0 then
         call cl_err(l_ima.ima02,"cim-093",1)
         LET g_errno = 'cim-093'
         LET g_success = 'N'
         RETURN
      end if
   end if
   #darcy:2024/03/15 add e---
   #darcy:2024/07/10 add s---
   if g_ima.ima06 ='G02' then
      if not aimi100_imaud07(g_ima.imaud07) then
         LET g_success = 'N'
      RETURN
      end if
   end if
   #darcy:2024/07/10 add e---

   IF l_ima.imaacti='N' THEN
      #此筆資料已無效, 不可異動
      CALL cl_err('','aim-153',1)
      LET g_errno = 'aim-153'
      LET g_success = 'N'
      RETURN
   END IF
   
   IF NOT s_industry('slk') THEN  #FUN-C60021--ADD
#MOD-C30124 ----- add ----- begin
# 母料為特性主料時，無特性主料不能確認
   IF l_ima.ima928 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM imac_file WHERE imac01 = p_ima01
      IF l_n = 0 THEN
         CALL cl_err('','aim1151',1)
         LET g_errno = 'aim1151'
         LET g_success = 'N'
         RETURN
      END IF
   END IF
#MOD-C30124 ----- add ----- end
   #darcy:2022/11/18 s---
   # 限制成品料号，必须维护库存单位到SET单位的转化率
   if l_ima.ima06 = "G01" OR l_ima.ima06 = "G02" then
      let l_factor = 0
      call s_umfchk(p_ima01,l_ima.ima25,'SET') returning l_flag,l_factor
      #if cl_null(l_factor) or l_factor = 0 then
      #   call cl_err('','cim-016',1)
      #   let g_errno = 'cim-016'
      #   let g_success = 'N'
      #end if
   end if
   #darcy:2022/11/18 e---

   #TQC-C20283--add--begin
   IF l_ima.ima928 <> 'Y' THEN    #MOD-C30164 add
      DECLARE imac_cr CURSOR FOR
      SELECT * FROM imac_file WHERE imac01 = p_ima01 AND imac03 = '1'
      FOREACH imac_cr INTO l_imac.*
         IF cl_null(l_imac.imac02) OR cl_null(l_imac.imac04)
            OR cl_null(l_imac.imac05) THEN
            CALL cl_err('','aim1144',1)
            LET g_errno = 'aim1144'
            LET g_success = 'N'
            RETURN
         END IF
      END FOREACH
   END IF    #MOD-C30164 add
   #TQC-C20283--add--end
   END IF #FUN-C60021----ADD--

END FUNCTION 

FUNCTION i100sub_y_upd(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_ima     RECORD LIKE ima_file.*
   DEFINE l_imaag   LIKE ima_file.imaag   
   DEFINE l_sql     STRING                

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'   

   CALL i100sub_lock_cl()

   OPEN i100sub_cl USING p_ima01
   IF STATUS THEN
      CALL cl_err("OPEN i100sub_cl:", STATUS, 1)
      CLOSE i100sub_cl
      LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
      LET g_success = 'N'
      RETURN
   END IF
   FETCH i100sub_cl INTO l_ima.*                # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_ima01,SQLCA.sqlcode,1)     # 資料被他人LOCK
       CLOSE i100sub_cl 
       LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
       LET g_success = 'N'
       RETURN
   END IF
   CLOSE i100sub_cl
   
   UPDATE ima_file
      SET ima1010 = '1', #'1':確認
          imaacti = 'Y', #'Y':確認
          imadate = g_today  #FUN-C30315 add
    WHERE ima01 = p_ima01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"",
                    "ima1010",1)  #
       LET g_errno = 'aws-190' #更新ERP料件主檔的狀況碼(ima1010)和有效碼(imaacti)不成功!
       LET g_success = 'N'    
       RETURN
   END IF
   
   SELECT imaag INTO l_imaag
     FROM ima_file
    WHERE ima01 = l_ima.ima01
   
   IF l_imaag IS NULL OR l_imaag = '@CHILD' THEN
   ELSE
      LET l_sql = " UPDATE ima_file SET ima1010 = '1',imaacti='Y', ",
                  " imadate = '",g_today, "'",     #FUN-C30315 add 
                  "  WHERE ima01 LIKE '",l_ima.ima01,"_%'"
      PREPARE ima_cs3       FROM l_sql
      EXECUTE ima_cs3
      IF STATUS THEN
         CALL cl_err('ima1010',STATUS,1) 
         LET g_errno = 'aws-192' #更新料件屬性群組資料失敗!
         LET g_success = 'N'            
         RETURN
      END IF
   END IF 
   
   IF g_aza.aza90 MATCHES "[Yy]" THEN
       CALL i100sub_mes(l_ima.ima08,'insert',l_ima.ima01)
       #FUN-B20050---add---str--
       IF g_success = 'N' THEN
           LET g_errno = 'aws-557' #MES整合無法連線!
       END IF
       #FUN-B20050---add---end--
   END IF
END FUNCTION 

FUNCTION i100sub_carry(p_ima01)
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE l_gew03   LIKE gew_file.gew03   
   DEFINE l_i       LIKE type_file.num10  
   DEFINE l_sql     STRING     
   DEFINE l_bma01   LIKE bma_file.bma01  #FUN-C50110
   DEFINE l_bma06   LIKE bma_file.bma06  #FUN-C50110
   DEFINE l_bma10   LIKE bma_file.bma10  #FUN-C50110 
   
   SELECT gev04 
     INTO g_gev04 
     FROM gev_file 
    WHERE gev01 = '1' 
      AND gev02 = g_plant
      AND gev03 = 'Y'
   IF NOT cl_null(g_gev04) THEN 
      SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
       WHERE gew01 = g_gev04 AND gew02 = '1'
      IF l_gew03 = '1' THEN #自動拋轉
        #開窗選擇拋轉的db清單
         LET l_sql = "SELECT COUNT(*) FROM &ima_file WHERE ima01='",p_ima01,"'"  
         CALL s_dc_sel_db1(g_gev04,'1',l_sql)
         IF INT_FLAG THEN
            LET INT_FLAG=0
            RETURN
         END IF
      
         CALL g_imax.clear()
         LET g_imax[1].sel = 'Y'
         LET g_imax[1].ima01 = p_ima01
      
         FOR l_i = 1 TO g_azp1.getLength()
            LET g_azp[l_i].sel   = g_azp1[l_i].sel
            LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
            LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
            LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
         END FOR
         #FUN-C50110---begin
         IF s_industry('icd') THEN
            LET g_sql = "SELECT 'Y',imaicd00 FROM imaicd_file",
                        " WHERE imaicd11='",p_ima01 CLIPPED,"'",
                        " ORDER BY imaicd00"
            PREPARE i100_imaicd00_p FROM g_sql
            DECLARE i100_imaicd00_cs CURSOR FOR i100_imaicd00_p
       
            LET l_i = 2
            FOREACH i100_imaicd00_cs INTO g_imax[l_i].*
               LET l_i = l_i + 1
            END FOREACH
         END IF 
         #FUN-C50110---end   
         CALL s_showmsg_init()
         CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
         CALL s_showmsg()
         #FUN-C50110---begin
         #ICD行業別時,自動產生出來的BOM也要做資料拋轉
         IF s_industry('icd') THEN   
            LET g_sql = "SELECT DISTINCT bma01,bma06,bma10 FROM bma_file",
                        " WHERE bmaicd01='",p_ima01 CLIPPED,"'",
                        " ORDER BY bma01,bma06"
            PREPARE i100_bma_p FROM g_sql
            DECLARE i100_bma_cs CURSOR WITH HOLD FOR i100_bma_p
                  
            FOREACH i100_bma_cs INTO l_bma01,l_bma06,l_bma10  
               CALL s_abmi600_com_carry(l_bma01,l_bma06,l_bma10,g_plant,1)
            END FOREACH
         END IF
         #FUN-C50110---end 
      END IF
   END IF
END FUNCTION

FUNCTION i100sub_mes(p_key1,p_key2,p_key3)
 DEFINE p_key1   LIKE type_file.chr1
 DEFINE p_key2   LIKE type_file.chr6
 DEFINE p_key3   LIKE type_file.chr500
 DEFINE l_prog   LIKE type_file.chr7
 DEFINE l_mesg01 LIKE type_file.chr30

 LET l_prog = ''
 CASE p_key1
   WHEN 'P' LET l_prog = 'aimi100'
   WHEN 'V' LET l_prog = 'aimi100'
   WHEN 'Z' LET l_prog = ' '
   OTHERWISE LET l_prog= 'axmi121'
 END CASE

 CASE p_key2
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
 CASE aws_mescli(l_prog,p_key2,p_key3)
    WHEN 0  #無與 MES 整合               #FUN-B60046 add
         MESSAGE l_mesg01                #FUN-B60046 add
         LET g_success = 'Y'             #FUN-B60046 add
    WHEN 1  #呼叫 MES 成功
         MESSAGE l_mesg01
         LET g_success = 'Y'
    WHEN 2  #呼叫 MES 失敗
         LET g_success = 'N'
   #OTHERWISE  #其他異常                 #FUN-B60046 mark
   #     LET g_success = 'N'             #FUN-B60046 mark
 END CASE

END FUNCTION

#FUN-C90107 add str---
FUNCTION i100sub_x(p_ima01)
    DEFINE
        l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n   LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_prog   LIKE type_file.chr8    #FUN-870101 add
    DEFINE l_avl_stk_mpsmrp LIKE type_file.num15_3,   #FUN-A20044
           l_unavl_stk      LIKE type_file.num15_3,   #FUN-A20044
           l_avl_stk        LIKE type_file.num15_3    #FUN-A20044
    DEFINE p_ima01  LIKE ima_file.ima01     #FUN-C90107 add
    DEFINE l_exe_exp LIKE type_file.chr1    #FUN-C90107 add

    LET g_errno = ''   #FUN-5A0081
    IF s_shut(0) THEN RETURN END IF
    IF g_ima.ima01 IS NULL THEN
        CALL cl_err('',-400,0)
        LET g_errno = '-400'       #FUN-C90107 add
        RETURN
    END IF
    IF NOT s_dc_ud_flag('1',g_ima.ima916,g_plant,'u') THEN
       CALL cl_err(g_ima.ima916,'aoo-045',1)
       LET g_errno = 'aoo-045'     #FUN-C90107 add
       RETURN
    END IF

    #MOD-A90011 add --start--
    #--->產品結構(bma_file,bmb_file)須有效BOM
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM bma_file
     WHERE bma01 = g_ima.ima01
       AND bmaacti = 'Y'
   #IF l_n > 0 THEN                          #MOD-CA0016 mark
    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
        CALL cl_err(g_ima.ima01,'aim-022',1)
        LET g_errno = 'aim-022'              #FUN-C90107 add
        RETURN
    END IF
    LET l_n = 0
   #MOD-B60132---modify---start---
   #SELECT COUNT(*) INTO l_n FROM bmb_file
   # WHERE bmb03 = g_ima.ima01
   #   AND (bmb04<=g_today OR bmb04 IS NULL)
   #   AND (bmb05> g_today OR bmb05 IS NULL)
    SELECT COUNT(*) INTO l_n FROM bmb_file,bma_file
     WHERE bmb03 = g_ima.ima01
       AND bma01 = bmb01 AND bma06 = bmb29
       AND (bmb04<=g_today OR bmb04 IS NULL)
       AND (bmb05> g_today OR bmb05 IS NULL)
       AND bmaacti = 'Y'
   #MOD-B60132---modify---end---
   #IF l_n > 0 THEN                          #MOD-CA0016 mark
    IF l_n > 0 AND g_ima.imaacti = 'Y' THEN  #MOD-CA0016
        CALL cl_err(g_ima.ima01,'aim-022',1)
        LET g_errno = 'aim-022'     #FUN-C90107 add
        RETURN
    END IF
    #MOD-A90011 add --end--

     #MOD-CC0187---add---S
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM bmd_file
       WHERE bmd04 = g_ima.ima01 AND bmdacti = 'Y'
         AND (bmd06 IS NULL OR bmd06 > g_today)
      IF l_n > 0 THEN
         CALL cl_err(g_ima.ima01,'aim1164',1)
         RETURN
      END IF
     #MOD-CC0187---add---S

    #CHI-AC0014 add --start--
    LET l_n = 0
    SELECT COUNT(DISTINCT ina01) INTO l_n
      FROM ina_file,inb_file
     WHERE inb01 = ina01
       AND inb04 = g_ima.ima01
      #AND inaconf != 'X'       #MOD-B10101 mark
       AND inaconf = 'N'        #MOD-B10101 add
    IF l_n > 0 THEN
        CALL cl_err(g_ima.ima01,'aim-026',1)
        LET g_errno = 'aim-026'     #FUN-C90107 add
        RETURN
    END IF
    #CHI-AC0014 add --end--

    IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
       BEGIN WORK
    END IF                            #FUN-C90107 add
 
    CALL i100sub_lock_cl()            #FUN-C90107 add

#   OPEN i100_cl USING g_ima.ima01    #FUN-C90107 mark
#   FETCH i100_cl INTO g_ima.*        #FUN-C90107 mark
    OPEN i100sub_cl USING g_ima.ima01 #FUN-C90107 add
    FETCH i100sub_cl INTO g_ima.*     #FUN-C90107 add
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       LET g_errno = SQLCA.sqlcode       #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083     
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF
    CALL s_getstock(g_ima.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044 add

#   IF g_ima.ima26  >0 THEN        #FUN-A20044
    IF l_avl_stk_mpsmrp > 0 THEN   #FUN-A20044
       CALL cl_err('','mfg9165',0)
       LET g_errno = 'mfg9165'          #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN   #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083
       END IF                           #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083   #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083   #FUN-C90107 add
       RETURN
    END IF
#   IF g_ima.ima261 >0 THEN       #FUN-A20044
    IF l_unavl_stk > 0 THEN       #FUN-A20044
       CALL cl_err('','mfg9166',0)
       LET g_errno = 'mfg9166'           #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF
#   IF g_ima.ima262 >0 THEN       #FUN-A20044
    IF l_avl_stk > 0 THEN         #FUN-A20044
       CALL cl_err('','mfg9167',0)
       LET g_errno = 'mfg9167'           #FUN-C90107 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083   
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark 
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add 
       RETURN
    END IF

    IF g_prog <> 'aws_ttsrv2' THEN       #FUN-C90107 add
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM sfb_file     #判斷是否有工單
              WHERE sfb05 = g_ima.ima01 AND sfb04 < '8'   #No.MOD-940165 add
                AND sfb87 != 'X'                           #No:MOD-9B0066 add
       IF cl_null(l_n) OR l_n = 0 THEN
          SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file  #判斷是否有採購單    #No:MOD-9B0066 add pmm_file
                 WHERE pmn04 = g_ima.ima01 AND pmn16 < '6'
                   AND pmn01 = pmm01 AND pmm18 != 'X'    #No:MOD-9B0066 add
          IF cl_null(l_n) OR l_n = 0 THEN
             SELECT COUNT(*) INTO l_n FROM oeb_file,oea_file   #判斷是否有訂單    #No:MOD-9B0066 add oea_file
                    WHERE oeb04 = g_ima.ima01 AND oeb70 != 'Y'
                      AND oeb01 = oea01 AND oeaconf !='X'   #No:MOD-9B0066 add
          END IF
       END IF

       IF NOT cl_null(l_n) AND l_n != 0 THEN
          IF NOT cl_confirm('aim-141') THEN
             ROLLBACK WORK   #MOD-A10083
             CLOSE i100sub_cl   #MOD-A10083
             RETURN
          END IF
       END IF
    END IF

    SELECT COUNT(*) INTO l_n FROM img_file
     WHERE img01=g_ima.ima01
       AND img10 <>0
    IF l_n > 0 THEN
       LET g_errno='mfg9163'
       CALL cl_err('',g_errno,0)       #No:MOD-A10080 add
       IF g_prog <> 'aws_ttsrv2' THEN    #FUN-C90107 add
          ROLLBACK WORK   #MOD-A10083 
       END IF                            #FUN-C90107 add
      #CLOSE i100_cl      #MOD-A10083    #FUN-C90107 mark
       CLOSE i100sub_cl   #MOD-A10083    #FUN-C90107 add
       RETURN
    END IF #MOD-5B0336 add RETURN

   #FUN-C90107 add str---
    LET l_exe_exp = 'N'
    IF g_prog <> 'aws_ttsrv2' THEN
       IF cl_exp(0,0,g_ima.imaacti) THEN
         LET l_exe_exp = 'Y'
       END IF
    ELSE
       LET l_exe_exp = 'Y'
    END IF

    IF l_exe_exp = 'Y' THEN
   #FUN-C90107 add end---
   #IF cl_exp(0,0,g_ima.imaacti) THEN    #FUN-C90107 mark
        LET g_chr=g_ima.imaacti
        LET g_chr2=g_ima.ima1010   #No.FUN-610013
        CASE g_ima.ima1010
          WHEN '0' #開立
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='P'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
          WHEN '1' #確認
               IF g_ima.imaacti='N' THEN
                  LET g_ima.imaacti='Y'
               ELSE
                  LET g_ima.imaacti='N'
               END IF
         END CASE
        UPDATE ima_file
            SET imaacti=g_ima.imaacti,
                imamodu=g_user, imadate=g_today
            WHERE ima01 = g_ima.ima01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_errno = SQLCA.sqlcode    #FUN-C90107 add
            LET g_ima.imaacti=g_chr
            LET g_ima.ima1010=g_chr2      #No.FUN-610013
            LET g_success = 'N'           #FUN-9A0056 add
            LET g_errno = SQLCA.sqlcode   #FUN-C90107 add
        END IF

       #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD  #FUN-9A0056 mark
        IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_ima.ima1010 = '1' THEN  #FUN-9A0056 add

           IF g_ima.imaacti='N' THEN
             #FUN-9A0056 mark str ------
              ## CALL aws_mescli
              ## 傳入參數: (1)程式代號
              ##           (2)功能選項：insert(新增),update(修改),delete(刪除)
              ##           (3)Key
              #LET l_prog=''
              #CASE g_ima.ima08
              #   WHEN 'P' LET l_prog = 'aimi100'
              #   WHEN 'M' LET l_prog = 'axmi121'
              #   OTHERWISE LET l_prog= ' '
              #END CASE
              #CASE aws_mescli(l_prog,'delete',g_ima.ima01)
              #   WHEN 0  #無與 MES 整合
              #        CALL cl_msg('Delete O.K')
              #   WHEN 1  #呼叫 MES 成功
              #        CALL cl_msg('Delete O.K, Delete MES O.K')
              #   WHEN 2  #呼叫 MES 失敗
              #        RETURN FALSE
              #END CASE
              #FUN-9A0056 mark end ------
              #確認資料由有效變無效,則傳送刪除MES
              #CALL i100_mes(g_ima.ima08,'delete',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
               CALL i100sub_mes(g_ima.ima08,'delete',g_ima.ima01)                #FUN-A70106 add
            ELSE                                                 #FUN-9A0056 add
              #確認資料由無效變有效,則傳送新增MES
              #CALL i100_mes(g_ima.ima08,'insert',g_ima.ima01)   #FUN-9A0056 add #FUN-A70106 mark
               CALL i100sub_mes(g_ima.ima08,'insert',g_ima.ima01)                #FUN-A70106 add
           END IF
        END IF  #TQC-8B0011  ADD

        #FUN-9A0056-----start
        IF g_success = 'N' THEN
           IF g_prog <> 'aws_ttsrv2' THEN   #FUN-C90107 add
              ROLLBACK WORK
           END IF                           #FUN-C90107 add
          #CLOSE i100_cl                    #FUN-C90107 mar
           CLOSE i100sub_cl                 #FUN-C90107 add
           RETURN
        END IF
        #FUN-9A0056-------end

        DISPLAY BY NAME g_ima.ima1010     #No.FUN-610013
        DISPLAY BY NAME g_ima.imaacti
        IF g_prog <> 'aws_ttsrv2' THEN                         #FUN-C90107 add
#          CALL i100_list_fill()             #No.FUN-7C0010    #FUN-C90107 mark
           CALL i100sub_list_fill()          #No.FUN-7C0010    #FUN-C90107 add
        END IF                                                 #FUN-C90107 add
    END IF
    CLOSE i100sub_cl
    IF g_prog <> 'aws_ttsrv2' THEN                             #FUN-C90107 add
       COMMIT WORK
    END IF                                                     #FUN-C90107 add
END FUNCTION

FUNCTION i100sub_list_fill()
  DEFINE l_ima01         LIKE ima_file.ima01
  DEFINE l_i             LIKE type_file.num10
  
   CALL i100sub_declare_curs()  #MOD-D30241
   CALL g_ima_l.clear()
    LET l_i = 1
    FOREACH aimi100sub_list_cur INTO l_ima01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ima01,ima02,ima021,ima06,ima08,ima130,ima109,
              ima25,ima37,ima1010,imaacti,ima916
         INTO g_ima_l[l_i].*
         FROM ima_file
        WHERE ima01=l_ima01
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN   #CHI-BB0034 add
            CALL cl_err( '', 9035, 0 )
          END IF                              #CHI-BB0034 add
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_i - 1
    DISPLAY ARRAY g_ima_l TO s_ima_l.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
   END DISPLAY
END FUNCTION
#FUN-C90107 add end---
#darcy:2022/11/18 add s---
function p100sub_cre_set(p_ima01,p_smd04)
   define p_smd04    like smd_file.smd04
   define p_ima01    like ima_file.ima01
   define l_cnt      like type_file.num5

   let l_cnt = 0
   select 1 into l_cnt from smd_file
    where smd01 = p_ima01 and smd02 = 'SET' and smd03='PNL'
   if l_cnt = 0 then
      insert into smd_file values (
         p_ima01,'SET','PNL',p_smd04,1,'','Y',1,g_today
      )
      if status then
         call cl_err("ins smd",status,1)
         return false
      end if
   else
        if cl_null(p_smd04) or p_smd04 = 0 then
            delete from smd_file
             where smd01 = p_ima01
                and smd02 = 'SET' 
                and smd03='PNL'
        else
            update smd_file
                set smd04 = p_smd04,
                    smd06 = 1,
                    smdacti = 'Y',
                    smddate = g_today
            where smd01 = p_ima01
                and smd02 = 'SET' 
                and smd03='PNL'
        end if
      
      if status then
         call cl_err("upd smd",status,1)
         return false
      end if
   end if
   return true
end function
#darcy:2022/11/18 add e---

#darcy:2024/07/10 add s---
# 检查PNL尺寸输入是否正确
function aimi100_imaud07(p_imaud07)
   define p_imaud07 like ima_file.imaud07
   define l_sql      string
   define i                decimal(15,3)
   # if g_user <> 'tiptop' then
   #    return true
   # end if
   let p_imaud07 = cl_replace_str(p_imaud07," ","")

   let i = 0
   let l_sql = "SELECT count(1) FROM dual ",
               "  WHERE  REGEXP_LIKE('",p_imaud07,"','^([1-9]\\d{0,2})\\*([1-9]\\d{0,2})$')"
   prepare imaud07_chk_p from l_sql
   execute imaud07_chk_p into i
   if i = 0 then 
      call cl_err(p_imaud07,'cim-034',1)
      return false
   end if
   return true
end function
#darcy:2024/07/10 add e---
