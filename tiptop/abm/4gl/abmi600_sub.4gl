# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: abmi600_sub.4gl
# Descriptions...: 將原abmi600.4gl確認段拆解至abmi600_sub.4gl中
# Date & Author..: #FUN-A70134 10/07/28 By Mandy
# Modify.........: #FUN-AA0018 10/10/08 By Mandy 將原在abmi600.4gl內
#                  發放功能i600_j()拆解成:
#                  i600sub_j_chk()
#                  i600sub_j_input() ==>Service 做發放時不會呼叫
#                  i600sub_j_upd()
#                  i600sub_carry() ==>Service 做發放時不會呼叫
# Modify.........: #FUN-AA0035 10/10/27 By Mandy 錯誤訊息調整
# Modify.........: No:MOD-AC0292 10/12/23 By Pengu 下階半成品BOM未發放時，不應控管不允許成品發放
# Modify.........: No.MOD-B30070 11/03/09 By Mandy BOM發放時,無法輸入發放日期
#-------------------------------------------------------------------------------------
# Modify.........: No:FUN-A70134 11/07/05 By Mandy GP5.25 PLM 追版,以上單號為GP5.1 單號
# Modify.........: No:TQC-C20149 12/02/15 By bart 點選"BOM發放"按鈕後選擇取消,程式會自動關閉
# Modify.........: No:MOD-C40044 12/04/06 By Elise 修正l_imaacti MATCHES '[PH]' 錯誤代碼
# Modify.........: No:CHI-C40007 12/04/10 By Elise 確認的檢查段加上發放段check料件是否為正式料號的控卡
# Modify.........: No:TQC-C50031 12/05/14 By fengrui 確認與發放的檢查段加上發放段check單身元料件是否為正式料號的控卡
# Modify.........: No.CHI-C30107 12/06/05 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70060 12/07/13 By yuhuabao abmi600對應的sub沒有同步過單 導致無法審核
# Modify.........: No.MOD-CC0285 13/01/08 By Elise 調整按下確認時訊息
# Modify.........: No.FUN-C40006 13/01/10 By Nina 只要程式有UPDATE bma_file 的任何一個欄位時,多加bmadate=g_today

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"  #FUN-AA0018 add

FUNCTION i600sub_lock_cl() #FUN-A7106
   DEFINE l_forupd_sql STRING                                                   

   LET l_forupd_sql = "SELECT * FROM bma_file WHERE bma01 = ? AND bma06 = ? FOR UPDATE " #FUN-A70134(110705) mod
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)                                        #FUN-A70134(110705) add
   DECLARE i600sub_cl CURSOR FROM l_forupd_sql                                  
END FUNCTION

FUNCTION i600sub_refresh(p_bma01,p_bma06)
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_bma RECORD LIKE bma_file.*

   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF
   
   SELECT * INTO l_bma.* FROM bma_file 
    WHERE bma01=p_bma01
      AND bma06=p_bma06
   RETURN l_bma.*
END FUNCTION

FUNCTION i600sub_y_chk(p_bma01,p_bma06)
   DEFINE l_cnt   LIKE type_file.num5  
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_bma RECORD LIKE bma_file.*
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_bmb09   LIKE bmb_file.bmb09
   #darcy add 2022年2月16日 s---  
   DEFINE l_bmb     RECORD
                  bmb02    LIKE bmb_file.bmb02,
                  bmb03    LIKE bmb_file.bmb03,
                  #add by darcy2022-03-10 16:58:42 s---
                  bmb19    LIKE bmb_file.bmb19,
                  bmb10    LIKE bmb_file.bmb10,
                  bmb10_fac      LIKE bmb_file.bmb10_fac,
                  bmb10_fac2     LIKE bmb_file.bmb10_fac2,
                  ima25    LIKE ima_file.ima25,
                  ima86    LIKE ima_file.ima86,
                  bmb04    LIKE bmb_file.bmb04,
                  bmb09    LIKE bmb_file.bmb09,
                  imaud32  like ima_file.imaud32 #darcy:2023/07/15 add
               END RECORD 
   DEFINE l_sw             LIKE type_file.chr1,
          l_bmb10_fac      LIKE bmb_file.bmb10_fac,
          l_bmb10_fac2     LIKE bmb_file.bmb10_fac2
                  #add by darcy2022-03-10 16:58:42 e---
                  
                 
   #darcy add 2022年2月16日 e---

   IF s_shut(0) THEN RETURN END IF

   LET g_success = 'Y'
   IF cl_null(p_bma01)THEN
      CALL cl_err("",-400,1)
      LET g_errno = '-400'
      LET g_success = 'N'
      RETURN
   END IF

  #MOD-CC0285---add---S
   SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06
  #MOD-CC0285---add---E

   #CHI-C30107 -------- add --------- begin
   IF l_bma.bma10='1' THEN
       CALL cl_err('','9023',1)
       LET g_errno = '9023'
       LET g_success = 'N'
       RETURN
   END IF

  #MOD-CC0285---add---S
   IF l_bma.bma10 = '2' THEN
      CALL cl_err('','abm-123',0)
      LET g_errno = 'abm-123'
      LET g_success = 'N'
      RETURN
   END IF
  #MOD-CC0285---add---E

   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN #120703 add if 判斷   #FUN-C70060
      IF  NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF  #CHI-C30107 add
   END IF                                      
   #CHI-C30107 -------- add --------- end
   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF
   
   #darcy add 2022年2月16日 s---
   CALL s_showmsg_init()  

   DECLARE i600_checkbmb19 CURSOR FOR 
    SELECT bmb02,bmb03,bmb19
           ,bmb10,bmb10_fac,bmb10_fac,ima25,ima86,bmb04,bmb09,imaud32   #add by darcy 2022年3月10日 #darcy:2023/07/15 add
      FROM bmb_file 
      ,ima_file   #add by darcy 2022年3月11日
      WHERE bmb01 =p_bma01 AND bmb29=p_bma06 
        AND ima01 = bmb03  #add by darcy 2022年3月11日
   FOREACH i600_checkbmb19 INTO l_bmb.*
      IF STATUS THEN
         CALL cl_err("i600_checkbmb19",STATUS,1) #參數設定:不可修改其他營運中心拋轉過來的資料 
         LET g_success = 'N' 
         RETURN
      END IF 
      IF l_bmb.bmb03 MATCHES '*-*' AND l_bmb.bmb19 <>'2' THEN
         CALL s_errmsg("bmb02,bmb03",l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
         LET g_success = 'N'
      END IF 
      IF l_bmb.bmb03 NOT MATCHES '*-*' AND l_bmb.bmb19 <>'1' THEN
         CALL s_errmsg("bmb02,bmb03",l_bmb.bmb02||","||l_bmb.bmb03," ",'cbm-003',1)
         LET g_success = 'N'
      END IF 
      #bmb10_fac
      #darcy:2023/07/15 add s---
      # 设计停止使用检查
      if l_bmb.imaud32 = 1 then
         call s_errmsg('bmb01,bmb03,bmb09',p_bma01||","||l_bmb.bmb03||","||l_bmb.bmb09,'i600:','cbm-023',1)
         let g_success = 'N'
         continue foreach
      end if
      #darcy:2023/07/15 add e---
        
      #add by darcy2022-03-10 16:59:57 s---
      CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima25)
         RETURNING l_sw,l_bmb10_fac
      IF l_sw THEN LET l_bmb10_fac = 1 END IF
      CALL s_umfchk(l_bmb.bmb03,l_bmb.bmb10,l_bmb.ima86)
            RETURNING l_sw,l_bmb10_fac2
      IF l_sw THEN LET l_bmb10_fac2 = 1 END IF
      UPDATE bmb_file 
         SET bmb10_fac = l_bmb10_fac,
             bmb10_fac2 =  l_bmb10_fac2
      WHERE bmb01 = p_bma01 AND bmb02 = l_bmb.bmb02 
        AND bmb03 = l_bmb.bmb03 AND bmb04= l_bmb.bmb04 AND bmb09= l_bmb.bmb09
      #add by darcy2022-03-10 16:59:57 e---
   END FOREACH 
   CALL s_showmsg()  
   IF g_success = 'N' THEN 
      RETURN
   END IF 
   #darcy add 2022年2月16日 e---   

   SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06
   
    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
       CALL cl_err(l_bma.bma08,'aoo-045',1) #參數設定:不可修改其他營運中心拋轉過來的資料
       LET g_errno = 'aoo-045'
       LET g_success = 'N'
       RETURN
    END IF

   IF l_bma.bma10='1' THEN 
       CALL cl_err('','9023',1) 
       LET g_errno = '9023'
       LET g_success = 'N'
       RETURN 
   END IF

  #CHI-C40007---str---
    SELECT ima01,imaacti
      INTO l_ima01,l_imaacti
      FROM ima_file
     WHERE ima01 = l_bma.bma01

    IF l_imaacti MATCHES '[PH]' THEN
        CALL cl_err('','abm-038',0)  
        LET g_errno = 'abm-038'      
        LET g_success = 'N'
        RETURN
    END IF
  #CHI-C40007---end---

   #---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM bmb_file
    WHERE bmb01=p_bma01
      AND bmb29=p_bma06
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',1)
      LET g_errno = 'mfg-009'
      LET g_success = 'N'
      RETURN
   END IF
#str---add by huanglf161020
   IF NOT i600sub_chk_bmb09(p_bma01,p_bma06) THEN 
      LET g_success = 'N'
      RETURN
   END IF   
#str---end by huanglf161020
 
   #TQC-C50031--add--str--
   IF NOT i600sub_chk_bmb03(p_bma01,p_bma06) THEN 
      LET g_success = 'N'
      RETURN
   END IF    
   #TQC-C50031--add--end--
END FUNCTION

FUNCTION i600sub_y_upd(p_bma01,p_bma06)
   DEFINE p_bma01   LIKE bma_file.bma01
   DEFINE p_bma06   LIKE bma_file.bma06
   DEFINE l_bma     RECORD LIKE bma_file.*

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'   

   CALL i600sub_lock_cl()

   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF

   OPEN i600sub_cl USING p_bma01,p_bma06
   IF STATUS THEN
      CALL cl_err("OPEN i600sub_cl:", STATUS, 1)
      CLOSE i600sub_cl
      LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
      LET g_success = 'N'
      RETURN
   END IF

   FETCH i600sub_cl INTO l_bma.*                # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_bma01,SQLCA.sqlcode,1)     # 資料被他人LOCK
       CLOSE i600sub_cl 
       LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
       LET g_success = 'N'
       RETURN
   END IF
   CLOSE i600sub_cl

   UPDATE bma_file
      SET bma10 = '1',#審核
          bmadate=g_today     #FUN-C40006 add
    WHERE bma01 = p_bma01
      AND bma06 = p_bma06
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err(l_bma.bma01,SQLCA.sqlcode,0)
      LET g_errno = 'aws-193' #更新ERP BOM的狀態碼(bma1010)不成功!
      LET g_success = 'N'    
      RETURN
   END IF
END FUNCTION
#FUN-A70134 

#FUN-AA0018---add----str---
FUNCTION i600sub_j_chk(p_bma01,p_bma06)
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_bma RECORD LIKE bma_file.*
   DEFINE l_cnt   LIKE type_file.num10
   DEFINE l_ima01   LIKE ima_file.ima01   
   DEFINE l_imaacti LIKE ima_file.imaacti 
   DEFINE l_bmb01   LIKE bmb_file.bmb01   
   DEFINE l_bmb02   LIKE bmb_file.bmb02   
   DEFINE l_bmb03   LIKE bmb_file.bmb03   
   DEFINE l_bmb04   LIKE bmb_file.bmb04   
   DEFINE l_ima910  LIKE ima_file.ima910  
   DEFINE l_n       LIKE type_file.num5   
   DEFINE l_bma05   LIKE bma_file.bma05   

   IF s_shut(0) THEN RETURN END IF

   LET g_success = 'Y'
   IF p_bma01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       LET g_errno = '-400'
       LET g_success = 'N'
       RETURN 
   END IF
   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF
 
   SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06
    IF NOT s_dc_ud_flag('2',l_bma.bma08,g_plant,'u') THEN
        CALL cl_err(l_bma.bma08,'aoo-045',1)
        LET g_errno = 'aoo-045'
        LET g_success = 'N'
        RETURN
    END IF
    SELECT ima01,imaacti 
      INTO l_ima01,l_imaacti 
      FROM ima_file 
     WHERE ima01 = l_bma.bma01
    IF l_imaacti = 'N' THEN 
        CALL cl_err('','9028',0)      
        LET g_errno = '9028'
        LET g_success = 'N'
        RETURN 
    END IF
    IF l_imaacti MATCHES '[PH]' THEN
       #CALL cl_err('','abm-037',0)  #MOD-C40044 mark 
       #LET g_errno = 'abm-037'      #MOD-C40044 mark
        CALL cl_err('','abm-038',0)  #MOD-C40044 
        LET g_errno = 'abm-038'      #MOD-C40044 
        LET g_success = 'N'
        RETURN
    END IF  
    IF l_bma.bma10 = 0 THEN 
        CALL cl_err('','aco-174',0) 
        LET g_errno = 'aco-174'
        LET g_success = 'N'
        RETURN 
    END IF   
    IF l_bma.bma10 = 2 THEN 
        CALL cl_err('','abm-003',0) 
        LET g_errno = 'abm-003'
        LET g_success = 'N'
        RETURN 
    END IF   
    IF l_bma.bmaacti='N' THEN
        CALL cl_err(l_bma.bmaacti,'aap-127',0) 
        LET g_errno = 'aap-127'
        LET g_success = 'N'
        RETURN
    END IF
    IF NOT cl_null(l_bma.bma05) THEN
        CALL cl_err(l_bma.bma05,'abm-003',0) 
        LET g_errno = 'abm-003'
        LET g_success = 'N'
        RETURN
    END IF
    SELECT COUNT(*) 
      INTO l_cnt
      FROM bmb_file 
     WHERE bmb01 = l_bma.bma01
       AND bmb29 = l_bma.bma06  
    IF l_cnt=0 THEN
        CALL cl_err(l_bma.bma01,'arm-034',0) 
        LET g_errno = 'arm-034'
        LET g_success = 'N'
        RETURN
    END IF

    #TQC-C50031--add--str--
    IF NOT i600sub_chk_bmb03(p_bma01,p_bma06) THEN
       LET g_success = 'N'
       RETURN
    END IF
    #TQC-C50031--add--end--

    #==>BOM在進行發放時，檢核下階半成品的BOM是否發放
    DECLARE i600_up_cs CURSOR FOR
     SELECT bmb01,bmb02,bmb03,bmb04
       FROM bmb_file
      WHERE bmb01 = l_bma.bma01
        AND bmb29 = l_bma.bma06  
        AND (bmb05 > l_bma.bma05 OR bmb05 IS NULL )

    CALL s_showmsg_init() 

    FOREACH i600_up_cs INTO l_bmb01,l_bmb02,l_bmb03,l_bmb04
        SELECT ima910 
          INTO l_ima910 
          FROM ima_file 
         WHERE ima01 = l_bmb03
        IF cl_null(l_ima910) THEN 
            LET l_ima910 = ' ' 
        END IF
        SELECT COUNT(*) INTO l_n
          FROM bma_file
         WHERE bma01 = l_bmb03
           AND bma06 = l_ima910
           AND bmaacti = 'Y'
        IF l_n > 0 THEN
            SELECT bma05 INTO l_bma05
              FROM bma_file
             WHERE bma01 = l_bmb03
               AND bma06 = l_ima910
               AND bmaacti = 'Y'
            IF cl_null(l_bma05) OR l_bma05 = ' ' THEN
                CALL s_errmsg('bmb03',l_bmb03,'i600:','amr-001',1)
               #LET g_errno = 'amr-001'                                #FUN-AA0035 mark
              #-------------No:MOD-AC0292 mark
               #LET g_errno = 'aws-452' #此BOM或下階半成品的BOM未發放! #FUN-AA0035 add
               #LET g_success = 'N'
              #-------------No:MOD-AC0292 end
            END IF
        END IF
    END FOREACH
    CALL s_showmsg() 
END FUNCTION

FUNCTION i600sub_j_upd(p_bma01,p_bma06,p_bma05)
   DEFINE p_bma01   LIKE bma_file.bma01
   DEFINE p_bma06   LIKE bma_file.bma06
   DEFINE p_bma05   LIKE bma_file.bma05
   DEFINE l_bma     RECORD LIKE bma_file.*

   WHENEVER ERROR CONTINUE

   LET g_success = 'Y'   

   CALL i600sub_lock_cl()

   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF

   OPEN i600sub_cl USING p_bma01,p_bma06
   IF STATUS THEN
      CALL cl_err("OPEN i600sub_cl:", STATUS, 1)
      CLOSE i600sub_cl
      LET g_errno = 'aws-191' #OPEN LOCK CURSOR失敗!
      LET g_success = 'N'
      RETURN
   END IF

   FETCH i600sub_cl INTO l_bma.*                # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(p_bma01,SQLCA.sqlcode,1)     # 資料被他人LOCK
       CLOSE i600sub_cl 
       LET g_errno = '-243'                     #資料已經被鎖住, 無法讀取 !
       LET g_success = 'N'
       RETURN
   END IF
   CLOSE i600sub_cl
   IF cl_null(p_bma05) THEN
       LET p_bma05 = g_today
   END IF
   UPDATE bma_file 
      SET bma05 = p_bma05, 
          bma10 = '2', 
          bmadate=g_today     #FUN-C40006 add        
    WHERE bma01 = l_bma.bma01
      AND bma06 = l_bma.bma06 
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","bma_file",l_bma.bma01,l_bma.bma06,SQLCA.sqlcode,"","up bma05",1)  #No.TQC-660046
      LET g_errno = 'aws-340' #更新ERP BOM的狀態碼(bma1010)為'2:發放'不成功!
      LET g_success = 'N'    
      RETURN
   END IF
END FUNCTION

FUNCTION i600sub_j_input()
    DEFINE l_bma05   LIKE bma_file.bma05

    WHENEVER ERROR CONTINUE

    LET l_bma05=g_today
    #IF NOT cl_confirm('abm-004') THEN RETURN END IF   #TQC-C20149 mark
    #TQC-C20149---begin
    IF NOT cl_confirm('abm-004') THEN
       LET INT_FLAG = 1
       RETURN NULL
    END IF
    ##TQC-C20149---end
    
    CALL cl_set_head_visible("","YES")   
   #INPUT BY NAME l_bma05 WITHOUT DEFAULTS    #MOD-B30070 mark
    INPUT l_bma05 WITHOUT DEFAULTS FROM bma05 #MOD-B30070 add
    
      AFTER FIELD bma05
        IF cl_null(l_bma05) THEN NEXT FIELD bma05 END IF
    
      AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
        IF cl_null(l_bma05) THEN NEXT FIELD bma05 END IF
    
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
    
      ON ACTION about         
         CALL cl_about()      
    
      ON ACTION help          
         CALL cl_show_help()  
    
      ON ACTION controlg      
         CALL cl_cmdask()     
    
    END INPUT
    RETURN l_bma05
END FUNCTION

FUNCTION i600sub_carry(p_bma01,p_bma06)
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_bma   RECORD LIKE bma_file.*
   DEFINE l_gev04 LIKE gev_file.gev04
   DEFINE l_gew03 LIKE gew_file.gew03   
   DEFINE l_sql   STRING                
   DEFINE l_i     LIKE type_file.num10
   DEFINE l_bmax  DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                      sel         LIKE type_file.chr1,
                      bma01       LIKE bma_file.bma01,
                      bma06       LIKE bma_file.bma06
                  END RECORD

   IF cl_null(p_bma01)THEN
      CALL cl_err("",-400,1)
      LET g_errno = '-400'
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(p_bma06) THEN
       LET p_bma06 = ' '
   END IF
 
   SELECT * INTO l_bma.* FROM bma_file
    WHERE bma01=p_bma01
      AND bma06=p_bma06

    #如果勾選自動拋轉,發放時一併做拋轉動作---
    #是否為資料中心的拋轉DB                                                      
    SELECT gev04 INTO l_gev04 FROM gev_file                                      
     WHERE gev01 = '2' AND gev02 = g_plant                                       
       AND gev03 = 'Y'                                                           
    IF SQLCA.sqlcode THEN
       IF SQLCA.sqlcode=100 THEN
          RETURN
       ELSE                                                        
          CALL cl_err(l_gev04,'aoo-036',1)                                          
          RETURN
       END IF
    END IF

    IF cl_null(l_gev04) THEN RETURN END IF
    SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
     WHERE gew01 = l_gev04
       AND gew02 = '2'
    IF l_gew03 = '1' THEN
        #開窗選擇拋轉的db清單
        LET l_sql = "SELECT COUNT(*) FROM &bma_file WHERE bma01='",l_bma.bma01,"'",
                                                   "  AND bma06='",l_bma.bma06,"'"
        CALL s_dc_sel_db1(l_gev04,'2',l_sql)
        IF INT_FLAG THEN
           LET INT_FLAG=0
           RETURN
        END IF

        CALL l_bmax.clear()
        LET l_bmax[1].sel = 'Y'
        LET l_bmax[1].bma01 = l_bma.bma01
        LET l_bmax[1].bma06 = l_bma.bma06
        FOR l_i = 1 TO g_azp1.getLength()
            LET g_azp[l_i].sel   = g_azp1[l_i].sel
            LET g_azp[l_i].azp01 = g_azp1[l_i].azp01
            LET g_azp[l_i].azp02 = g_azp1[l_i].azp02
            LET g_azp[l_i].azp03 = g_azp1[l_i].azp03
        END FOR

        CALL s_showmsg_init()
        CALL s_abmi600_carry(l_bmax,g_azp,l_gev04,'0')  
        CALL s_showmsg()
    END IF 
END FUNCTION
#FUN-AA0018---add----end---

#TQC-C50031--add--str--
#---單身元件未審核不可確認與發放
FUNCTION i600sub_chk_bmb03(p_bma01,p_bma06)
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_bmb03   LIKE bmb_file.bmb03  
   DEFINE l_ima70   LIKE ima_file.ima70
   DEFINE l_bmb15   LIKE bmb_file.bmb15

   LET l_ima01 = NULL
   LET l_imaacti = NULL

   DECLARE i600_bmb03_cs CURSOR FOR
     SELECT bmb03,bmb15
       FROM bmb_file
      WHERE bmb01 = p_bma01
        AND bmb29 = p_bma06

   CALL s_showmsg_init()
   FOREACH i600_bmb03_cs INTO l_bmb03,l_bmb15
      SELECT ima01,imaacti,ima70
        INTO l_ima01,l_imaacti,l_ima70
        FROM ima_file
       WHERE ima01 = l_bmb03

      IF l_imaacti MATCHES '[PH]' THEN
         CALL s_errmsg('bmb03',l_bmb03,'i600:','abm-084',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
      IF l_ima70 <> l_bmb15 THEN
         CALL s_errmsg('bmb03',l_bmb03,'i600:','cbm-002',1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION


#TQC-C50031--add--end--


#str----add by huanglf161020
FUNCTION i600sub_chk_bmb09(p_bma01,p_bma06)
   DEFINE p_bma01 LIKE bma_file.bma01
   DEFINE p_bma06 LIKE bma_file.bma06
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_imaacti LIKE ima_file.imaacti
   DEFINE l_bmb09   LIKE bmb_file.bmb03    

   LET l_ima01 = NULL
   LET l_imaacti = NULL

   DECLARE i600_bmb09_cs CURSOR FOR
     SELECT bmb09
       FROM bmb_file
      WHERE bmb01 = p_bma01
        AND bmb29 = p_bma06

   CALL s_showmsg_init()
   FOREACH i600_bmb09_cs INTO l_bmb09
     IF cl_null(l_bmb09) THEN
        CALL s_errmsg('bmb09',l_bmb09,'i600:','cbm-001',1)
     LET g_success = 'N'
     END IF 
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN FALSE
   END IF
   RETURN TRUE 
END FUNCTION



#str----end by huanglf161020

