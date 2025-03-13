# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp910.4gl
# Descriptions...: 客制成本推算过程-调整
# Date & Author..: 17/07/28 By luoyb




DATABASE ds                         #建立與資料庫的連線
 
GLOBALS "../../../tiptop/config/top.global"              #存放的為TIPTOP GP系統整體全域變數定義

DEFINE g_tc_ccc              RECORD LIKE tc_ccc_file.*
DEFINE g_azb_t               RECORD LIKE azb_file.*      #備份舊值
DEFINE g_azb01_t             LIKE azb_file.azb01         #Key值備份
DEFINE g_wc                  STRING                      #儲存 user 的查詢條件  #No.FUN-580092 HCN        #No.FUN-680102
DEFINE g_sql                 STRING                      #組 sql 用 
DEFINE g_forupd_sql          STRING                      #SELECT ... FOR UPDATE  SQL    
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令 
DEFINE g_chr                 LIKE azb_file.azbacti
DEFINE g_cnt                 LIKE type_file.num10       
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose 
DEFINE g_msg                 STRING
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10        #總筆數     
DEFINE g_jump                LIKE type_file.num10        #查詢指定的筆數 
DEFINE g_no_ask              LIKE type_file.num5         #是否開啟指定筆視窗
DEFINE b_date                DATE
DEFINE e_date                DATE
DEFINE g_all                 SMALLINT
DEFINE g_ima01               LIKE ima_file.ima01
DEFINE tm                    RECORD
       yy                    LIKE type_file.num5,
       mm                    LIKE type_file.num5
       END RECORD
DEFINE e_yy,e_mm             LIKE type_file.num5
DEFINE g_p1                  LIKE type_file.num5
DEFINE g_p2                  STRING
       
MAIN
    OPTIONS
        INPUT NO WRAP                          #輸入的方式: 不打轉
    DEFER INTERRUPT                            #擷取中斷鍵

   IF (NOT cl_user()) THEN                     #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                             #切換成使用者預設的營運中心
   END IF

   WHENEVER ERROR CALL cl_err_msg_log          #遇錯則記錄log檔
 
   IF (NOT cl_setup("CXC")) THEN               #預設模組參數(g_aza.*,...)、權限參數
      EXIT PROGRAM                             #判斷使用者程式執行權限
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #程式進入時間
   INITIALIZE tm.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM tc_ccp_file WHERE ta_ccc02 = ? AND ta_ccc03 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE p910_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p910_w WITH FORM "cxc/42f/cxcp910"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p910_curs()
   
   CLOSE WINDOW p910_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN

FUNCTION p910_curs()
    CLEAR FORM
    INITIALIZE tm.* TO NULL   
    SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
    LET tm.yy = g_ccz.ccz01
    LET tm.mm = g_ccz.ccz02
    INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS         #螢幕上取條件
       BEFORE INPUT                                    #預設查詢條件
           CALL cl_qbe_init()                          #讀回使用者存檔的預設條件 

       AFTER FIELD yy 
         IF tm.yy < 2017 THEN
            CALL cl_err('无法计算2017年之前资料,请重新输入','!',1)
            NEXT FIELD yy
         END IF 
         
        ON ACTION controlp

        AFTER INPUT
          IF cl_null(tm.yy) OR cl_null(tm.mm) THEN
             CALL cl_err('','cxc-008',0)
             CONTINUE INPUT      
          END IF
 
      ON IDLE g_idle_seconds                                #Idle控管（每一交談指令皆要加入）
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about                                       #程式資訊（每一交談指令皆要加入）
         CALL cl_about()  

      ON ACTION generate_link
         CALL cl_generate_shortcut()
 
      ON ACTION HELP                                        #程式說明（每一交談指令皆要加入）
         CALL cl_show_help()  
 
      ON ACTION controlg                                    #開啟其他作業（每一交談指令皆要加入）
         CALL cl_cmdask()  
 
      ON ACTION qbe_select                                  #選擇儲存的查詢條件
         CALL cl_qbe_select()

      ON ACTION qbe_save                                    #儲存畫面上欄位條件
         CALL cl_qbe_save()
         
      ON ACTION EXIT
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION CANCEL
         LET INT_FLAG = 1
         EXIT INPUT
    END INPUT
    
    IF INT_FLAG THEN
       CLOSE WINDOW p910_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p910_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p910_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p910_curs()
       END IF
    END IF
END FUNCTION 

FUNCTION p910_pro()
  DEFINE l_cnt       LIKE type_file.num10
  DEFINE l_flag              LIKE type_file.chr1
  
  IF cl_null(tm.yy) OR cl_null(tm.mm) THEN RETURN END IF
  
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM tc_ccp_file 
   WHERE ta_ccc02 = tm.yy AND ta_ccc03 = tm.mm
  IF l_cnt > 0 THEN
     IF NOT cl_confirm('cxc-009') THEN
        RETURN
     END IF 
  END IF 

  LET g_success = 'Y'
  CALL p910_pre() #期别计算

  BEGIN WORK 

  CALL p910_p()   #成本计算

  IF g_success = 'Y' THEN
     COMMIT WORK
     CALL cl_end2(1) RETURNING l_flag
  ELSE 
     ROLLBACK WORK
     CALL cl_end2(2) RETURNING l_flag
  END IF 
END FUNCTION
#期别资料设置
FUNCTION p910_pre()  
  DEFINE l_c   CHAR(1)
  
  IF tm.mm = '1' THEN 
     LET e_mm = '12'
     LET e_yy = tm.yy - 1
  ELSE
     LET e_yy = tm.yy
     LET e_mm = tm.mm - 1
  END IF
   CALL s_azm(tm.yy,tm.mm)                     #得出期間的起始日與截止日
        RETURNING l_c,b_date,e_date
END FUNCTION

FUNCTION p910_p()
DEFINE ta_cccbzxh1    LIKE type_file.num20_6
DEFINE ta_cccbzxh2    LIKE type_file.num20_6
DEFINE ta_cccbzxh3    LIKE type_file.num20_6
DEFINE ta_cccbzxh4    LIKE type_file.num20_6
DEFINE ta_cccbzxh5    LIKE type_file.num20_6
DEFINE ta_cccbzxh6    LIKE type_file.num20_6

DELETE FROM ta_ccq1_file WHERE ta_ccq02=tm.yy AND ta_ccq03=tm.mm

LET g_sql = " INSERT INTO ta_ccq1_file 
             SELECT DISTINCT ta_ccq01 ,TA_CCQ02 年度,TA_CCQ03 月份,TA_CCQ04 本期产量,TA_CCQ05 发料料号,tdl ta_ccq06,ta_ccq07, 
             TA_CCQ11 实际耗用量,TA_CCQ18 定额耗用量,TA_CCQ12 实际耗用金额,TA_CCQ12 TA_CCQ12a,0,0,0,0,0 摊销材料损耗,ta_ccq19 bzxhj,ta_ccq19 bzxhj,0,0,0,0,0 
             ,0 耗用率,0 单价,0 单价,0,0,0,0,0,0,0,0 FROM 
             ( SELECT DISTINCT ta_ccq01 ,a.ima02 ,a.ima021 ,a.ima39,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04 
             ,TA_CCQ05 ,TA_CCQ05 tdl ,TA_CCQ11,TA_CCQ18,ta_ccq19 ,TA_CCQ12 ,TA_CCQ12f,ta_ccq07  
             FROM ta_ccq_file,ima_file a,ima_file b,gfe_file 
             WHERE ta_ccq01=a.ima01 AND ta_ccq05=b.ima01 AND b.ima25=gfe01 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," 
               AND INSTR(TA_CCQ05,'.')>0 
               AND ta_ccq05 NOT IN (SELECT ta_bmd01 FROM ta_bmd_file WHERE TA_BMD05=",tm.yy," AND TA_BMD06=",tm.mm," )
               AND ta_ccq05 NOT IN (SELECT ta_bmd02 FROM ta_bmd_file WHERE TA_BMD05=",tm.yy," AND TA_BMD06=",tm.mm," AND TA_BMD04>1)
             UNION
 SELECT DISTINCT ta_ccq01 入库料号,a.ima02 品名,a.ima021 规格,a.ima39 分属科目,TA_CCQ02 年度,TA_CCQ03 月份,TA_CCQ04 本期产量
 ,TA_CCQ05 发料料号,CASE WHEN nvl(TA_BMD02,' ')=' ' THEN TA_CCQ05 ELSE TA_BMD02 END 替代料号,TA_CCQ11 实际耗用量
 ,TA_CCQ18 定额耗用量,ta_ccq19,TA_CCQ12 实际耗用金额,TA_CCQ12f 摊销材料损耗,ta_ccq07 替代否
 FROM ta_ccq_file,ima_file a,ima_file b,gfe_file,Ta_Bmd_File
 WHERE ta_ccq01=a.ima01 AND ta_ccq05=b.ima01 AND b.ima25=gfe01 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
 AND ta_ccQ02=ta_bmd05 AND ta_ccQ03=ta_bmd06
 AND INSTR(TA_CCQ05,'.')>0 AND TA_CCQ05=TA_BMD01 AND ta_bmd04=1
 UNION
 SELECT DISTINCT ta_ccq01 入库料号,a.ima02 品名,a.ima021 规格,a.ima39 分属科目,TA_CCQ02 年度,TA_CCQ03 月份,TA_CCQ04 本期产量
 ,TA_CCQ05 发料料号, TA_CCQ05 替代料号,TA_CCQ11 实际耗用量
 ,TA_CCQ18 定额耗用量,ta_ccq19,TA_CCQ12 实际耗用金额,TA_CCQ12f 摊销材料损耗
 ,ta_ccq07 替代否
 FROM ta_ccq_file,ima_file a,ima_file b,gfe_file
 WHERE ta_ccq01=a.ima01 AND ta_ccq05=b.ima01 AND b.ima25=gfe01 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," 
 AND INSTR(TA_CCQ05,'.')>0
 AND ta_ccq05 IN (SELECT ta_bmd01 FROM ta_bmd_file WHERE TA_BMD05=",tm.yy," AND TA_BMD06=",tm.mm," AND ta_bmd04>1)
 UNION
 SELECT DISTINCT ta_ccq01 入库料号,a.ima02 品名,a.ima021 规格,a.ima39 分属科目,TA_CCQ02 年度,TA_CCQ03 月份,TA_CCQ04 本期产量
 ,TA_CCQ05 发料料号,CASE WHEN nvl(TA_BMD01,' ')=' ' THEN TA_CCQ05 ELSE TA_BMD01 END 替代料号,TA_CCQ11 实际耗用量
 ,TA_CCQ18 定额耗用量,ta_ccq19,TA_CCQ12 实际耗用金额,TA_CCQ12f 摊销材料损耗,ta_ccq07 替代否
 FROM ta_ccq_file,ima_file a,ima_file b,gfe_file,Ta_Bmd_File
 WHERE ta_ccq01=a.ima01 AND ta_ccq05=b.ima01 AND b.ima25=gfe01 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," 
 AND ta_ccQ02=ta_bmd05 AND ta_ccQ03=ta_bmd06
 AND INSTR(TA_CCQ05,'.')>0 AND TA_CCQ05=TA_BMD02 AND ta_bmd04>1
 AND TA_BMD02 NOT IN(SELECT TA_CCC01 FROM TA_CCP_FILE WHERE TA_CCC02=",tm.yy," AND TA_CCC03=",tm.mm," AND TA_CCCUD12=0)) a "

  PREPARE p910_p1 FROM g_sql
  EXECUTE p910_p1

--插入本期无异动，有消耗的替代料
LET g_sql = "INSERT INTO ta_ccq1_file
 SELECT DISTINCT ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,TA_CCQ05,ta_ccc01 料号,'Y'
 ,bqsl 本期实际耗用数量,0,bqje 本期实际耗用金额,bqje1 本期实际耗用金额
 ,0,0,0,0,0,0,0,0,0,0,0,0,0 耗用率,0 单价,0 单价,0,0,0,0,0,0,0,0 FROM
 (SELECT MM,ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,TA_CCQ05,ta_ccc01,bqsl,bqje,bqje1 FROM
 ( SELECT ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,ta_ccc01 TA_CCQ05,
 CASE WHEN TA_BMD04=1 THEN ta_ccc01 ELSE TA_CCQ05 END ta_ccc01
 ,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98,0) bqsl
 ,ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23 bqje
 ,ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23 bqje1
 ,row_number()over(partition by TA_CCQ05,ta_ccc01 ORDER BY ta_ccq04 DESC) mm
  FROM ta_ccq_file,ta_ccp_file,ta_bmd_file
  WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
  AND TA_CCCUD12=0 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03
  AND ta_ccc01=ta_bmd02 AND ta_bmd01=ta_ccq05 AND ta_ccc02=ta_bmd05 AND ta_ccc03=ta_bmd06
  AND instr(ta_ccq05,'.')>0) a WHERE MM=1) b "
  
  PREPARE p910_p2 FROM g_sql
  EXECUTE p910_p2
  
--更新利用率，以免被分摊
UPDATE ta_ccp_file SET ta_cccud12=0.0001
 WHERE ta_ccc01 IN (SELECT ta_bmd02 FROM ta_bmd_file,ta_ccp_file a,ta_ccp_file b
                     WHERE ta_bmd01=a.ta_ccc01 AND ta_bmd02=b.ta_ccc01
                       AND a.ta_ccc02=tm.yy AND a.ta_ccc03=tm.mm AND b.ta_ccc02=tm.yy AND b.ta_ccc03=tm.mm
                       AND a.ta_cccud12<>0 AND b.ta_cccud12=0 AND TA_BMD05=tm.yy AND TA_BMD06=tm.mm)

DELETE FROM ta_ccq2_file WHERE ta_ccq02=tm.yy AND ta_ccq03=tm.mm

LET g_sql = "INSERT INTO ta_ccq2_file
 SELECT a.ta_ccq01,",tm.yy,",",tm.mm,",a.ta_ccq04,a.ta_ccq05,a.ta_ccq06,a.ta_ccq07
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq11*a.ta_ccq18/b.ta_ccq18  END nta_ccq11
 ,b.ta_ccq18
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12*a.ta_ccq18/b.ta_ccq18  END nta_ccq12
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12a*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12a
 ,0,0,0,0
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12f*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12f
 ,b.ta_ccq19,b.ta_ccq19,0,0,0,0,0
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq11/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq19/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq19/b.ta_ccq18 END ,0,0,0,0,0,0,0,0 FROM
 (SELECT * FROM ta_ccq1_file WHERE  ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," ) a
 LEFT JOIN
 (SELECT ta_ccq06,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq18) ta_ccq18,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a,SUM(ta_ccq12f) ta_ccq12f,SUM(ta_ccq19) ta_ccq19 FROM ta_ccq1_file
 WHERE ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
 GROUP BY ta_ccq06 ) b ON a.ta_ccq06=b.ta_ccq06 "

  PREPARE p910_p3 FROM g_sql
  EXECUTE p910_p3

  SELECT round(SUM(ta_ccc12+ta_ccc22a1-(ta_ccc31)*ta_ccc23
  -ta_ccc41*-1*ta_ccc23+ta_ccc22a4-ta_ccc61*-1*ta_ccc26a-(ta_ccc43)*ta_cccud07-ta_ccc91*ta_ccc26a),6)
    INTO ta_cccbzxh1
    FROM ta_ccp_file,ima_file 
   WHERE ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')>1 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm
     AND ((ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214+ta_ccc215+ta_ccc216+ta_ccc11)<>0
           OR ta_ccc31<>0 OR ta_ccc41<>0 OR ta_ccc43<>0 OR ta_ccc61<>0 OR ta_ccc91<>0)

  LET g_sql = "SELECT round(sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23  ),6)
    FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(BZXH) BZXH　FROM ex_ccg_result
   WHERE yym= ",tm.yy," AND mmy=",tm.mm," AND INSTR(cch04,'.')>0 AND SUBSTR(cch04,1,2)<>'K.' GROUP BY CCH04 ) HYB,
 (SELECT YJLH,SUM(BZXH*LJYL) BZXH1 FROM ex_ccg_WGD,EX_BOM_CP
 WHERE CCH04=CPLH AND yym=",tm.yy," AND mmy=",tm.mm,"
   AND EX_BOM_CP.yy = ",tm.yy," AND EX_BOM_CP.mm = ",tm.mm,"
 AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM')
 AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM')
 AND INSTR(YJLH,'.')>1 GROUP BY YJLH ) HYC
 WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')>0  AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
 AND ta_ccc01=HYC.YJLH(+) AND round(NVL(BZXH,0)+NVL(BZXH1,0),8)=0 AND ta_cccud12<>'0.0001'
 AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc81<>0 OR ta_ccc98<>0 OR ta_ccc43<>0)"

   # mod by lixwz200309  把排除K的条件，改成排除K.

  PREPARE p910_p4 FROM g_sql
  EXECUTE p910_p4 INTO ta_cccbzxh2

  SELECT SUM(TA_CCQ12) INTO ta_cccbzxh3 FROM ta_ccq2_file,IMA_FILE
   WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
     AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')>0

  UPDATE ta_ccQ2_file SET ta_ccQ12f=ta_ccQ12*((ta_cccbzxh1+ta_cccbzxh2)/ta_cccbzxh3)
   WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm
     AND instr(ta_ccq05,'.')>0
     AND ta_ccq01 IN(SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))

--清空成本表中的本期入库金额
  UPDATE ta_ccp_file SET ta_ccc22a3=0
                        ,ta_ccc22b3=0
                        ,ta_ccc22c3=0
   WHERE ta_ccc22a3<>0 AND ta_ccC02=tm.yy AND ta_ccC03=tm.mm
   
--更新材料耗用到成本表
  UPDATE ta_ccp_file SET ta_ccc22a3=(SELECT SUM(ta_ccq12a+ta_ccq12f) FROM ta_ccq2_file
                                      WHERE ta_ccq01=ta_ccc01 AND ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm)
   WHERE ta_ccc01 IN (SELECT ta_ccq01 FROM ta_ccq2_file WHERE ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm )

--更新工单 工费等
  UPDATE TA_CCP_FILE 
     SET ta_ccc22b3=(SELECT SUM(ta_cck06a) FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm AND ta_ccc01=ta_cck03)
        ,ta_ccc22c3=(SELECT SUM(ta_cck07a+ta_cck08a) FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm AND ta_ccc01=ta_cck03)
   WHERE ta_ccc01 IN (SELECT ta_cck03 FROM ta_cck_file WHERE ta_cck01=tm.yy AND ta_cck02=tm.mm)
     AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

--更新库存杂项异动入库材料金额
  UPDATE TA_CCP_FILE SET ta_ccc22a4=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213=0 THEN 0 ELSE (ta_ccc214*(ta_ccc12a+ta_ccc22a1+ta_ccc22a3)/(ta_ccc11+ta_ccc211+ta_ccc213) ) END)
   WHERE ta_ccc214>0 AND ta_ccc22a4=0
     AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

  UPDATE TA_CCP_FILE 
     SET ta_ccc22a4=(SELECT sum(inb09*inb132)
FROM ina_file,inb_file WHERE ina01=inb01 
AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3' )
   WHERE ta_ccc01 IN(SELECT inb04
  FROM ina_file,inb_file WHERE ina01=inb01 
  AND to_char(ina02,'yyyyMM')= TO_CHAR(to_date(tm.yy||tm.mm,'yyyyMM'),'yyyyMM')
  AND inb05 NOT IN( SELECT jce02 FROM jce_file WHERE jceacti='Y')
  AND inb05 NOT IN( SELECT tc_jcf02 FROM tc_jcf_file WHERE tc_jcfacti='Y')  AND ta_ccc01=inb04
  AND inapost='Y' AND INACONF='Y' AND ina00='3') AND ta_ccc22a4=0
   AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

  LET g_sql = "UPDATE TA_CCP_FILE SET ta_ccc22a4=(ta_ccc214*NVL((SELECT CCC23a from
    (
    select ccc01,ccc02||ccc03,ccc23a,row_number()over(partition by ccc01 order by to_char(to_date(ccc02||ccc03,'yyyyMM'),'yyyyMM') desc) mm from ccc_file
    WHERE to_date(ccc02||ccc03,'yyyyMM')<=to_date(",tm.yy,"||",tm.mm,",'yyyyMM') AND ccc23<>0 
    ) where mm=1  AND ta_ccc01=ccc01),0) )
   WHERE ta_ccc214>0 AND ta_ccc22a4=0
   AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," "
   
   PREPARE p910_p5 FROM g_sql
   EXECUTE p910_p5

   UPDATE ta_ccP_file SET
TA_CCC23A=round((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12a+ta_ccc22a1+ta_ccc22a3+ta_ccc22a4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23B=round((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b3+ta_ccc22b4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23C=round((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C3+ta_ccc22C4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23D=round((CASE WHEN ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22d3+ta_ccc22D4
)/(ta_ccc11+ta_ccc211+ta_ccc213+ta_ccc214) ELSE 0 END),6),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND (ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc214<>0)
AND INSTR(TA_CCC01,'.')=0

UPDATE  ta_ccP_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND INSTR(TA_CCC01,'.')=0

UPDATE ta_ccP_file SET TA_CCC23=(CASE WHEN ta_ccc18<>0  THEN ta_ccc19/ta_ccc18 ELSE 0 END),
TA_CCC23a=(CASE WHEN ta_ccc18<>0 THEN ta_ccc19a/ta_ccc18 ELSE 0 END),
TA_CCC23b=(CASE WHEN ta_ccc18<>0 THEN ta_ccc19b/ta_ccc18 ELSE 0 END),
TA_CCC23c=(CASE WHEN ta_ccc18<>0 THEN ta_ccc19c/ta_ccc18 ELSE 0 END),
TA_CCC23d=(CASE WHEN ta_ccc18<>0 THEN ta_ccc19d/ta_ccc18 ELSE 0 END)
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm  AND INSTR(TA_CCC01,'.')=0 AND ta_ccc23=0

---处理返工造成的成本变动

--该处是否适合单据
--期初与当月转到WIP 的加权平均单价

--期初与当月转到WIP 的加权平均单价
UPDATE ta_ccp_file SET TA_CCCUD07=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0
 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD08=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0
 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD09=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0
 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   ,TA_CCCUD10=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0
 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0

--更新半成品损耗率
LET g_sql = "UPDATE ta_ccp_file SET TA_CCCUD12=
(SELECT CASE WHEN NVL(BZXH,0)=0 THEN 0 ELSE ROUND(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98,0)/NVL(BZXH,0),10) END
 FROM ta_ccp_file b,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
 WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB
 WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
 AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," AND a.ta_ccc01=b.ta_ccc01
 AND substr(ta_ccc01,7,1) IN('A','F','R','G')
AND (ta_ccc217+ta_ccc18+ta_ccc31)<>0  )
WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm," AND substr(ta_ccc01,7,1) IN('A','F','R','G')
AND ta_ccc01  IN (SELECT ta_ccc01
 FROM ta_ccp_file b,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
 WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB
 WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
 AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
 AND substr(ta_ccc01,7,1) IN('A','F','R','G') 
AND (ta_ccc217+ta_ccc18+ta_ccc31)<>0) "
   PREPARE p910_p5_1 FROM g_sql
   EXECUTE p910_p5_1

--插入半成品消耗记录
LET g_sql = "INSERT INTO ta_ccq2_file
SELECT ccg04,",tm.yy,",",tm.mm,",ta_ccc213,cch04,cch04,'N' TDF,SUM(cch31) cch31,SUM(bzxh) bzxh,SUM(cch31j) cch31j,SUM(cch31ja) cch31ja
,SUM(cch31jb) cch31jb,SUM(cch31jc) cch31jc,SUM(cch31jd) cch31jd,0,0
,SUM(bzxhj) bzxhj,SUM(bzxhja) bzxhja,SUM(bzxhjb) bzxhjb,SUM(bzxhjc) bzxhjc,SUM(bzxhjd) bzxhjd,0,0,a.ta_cccud12,a.ta_ccc23,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,0,0,0,0,0 FROM
(SELECT ccg04,cch04,bzxh*ta_cccud12*-1 cch31,
bzxh*ta_cccud12*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) cch31j,
bzxh*ta_cccud12*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07)+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) cch31ja,
bzxh*ta_cccud12*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud08)+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) cch31jb,
bzxh*ta_cccud12*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud09)+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) cch31jc,
bzxh*ta_cccud12*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud10)+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) cch31jd,
bzxh*-1 bzxh,
bzxh*-1*(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) bzxhj,
bzxh*-1*(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) bzxhja,
bzxh*-1*(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+bzxh*ta_ccc23b-ta_ccc27*ta_ccc23b)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) bzxhjb,
bzxh*-1*(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+bzxh*ta_ccc23c-ta_ccc27*ta_ccc23c)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) bzxhjc,
bzxh*-1*(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+bzxh*ta_ccc23d-ta_ccc27*ta_ccc23d)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) bzxhjd,
(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d))/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0))  ta_ccc23,
(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) ta_ccc23a,
(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) ta_ccc23b,
(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) ta_ccc23c,
(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d)/
(nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)) ta_ccc23d
,ta_cccud12
FROM ex_ccg_result,ta_ccp_file a
WHERE yym=",tm.yy," AND mmy=",tm.mm," AND cch04=a.ta_ccc01(+) AND a.ta_ccc02(+)=",tm.yy," AND a.ta_ccc03(+)=",tm.mm,"
  AND SUBSTR(cch04,1,2)<>'K.' AND INSTR(cch04,'.')=0   AND INSTR(cch04,'-')=0
 AND (a.ta_ccc217<>0 OR a.ta_ccc213<>0 OR a.ta_ccc18<>0 OR a.ta_ccc31<>0 OR a.ta_ccc81<>0 OR a.ta_ccc98<>0)
 ) a ,ta_ccp_file b
 WHERE ccg04=b.ta_ccc01 AND b.ta_ccc02(+)=",tm.yy," AND b.ta_ccc03(+)=",tm.mm,"
 GROUP BY ccg04,cch04,a.ta_ccc23,b.ta_ccc213,a.ta_ccc23a,a.ta_ccc23b,a.ta_ccc23c,a.ta_ccc23d,a.ta_cccud12 "
   PREPARE p910_p5_2 FROM g_sql
   EXECUTE p910_p5_2
   # mod by lixwz200309  把排除K的条件，改成排除K.
   
--更新替代料号
UPDATE ta_ccq2_file SET ta_ccq06=(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm
AND ta_bmd01=ta_ccq05)
WHERE instr(ta_ccq05,'.')=0
AND ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm)

--更新被替代料号
UPDATE ta_ccq2_file SET ta_ccq06=(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm
AND ta_bmd02=ta_ccq05)
WHERE instr(ta_ccq05,'.')=0
AND ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm)

--插入替代料号不在工单领用的情况
LET g_sql = "INSERT INTO ta_ccq2_file
 SELECT DISTINCT ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,TA_CCQ05,ta_ccc01 料号,'Y'
 ,bqsl 本期实际耗用数量,0,bqje 本期实际耗用金额,bqcl 本期实际耗用金额
 ,bqrg,bqzf,bqjg,0,0,0,0,0,0,0,0,0,0 耗用率,0 单价,0 单价,0,0,0,0,0,0,0,0 FROM
 (SELECT MM,ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,TA_CCQ05,ta_ccc01,bqsl,bqje,bqcl,bqrg,bqzf,bqjg FROM
 ( SELECT ta_ccq01 ,TA_CCQ02 ,TA_CCQ03 ,TA_CCQ04,CASE WHEN TA_BMD04>1 THEN ta_ccc01 ELSE TA_CCQ05 END TA_CCQ05,
 CASE WHEN TA_BMD04=1 THEN ta_ccc01 ELSE TA_CCQ05 END ta_ccc01
 ,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98,0) bqsl
 ,ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23 bqje
 ,ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a bqcl
 ,ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b bqrg
 ,ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c bqzf
 ,ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d bqjg
 ,row_number()over(partition by TA_CCQ05,ta_ccc01 ORDER BY ta_ccq04 DESC) mm
  FROM ta_ccq2_file,ta_ccp_file,ta_bmd_file
  WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
  AND TA_CCCUD12=0 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND instr(ta_ccq05,'.')=0
  AND ta_ccc01=ta_bmd02 AND ta_bmd01=ta_ccq05 AND ta_ccc02=ta_bmd05 AND ta_ccc03=ta_bmd06
  ) a WHERE MM=1) b "
  PREPARE p910_p6 FROM g_sql
  EXECUTE p910_p6
  
--更新利用率，以免被分摊
  UPDATE ta_ccp_file SET ta_cccud12=0.0001
   WHERE ta_ccc01 IN (SELECT ta_bmd02 FROM  ta_bmd_file,ta_ccp_file a,ta_ccp_file b
                       WHERE ta_bmd01=a.ta_ccc01 AND ta_bmd02=b.ta_ccc01
     AND a.ta_ccc02=tm.yy AND a.ta_ccc03=tm.mm AND b.ta_ccc02=tm.yy AND b.ta_ccc03=tm.mm
     AND a.ta_cccud12<>0 AND b.ta_cccud12=0  AND TA_BMD05=tm.yy AND TA_BMD06=tm.mm)

INSERT INTO ta_ccq1_file
SELECT * FROM ta_ccq2_file
WHERE instr(ta_ccq05,'.')=0 AND (ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm)
OR ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm))

--删除替代资料
DELETE FROM ta_ccq2_file
WHERE instr(ta_ccq05,'.')=0 AND (ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm)
OR ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm))

--将替代料件返回原表，准备计算
INSERT INTO ta_ccq1_file
SELECT * FROM ta_ccq2_file
WHERE (ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm)
OR ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=tm.yy AND ta_bmd06=tm.mm))
AND ta_ccq02=tm.yy AND ta_ccq03=tm.mm AND INSTR(ta_ccq05,'.')=0

--返回差异件
LET g_sql = "INSERT INTO ta_ccq2_file
 SELECT a.ta_ccq01,",tm.yy,",",tm.mm,",a.ta_ccq04,a.ta_ccq05,a.ta_ccq06,a.ta_ccq07
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq11*a.ta_ccq18/b.ta_ccq18  END nta_ccq11
 ,b.ta_ccq18
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12*a.ta_ccq18/b.ta_ccq18  END nta_ccq12
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12a*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12a
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12b*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12b
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12c*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12c
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12d*a.ta_ccq18/b.ta_ccq18 END  nta_ccq12d
 ,0,0
 ,b.ta_ccq19,b.ta_ccq19a,b.ta_ccq19b,b.ta_ccq19c,b.ta_ccq19d,b.ta_ccq19e,b.ta_ccq19f
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq11/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12a/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12b/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12c/b.ta_ccq18 END
 ,CASE WHEN b.ta_ccq18=0 THEN 0 ELSE b.ta_ccq12d/b.ta_ccq18 END
 ,0,0,0,0,0 FROM
 (SELECT * FROM ta_ccq1_file WHERE  ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm," AND (ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=",tm.yy," AND ta_bmd06=",tm.mm,")
 OR ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=",tm.yy," AND ta_bmd06=",tm.mm,") ) AND INSTR(ta_ccq05,'.')=0 ) a
 LEFT JOIN
 (SELECT ta_ccq06,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq18) ta_ccq18,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d
 ,SUM(ta_ccq12e) ta_ccq12e,SUM(ta_ccq12f) ta_ccq12f,SUM(ta_ccq19) ta_ccq19,SUM(ta_ccq19a) ta_ccq19a,SUM(ta_ccq19b) ta_ccq19b,SUM(ta_ccq19c) ta_ccq19c,SUM(ta_ccq19d) ta_ccq19d,SUM(ta_ccq19e) ta_ccq19e,SUM(ta_ccq19f) ta_ccq19f
 FROM ta_ccq1_file WHERE ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
 AND ( ta_ccq05 IN(SELECT ta_bmd01 FROM ta_bmd_file WHERE ta_bmd05=",tm.yy," AND ta_bmd06=",tm.mm,")
 OR ta_ccq05 IN(SELECT ta_bmd02 FROM ta_bmd_file WHERE ta_bmd05=",tm.yy," AND ta_bmd06=",tm.mm,"))
 GROUP BY ta_ccq06 ) b ON a.ta_ccq06=b.ta_ccq06 "

  PREPARE p910_p7 FROM g_sql
  EXECUTE p910_p7
 
--获取未返工的料号
  DELETE FROM ta_ccpa2_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  LET g_sql = "INSERT INTO ta_ccpa2_file
 SELECT DISTINCT ta_ccc01 料号,ima02 品名,ima021 规格,ima39 科目别,ima25 单位,",tm.yy,",",tm.mm,",
 ta_ccc18 上期数量,ta_ccc19 上期合计,ta_ccc19a 上期材料,ta_ccc19b 上期人工,ta_ccc19c+ta_ccc19e 上期制费,ta_ccc19d 上期加工
 ,ta_ccc31+ta_ccc43 领入数量,ta_ccc31*ta_ccc23a+ta_ccc43*ta_cccud07 领入材料
 ,ta_ccc31*ta_ccc23b+ta_ccc43*ta_cccud08 领入人工,ta_ccc31*ta_ccc23c+ta_ccc43*ta_cccud09 领入制费
 ,ta_ccc31*ta_ccc23d+ta_ccc43*ta_cccud10 领用加工,ta_ccc43*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23  领入合计
 ,ta_ccc98 期末数量,ta_ccc98*ta_cccud07 期末材料,ta_ccc98*ta_cccud08 期末人工,ta_ccc98*ta_cccud09 期末费用,ta_ccc98*ta_cccud10 期末加工
 ,ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 期末合计
 ,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) 实际耗用数量
 ,ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a 实际耗用材料
 ,ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b 实际耗用人工
 ,ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c 实际耗用制费
 ,ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d 实际耗用加工,
  ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)
  +ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)  实际耗用金额合计
 ,ta_cccud07 单价材料,ta_cccud08 单价人工,ta_cccud09 单价制费,ta_cccud10 单价加工
 ,(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 单价合计,NVL(BZXH,0) 标准耗用,NVL(BZXH,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 标准金额
 ,CASE WHEN NVL(BZXH,0)=0 THEN 0 ELSE ROUND(nvl(ta_ccc18+ta_ccc217+ta_ccc31+TA_CCC81-ta_ccc98,0)/NVL(BZXH,0),10) END 实际耗用率,
 ta_ccc27 返工入库数量,ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) 返工入库金额,ta_ccc27*(ta_ccc23a) 返工入库材料,ta_ccc27*(ta_ccc23b) 返工入库人工,ta_ccc27*(ta_ccc23c) 返工入库制费,ta_ccc27*(ta_ccc23d) 返工入库加工
 ,ta_ccc217 WIP杂收,ta_ccc217*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) WIP杂收金额,ta_ccc217*(ta_ccc23a) WIP杂收材料,ta_ccc217*(ta_ccc23b) WIP杂收人工,ta_ccc217*(ta_ccc23c) WIP杂收制费,ta_ccc217*(ta_ccc23d) WIP杂收加工
 ,ta_ccc81 WIP杂发,ta_ccc217*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) WIP杂发金额,ta_ccc217*(ta_ccc23a) WIP杂发材料,ta_ccc217*(ta_ccc23b) WIP发收人工,ta_ccc217*(ta_ccc23c) WIP发收制费,ta_ccc81*(ta_ccc23d) WIP杂发加工
  FROM ta_ccp_file,ima_file,GFE_FILE,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
  WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB
  WHERE  ta_ccc01=ima01 AND IMA25=GFE01  AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
  AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
  AND substr(ta_ccc01,7,1) IN('A','F','R','G') AND ta_cccud12=0 AND ima06 IN('G01','G02')
  AND  ta_ccc31=0 AND  ta_ccc43=0 AND ta_ccc213<>0 "

  PREPARE p910_p8 FROM g_sql
  EXECUTE p910_p8

  LET g_sql = "SELECT sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23-ta_ccc27*ta_ccc23)
 ,sum(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a)
 ,sum(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b)
 ,sum(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c)
 ,sum(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d)
 INTO ta_cccbzxh1,ta_cccbzxh3,ta_cccbzxh4,ta_cccbzxh5,ta_cccbzxh6
  FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
  WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB
  WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
  AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
  AND substr(ta_ccc01,7,1) IN('A','F','R','G') AND ima06 NOT IN('G01','G02')
 AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) AND NVL(BZXH,0)=0 "
  PREPARE p910_p9 FROM g_sql
  EXECUTE p910_p9
 
SELECT SUM(TA_CCQ12) INTO ta_cccbzxh2 FROM ta_ccq2_file,IMA_FILE
WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')=0

UPDATE ta_ccQ2_file SET ta_ccQ22=(TA_CCQ12*ta_cccbzxh1/ta_cccbzxh2)
,ta_ccQ22A=(TA_CCQ12*ta_cccbzxh3/ta_cccbzxh2)
,ta_ccQ22B=(TA_CCQ12*ta_cccbzxh4/ta_cccbzxh2)
,ta_ccQ22C=(TA_CCQ12*ta_cccbzxh5/ta_cccbzxh2)
,ta_ccQ22D=(TA_CCQ12*ta_cccbzxh6/ta_cccbzxh2)
WHERE  ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm
AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN(SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))

--插入成品成本表
DELETE FROM TA_CCT2_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm
LET g_sql = "INSERT INTO TA_CCT2_FILE
SELECT DISTINCT a.TA_CCQ01 入库产品,",tm.yy,",",tm.mm,",TA_CCQ04 入库数量 ,TO_CHAR(TA_CCQ05) 半成品,NVL(ta_ccq11,0) 投入数量,NVL(ta_ccq12,0)+nvl(TA_CCQ22,0) 投入金额
,NVL(ta_ccq12a,0)+nvl(TA_CCQ22a,0) 投入材料,NVL(ta_ccq12b,0)+nvl(TA_CCQ22b,0) 投入人工,NVL(ta_ccq12c,0)+nvl(TA_CCQ22c,0) 投入制费,NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 投入加工
,ta_ccc22a3 本阶材料,ta_ccc22b3 本阶人工, ta_ccc22c3 本阶制费,
CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN 0 ELSE ta_ccc22d3-(nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0)) end 本阶加工,ta_ccc22a3+ta_ccc22b3+ta_ccc22c3+ta_ccc22d3 本阶金额
,nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3 材料合计,nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3 人工合计,nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3 制费合计
,CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0)) ELSE ta_ccc22d3 END 加工合计,
nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3+(nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3)+(nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3)
+(nvl(CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ELSE ta_ccc22d3 END,0) ) 金额合计,0,0
 FROM
 ( SELECT DISTINCT TA_CCQ01,TA_CCQ04,sum(TA_CCQ22) TA_CCQ22,sum(TA_CCQ22a) TA_CCQ22a,sum(TA_CCQ22b) TA_CCQ22b,sum(TA_CCQ22c) TA_CCQ22c,sum(TA_CCQ22d) TA_CCQ22d
 ,ta_ccc223,ta_ccc22a3 ta_ccc22a3 ,ta_ccc22b3,ta_ccc22c3 ta_ccc22c3,ta_ccc22d3 FROM ta_ccq2_file a,ta_ccp_file a
  WHERE ta_ccq01=ta_ccc01 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
   GROUP BY TA_CCQ01,TA_CCQ04,ta_ccc223,ta_ccc22a3,ta_ccc22b3,ta_ccc22c3 ,ta_ccc22d3 ) a
 LEFT JOIN
  ( SELECT TA_CCQ01,WM_CONCAT(TA_CCQ05) TA_CCQ05,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a
  ,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d
   FROM ta_ccq2_file a  WHERE INSTR(TA_CCQ05,'.')=0 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
   GROUP BY TA_CCQ01 ) b ON a.ta_ccq01=b.TA_CCQ01 "
  PREPARE p910_p10 FROM g_sql
  EXECUTE p910_p10

 UPDATE ta_ccp_file SET ta_ccc28=ta_ccc223
                       ,ta_ccc28a=ta_ccc22a3
                       ,ta_ccc28b=ta_ccc22b3
                       ,ta_ccc28c=ta_ccc22c3
                       ,ta_ccc28d=ta_ccc22d3
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM TA_CCT2_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm)

 UPDATE ta_ccp_file SET ta_ccc223=(SELECT ta_cct21 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22a3=(SELECT ta_cct17 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22b3=(SELECT ta_cct18 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22c3=(SELECT ta_cct19 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22d3=(SELECT ta_cct20 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM TA_CCT2_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm)

  UPDATE ta_ccP_file SET
TA_CCC23A=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0
THEN ( ta_ccc12a+ta_ccc22a1+ta_ccc22a2+ta_ccc22a3+ta_ccc22a5+ta_ccc22a6 )
  /(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23B=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b2+ta_ccc22b3+ta_ccc22b5+ta_ccc22b6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23C=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C2+ta_ccc22C3+ta_ccc22C5+ta_ccc22C6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23D=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22D2+ta_ccc22D3+ta_ccc22D5+ta_ccc22D6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216)<>0 )
AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0

UPDATE  ta_ccP_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0

UPDATE ta_ccp_file SET TA_CCCUD07=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD08=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD09=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   ,TA_CCCUD10=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   ,
   TA_CCC66=ta_ccc23
   ,TA_CCC66A=ta_ccc23a
   ,TA_CCC66b=ta_ccc23b
   ,TA_CCC66c=ta_ccc23c
   ,TA_CCC66d=ta_ccc23d
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0

 --返工成品损耗摊销
LET g_sql = "SELECT sum(ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23)
,sum(ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)*ta_cccud07+ta_ccc31*ta_ccc23a)
,sum(ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)*ta_cccud08+ta_ccc31*ta_ccc23b)
,sum(ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)*ta_cccud09+ta_ccc31*ta_ccc23c)
,sum(ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0)*ta_cccud10+ta_ccc31*ta_ccc23d)
INTO ta_cccbzxh1,ta_cccbzxh3,ta_cccbzxh4,ta_cccbzxh5,ta_cccbzxh6
 FROM ta_ccp_file,ima_file,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
 WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04 ) HYB
 WHERE  ta_ccc01=ima01 AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
 AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
 AND substr(ta_ccc01,7,1) IN('A','F','R','G') AND ima06 IN('G01','G02')
AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) AND ta_cccud12=0 "
  PREPARE p910_p11 FROM g_sql
  EXECUTE p910_p11

SELECT SUM(TA_CCQ12) INTO ta_cccbzxh2 FROM ta_ccq2_file,IMA_FILE
WHERE TA_CCQ01=IMA01 AND TA_CCQ02=tm.yy AND TA_CCQ03=tm.mm
AND IMA06 IN('G01','G02') AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN(SELECT ta_ccc01 FROM ta_ccpa2_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

UPDATE ta_ccQ2_file SET ta_ccQ22=ta_ccQ22+(TA_CCQ12*ta_cccbzxh1/ta_cccbzxh2)
,ta_ccQ22A=ta_ccQ22A+(TA_CCQ12*ta_cccbzxh3/ta_cccbzxh2)
,ta_ccQ22B=ta_ccQ22B+(TA_CCQ12*ta_cccbzxh4/ta_cccbzxh2)
,ta_ccQ22C=ta_ccQ22C+(TA_CCQ12*ta_cccbzxh5/ta_cccbzxh2)
,ta_ccQ22D=ta_ccQ22D+(TA_CCQ12*ta_cccbzxh6/ta_cccbzxh2)
WHERE  ta_ccQ02=tm.yy AND ta_ccQ03=tm.mm
AND instr(ta_ccq05,'.')=0
AND ta_ccq01 IN (SELECT ima01 FROM ima_file WHERE IMA06 IN('G01','G02'))
AND ta_ccq01 IN (SELECT ta_ccc01 FROM ta_ccpa2_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm)

--重新形成成品成本表
DELETE FROM TA_CCT2_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm
LET g_sql = "INSERT INTO TA_CCT2_FILE
SELECT DISTINCT a.TA_CCQ01 入库产品,",tm.yy,",",tm.mm,",TA_CCQ04 入库数量 ,TO_CHAR(TA_CCQ05) 半成品,NVL(ta_ccq11,0) 投入数量,NVL(ta_ccq12,0)+nvl(TA_CCQ22,0) 投入金额
,NVL(ta_ccq12a,0)+nvl(TA_CCQ22a,0) 投入材料,NVL(ta_ccq12b,0)+nvl(TA_CCQ22b,0) 投入人工,NVL(ta_ccq12c,0)+nvl(TA_CCQ22c,0) 投入制费,NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) 投入加工
,ta_ccc22a3 本阶材料,ta_ccc22b3 本阶人工, ta_ccc22c3 本阶制费
,CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN 0 ELSE ta_ccc22d3-(nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0)) END 本阶加工,ta_ccc22a3+ta_ccc22b3+ta_ccc22c3+ta_ccc22d3 本阶金额
,nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3 材料合计,nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3 人工合计,nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3 制费合计
,CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ELSE ta_ccc22d3 END 加工合计,
nvl(ta_ccq12a,0)+nvl(TA_CCQ22a,0)+ta_ccc22a3+(nvl(ta_ccq12b,0)+nvl(TA_CCQ22b,0)+ta_ccc22b3)+(nvl(ta_ccq12c,0)+nvl(TA_CCQ22c,0)+ta_ccc22c3)
+(nvl(CASE WHEN (nvl(ta_ccq12d,0)+nvl(TA_CCQ22d,0))>ta_ccc22d3 THEN NVL(ta_ccq12d,0)+nvl(TA_CCQ22d,0) ELSE ta_ccc22d3 END,0) ) 金额合计,0,0
 FROM
 ( SELECT DISTINCT TA_CCQ01,TA_CCQ04,sum(TA_CCQ22) TA_CCQ22,sum(TA_CCQ22a) TA_CCQ22a,sum(TA_CCQ22b) TA_CCQ22b,sum(TA_CCQ22c) TA_CCQ22c,sum(TA_CCQ22d) TA_CCQ22d
 ,ta_ccc28 ta_ccc223,ta_ccc28a ta_ccc22a3 ,ta_ccc28b ta_ccc22b3,ta_ccc28c ta_ccc22c3,ta_ccc28d ta_ccc22d3 FROM ta_ccq2_file a,ta_ccp_file a
  WHERE ta_ccq01=ta_ccc01 AND ta_ccq02=ta_ccc02 AND ta_ccq03=ta_ccc03 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
   GROUP BY TA_CCQ01,TA_CCQ04,ta_ccc28,ta_ccc28a,ta_ccc28b,ta_ccc28c ,ta_ccc28d ) a
 LEFT JOIN
  ( SELECT TA_CCQ01,WM_CONCAT(TA_CCQ05) TA_CCQ05,SUM(ta_ccq11) ta_ccq11,SUM(ta_ccq12) ta_ccq12,SUM(ta_ccq12a) ta_ccq12a
  ,SUM(ta_ccq12b) ta_ccq12b,SUM(ta_ccq12c) ta_ccq12c,SUM(ta_ccq12d) ta_ccq12d
   FROM ta_ccq2_file a  WHERE INSTR(TA_CCQ05,'.')=0 AND ta_ccq02=",tm.yy," AND ta_ccq03=",tm.mm,"
   GROUP BY  TA_CCQ01  ) b ON a.ta_ccq01=b.TA_CCQ01"
  PREPARE p910_p12 FROM g_sql
  EXECUTE p910_p12
   
 UPDATE ta_ccp_file SET ta_ccc223=(SELECT ta_cct21 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22a3=(SELECT ta_cct17 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22b3=(SELECT ta_cct18 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22c3=(SELECT ta_cct19 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 ,ta_ccc22d3=(SELECT ta_cct20 FROM TA_CCT2_FILE WHERE ta_ccc01=ta_cct01 AND ta_cct02=tm.yy AND ta_cct03=tm.mm)
 WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
  AND ta_ccc01 IN(SELECT ta_cct01 FROM TA_CCT2_FILE WHERE ta_cct02=tm.yy AND ta_cct03=tm.mm)

 UPDATE ta_ccP_file SET
TA_CCC23A=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0
THEN ( ta_ccc12a+ta_ccc22a1+ta_ccc22a2+ta_ccc22a3+ta_ccc22a5+ta_ccc22a6 )
  /(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23B=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12b+ta_ccc22b1+ta_ccc22b2+ta_ccc22b3+ta_ccc22b5+ta_ccc22b6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23C=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12C+ta_ccc22C1+ta_ccc22C2+ta_ccc22C3+ta_ccc22C5+ta_ccc22C6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23D=(CASE WHEN ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216<>0 THEN (ta_ccc12D+ta_ccc22D1+ta_ccc22D2+ta_ccc22D3+ta_ccc22D5+ta_ccc22D6
)/(ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216) ELSE 0 END ),
TA_CCC23E=0,
TA_CCC23F=0
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
AND ((ta_ccc11+ta_ccc211+ta_ccc212+ta_ccc213+ta_ccc215+ta_ccc216)<>0 )
AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0

UPDATE ta_ccP_file SET TA_CCC23=TA_CCC23A+TA_CCC23B+TA_CCC23C+TA_CCC23D
WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND INSTR(TA_CCC01,'.')=0 AND INSTR(TA_CCC01,'-')=0

UPDATE ta_ccp_file SET TA_CCCUD07=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0
 ELSE (ta_ccc19a+ta_ccc31*ta_ccc23a)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD08=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31,0)=0 THEN 0
 ELSE (ta_ccc19b+ta_ccc31*ta_ccc23b)/nvl(ta_ccc18+ta_ccc31,0) END,8) )
   ,TA_CCCUD09=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0
 ELSE (ta_ccc19c+ta_ccc31*ta_ccc23c+ta_ccc31*ta_ccc23e)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   ,TA_CCCUD10=(round(CASE WHEN nvl(ta_ccc18+ta_ccc31+TA_CCC81,0)=0 THEN 0
 ELSE (ta_ccc19d+ta_ccc31*ta_ccc23d)/nvl(ta_ccc18+ta_ccc31+TA_CCC81,0) END,8) )
   ,TA_CCC66=ta_ccc23
   ,TA_CCC66A=ta_ccc23a
   ,TA_CCC66b=ta_ccc23b
   ,TA_CCC66c=ta_ccc23c
   ,TA_CCC66d=ta_ccc23d
   WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm AND instr(ta_ccc01,'.')=0 AND instr(ta_ccc01,'-')=0

DELETE FROM ta_ccpa2_file WHERE ta_ccc02=tm.yy AND ta_ccc03=tm.mm
LET g_sql = "INSERT INTO ta_ccpa2_file
SELECT DISTINCT ta_ccc01 料号,ima02 品名,ima021 规格,ima39 科目别,ima25 单位,",tm.yy,",",tm.mm,",
ta_ccc18 上期数量,ta_ccc19 上期合计,ta_ccc19a 上期材料,ta_ccc19b 上期人工,ta_ccc19c+ta_ccc19e 上期制费,ta_ccc19d 上期加工
,ta_ccc31+ta_ccc43 领入数量,ta_ccc31*ta_ccc23a+ta_ccc43*ta_cccud07 领入材料
,ta_ccc31*ta_ccc23b+ta_ccc43*ta_cccud08 领入人工,ta_ccc31*ta_ccc23c+ta_ccc43*ta_cccud09 领入制费
,ta_ccc31*ta_ccc23d+ta_ccc43*ta_cccud10 领用加工,ta_ccc43*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)+ta_ccc31*ta_ccc23 领入合计
,ta_ccc98 期末数量,ta_ccc98*ta_cccud07 期末材料,ta_ccc98*ta_cccud08 期末人工,ta_ccc98*ta_cccud09 期末费用,ta_ccc98*ta_cccud10 期末加工
,ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 期末合计
,nvl(ta_ccc18+ta_ccc217+ta_ccc31+ta_ccc43+TA_CCC81-ta_ccc98-ta_ccc27,0) 实际耗用数量
,ta_ccc19a+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud07+ta_ccc31*ta_ccc23a-ta_ccc27*ta_ccc23a 实际耗用材料
,ta_ccc19b+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud08+ta_ccc31*ta_ccc23b-ta_ccc27*ta_ccc23b 实际耗用人工
,ta_ccc19c+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud09+ta_ccc31*ta_ccc23c-ta_ccc27*ta_ccc23c 实际耗用制费
,ta_ccc19d+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*ta_cccud10+ta_ccc31*ta_ccc23d-ta_ccc27*ta_ccc23d 实际耗用加工,
 ta_ccc19+nvl(ta_ccc217+ta_ccc43+TA_CCC81-ta_ccc98,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)
 +ta_ccc31*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)-ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d)  实际耗用金额合计
,ta_cccud07 单价材料,ta_cccud08 单价人工,ta_cccud09 单价制费,ta_cccud10 单价加工
,(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 单价合计,NVL(BZXH,0) 标准耗用,NVL(BZXH,0)*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) 标准金额
,CASE WHEN NVL(BZXH,0)=0 THEN 0 ELSE ROUND(nvl(ta_ccc18+ta_ccc217+ta_ccc31+TA_CCC81-ta_ccc98,0)/NVL(BZXH,0),10) END 实际耗用率,
ta_ccc27 返工入库数量,ta_ccc27*(ta_ccc23a+ta_ccc23b+ta_ccc23c+ta_ccc23d) 返工入库金额,ta_ccc27*(ta_ccc23a) 返工入库材料,ta_ccc27*(ta_ccc23b) 返工入库人工,ta_ccc27*(ta_ccc23c) 返工入库制费,ta_ccc27*(ta_ccc23d) 返工入库加工
,ta_ccc217 WIP杂收,ta_ccc217*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) WIP杂收金额,ta_ccc217*(ta_cccud07) WIP杂收材料,ta_ccc217*(ta_cccud08) WIP杂收人工,ta_ccc217*(ta_cccud09) WIP杂收制费,ta_ccc217*(ta_cccud10) WIP杂收加工
,ta_ccc81 WIP杂发,ta_ccc217*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10) WIP杂发金额,ta_ccc217*(ta_cccud07) WIP杂发材料,ta_ccc217*(ta_cccud08) WIP发收人工,ta_ccc217*(ta_cccud09) WIP发收制费,ta_ccc81*(ta_cccud10) WIP杂发加工
 FROM ta_ccp_file,ima_file,GFE_FILE,(SELECT CCH04,SUM(-CCH31) CCH31,SUM(-BZXH) BZXH　FROM ex_ccg_result
 WHERE yym=",tm.yy," AND mmy=",tm.mm," GROUP BY CCH04) HYB
 WHERE  ta_ccc01=ima01 AND IMA25=GFE01  AND INSTR(ta_ccc01,'.')=0 AND INSTR(ta_ccc01,'-')=0
 AND ta_ccc01=HYB.cch04(+) AND ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
 AND substr(ta_ccc01,7,1) IN('A','F','R','G')
AND (ta_ccc217<>0 OR ta_ccc18<>0 OR ta_ccc31<>0 OR ta_ccc213<>0 OR ta_ccc43<>0 OR ta_ccc81<>0 OR ta_ccc98<>0) "
  PREPARE p910_p13 FROM g_sql
  EXECUTE p910_p13

 UPDATE ta_ccp_file SET ta_ccc92=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26 ELSE ta_ccc91*ta_ccc23 END)
                        ,ta_ccc92a=(CASE WHEN instr(ta_ccc01,'.')>0 THEN ta_ccc91*ta_ccc26a ELSE ta_ccc91*ta_ccc23a END)
                        ,ta_ccc92b=ta_ccc91*ta_ccc23b
                        ,ta_ccc92c=ta_ccc91*ta_ccc23c
                        ,ta_ccc92d=ta_ccc91*ta_ccc23d
                        ,ta_ccc92e=0
                        ,ta_ccc92f=0
                        ,ta_ccc99=ta_ccc98*(ta_cccud07+ta_cccud08+ta_cccud09+ta_cccud10)
                        ,ta_ccc99a=ta_ccc98*ta_cccud07
                        ,ta_ccc99b=ta_ccc98*ta_cccud08
                        ,ta_ccc99c=ta_ccc98*ta_cccud09
                        ,ta_ccc99d=ta_ccc98*ta_cccud10
 WHERE ta_ccc01 IN(SELECT ta_imk01 FROM ta_imk_file WHERE ta_imk05=tm.yy AND ta_imk06=tm.mm)
 AND ta_ccc02=tm.yy AND ta_ccc03=tm.mm

LET g_sql = " UPDATE ta_ccp_file SET ta_cccud06='Y'
 WHERE ta_ccc02=",tm.yy," AND ta_ccc03=",tm.mm,"
 AND  TA_CCC01 IN((SELECT CCH04 FROM EX_CCG_RESULT WHERE TDF LIKE '%Y%' AND YYM=",tm.yy," AND MMY=",tm.mm,")
 UNION ( SELECT YJLH FROM EX_CCG_WGD,EX_BOM_CP WHERE TDF LIKE '%Y%' AND YYM=",tm.yy," AND MMY=",tm.mm," AND EX_BOM_CP.yy = ",tm.yy," AND EX_BOM_CP.mm = ",tm.mm,"
  AND to_char(sxrq1,'yyyyMM')<=TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM') AND INSTR(YJLH,'.')>1
 AND nvl(to_char(sxrq2,'yyyyMM'),TO_CHAR(SYSDATE+1,'yyyyMM')) >TO_CHAR(to_date(",tm.yy,"||",tm.mm,",'yyyyMM'),'yyyyMM')
 AND CCH04=CPLH ))"
 PREPARE p910_p14 FROM g_sql
  EXECUTE p910_p14
END FUNCTION
