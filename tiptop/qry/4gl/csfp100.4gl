# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asfp100.4gl
# Descriptions...: 已發放工單還原作業
# Date & Author..: 92/11/24 Lee
#TODO  工序序号不能手工录入
#TODO  工艺说明未带出
#TODO  工艺版本唯一时候，自动带出 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm RECORD
        wc           LIKE type_file.chr1000,
        begin,end    LIKE sfb_file.sfb15,
        cfconfirm    LIKE type_file.chr1,
        fcnt         DECIMAL(15,3),
        ecb02        LIKE ecb_file.ecb02,
        ecb03        LIKE ecb_file.ecb03,
        ecb06        LIKE ecb_file.ecb06 
    END RECORD, 
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        sfb513       LIKE sfb_file.sfb04,          #TQC-A50027   add
        s_t          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_exit_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_argv1   STRING   #TQC-730022
DEFINE g_no          VARCHAR(40)
    
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
  
   LET g_argv1 = ARG_VAL(1)   #TQC-730022
   IF cl_null(g_argv1) THEN 
      LET g_argv1 ='N'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL p100_init()
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
  #TQC-730022 begin
   # IF NOT cl_null(g_argv1) THEN
   # #   LET tm.cfConfirm = 'N' 
   # #   LET tm.cfAlc     = 'N' 
   # #   LET tm.cfTrk     = 'N' 
   # #   LET tm.sfb13 = NULL
   # #   LET tm.sfb15 = NULL
   #   LET tm.wc = g_argv1
   #   CALL p100_p()
   # ELSE
  #TQC-730022 end
     CALL p100_cmd(0,0)          #condition input
   # END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p100_cmd(p_row,p_col)
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 10
   END IF
   IF g_argv1 = 'Y' THEN 
      OPEN WINDOW p100_w AT p_row,p_col
         WITH FORM "csf/42f/csfp100" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   ELSE 
      OPEN WINDOW p100_w AT p_row,p_col
         WITH FORM "csf/42f/csfp101" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   END IF 
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
    WHILE TRUE
        IF s_shut(0) THEN RETURN END IF
        IF g_argv1 = 'Y' THEN
            CALL p100_i()
        ELSE
            CALL p100_i2()
        END IF
        IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
 
        IF cl_sure(0,0)
        THEN
            CALL p100_p()
        END IF
        CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           EXIT WHILE
        END IF
    END WHILE
    ERROR ""
    CLOSE WINDOW p100_w
END FUNCTION
 
FUNCTION p100_i()
   DEFINE   l_sfRequired    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_cfDirection   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) #TQC-840066
   DEFINE   l_sql           STRING 
   DEFINE   l_ecb01         LIKE ecb_file.ecb01 
   DEFINE   l_wc            STRING
   DEFINE   l_cnt           LIKE type_file.num5
 
 
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
 
   #QBE
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
      
      CONSTRUCT BY NAME tm.wc ON sfb01,sfb05  

         AFTER FIELD sfb05 
            LET l_ecb01 = DIALOG.getFieldBuffer("sfb05")
            SELECT count(unique ecb02) INTO l_cnt  FROM ecb_file  WHERE ecb01 =l_ecb01
            IF l_cnt = 1 THEN
               SELECT ecb02 INTO tm.ecb02 FROM ecb_file WHERE ecb01 =l_ecb01
               DISPLAY BY NAME tm.ecb02
            END IF         

         ON ACTION controlp INFIELD sfb01
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_sfb"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb01
            NEXT FIELD sfb01

         ON ACTION controlp INFIELD sfb05
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb05
            NEXT FIELD sfb05

      END CONSTRUCT
      INPUT tm.begin,tm.end,tm.ecb02 FROM sfb22,sfb15,ecb02
         BEFORE INPUT
     
         
         ON ACTION controlp 
            LET l_wc = cl_replace_str(tm.wc,"sfb05","ecb01")
            IF NOT cl_null(tm.ecb02) THEN 
               LET l_wc = l_wc," AND ecb02 ='",tm.ecb02,"'"
            END IF
            IF NOT cl_null(l_ecb01)  THEN
               IF INFIELD(ecb02) THEN 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_ecb02"
                  LET g_qryparam.arg1 = l_wc
                  LET g_qryparam.state = "i"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.ecb02 = g_qryparam.multiret
                  DISPLAY tm.ecb02 TO ecb02
                  NEXT FIELD ecb02
               END IF 
            END IF         

      END INPUT 
      
      BEFORE DIALOG
         #TODO nothing
         LET l_sql = "SELECT add_months(last_day(sysdate), -1) + 1, last_day(sysdate) FROM dual"
         PREPARE p_date_cur FROM l_sql 
         EXECUTE p_date_cur INTO   tm.begin,tm.end 
         LET tm.fcnt=1
         LET tm.cfconfirm = 'N' 
         CALL cl_set_comp_entry("ecb03,ecb06,fcnt",FALSE) 

      AFTER DIALOG
         #TODO 检查
         #TODO 1.模拟模式
         #TODO 1.1 不可输入工单号，提示查不到资料
         IF tm.cfconfirm ='Y' THEN 
         ELSE  
         #TODO 2.实际报废模式  
         END IF 

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION accept             
         EXIT DIALOG

      ON ACTION cancel 
         LET INT_FLAG = 1            
         EXIT DIALOG

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT DIALOG
   
   END DIALOG
    
   IF INT_FLAG THEN
      RETURN
   END IF 
    
END FUNCTION

FUNCTION p100_i2()
   DEFINE   l_sfRequired    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_cfDirection   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) #TQC-840066
   DEFINE   l_sql           STRING 
   DEFINE   l_ecb01         LIKE ecb_file.ecb01 
   DEFINE   l_wc            STRING
   DEFINE   l_cnt           LIKE type_file.num5
 
 
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
 
   #QBE
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)
      
      CONSTRUCT BY NAME tm.wc ON sfb05  

         AFTER FIELD sfb05 
            LET l_ecb01 = DIALOG.getFieldBuffer("sfb05")
            SELECT count(unique ecb02) INTO l_cnt  FROM ecb_file  WHERE ecb01 =l_ecb01
            IF l_cnt = 1 THEN
               SELECT ecb02 INTO tm.ecb02 FROM ecb_file WHERE ecb01 =l_ecb01
               DISPLAY BY NAME tm.ecb02
            END IF          

         ON ACTION controlp INFIELD sfb05
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO sfb05
            NEXT FIELD sfb05

      END CONSTRUCT
      INPUT tm.begin,tm.end,tm.fcnt,tm.ecb02,tm.ecb03,tm.ecb06 FROM sfb22,sfb15,fcnt,ecb02,ecb03,ecb06
         BEFORE INPUT
            
            DISPLAY  tm.fcnt TO fcnt
         
         AFTER FIELD ecb03
            IF NOT cl_null(l_ecb01)  THEN
               CALL p100_get_ecb(cl_replace_str(tm.wc,"sfb05","ecb01")||" AND ecb03='"||tm.ecb03||"'")
                   RETURNING tm.ecb03,tm.ecb06
               DISPLAY BY NAME tm.ecb03,tm.ecb06
            END IF 
         AFTER FIELD ecb06
            IF NOT cl_null(l_ecb01)  THEN
               CALL p100_get_ecb(cl_replace_str(tm.wc,"sfb05","ecb01")||" AND ecb06='"||tm.ecb06||"'")
                   RETURNING tm.ecb03,tm.ecb06
               DISPLAY BY NAME tm.ecb03,tm.ecb06
            END IF 
         
         ON ACTION controlp 
            LET l_wc = cl_replace_str(tm.wc,"sfb05","ecb01")
            IF NOT cl_null(tm.ecb02) THEN 
               LET l_wc = l_wc," AND ecb02 ='",tm.ecb02,"'"
            END IF
            IF NOT cl_null(l_ecb01)  THEN
               IF INFIELD(ecb02) THEN 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_ecb02"
                  LET g_qryparam.arg1 = l_wc
                  LET g_qryparam.state = "i"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tm.ecb02 = g_qryparam.multiret
                  DISPLAY tm.ecb02 TO ecb02
                  NEXT FIELD ecb02
               END IF
               IF INFIELD(ecb03) THEN 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_ecb03"
                  LET g_qryparam.arg1 = l_wc
                  LET g_qryparam.state = "i"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL p100_get_ecb(l_wc||" AND ecb03='"||g_qryparam.multiret||"'")
                     RETURNING tm.ecb03,tm.ecb06
                  DISPLAY BY NAME tm.ecb03,tm.ecb06
                  NEXT FIELD ecb03
               END IF
               IF INFIELD(ecb06) THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "cq_ecb06"
                  LET g_qryparam.arg1 = l_wc
                  LET g_qryparam.state = "i"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL p100_get_ecb(l_wc||" AND ecb06='"||g_qryparam.multiret||"'")
                     RETURNING tm.ecb03,tm.ecb06
                  DISPLAY BY NAME tm.ecb03,tm.ecb06
                  NEXT FIELD ecb06
               END IF
            END IF         

      END INPUT 
      
      BEFORE DIALOG
         #TODO nothing
         LET l_sql = "SELECT add_months(last_day(sysdate), -1) + 1, last_day(sysdate) FROM dual"
         PREPARE p_date_cur2 FROM l_sql 
         EXECUTE p_date_cur2 INTO  tm.begin,tm.end 
         LET tm.fcnt=1  

      AFTER DIALOG
         #TODO 检查
         #TODO 1.模拟模式
         #TODO 1.1 不可输入工单号，提示查不到资料 
         IF NOT cl_null(DIALOG.getFieldBuffer("sfb01")) THEN
            CALL cl_err("","csf-100",1)
            NEXT FIELD sfb05
         END IF
         #TODO 1.2 数量不可为0
         IF cl_null(tm.fcnt) OR tm.fcnt =0 THEN
            CALL cl_err("","csf-101",1)
            NEXT FIELD sfb05
         END IF   

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      
      ON ACTION accept             
         EXIT DIALOG

      ON ACTION cancel 
         LET INT_FLAG = 1            
         EXIT DIALOG

      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT DIALOG
   
   END DIALOG
    
   IF INT_FLAG THEN
      RETURN
   END IF 
    
END FUNCTION
 
FUNCTION p100_p()
   DEFINE l_sql,l_wc,l_wc2,l_where STRING 
   DEFINE l_idx      LIKE type_file.num5
   DEFINE l_cnt      LIKE type_file.num5 
#TODO 1.根据料号时间，将所有的报废+作业编号抓取出来。
#TODO 1.1 建立中间表
   CALL p100_create_temp()
   LET l_wc = cl_replace_str(tm.wc,"sfb01","tc_shb04")
   LET l_wc = cl_replace_str(l_wc,"sfb05","tc_shb05")
   IF NOT cl_null (tm.ecb02) THEN 
      LET l_wc = l_wc, " AND tc_shb07 = '",tm.ecb02,"'"
   END IF
 
   LET l_wc2 = cl_replace_str(tm.wc,"sfb05","ecb01")
   IF NOT cl_null(tm.ecb06) THEN 
      LET l_wc2 = l_wc2," AND ecb06 = '",tm.ecb06,"' AND ecb02 = '",tm.ecb02,"'"
   ELSE 
   #TODO 为空，应该报错
      IF g_argv1 ='Y' THEN 
         CALL cl_err("","csf-103",1)
         RETURN
      END IF 
   END IF   

   IF g_argv1 = 'Y' THEN 
   #TODO 处理模拟情况的报废金额 
      LET l_sql = "INSERT INTO p100_todoitem ",
                  "select '' sfb01,ecb01,'' tc_shb02,'' tc_shb03,'' tc_shb11,ecb02,ecb03,ecb06,",tm.fcnt,",sysdate bdate,'' ecbud04,ecb17
                  from ecb_file
                  where ",l_wc2 
      LET l_where = " m.sfb05 = n.sfb05 AND m.ecb02 = n.ecb02 AND m.ecb03 = n.ecb03 AND m.fcnt = n.fcnt AND m.bdate = n.bdate "
   ELSE
   #NOTE 处理未模拟的真实报废情况
      LET l_sql = "INSERT INTO p100_todoitem ",
                  " SELECT tc_shb04,tc_shb05,tc_shb02,tc_shb03,tc_shb11,tc_shb07,tc_shb06,tc_shb08,tc_shb121,tc_shb14,'',ecb17 ",
                  " FROM tc_shb_file LEFT JOIN ecb_file ON ecb01 = tc_shb05 AND ecb02 =tc_shb07 AND ecb06 = tc_shb08",
                  " WHERE ",l_wc," AND tc_shb14 between '",tm.begin,"' AND '",tm.end, 
                  "' AND tc_shb121 >0 "
      LET l_where = " m.sfb01 = n.sfb01 AND m.sfb05 = n.sfb05 AND m.tc_shb03 = n.tc_shb03 AND m.tc_shb02 = n.tc_shb02
                     AND m.ecb02 = n.ecb02 AND m.ecb03 = n.ecb03 AND m.fcnt = n.fcnt AND m.bdate = n.bdate "
   END IF
   MESSAGE "正在抓取处理的资料... 第1步/共7步"
   PREPARE p100_todoitem_ins FROM l_sql
   EXECUTE p100_todoitem_ins
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_todoitem_ins:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   LET l_cnt = 0
   SELECT 1 INTO l_cnt FROM p100_todoitem
   
   IF cl_null(l_cnt) OR l_cnt = 0 THEN 
      CALL cl_err("","csf-102",1)
      RETURN
   END IF  
   
#TODO 1.2 更新ecbud04 
   LET l_sql= " merge into P100_TODOITEM m 
                using (select a.sfb01,a.sfb05,a.tc_shb02,a.tc_shb03,a.ecb02,a.ecb03,a.fcnt,a.bdate, 
                              listagg(b.ecbud04,'|') within group(order by a.sfb01,a.sfb05,a.tc_shb02,a.tc_shb03,a.ecb02,a.ecb03,a.fcnt,a.bdate)||'|' ecbud04  
                        from P100_TODOITEM a, ecb_file b 
                       where a.sfb05 = b.ecb01 AND a.ecb02 = b.ecb02 AND a.ecb03 >= b.ecb03 AND b.ecbud04 is not null  
                        group by a.sfb01,a.sfb05,a.tc_shb02,a.tc_shb03,a.ecb02,a.ecb03,a.fcnt,a.bdate)n
                  ON (",l_where,")
                  WHEN MATCHED THEN UPDATE SET m.ecbud04 = n.ecbud04 "
   PREPARE p100_todoitem_upd FROM l_sql
   EXECUTE p100_todoitem_upd
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_todoitem_upd:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   MESSAGE "正在计算报废的料件... 第2步/共7步"

#TODO 2.展开BOM,根据展开的BOM判断哪些时报废工艺之前的。NOTE 先假设料件能汇总           
#TODO 计算第1阶料号
   LET l_sql = "INSERT INTO tc_bom_file ",
               " SELECT '",g_no,"', tc_shb02,tc_shb03,ecb03,ecb02,ecb06,tc_shb11,fcnt,bmb01,bmb01,bmb02,bmb03,1,bmb10,(
               fcnt * (case bmb07 WHEN 0 THEN 0 ELSE  bmb06/bmb07 END ) /*BOM组成用量*/
                  * (1+bmb08/100) + bmb081                              /*损耗率*/
               )cnt,bmbud02,0,bdate,(case bmb07 WHEN 0 THEN 0 ELSE  bmb06/bmb07 END ),0,ecb17",
               " FROM bmb_file,bma_file,p100_todoitem ",
               " WHERE bma01 = bmb01 AND bma06= bmb29 ",
               " AND bmb01 = sfb05 AND bma05 < '",TODAY,"' AND  bmb04 <'",TODAY,"' AND (bmb05 is null OR bmb05 > '",TODAY,"' )",
               # " AND bmb02 <=  ecb03"
               #NOTE 根据 #ecbud04 #bmbud02 判断报废料号
               " AND ecbud04 LIKE '%'||bmbud02||'|%' "
   #TODO 考虑BOM项次小于工艺序号
   PREPARE p100_temp_ins1  FROM l_sql
   EXECUTE p100_temp_ins1

   MESSAGE "正在展开第1阶BOM... 第3步/共7步"

   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_temp_ins1:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   FOR l_idx = 1 TO 99 
      MESSAGE "正在展开第"||l_idx+1||"阶BOM... 第3步/共7步"
      IF NOT p100_bom(l_idx) THEN
         CALL cl_err('p100_temp_ins: ',SQLCA.SQLCODE,1) 
         EXIT FOR 
      END IF
   END FOR  
   LET l_where = " m.tc_shb08=n.tc_shb08 AND m.tc_shb06=n.tc_shb06 AND m.tc_shb121=n.tc_shb121 AND
                  m.bmb01_f=n.bmb01_f AND m.bmb01=n.bmb01 AND m.bmb02=n.bmb02 AND m.bmb03=n.bmb03 AND m.bomkey=n.bomkey AND
                  m.bmb10=n.bmb10 "
   IF cl_null(g_argv1) OR g_argv1 ='N' THEN 
      LET l_where =  l_where," AND m.tc_shb03=n.tc_shb03 AND m.tc_shb02=n.tc_shb02 AND m.bdate = n.bdate "
   END IF  

   LET l_sql = "merge into tc_bom_file m using (
                select unique b.* from  tc_bom_file a,tc_bom_file b  
                where a.bmb01_f = b.bmb01_f AND a.bmb01 = b.bmb03 
                  AND a.bomkey = b.bomkey+1
                  AND a.bom_ver = b.bom_ver AND a.bom_ver = '",g_no,"'
                  AND (a.tc_shb03= b.tc_shb03 OR a.tc_shb03 is null )
                  AND (a.tc_shb02= b.tc_shb02 OR a.tc_shb02 is null ))n
                  ON (",l_where,") WHEN MATCHED THEN UPDATE SET m.fcnt = 0 "
   
   #NOTE 半成品数量更新为0，只保留材料数量
   MESSAGE "正在清空半成品数量... 第4步/共7步"
   PREPARE p100_temp_upd  FROM l_sql
   EXECUTE p100_temp_upd

   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_temp_upd:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   #TODO 更新材料金额 
   #ERROR 假设采购单位和BOM单位一致

   LET l_sql = "merge INTO tc_bom_file a using (select ima01,ima53 FROM ima_file ) b on (bmb03 = ima01 AND bom_ver = '",g_no,"')",
               " WHEN MATCHED THEN UPDATE SET a.famt = NVL(b.ima53,0)*fcnt,a.ima53 =b.ima53 "
   MESSAGE "正在计算材料金额1... 第5步/共7步"
   PREPARE p100_upd_fmt  FROM l_sql
   EXECUTE p100_upd_fmt

   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_upd_fmt:',SQLCA.SQLCODE,1)
      RETURN
   END IF

   #TODO 采购单位和BOM单位不一致情况，单价金额需重新更新
   LET l_sql = "merge into tc_bom_file a using (
                SELECT  tc_bom_file.*,ima44,ima_file.ima53 ima53_1,
                coalesce(
                ( SELECT (smd04 / smd06) FROM smd_file WHERE smd01 = bmb03 AND smd03 = bmb10 AND smd02 = ima44 AND smdacti = 'Y' ),
                ( SELECT (smd06 / smd04) FROM smd_file WHERE smd01 = bmb03 AND smd03 = ima44 AND smd02 = bmb10 AND smdacti = 'Y' ),
                ( SELECT (smc03 / smc04) FROM smc_file WHERE smc02 = bmb10 AND smc01 = ima44 AND smcacti = 'Y' ),
                ( SELECT (smc04 / smc03) FROM smc_file WHERE smc02 = ima44 AND smc01 = bmb10 AND smcacti = 'Y' ) 
                ) ccc FROM tc_bom_file,ima_file where bmb03 = ima01 AND bom_ver='",g_no,"' AND bmb10 <> ima44) b
                ON (a.bom_ver=b.bom_ver AND (a.tc_shb03 = b.tc_shb03 OR a.tc_shb03 is null) AND (a.tc_shb02 = b.tc_shb02 OR a.tc_shb02 is null) AND a.tc_shb08 =b.tc_shb08
                AND a.tc_shb06=b.tc_shb06 AND a.tc_shb121 = b.tc_shb121 AND a.bmb01_f = b.bmb01_f AND a.bmb01 = b.bmb01 
                AND a.bmb03 = b.bmb03 AND a.bomkey = b.bomkey AND a.bmb10 = b.bmb10 AND a.bmbud02 = b.bmbud02 AND a.bdate = b.bdate )
                WHEN MATCHED THEN UPDATE SET a.ima53 = b.ccc*b.ima53_1,a.famt = b.ccc*b.ima53_1*a.fcnt "

   MESSAGE "正在计算材料金额2... 第5步/共7步"
   PREPARE p100_upd_fmt2  FROM l_sql
   EXECUTE p100_upd_fmt2
   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_upd_fmt2:',SQLCA.SQLCODE,1)
      RETURN
   END IF


   #TODO 更新上阶料汇总金额
   #TODO 要从最低阶汇总
   SELECT max(bomkey) INTO l_cnt FROM tc_bom_file WHERE bom_ver=g_no
   IF l_cnt >2 AND NOT cl_null(l_cnt) THEN
      FOR l_idx = l_cnt TO 2 STEP -1
         MESSAGE "正在汇总材料金额,第"||l_idx||"阶... 第6步/共7步"
         IF NOT p100_amt(l_idx) THEN
            CALL cl_err('p100_amt: ',SQLCA.SQLCODE,1) 
            EXIT FOR 
         END IF
      END FOR 
   END IF 

   LET l_cnt = 0
   SELECT 1 INTO l_cnt FROM tc_bom_file  WHERE bom_ver = g_no 
   IF NOT cl_null(l_cnt ) OR l_cnt > 0  THEN 
      MESSAGE "正在打印... 第7步/共7步"
      IF g_argv1 = 'Y' THEN 
         CALL cl_cmdrun_wait("csfr100 '"||g_no||"' 'Y' 'Y' ")
      ELSE 
         CALL cl_cmdrun_wait("csfr100 '"||g_no||"' 'Y' 'N' ")
      END IF 
      
      MESSAGE ""
   END IF
    
 
END FUNCTION
# 遍历BOM
FUNCTION p100_bom(p_key) 
   DEFINE p_key        LIKE type_file.num5 #数量
   DEFINE l_sql         STRING 

   LET l_sql = "INSERT INTO tc_bom_file ",
               " SELECT bom_ver,tc_shb02,tc_shb03,tc_shb06,tc_shb07,tc_shb08,tc_shb11,tc_shb121,bmb01_f,a.bmb01,a.bmb02,a.bmb03,",p_key+1,",a.bmb10,(
               fcnt * (case a.bmb07 WHEN 0 THEN 0 ELSE  a.bmb06/a.bmb07 END ) /*BOM组成用量*/
                  * (1+a.bmb08/100) + a.bmb081                              /*损耗率*/
               )fcnt,a.bmbud02,0,bdate,(case a.bmb07 WHEN 0 THEN 0 ELSE  a.bmb06/a.bmb07 END ),0,ecb17",
               " FROM bmb_file a,bma_file,tc_bom_file b",
               " WHERE bma01 = a.bmb01 AND bma06= a.bmb29 ",
               " AND b.bom_ver = '",g_no,"'",
               " AND a.bmb01 = b.bmb03 AND bma05 < '",TODAY,"' AND  a.bmb04 <'",TODAY,"' AND (a.bmb05 is null OR a.bmb05 > '",TODAY,"' )",
               " AND bomkey = ",p_key 

   PREPARE p100_temp_ins  FROM l_sql
   EXECUTE p100_temp_ins

   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_temp_ins: key is '||p_key||' ',SQLCA.SQLCODE,1)
      RETURN FALSE
   END IF 
   IF SQLCA.sqlerrd[3] =0 THEN 
      RETURN FALSE
   END IF 

   RETURN TRUE

END FUNCTION
FUNCTION p100_amt(p_key)
   DEFINE p_key        LIKE type_file.num5 #数量
   DEFINE l_sql,l_where   STRING 

   LET l_where = " a.bomkey = ",p_key," AND a.tc_shb08 = b.tc_shb08 
                  AND a.tc_shb06 = b.tc_shb06 AND a.tc_shb121 = b.tc_shb121 AND a.bmb01_f = b.bmb01_f AND a.bmb03 = b.bmb01 "
   IF cl_null(g_argv1) OR g_argv1 ='N' THEN
      LET l_where = l_where," AND a.tc_shb121 = b.tc_shb121 " 
   END IF
   LET l_sql = "MERGE INTO tc_bom_file a using (
                  SELECT bom_ver,tc_shb02,tc_shb03,tc_shb08,tc_shb06,tc_shb121,bmb01_f,bmb01,bdate,sum(NVL(famt,0)) famt 
                  FROM tc_bom_file WHERE bomkey = ",p_key," AND bom_ver ='",g_no,"' group by bom_ver,tc_shb02,tc_shb03,tc_shb08,tc_shb06,tc_shb121,bmb01_f,bmb01,bdate
               ) b ON( a.bomkey = ",p_key-1," AND (a.tc_shb03 = b.tc_shb03 OR a.tc_shb03 is null) AND (a.tc_shb02 = b.tc_shb02 OR a.tc_shb02 is null) AND a.tc_shb08 = b.tc_shb08 
                     AND a.tc_shb06 = b.tc_shb06 AND a.tc_shb121 = b.tc_shb121 AND a.bmb01_f = b.bmb01_f AND a.bmb03 = b.bmb01  
                     AND a.bom_ver = b.bom_ver AND a.bdate = b.bdate AND a.bom_ver = '",g_no,"')
               WHEN MATCHED THEN UPDATE SET a.famt = b.famt"
   PREPARE p100_upd_amt  FROM l_sql
   EXECUTE p100_upd_amt

   IF SQLCA.SQLCODE THEN
      CALL cl_err('p100_upd_amt: key is '||p_key||' ',SQLCA.SQLCODE,1)
      RETURN FALSE
   END IF 
   IF SQLCA.sqlerrd[3] =0 THEN 
      RETURN FALSE
   END IF 

   RETURN TRUE
END FUNCTION
FUNCTION p100_drop_temp()
   DEFINE c DATETIME YEAR TO SECOND
   LET c = CURRENT YEAR TO SECOND
   LET g_no = c
   
   DROP TABLE p100_todoitem;
   # DELETE FROM tc_bom_file;

   # DROP TABLE p100_temp
END FUNCTION
FUNCTION p100_create_temp()
   CALL p100_drop_temp()
   CREATE TEMP TABLE p100_todoitem(
      sfb01    VARCHAR(20), #工单单号
      sfb05    VARCHAR(40), #主阶料号
      tc_shb02 VARCHAR(20), #LOT号
      tc_shb03 VARCHAR(20), #报工单号
      tc_shb11 VARCHAR(60),#报废提报人员
      ecb02    VARCHAR(80), #工艺编号 
      ecb03    INTEGER, #工艺序号
      ecb06    VARCHAR(6), #作业编号
      fcnt     DECIMAL(15,3), #报废数量
      bdate    DATE,  #报工日期
      ecbud04  VARCHAR(3000),
      ecb17    VARCHAR(80)    #工艺说明
   )
   #TODO 增加工艺编号 #ecbud04 #bmbud02
   #TODO 需要增加BOM项次
   # CREATE TEMP TABLE p100_temp (
   #    bom_ver  VARCHAR(40),
   #    tc_shb02 VARCHAR(40),#报工单号
   #    tc_shb03 VARCHAR(40),#LOT号
   #    tc_shb06 INTEGER,       #报废工艺序号
   #    tc_shb07 VARCHAR(6),    #工艺编号
   #    tc_shb08 VARCHAR(80),   #作业编号
   #    tc_shb11 VARCHAR(60),#报废提报人员
   #    tc_shb121 DECIMAL(15,3),#报废数量
   #    bmb01_f  VARCHAR(40),#主件
   #    bmb01    VARCHAR(40),#上一阶
   #    bmb02    INTEGER,  #元件项次
   #    bmb03    VARCHAR(40),#元件料件
   #    bomkey   INTEGER,#元件阶层
   #    bmb10    VARCHAR(6),#元件单位  
   #    fcnt     DECIMAL(15,3), #报废数量
   #    bmbud02  VARCHAR(40), #
   #    famt     DECIMAL(20,6), #金额
   #    bdate    DATE,  #报工日期
   #    bmb06    DECIMAL(16,8), #组成用量
   #    ima53    DECIMAL(22,8), #单价
   #    ecb17    VARCHAR(80)    #工艺说明 
   # )

END FUNCTION

FUNCTION p100_get_ecb(p_wc)
   DEFINE p_wc,l_sql    STRING
   DEFINE l_ecb03       LIKE ecb_file.ecb03,
          l_ecb06       LIKE ecb_file.ecb06,
          l_ecb17       LIKE ecb_file.ecb17

   LET l_sql ="select ecb03,ecb06,ecb17 FROM ecb_file WHERE ",p_wc 
   PREPARE p_ecb036 FROM l_sql 
   EXECUTE p_ecb036 INTO l_ecb03,l_ecb06,l_ecb17
   DISPLAY l_ecb17 TO ecb17 

   RETURN l_ecb03,l_ecb06   
END FUNCTION

FUNCTION p100_init()
   IF g_argv1 = '1' THEN 
      CALL cl_chg_comp_att("group02","HIDDEN",TRUE)
   END IF 

END FUNCTION
