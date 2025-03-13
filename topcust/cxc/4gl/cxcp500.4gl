# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: cxcp500.4gl
# Descriptions...: 客制成本推算过程
# Date & Author..: 17/03/20 By donghy


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
       ima01                 LIKE ima_file.ima01,
       tc_ccc01              LIKE tc_ccc_file.tc_ccc01,
       tc_ccc02              LIKE tc_ccc_file.tc_ccc02,
       tc_ccc01_o            LIKE tc_ccc_file.tc_ccc01,
       tc_ccc02_o            LIKE tc_ccc_file.tc_ccc02
       END RECORD
 
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
 
   LET g_forupd_sql = "SELECT * FROM azb_file WHERE azb01 = ? FOR UPDATE "      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE p500_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW p500_w WITH FORM "cxc/42f/cxcp500"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()                                        #轉換介面語言別、匯入ToolBar、Action…等資訊

   LET g_action_choice = ""
   CALL p500_curs() 
   CLOSE WINDOW p500_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
END MAIN
 


FUNCTION p500_curs()
    CLEAR FORM
    INITIALIZE tm.* TO NULL   
    #INPUT BY NAME tm.* ON ima01,tc_ccc01,tc_ccc02  #螢幕上取條件
    INPUT BY NAME tm.ima01,tm.tc_ccc01,tm.tc_ccc02 WITHOUT DEFAULTS   #螢幕上取條件
       BEFORE INPUT                                    #預設查詢條件
           CALL cl_qbe_init()                          #讀回使用者存檔的預設條件 
        ON ACTION controlp
           CASE
              WHEN INFIELD(ima01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_ima"
                 LET g_qryparam.default1 = tm.ima01
                 CALL cl_create_qry() RETURNING tm.ima01
                 DISPLAY BY NAME tm.ima01
                 NEXT FIELD ima01 
              OTHERWISE
                 EXIT CASE
           END CASE     
        AFTER INPUT
          IF cl_null(tm.tc_ccc01) OR cl_null(tm.tc_ccc02) THEN
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
 
      ON ACTION help                                        #程式說明（每一交談指令皆要加入）
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
       CLOSE WINDOW p500_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
    ELSE
       CALL p500_pro()
       IF cl_confirm('cxc-007') THEN
          CLOSE WINDOW p500_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time           #程式結束時間
       ELSE
          CALL p500_curs()
       END IF
    END IF
    
END FUNCTION 


FUNCTION p500_pro()
   IF cl_null(tm.tc_ccc01) THEN RETURN END IF
   IF cl_null(tm.tc_ccc02) THEN RETURN END IF  
   CALL p500_pre() #期别计算
   CALL p500_del() #删除已存在的记录
   CALL p500_tc_tlf_pro()     #从标准系统中抓出需要的异动明细并存入tc_tlf中 
   CALL p500_tc_tlf_imm_pro() #从标准系统中抓取调拨异动明细
   CALL p500_tc_ccc_ins()     #依据抓出的tlf异动记录进行计算
   CALL p500_tc_ccg_sel()     #依据在制结存盘点量推算物料结存状况
   CALL p500_tc_imk_ins()     #期末线边仓库存作为在制量写入在制结存
   #CALL l_ll_zzc()           #中转仓结存物料转成在制--尚未完善
END FUNCTION
#期别资料设置
FUNCTION p500_pre()  
  DEFINE l_c   CHAR(1)
  IF tm.tc_ccc02 = '1' THEN 
     LET tm.tc_ccc02_o = '12'
     LET tm.tc_ccc01_o = tm.tc_ccc01 - 1
  ELSE
     LET tm.tc_ccc01_o = tm.tc_ccc01
     LET tm.tc_ccc02_o = tm.tc_ccc02 - 1
  END IF
   CALL s_azm(tm.tc_ccc01,tm.tc_ccc02)                     #得出期間的起始日與截止日
        RETURNING l_c,b_date,e_date    
END FUNCTION
#历史存在资料清空
FUNCTION p500_del()
   IF NOT cl_null(tm.ima01) THEN 
      DELETE FROM tc_tlf_file WHERE tc_tlf03=tm.ima01 AND tc_tlf01=tm.tc_ccc01 AND tc_tlf02=tm.tc_ccc02
      DELETE FROM tc_ccc_file WHERE tc_ccc04=tm.ima01 AND tc_ccc01=tm.tc_ccc01 AND tc_ccc02=tm.tc_ccc02
   ELSE
      DELETE FROM tc_tlf_file WHERE tc_tlf01=tm.tc_ccc01 AND tc_tlf02=tm.tc_ccc02
      DELETE FROM tc_ccc_file WHERE tc_ccc01=tm.tc_ccc01 AND tc_ccc02=tm.tc_ccc02
   END IF
END FUNCTION

FUNCTION p500_tc_tlf_pro()
  DEFINE l_sql      STRING
  DEFINE l_tlf905   LIKE tlf_file.tlf905
  DEFINE l_imd10    LIKE imd_file.imd10
  DEFINE l_tlf902   LIKE tlf_file.tlf902
  DEFINE l_tlf01    LIKE tlf_file.tlf01
  DEFINE l_bmb031   LIKE bmb_file.bmb03
  DEFINE l_bmb061   LIKE bmb_file.bmb06
  DEFINE l_bmb032   LIKE bmb_file.bmb03
  DEFINE l_sfb02    LIKE sfb_file.sfb02
  DEFINE l_bmb062   LIKE bmb_file.bmb06
  DEFINE l_n        SMALLINT
  DEFINE l_msg      LIKE ima_file.ima01
  DEFINE l_tlf      RECORD
            tc_ccc01    LIKE tc_tlf_file.tc_tlf01,
            tc_ccc02    LIKE tc_tlf_file.tc_tlf02,
            tlf01       LIKE tc_tlf_file.tc_tlf03,
            tlf06       LIKE tc_tlf_file.tc_tlf04,
            tlf905      LIKE tc_tlf_file.tc_tlf05,
            tlf906      LIKE tc_tlf_file.tc_tlf06,
            tlf907      LIKE tc_tlf_file.tc_tlf07,
            tlf10a      LIKE tc_tlf_file.tc_tlf08,
            tlf21a      LIKE tc_tlf_file.tc_tlf09,
            tlf10b      LIKE tc_tlf_file.tc_tlf10,
            tlf21b      LIKE tc_tlf_file.tc_tlf11,
            tlf11       LIKE tc_tlf_file.tc_tlf12,#异动单位
            tlf12       LIKE tc_tlf_file.tc_tlf13,#异动单位转换率            
            tlf13       LIKE tc_tlf_file.tc_tlf14,#异动类型
            tlf62       LIKE tc_tlf_file.tc_tlf15,#工单单号
            tlf14       LIKE tc_tlf_file.tc_tlf16 #理由码          
         END RECORD

         
  LET l_sql ="SELECT '','',tlf01,tlf06,tlf905,tlf906,tlf907,tlf10,tlf21,tlf10,tlf21,tlf11,tlf12,tlf13,tlf62,tlf14,tlf902 FROM tlf_file  ",
             " WHERE tlf06 BETWEEN to_date('",b_date,"','YY/MM/DD') ",
             " AND to_date('",e_date,"','YY/MM/DD') ",
             " AND tlf13 IN ('aimt301','aimt302','aimt303','axmt620','axmt650','aomt800','apmt150',",
             " 'asfi511','asfi512','asfi513','asfi514','asfi526','asfi527','asfi528','asfi529','asft6201',",
             " 'apmt1072','asft6231') AND tlf01 NOT LIKE '%-%' "
  IF NOT cl_null(tm.ima01) THEN 
     LET l_sql = l_sql CLIPPED," AND tlf01 = '",tm.ima01,"'"
  END IF
  LET l_sql = l_sql CLIPPED," ORDER BY tlf01 "
  PREPARE p500_tc_tlf_pre FROM l_sql
  DECLARE p500_tc_tlf_cs CURSOR FOR p500_tc_tlf_pre
  FOREACH p500_tc_tlf_cs INTO l_tlf.*,l_tlf902
    LET l_n = l_n + 1
    LET l_msg = 'a',l_n    
    DISPLAY l_msg

    LET l_tlf.tc_ccc01 = tm.tc_ccc01
    LET l_tlf.tc_ccc02 = tm.tc_ccc02
    LET l_tlf905 = l_tlf.tlf905
    #委外采购入库的不纳入计算
    IF l_tlf905[1,3] ='PRG' AND l_tlf.tlf13 = 'asft6201' THEN 
       CONTINUE FOREACH
    END IF
    #从线边仓发出的物料不纳入计算
    IF l_tlf.tlf13 = 'asfi511' OR l_tlf.tlf13 = 'asfi512' OR l_tlf.tlf13 = 'asfi513' OR l_tlf.tlf13 = 'asfi514' OR
       l_tlf.tlf13 = 'asfi526' OR l_tlf.tlf13 = 'asfi527' OR l_tlf.tlf13 = 'asfi528' OR l_tlf.tlf13 = 'asfi529' THEN 
       SELECT imd10 INTO l_imd10 FROM imd_file WHERE imd01=l_tlf902
       IF l_imd10 !='S' THEN  CONTINUE FOREACH END IF
    END IF
    
    #工单类型抓取
    IF l_tlf.tlf13 = 'asft6201' OR  l_tlf.tlf13 = 'asft6231' THEN
        SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=l_tlf.tlf62
        LET l_tlf.tlf62 = l_sfb02
    ELSE
       LET l_tlf.tlf62 = ''
    END IF
    #入库/出库单价抓取
    LET l_tlf.tlf21a = 0
    LET l_tlf.tlf21b = 0
    IF l_tlf.tlf13 = 'apmt150'  THEN
       SELECT rvv38 INTO l_tlf.tlf21a FROM rvv_file 
          WHERE rvv01 = l_tlf.tlf905 AND rvv02 = l_tlf.tlf906
    END IF
    IF l_tlf.tlf13 = 'axmt620'  THEN
       SELECT ogb13 INTO l_tlf.tlf21b FROM ogb_file 
          WHERE ogb01 = l_tlf.tlf905 AND ogb03 = l_tlf.tlf906
    END IF
    LET l_tlf.tlf10a = l_tlf.tlf10a * l_tlf.tlf907
    LET l_tlf.tlf10b = l_tlf.tlf10b * l_tlf.tlf907
    IF l_tlf.tlf907 = '-1' THEN 
       LET l_tlf.tlf10a = 0 
       LET l_tlf.tlf21a = 0
    ELSE
       LET l_tlf.tlf10b = 0 
       LET l_tlf.tlf21b = 0
    END IF    
    INSERT INTO tc_tlf_file VALUES(l_tlf.*)   
  END FOREACH
  #CALL l_mm2()  
END FUNCTION
#调拨单正常仓-->线边仓算工单发料出
#调拨单线边仓-->正常仓算工单退料入
FUNCTION p500_tc_tlf_imm_pro()
  DEFINE l_imn04    LIKE imn_file.imn04
  DEFINE l_imn15    LIKE imn_file.imn15
  DEFINE l_sql      STRING
  DEFINE l_imd10_r  LIKE imd_file.imd10
  DEFINE l_imd10_c  LIKE imd_file.imd10
  DEFINE l_n        SMALLINT
  DEFINE l_msg      LIKE ima_file.ima01
  DEFINE l_tlf      RECORD
            tc_ccc01    LIKE tc_tlf_file.tc_tlf01,
            tc_ccc02    LIKE tc_tlf_file.tc_tlf02,
            tlf01       LIKE tc_tlf_file.tc_tlf03,
            tlf06       LIKE tc_tlf_file.tc_tlf04,
            tlf905      LIKE tc_tlf_file.tc_tlf05,
            tlf906      LIKE tc_tlf_file.tc_tlf06,
            tlf907      LIKE tc_tlf_file.tc_tlf07,
            tlf10a      LIKE tc_tlf_file.tc_tlf08,
            tlf21a      LIKE tc_tlf_file.tc_tlf09,
            tlf10b      LIKE tc_tlf_file.tc_tlf10,
            tlf21b      LIKE tc_tlf_file.tc_tlf11,
            tlf11       LIKE tc_tlf_file.tc_tlf12,#异动单位
            tlf12       LIKE tc_tlf_file.tc_tlf13,#异动单位转换率            
            tlf13       LIKE tc_tlf_file.tc_tlf14,#异动类型
            tlf62       LIKE tc_tlf_file.tc_tlf15,#工单单号
            tlf14       LIKE tc_tlf_file.tc_tlf16 #理由码  
         END RECORD

   LET l_n = 0
   LET l_sql = " SELECT '','',imn03,imm17,imn01,imn02,'',imn22,0,imn22,0,imn20,'1','','','',imn04,imn15",
               " FROM imn_file,imm_file ",
               " WHERE imm01=imn01 AND imm17 BETWEEN to_date('",b_date,"','YY/MM/DD')",
               " AND to_date('",e_date,"','YY/MM/DD')",
               --" AND (imn03='E.DD.0024R' or imn03='E.DD.0051R' or imn03='AA0028A2BR' or imn03='AA0028F2BR') "
               " AND imn03 NOT LIKE '%-%' "
  IF NOT cl_null(tm.ima01) THEN 
     LET l_sql = l_sql CLIPPED," AND imn03 = '",tm.ima01,"'"
  END IF
  PREPARE p500_tc_tlf_imm_pre FROM l_sql
  DECLARE p500_tc_tlf_imm_cs CURSOR FOR p500_tc_tlf_imm_pre
  FOREACH p500_tc_tlf_imm_cs INTO l_tlf.*,l_imn04,l_imn15
    LET l_n = l_n + 1
    LET l_msg = 'b',l_n    
    DISPLAY l_msg
     SELECT imd10 INTO l_imd10_r FROM imd_file WHERE imd01=l_imn15
     SELECT imd10 INTO l_imd10_c FROM imd_file WHERE imd01=l_imn04
     IF l_imd10_r = l_imd10_c THEN CONTINUE FOREACH END IF
     IF l_imd10_c = 'S' THEN #表示调拨出
        LET l_tlf.tlf10b = l_tlf.tlf10b * -1
        LET l_tlf.tlf907 = '-1'
        LET l_tlf.tlf13  = 'aimt323'
        LET l_tlf.tlf10a = 0
     ELSE
     #表示调拨入
        LET l_tlf.tlf907 = '1'
        LET l_tlf.tlf13  = 'aimt324'
        LET l_tlf.tlf10b = 0
     END IF
     LET l_tlf.tc_ccc01 = tm.tc_ccc01
     LET l_tlf.tc_ccc02 = tm.tc_ccc02
     INSERT INTO tc_tlf_file VALUES(l_tlf.*)
  END FOREACH  
END FUNCTION

#期初期末资料汇总
FUNCTION p500_tc_ccc_ins()
 DEFINE l_n        SMALLINT
 DEFINE l_cnt      SMALLINT
 DEFINE l_fac      LIKE ima_file.ima63_fac
 DEFINE l_msg      LIKE ima_file.ima01
 DEFINE l_sql      STRING
 DEFINE l_arc      CHAR(1)
 DEFINE l_tlf      RECORD
            ccc02   LIKE tc_ccc_file.tc_ccc01,     #年度
            ccc03   LIKE tc_ccc_file.tc_ccc02,     #期别 
            tlf01   LIKE tlf_file.tlf01,           #料号
            tlf06   LIKE tlf_file.tlf06,           #日期
            tlf905  LIKE tlf_file.tlf905,          #单据编号
            tlf906  LIKE tlf_file.tlf906,          #单据项次
            tlf907  LIKE tlf_file.tlf907,          #异动出入库指令
            tlf10a  LIKE tlf_file.tlf10,           #入库量
            tlf21a  LIKE tlf_file.tlf21,           #入库金额
            tlf10b  LIKE tlf_file.tlf10,           #出库量
            tlf21b  LIKE tlf_file.tlf21,           #出库金额
            tlf11   LIKE tlf_file.tlf11,           #异动单位
            tlf12   LIKE tlf_file.tlf12,           #异动单位转换率
            tlf13   LIKE tlf_file.tlf13,           #异动代号指令
            tlf62   LIKE tlf_file.tlf62,           #完工入库单对应类型
            tlf14   LIKE tlf_file.tlf14            #杂收发对应异动理由码
         END RECORD  
         
  LET l_sql = "SELECT distinct tc_tlf03 FROM tc_tlf_file WHERE tc_tlf01=",tm.tc_ccc01," AND tc_tlf02=",tm.tc_ccc02,
              " UNION ",
              "SELECT DISTINCT tc_ccc03 FROM tc_ccc_file WHERE tc_ccc01=",tm.tc_ccc01," AND tc_ccc02=",tm.tc_ccc02
  PREPARE p500_tc_ccc_ins FROM l_sql
  DECLARE p500_tc_ccc_cs CURSOR FOR p500_tc_ccc_ins
  FOREACH p500_tc_ccc_cs INTO g_ima01     
      LET l_n = l_n + 1
      LET l_msg = 'c',l_n
      DISPLAY l_msg
      CALL g_tc_ccc_init()
      LET g_tc_ccc.tc_ccc01 = tm.tc_ccc01
      LET g_tc_ccc.tc_ccc02 = tm.tc_ccc02
      LET l_arc = g_ima01[7,8]
      CASE l_arc
        WHEN "A"
          LET g_tc_ccc.tc_ccc03 = '3'
        WHEN "R"
          LET g_tc_ccc.tc_ccc03 = '2'
        WHEN "F"
          LET g_tc_ccc.tc_ccc03 = '2'
        WHEN "G"
          LET g_tc_ccc.tc_ccc03 = '2'
        OTHERWISE
          LET g_tc_ccc.tc_ccc03 = '1'
      END CASE
      LET g_tc_ccc.tc_ccc04 = g_ima01
      SELECT ima25 INTO g_tc_ccc.tc_ccc05 FROM ima_file WHERE ima01=g_ima01      
      CALL p500_tc_ccc_ins_qc()     
      LET l_sql = "SELECT * FROM tc_tlf_file WHERE tc_tlf01=",tm.tc_ccc01,
          " and tc_tlf03='",g_ima01,"' AND tc_tlf02=",tm.tc_ccc02       
      PREPARE l_mm3_pre FROM l_sql
      DECLARE l_mm3_cs CURSOR FOR l_mm3_pre
      FOREACH l_mm3_cs INTO l_tlf.*
         IF cl_null(l_tlf.tlf12) THEN LET l_tlf.tlf12 = 1 END IF
         IF l_tlf.tlf12 = 0 THEN LET l_tlf.tlf12 = 1 END IF
         #采购入库
         IF l_tlf.tlf13 = 'apmt150' THEN
            LET g_tc_ccc.tc_ccc09a=g_tc_ccc.tc_ccc09a + (l_tlf.tlf10a * l_tlf.tlf12)
            LET g_tc_ccc.tc_ccc11a=g_tc_ccc.tc_ccc11a + (l_tlf.tlf10a * l_tlf.tlf21a)
            LET g_tc_ccc.tc_ccc10a=g_tc_ccc.tc_ccc11a / g_tc_ccc.tc_ccc09a 
         END IF
         #采购仓退
         IF l_tlf.tlf13 = 'apmt1072' THEN
            LET g_tc_ccc.tc_ccc09b=g_tc_ccc.tc_ccc09b + (l_tlf.tlf10b * l_tlf.tlf12)
            LET g_tc_ccc.tc_ccc11a=g_tc_ccc.tc_ccc11a - (l_tlf.tlf10b * l_tlf.tlf21b)
            LET g_tc_ccc.tc_ccc10a=g_tc_ccc.tc_ccc11a /(g_tc_ccc.tc_ccc09a + g_tc_ccc.tc_ccc09b)
            IF cl_null(g_tc_ccc.tc_ccc10a) THEN LET g_tc_ccc.tc_ccc10a = 0 END IF
         END IF
         #工单入库/run-card单入库
         IF l_tlf.tlf13 = 'asft6231' OR l_tlf.tlf13 = 'asft6201' THEN           
            IF l_tlf.tlf62 = '5' THEN  #返工入库
               LET g_tc_ccc.tc_ccc09d = g_tc_ccc.tc_ccc09d + (l_tlf.tlf10a * l_tlf.tlf12)
            ELSE  #正常入库
               LET g_tc_ccc.tc_ccc09c = g_tc_ccc.tc_ccc09c + (l_tlf.tlf10a * l_tlf.tlf12)
            END IF
         END IF
         #产线调拨退料入库
         IF l_tlf.tlf13 = 'aimt324' THEN
            LET g_tc_ccc.tc_ccc09e=g_tc_ccc.tc_ccc09e + (l_tlf.tlf10a * l_tlf.tlf12) 
         END IF
         #产线一般退料入库
         IF l_tlf.tlf13 = 'asfi528' THEN
            LET g_tc_ccc.tc_ccc09e=g_tc_ccc.tc_ccc09e + (l_tlf.tlf10a * l_tlf.tlf12)           
         END IF
         #产线成套退料入库
         IF l_tlf.tlf13 = 'asfi526' THEN
            LET g_tc_ccc.tc_ccc09e=g_tc_ccc.tc_ccc09e + (l_tlf.tlf10a * l_tlf.tlf12)            
         END IF
         
         #生产调拨发料出库
         IF l_tlf.tlf13 = 'aimt323' THEN
            LET g_tc_ccc.tc_ccc12a=g_tc_ccc.tc_ccc12a + (l_tlf.tlf10b * l_tlf.tlf12)            
         END IF
         #出货单出货
         IF l_tlf.tlf13 = 'axmt620' THEN
            LET g_tc_ccc.tc_ccc12b=g_tc_ccc.tc_ccc12b + (l_tlf.tlf10b * l_tlf.tlf12)           
         END IF
         #销售销退入库
         IF l_tlf.tlf13 = 'aomt800' THEN
            LET g_tc_ccc.tc_ccc12b=g_tc_ccc.tc_ccc12b - (l_tlf.tlf10a * l_tlf.tlf12)          
         END IF
         
         #杂收入库
         IF l_tlf.tlf13 = 'aimt302' THEN
            LET g_tc_ccc.tc_ccc15a=g_tc_ccc.tc_ccc15a + (l_tlf.tlf10a * l_tlf.tlf12)            
         END IF
         #杂发出库
         IF l_tlf.tlf13 = 'aimt301' OR l_tlf.tlf13 = 'aimt303' THEN
            LET g_tc_ccc.tc_ccc15b=g_tc_ccc.tc_ccc15b + (l_tlf.tlf10b * l_tlf.tlf12)            
         END IF           
     END FOREACH
     IF cl_null(g_tc_ccc.tc_ccc09a) THEN LET g_tc_ccc.tc_ccc09a = 0 END IF
     IF cl_null(g_tc_ccc.tc_ccc09b) THEN LET g_tc_ccc.tc_ccc09b = 0 END IF
     IF cl_null(g_tc_ccc.tc_ccc09c) THEN LET g_tc_ccc.tc_ccc09c = 0 END IF
     IF cl_null(g_tc_ccc.tc_ccc09d) THEN LET g_tc_ccc.tc_ccc09d = 0 END IF
     IF cl_null(g_tc_ccc.tc_ccc09e) THEN LET g_tc_ccc.tc_ccc09e = 0 END IF
     LET g_tc_ccc.tc_ccc09 = g_tc_ccc.tc_ccc09a + g_tc_ccc.tc_ccc09b + g_tc_ccc.tc_ccc09c + g_tc_ccc.tc_ccc09d + g_tc_ccc.tc_ccc09e
     IF cl_null(g_tc_ccc.tc_ccc12a) THEN LET g_tc_ccc.tc_ccc12a = 0 END IF
     IF cl_null(g_tc_ccc.tc_ccc12b) THEN LET g_tc_ccc.tc_ccc12b = 0 END IF
     LET g_tc_ccc.tc_ccc12 = g_tc_ccc.tc_ccc12a + g_tc_ccc.tc_ccc12b
     #本期期末数量=本期期初数量+本期入库数量+本期出库数量(负数)+本期杂收发量
     LET g_tc_ccc.tc_ccc17 = g_tc_ccc.tc_ccc06 + g_tc_ccc.tc_ccc09 + g_tc_ccc.tc_ccc12 + g_tc_ccc.tc_ccc15    
     INSERT INTO tc_ccc_file VALUES (g_tc_ccc.*)
     
  END FOREACH
  
END FUNCTION
#抓取期初
FUNCTION p500_tc_ccc_ins_qc()  
      SELECT COUNT(*) INTO g_cnt FROM tc_omc_file WHERE tc_omc01=tm.tc_ccc01 AND tc_omc02=tm.tc_ccc02
         AND tc_omc03=g_ima01
      IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
      IF g_cnt > 0 THEN
         SELECT tc_omc06,tc_omc07,tc_omc08,tc_omc09,tc_omc10,tc_omc11 
            INTO g_tc_ccc.tc_ccc06,g_tc_ccc.tc_ccc07a,g_tc_ccc.tc_ccc07b,g_tc_ccc.tc_ccc07c,g_tc_ccc.tc_ccc07d,
                 g_tc_ccc.tc_ccc07 
            FROM tc_omc_file WHERE tc_omc01=tm.tc_ccc01 AND tc_omc02=tm.tc_ccc02
                 AND tc_omc03=g_ima01
         #依据单价推算金额
         LET g_tc_ccc.tc_ccc08a = g_tc_ccc.tc_ccc06 * g_tc_ccc.tc_ccc07a
         LET g_tc_ccc.tc_ccc08b = g_tc_ccc.tc_ccc06 * g_tc_ccc.tc_ccc07b
         LET g_tc_ccc.tc_ccc08c = g_tc_ccc.tc_ccc06 * g_tc_ccc.tc_ccc07c
         LET g_tc_ccc.tc_ccc08d = g_tc_ccc.tc_ccc06 * g_tc_ccc.tc_ccc07d
         LET g_tc_ccc.tc_ccc08 = g_tc_ccc.tc_ccc08a + g_tc_ccc.tc_ccc08b +g_tc_ccc.tc_ccc08c + g_tc_ccc.tc_ccc08d         
      ELSE
         SELECT tc_ccc17,tc_ccc18a,tc_ccc18b,tc_ccc18c,tc_ccc18d,tc_ccc18
            INTO g_tc_ccc.tc_ccc06,g_tc_ccc.tc_ccc08a,g_tc_ccc.tc_ccc08b,g_tc_ccc.tc_ccc08c,g_tc_ccc.tc_ccc08d,
                 g_tc_ccc.tc_ccc08
            FROM tc_ccc_file WHERE tc_ccc01=tm.tc_ccc01_o  AND tc_ccc02=tm.tc_ccc02_o 
                 AND tc_ccc04=g_ima01

         #依据金额推算单价
         LET g_tc_ccc.tc_ccc07a = g_tc_ccc.tc_ccc08a/g_tc_ccc.tc_ccc06
         LET g_tc_ccc.tc_ccc07b = g_tc_ccc.tc_ccc08b/g_tc_ccc.tc_ccc06
         LET g_tc_ccc.tc_ccc07c = g_tc_ccc.tc_ccc08c/g_tc_ccc.tc_ccc06
         LET g_tc_ccc.tc_ccc07d = g_tc_ccc.tc_ccc08d/g_tc_ccc.tc_ccc06
         LET g_tc_ccc.tc_ccc07 = g_tc_ccc.tc_ccc07a + g_tc_ccc.tc_ccc07b + g_tc_ccc.tc_ccc07c + g_tc_ccc.tc_ccc07d
      END IF
       
      IF cl_null(g_tc_ccc.tc_ccc06) OR g_tc_ccc.tc_ccc06 = 0 THEN
         LET g_tc_ccc.tc_ccc06 = 0
         LET g_tc_ccc.tc_ccc07 = 0
         LET g_tc_ccc.tc_ccc07a = 0
         LET g_tc_ccc.tc_ccc07b = 0
         LET g_tc_ccc.tc_ccc07c = 0
         LET g_tc_ccc.tc_ccc07d = 0
         LET g_tc_ccc.tc_ccc08 = 0
         LET g_tc_ccc.tc_ccc08a = 0
         LET g_tc_ccc.tc_ccc08b = 0
         LET g_tc_ccc.tc_ccc08c = 0
         LET g_tc_ccc.tc_ccc08d = 0
      END IF
END FUNCTION

#资料初始化
FUNCTION g_tc_ccc_init()
 INITIALIZE g_tc_ccc.* TO NULL
 LET g_tc_ccc.tc_ccc06  = 0
 LET g_tc_ccc.tc_ccc07  = 0
 LET g_tc_ccc.tc_ccc07a = 0 
 LET g_tc_ccc.tc_ccc07b = 0 
 LET g_tc_ccc.tc_ccc07c = 0 
 LET g_tc_ccc.tc_ccc07d = 0
 LET g_tc_ccc.tc_ccc08  = 0
 LET g_tc_ccc.tc_ccc08a = 0 
 LET g_tc_ccc.tc_ccc08b = 0 
 LET g_tc_ccc.tc_ccc08c = 0 
 LET g_tc_ccc.tc_ccc08d = 0
 LET g_tc_ccc.tc_ccc09  = 0
 LET g_tc_ccc.tc_ccc09a = 0 
 LET g_tc_ccc.tc_ccc09b = 0 
 LET g_tc_ccc.tc_ccc09c = 0 
 LET g_tc_ccc.tc_ccc09d = 0
 LET g_tc_ccc.tc_ccc09e = 0
 LET g_tc_ccc.tc_ccc10  = 0
 LET g_tc_ccc.tc_ccc10a = 0 
 LET g_tc_ccc.tc_ccc10b = 0 
 LET g_tc_ccc.tc_ccc10c = 0 
 LET g_tc_ccc.tc_ccc10d = 0
 LET g_tc_ccc.tc_ccc11  = 0
 LET g_tc_ccc.tc_ccc11a = 0 
 LET g_tc_ccc.tc_ccc11b = 0 
 LET g_tc_ccc.tc_ccc11c = 0 
 LET g_tc_ccc.tc_ccc11d = 0
 LET g_tc_ccc.tc_ccc12  = 0
 LET g_tc_ccc.tc_ccc12a = 0 
 LET g_tc_ccc.tc_ccc12b = 0
 LET g_tc_ccc.tc_ccc13  = 0
 LET g_tc_ccc.tc_ccc13a = 0 
 LET g_tc_ccc.tc_ccc13b = 0 
 LET g_tc_ccc.tc_ccc13c = 0 
 LET g_tc_ccc.tc_ccc13d = 0
 LET g_tc_ccc.tc_ccc14  = 0
 LET g_tc_ccc.tc_ccc14a = 0 
 LET g_tc_ccc.tc_ccc14b = 0 
 LET g_tc_ccc.tc_ccc14c = 0 
 LET g_tc_ccc.tc_ccc14d = 0
 LET g_tc_ccc.tc_ccc15  = 0
 LET g_tc_ccc.tc_ccc15a = 0 
 LET g_tc_ccc.tc_ccc15b = 0
 LET g_tc_ccc.tc_ccc16  = 0
 LET g_tc_ccc.tc_ccc17  = 0
 LET g_tc_ccc.tc_ccc18  = 0
 LET g_tc_ccc.tc_ccc18a = 0 
 LET g_tc_ccc.tc_ccc18b = 0 
 LET g_tc_ccc.tc_ccc18c = 0 
 LET g_tc_ccc.tc_ccc18d = 0
 LET g_tc_ccc.tc_ccc19  = 0
 LET g_tc_ccc.tc_ccc19a = 0 
 LET g_tc_ccc.tc_ccc19b = 0 
 LET g_tc_ccc.tc_ccc19c = 0 
 LET g_tc_ccc.tc_ccc19d = 0
END FUNCTION

#在制基本数据抓取
FUNCTION p500_tc_ccg_sel()
   DEFINE l_sql      STRING
   DEFINE l_cnt      SMALLINT
   DEFINE l_ecu02    LIKE ecu_file.ecu02
   DEFINE l_ecb03    LIKE ecb_file.ecb03
   DEFINE l_ecb06    LIKE ecb_file.ecb06
   DEFINE l_mm       SMALLINT
   
   DEFINE sr  RECORD
      ecb01        LIKE ecb_file.ecb01,
      ecb06        LIKE ecb_file.ecb06,
      num          LIKE bmb_file.bmb06
   END RECORD

   LET l_mm = 1
   LET l_sql = "SELECT tc_ccg03,tc_ccg04,tc_ccg05 FROM tc_ccg_file where tc_ccg01=",tm.tc_ccc01," and tc_ccg02=",tm.tc_ccc02
        
   PREPARE l_ll_pre FROM l_sql
   DECLARE l_ll_cs CURSOR FOR l_ll_pre
   FOREACH l_ll_cs INTO sr.*
      DISPLAY l_mm
      LET l_mm =l_mm + 1
      SELECT COUNT(*) INTO l_cnt FROM ecu_file,ecb_file WHERE ecu01=ecb01 AND ecu02=ecb02 
        AND ecb01=sr.ecb01 AND ecb06=sr.ecb06
      IF l_cnt = 0 THEN 
         CONTINUE FOREACH
      END IF
      IF l_cnt = 1 THEN
         SELECT ecu02,ecb03 INTO l_ecu02,l_ecb03 FROM ecb_file,ecu_file WHERE ecu01=ecb01 AND ecu02=ecb02
            AND ecb01=sr.ecb01 AND ecb06=sr.ecb06
      END IF
      IF l_cnt > 1 THEN
         LET l_sql = "SELECT ecu02 FROM ecu_file,ecb_file WHERE ecu01=ecb01 AND ecu02=ecb02 ",
             " AND ecu01='",sr.ecb01,"' AND ecb06='",sr.ecb06,"' ORDER BY ecu02 DESC"
         PREPARE l_ll1_pre FROM l_sql
         DECLARE l_ll1_cs CURSOR FOR l_ll1_pre
         FOREACH l_ll1_cs INTO l_ecu02
            SELECT ecu02,ecb03 INTO l_ecu02,l_ecb03 FROM ecb_file,ecu_file WHERE ecb01=ecu01 
              AND ecb01=sr.ecb01 AND ecb06=sr.ecb06 AND ecu02=l_ecu02
            EXIT FOREACH
         END FOREACH
      END IF
      LET l_sql = "SELECT ecb06 FROM ecb_file,ecu_file WHERE ecu01=ecb01 AND ecu02=ecb02 ",
      " AND ecb01='",sr.ecb01,"' and ecu02='",l_ecu02,"' and ecb03 <=",l_ecb03," order by ecb03"      
      PREPARE l_ll2_pre FROM l_sql
      DECLARE l_ll2_cs CURSOR FOR l_ll2_pre
      FOREACH l_ll2_cs INTO l_ecb06
         CALL p500_tc_cch_ins(sr.ecb01,sr.ecb01,l_ecb06,sr.num)
      END FOREACH
   END FOREACH
END FUNCTION

#在制推算结果写入
FUNCTION p500_tc_cch_ins(l_bma01,l_bmb01,l_bmb09,l_num)
   DEFINE l_bma01       LIKE bma_file.bma01
   DEFINE l_bmb01       LIKE bmb_file.bmb01
   DEFINE l_bmb09       LIKE bmb_file.bmb09
   DEFINE l_num         LIKE bmb_file.bmb06
   DEFINE l_num2        LIKE bmb_file.bmb06
   DEFINE l_n           SMALLINT
   DEFINE li            SMALLINT
   DEFINE l_bmb03       STRING
   DEFINE l_sql         STRING
   DEFINE l_cnt         SMALLINT   
   
   DEFINE l_tc_cch  RECORD   LIKE tc_cch_file.*
   DEFINE sm  DYNAMIC ARRAY OF RECORD
             bmb03         LIKE bmb_file.bmb03,
             bmb06         LIKE bmb_file.bmb06
          END RECORD 

   LET l_n = 1
   LET li = 1
   IF NOT cl_null(l_bmb09) THEN 
      SELECT COUNT(*) INTO l_cnt FROM bmb_file WHERE bmb01=l_bmb01 AND bmb09=l_bmb09 
         AND bmb04<=g_today AND (bmb05 IS NULL OR bmb05 >=g_today)
      IF l_cnt = 0 THEN RETURN END IF      
   END IF

   IF NOT cl_null(l_bmb09) THEN
      LET l_sql = "SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_bmb01,"' AND bmb09='",l_bmb09,"'",
                  " AND bmb04<=to_date('",g_today,"','yyyy/mm/dd') and (bmb05 is null or bmb05 >=to_date('",g_today,"','yyyy/mm/dd') )"       
   ELSE
      LET l_sql = "SELECT bmb03,bmb06/bmb07 FROM bmb_file WHERE bmb01='",l_bmb01,"' AND bmb04<=to_date('",g_today,"','yyyy/mm/dd') ",
                  " and (bmb05 is null or bmb05 >=to_date('",g_today,"','yyyy/mm/dd') )"       
   END IF
   PREPARE l_ll3_pre FROM l_sql
   DECLARE l_ll3_cs CURSOR FOR l_ll3_pre
   FOREACH l_ll3_cs INTO sm[l_n].bmb03,sm[l_n].bmb06
     LET l_n = l_n + 1
   END FOREACH
   LET l_n = l_n - 1
   FOR li = 1 TO l_n
      LET l_bmb03 = sm[li].bmb03
      IF l_bmb03.getIndexOf('-',1) THEN
         LET l_num2 = l_num * sm[li].bmb06
         CALL p500_tc_cch_ins(l_bma01,sm[li].bmb03,'',l_num2)
      ELSE
        #LET l_rec.bmb01 = l_bma01
        #LET l_rec.bmb03 = sm[li].bmb03
        #LET l_rec.bmb06 = l_num * sm[li].bmb06
        LET l_tc_cch.tc_cch01 = tm.tc_ccc01
        LET l_tc_cch.tc_cch02 = tm.tc_ccc02
        LET l_tc_cch.tc_cch03 = l_bma01
        IF NOT cl_null(l_bmb09) THEN
           LET l_tc_cch.tc_cch04 = l_bmb09
        ELSE
           LET l_tc_cch.tc_cch04 = l_bmb01
        END IF
        LET l_tc_cch.tc_cch05 = sm[li].bmb03
        LET l_tc_cch.tc_cch06 = l_num * sm[li].bmb06
        SELECT ima25,ima63,ima63_fac INTO l_tc_cch.tc_cch07,l_tc_cch.tc_cch08,l_tc_cch.tc_cch09
           FROM ima_file WHERE ima01=l_tc_cch.tc_cch05
        IF cl_null(l_tc_cch.tc_cch09) THEN LET l_tc_cch.tc_cch09 = 1 END IF        
        INSERT INTO tc_cch_file VALUES(l_tc_cch.*)
      END IF
   END FOR
   
END FUNCTION

#线边仓库存转换成在制资料写入tc_cch_file
FUNCTION p500_tc_imk_ins()
  DEFINE l_sql    STRING
  DEFINE l_n      SMALLINT
  DEFINE l_tc_cch  RECORD   LIKE tc_cch_file.*      

   LET l_n = 0
   LET l_sql = "SELECT IMK01,SUM(imk09) FROM imk_file WHERE imk05=",tm.tc_ccc01," AND imk06=",tm.tc_ccc02,
               "  AND imk02 NOT  IN (SELECT jce02 FROM jce_file) ",
               " AND imk02 IN (SELECT imd01 FROM imd_file WHERE imd10='W') ",
               " AND imk01 NOT LIKE '%-%' ",
               " GROUP BY imk01 HAVING SUM(imk09) > 0 "  
   PREPARE l_llimk_pre FROM l_sql
   DECLARE l_llimk_cs CURSOR FOR l_llimk_pre
   FOREACH l_llimk_cs INTO l_tc_cch.tc_cch05,l_tc_cch.tc_cch06
      LET l_n = l_n + 1
      DISPLAY l_n      
      LET l_tc_cch.tc_cch01 = tm.tc_ccc01
      LET l_tc_cch.tc_cch02 = tm.tc_ccc02
      LET l_tc_cch.tc_cch03 = 'imk-01'
      LET l_tc_cch.tc_cch04 = 'imk-01'     
      SELECT ima25,ima63,ima63_fac INTO l_tc_cch.tc_cch07,l_tc_cch.tc_cch08,l_tc_cch.tc_cch09
         FROM ima_file WHERE ima01=l_tc_cch.tc_cch05
      IF cl_null(l_tc_cch.tc_cch09) THEN LET l_tc_cch.tc_cch09 = 1 END IF        
      INSERT INTO tc_cch_file VALUES(l_tc_cch.*)
   END FOREACH
END FUNCTION

#中转仓库资料转换成原材料在制资料写入tc_cch_file
#tc_data01:半成品料号 带-
#tc_data08:半成品中转仓剩余数量
FUNCTION l_ll_zzc()
  DEFINE l_n        SMALLINT
  DEFINE li         SMALLINT
  DEFINE l_bmb03    STRING
  DEFINE l_sql      STRING
  DEFINE l_bma01 LIKE bma_file.bma01

  DEFINE sm  DYNAMIC ARRAY OF RECORD           
             bmb03         LIKE bmb_file.bmb03,
             bmb06         LIKE bmb_file.bmb06
  END RECORD 
          
   LET l_n = 1
   #LET l_sql = "SELECT tc_data01,tc_data08 FROM tc_data_file" 
   LET l_sql = "SELECT bmb03,bmb06 FROM rec_dhy where rec02='12' and  bmb03 LIKE '%-%' "     
   PREPARE l_llzzc_pre FROM l_sql
   DECLARE l_llzzc_cs CURSOR FOR l_llzzc_pre
   FOREACH l_llzzc_cs INTO sm[l_n].bmb03,sm[l_n].bmb06
      LET l_n = l_n + 1
   END FOREACH
   LET l_n = l_n - 1
   FOR li = 1 TO l_n
      DISPLAY li
      LET l_bmb03 = sm[li].bmb03
      IF l_bmb03.getIndexOf('-',1) THEN
         #LET l_bma01 =sm[li].bmb03 CLIPPED,'-zzc12' 
         LET l_bma01 = 'imk-12'
         CALL p500_tc_cch_ins(l_bma01,sm[li].bmb03,'',sm[li].bmb06)
      END IF
   END FOR
   
END FUNCTION




