# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg198.4gl
# Descriptions...: 多部門財務報表
# Date & Author..: 96/10/17 By Danny
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.MOD-550140 05/05/27 By Smapmin 列印內容與預算編號互換位置
# Modify.........: No.FUN-560242 05/06/29 By Sarah 改成新版寫法,處理無法轉Excel的問題
# Modify.........: No.MOD-570001 05/07/01 By Echo 1.每筆資料合計金額位置下移一行
#                                                 2.多部門的資料有部份資料沒有列印,客戶資料應列出四頁,但以此程式卻只印出三頁.
# Modify.........: No.MOD-560295 05/07/27 By Smapmin 變數值未清空
# Modify.........: No.MOD-580020 05/08/02 By CoCo 把表頭部門跟金額合併
# Modify.........: No:BUG-580105 05/08/11 By Smapmin 修正MOD-560295之錯誤
# Modify.........: No.MOD-580151 05/08/19 By Smapmin 將g_buf和l_sql之定義改為CHAR(600)和LIKE type_file.chr1000
# Modify.........: No.MOD-5A0289 05/11/08 By Smapmin 列印內容為'2.預算'時,預算編號不可空白.
# Modify.........: No.TQC-5B0170 05/11/17 By Echo 解決動態表頭
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.TQC-630157 06/04/04 By Smapmin 新增是否列印下層部門的選項
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-670005 06/07/07 By xumin 帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/09/02 By yjkhero 欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-6B0021 07/03/15 By jamie 族群欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By mike 會計科目加帳套
# Modify.........: No.FUN-740020 07/04/12 By dxfwo 會計科目加帳套
# Modify.........: No.MOD-760004 07/06/01 By Smapmin 放大maj20e欄位大小
# Modify.........: No.FUN-7C0015 07/12/06 By Sarah 報表改寫由Crystal Report產出
# Modify.........: No.MOD-810183 08/01/29 By Smapmin 選擇查行要印出,但金額不做加總時,金額應該要顯示出來
# Modify.........: No.MOD-820108 08/02/26 By Smapmin 增加報表結構中金額來源的判斷
# Modify.........: NO.FUN-810069 08/02/29 By destiny 預算編號改為預算項目
# Modify.........: No.FUN-830139 08/04/07 By bnlent 去掉預算項目字段
# Modify.........: No.TQC-840049 08/04/20 By bnlent  將afb041與g_buf對應起來
# Modify.........: No.MOD-850162 08/05/19 By Sarah g198_file裡的maj02改成LIKE maj_file.maj02
# Modify.........: No.MOD-850272 08/05/27 By Sarah 報表結構編號tm.a初值應為空白不應帶aaz67
# Modify.........: No.MOD-870087 08/07/10 By Sarah g_tot1[i]值的計算需增加maj09的判斷
# Modify.........: No.MOD-910099 09/01/13 By Sarah 將l_table1裡的dept*欄位改成參考gem_file.gem02
# Modify.........: No.MOD-930020 09/03/03 By Sarah 在g198_sum與g198_sum1前,先判斷若maj.maj06為Null則清空l_sql,l_sql1,CONTINUE FOREACH
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No:CHI-A30009 10/04/09 By Summer 預算金額錯誤 
# Modify.........: No:TQC-A40138 10/04/28 By Summer 若只下單一部門時會有負數問題
# Modify.........: No:CHI-A50013 10/05/12 By Summer 選【1:實際】時，轉撥前營業毛利應為營業收入-營業成本
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   添加預算項目(afc01)欄位 
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:MOD-B70110 11/07/13 By Dido 負數運算需判斷若 maj07 貸餘時才需 * -1 
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-B90027 11/09/06 By Wangning 明細CR報表轉GR
# Modify.........: No.FUN-B90027 12/01/05 By qirl FUN-BB0047追单
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
            rtype  LIKE type_file.chr1,                   #No.FUN-680098 VARCHAR(1) 
            a      LIKE mai_file.mai01,   #報表結構編號   #No.FUN-680098 VARCHAR(6)
            b      LIKE aaa_file.aaa01,   #帳別編號       #No.FUN-670039
            abe01  LIKE abe_file.abe01,   #列印族群/部門  #No.FUN-680098 VARCHAR(6) 
            yy     LIKE aao_file.aao03,   #輸入年度       #No.FUN-680098 smallint
            bm     LIKE aao_file.aao04,   #Begin 期別     #No.FUN-680098 smallint
            em     LIKE type_file.num5,   # End  期別     #No.FUN-680098 smalint
            kind   LIKE type_file.chr1,                   #No.FUN-680098 VARCHAR(1) 
            afc01  LIKE afc_file.afc01,   #預算項目   #FUN-AB0020
            c      LIKE type_file.chr1,   #異動額及餘額為0者是否列印 #No.FUN-680098 VARCHAR(1) 
            d      LIKE type_file.chr1,   #金額單位       #No.FUN-680098 VARCHAR(1) 
            f      LIKE type_file.num5,   #列印最小階數   #No.FUN-680098 smallint
            h      LIKE type_file.chr4,   #額外說明類別   #No.FUN-680098 VARCHAR(4) 
            o      LIKE type_file.chr1,   #轉換幣別否     #No.FUN-680098 VARCHAR(1) 
            p      LIKE azi_file.azi01,   #幣別
            q      LIKE azj_file.azj03,   #匯率
            r      LIKE azi_file.azi01,   #幣別
            s      LIKE type_file.chr1,   #列印下層部門   #TQC-630157 #No.FUN-680098 VARCHAR(1) 
            more   LIKE type_file.chr1    #Input more condition(Y/N)  #No.FUN-680098 VARCHAR(1) 
           END RECORD,
       m_abd02     LIKE abd_file.abd02,       #No.FUN-680098 VARCHAR(6) 
       i,j,k,g_mm  LIKE type_file.num5,       #No.FUN-680098 smallint
       g_unit      LIKE type_file.num10,      #金額單位基數 #No.FUN-680098 integer
       g_dash3     LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(300) 
       g_buf       LIKE type_file.chr1000,    #MOD-580151   #No.FUN-680098 VARCHAR(600) 
       g_cn        LIKE type_file.num5,       #No.FUN-680098 smallint
       g_gem05     LIKE gem_file.gem05,
       m_dept      LIKE gem_file.gem02,       #No.FUN-680098 VARCHAR(300) 
       g_mai02     LIKE mai_file.mai02,
       g_mai03     LIKE mai_file.mai03,
       g_abe01     LIKE abe_file.abe01,
       g_tot1,g_tot2      ARRAY[100] OF  LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_basetot1,g_basetot2,g_basetot3  LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6)
       g_basetot4,g_basetot5,g_basetot6  LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6) 
       g_basetot7,g_basetot8,g_basetot9  LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6) 
       g_basetot10                       LIKE type_file.num20_6,  #No.FUN-680098 dec(20,6) 
       g_no        LIKE type_file.num5,                    #No.FUN-680098 smllint
       g_dept      DYNAMIC ARRAY OF RECORD  
		    gem01 LIKE gem_file.gem01,  #部門編號
		    gem05 LIKE gem_file.gem05,  #是否為會計部門
		    gem02 LIKE gem_file.gem02   #部門名稱  #FUN-7C0015 add
		   END RECORD
DEFINE g_aaa03     LIKE aaa_file.aaa03   
DEFINE g_i         LIKE type_file.num5          #count/index for any purpose     #No.FUN-680098 smallint
DEFINE g_msg       LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(72)
DEFINE l_table     STRING                       #FUN-7C0015 add
DEFINE l_table1    STRING                       #FUN-7C0015 add
DEFINE g_sql       STRING                       #FUN-7C0015 add
DEFINE g_str       STRING                       #FUN-7C0015 add
 
###GENGRE###START
TYPE sr1_t RECORD
    groupno LIKE type_file.num5,
    line LIKE type_file.num5,
    maj20 LIKE maj_file.maj20,
    maj20e LIKE maj_file.maj20e,
    maj02 LIKE maj_file.maj02,
    maj03 LIKE maj_file.maj03,
    tot01 LIKE type_file.num20_6,
    tot02 LIKE type_file.num20_6,
    tot03 LIKE type_file.num20_6,
    tot04 LIKE type_file.num20_6,
    tot05 LIKE type_file.num20_6,
    tot06 LIKE type_file.num20_6,
    tot07 LIKE type_file.num20_6,
    tot08 LIKE type_file.num20_6,
    tot09 LIKE type_file.num20_6,
    tot10 LIKE type_file.num20_6
END RECORD

TYPE sr2_t RECORD
    groupno LIKE type_file.num5,
    dept_01 LIKE gem_file.gem02,
    dept_02 LIKE gem_file.gem02,
    dept_03 LIKE gem_file.gem02,
    dept_04 LIKE gem_file.gem02,
    dept_05 LIKE gem_file.gem02,
    dept_06 LIKE gem_file.gem02,
    dept_07 LIKE gem_file.gem02,
    dept_08 LIKE gem_file.gem02,
    dept_09 LIKE gem_file.gem02,
    dept_10 LIKE gem_file.gem02
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                          #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_sql = "groupno.type_file.num5 ,line.type_file.num5,",      #line-1:表示此筆為空行 2:表示此筆不為空行
               "maj20.maj_file.maj20   ,maj20e.maj_file.maj20e,",
               "maj02.maj_file.maj02   ,maj03.maj_file.maj03,",     #項次(排序要用的)/列印碼
               "tot01.type_file.num20_6,tot02.type_file.num20_6,",
               "tot03.type_file.num20_6,tot04.type_file.num20_6,",
               "tot05.type_file.num20_6,tot06.type_file.num20_6,",
               "tot07.type_file.num20_6,tot08.type_file.num20_6,",
               "tot09.type_file.num20_6,tot10.type_file.num20_6"
   LET l_table = cl_prt_temptable('aglg198',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
 
   LET g_sql = "groupno.type_file.num5,",
               "dept_01.gem_file.gem02,dept_02.gem_file.gem02,",  #MOD-910099 mod chr20->gem02
               "dept_03.gem_file.gem02,dept_04.gem_file.gem02,",  #MOD-910099 mod chr20->gem02
               "dept_05.gem_file.gem02,dept_06.gem_file.gem02,",  #MOD-910099 mod chr20->gem02
               "dept_07.gem_file.gem02,dept_08.gem_file.gem02,",  #MOD-910099 mod chr20->gem02
               "dept_09.gem_file.gem02,dept_10.gem_file.gem02"    #MOD-910099 mod chr20->gem02
   LET l_table1 = cl_prt_temptable('aglg1981',g_sql) CLIPPED   # 產生Temp Table   
   IF l_table1 = -1 THEN EXIT PROGRAM END IF                   # Temp Table產生   
   #------------------------------ CR (1) ------------------------------#
 
   LET g_pdate  = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang  = ARG_VAL(4)
   LET g_bgjob  = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype = ARG_VAL(8)
   LET tm.a     = ARG_VAL(9)
   LET tm.b     = ARG_VAL(10)   #TQC-630157
   LET tm.abe01 = ARG_VAL(11)
   LET tm.yy    = ARG_VAL(12)
   LET tm.bm    = ARG_VAL(13)
   LET tm.em    = ARG_VAL(14)
   LET tm.kind  = ARG_VAL(15)
   LET tm.afc01 = ARG_VAL(16)   #FUN-AB0020
   LET tm.c     = ARG_VAL(17)
   LET tm.d     = ARG_VAL(18)
   LET tm.f     = ARG_VAL(19)
   LET tm.h     = ARG_VAL(20)
   LET tm.o     = ARG_VAL(21)
   LET tm.p     = ARG_VAL(22)
   LET tm.q     = ARG_VAL(23)
   LET tm.r     = ARG_VAL(24)   #TQC-630157
   LET tm.s     = ARG_VAL(25)   #TQC-630157
   LET g_rep_user = ARG_VAL(26)
   LET g_rep_clas = ARG_VAL(27)
   LET g_template = ARG_VAL(28)
   LET g_rpt_name = ARG_VAL(29)  #No.FUN-7C0078
   DROP TABLE g198_file
   CREATE TEMP TABLE g198_file(
       no        LIKE type_file.num5,  
       maj02     LIKE maj_file.maj02,    #MOD-850162 mod
       maj03     LIKE maj_file.maj03,   
       maj04     LIKE maj_file.maj04,
       maj05     LIKE maj_file.maj05,
       maj07     LIKE maj_file.maj07,
       maj20     LIKE maj_file.maj20,
       maj20e    LIKE maj_file.maj20e,   #MOD-760004
       bal1      LIKE type_file.num20_6,    
       per1      LIKE con_file.con06,       
       bal2      LIKE type_file.num20_6,    
       per2      LIKE con_file.con06)
   IF cl_null(tm.b) THEN LET tm.b = g_aaz.aaz64 END IF   #No.FUN-740020 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL g198_tm()       # Input print condition
   ELSE
      CALL g198()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
END MAIN
 
FUNCTION g198_tm()
   DEFINE li_chk_bookno  LIKE type_file.num5    #No.FUN-670005   #No.FUN-680098  smallint
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680098 smallint
   DEFINE l_sw           LIKE type_file.chr1    #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
   DEFINE l_cmd          LIKE type_file.chr1000 #No.FUN-680098 VARCHAR(400)
   DEFINE li_result      LIKE type_file.num5    #FUN-6C0068
   DEFINE l_azfacti      LIKE azf_file.azfacti  #FUN-AB0020
 
   CALL s_dsmark(tm.b)      #No.FUN-740020 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 16
   ELSE LET p_row = 4 LET p_col =11
   END IF
   OPEN WINDOW g198_w AT p_row,p_col WITH FORM "agl/42f/aglg198" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL s_shwact(0,0,tm.b)   #No.FUN-740020 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   IF tm.b IS NULL OR tm.b = ' 'THEN      #No.FUN-740020
    LET tm.b = g_aza.aza81                #No.FUN-740020        
   END IF                                 #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  #No.FUN-740020 
   IF SQLCA.sqlcode THEN 
      CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123   #No.FUN-740020 
   END IF
   LET tm.c = 'N'
   LET tm.d = '2'
   LET tm.f = 0
   LET tm.kind='1'
   LET tm.h = 'N'
   LET tm.s = 'N'   #TQC-630157
   LET tm.o = 'N'
   LET tm.p = g_aaa03
   LET tm.q = 1
   LET tm.r = g_aaa03
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      LET l_sw = 1
      INPUT BY NAME tm.rtype,tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,       #No.FUN-740020
                    tm.f,tm.kind,tm.afc01,tm.d,tm.c,tm.h,tm.s,tm.o,tm.r,   #MOD-550140   #TQC-630157 #No.FUN-830139   #FUN-AB0020 add tm.afc01
                    tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
            CALL cl_qbe_init()
         ON ACTION locale
            LET g_action_choice = "locale"
            EXIT INPUT
 
         AFTER FIELD a
            IF tm.a IS NULL THEN NEXT FIELD a END IF
            CALL s_chkmai(tm.a,'RGL') RETURNING li_result
            IF NOT li_result THEN
              CALL cl_err(tm.a,g_errno,1)
              NEXT FIELD a
            END IF
            SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                   WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                     AND mai00 = tm.b #No.FUN-740020  
            IF STATUS THEN 
               CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)   #No.FUN-660123
               NEXT FIELD a
           #No.TQC-C50042   ---start---   Add
            ELSE
               IF g_mai03 = '5' OR g_mai03 = '6' THEN
                  CALL cl_err('','agl-268',0)
                  NEXT FIELD a
               END IF
           #No.TQC-C50042   ---end---     Add
            END IF
 
         AFTER FIELD b
            IF tm.b IS NULL THEN 
               NEXT FIELD b END IF
                CALL s_check_bookno(tm.b,g_user,g_plant) 
                     RETURNING li_chk_bookno
                IF (NOT li_chk_bookno) THEN
                   NEXT FIELD b
                END IF 
            SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
            IF STATUS THEN
               CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)   #No.FUN-660123
               NEXT FIELD b 
            END IF
 
         AFTER FIELD abe01
            IF cl_null(tm.abe01) THEN NEXT FIELD abe01 END IF
            SELECT UNIQUE abe01 INTO g_abe01 FROM abe_file WHERE abe01=tm.abe01
            IF STATUS=100 THEN
               LET g_abe01 =' '
               SELECT gem05 INTO g_gem05 FROM gem_file WHERE gem01=tm.abe01 
               IF STATUS=100 THEN NEXT FIELD abe01 END IF
            END IF
           IF cl_chkabf(tm.abe01) THEN NEXT FIELD abe01 END IF
 
         AFTER FIELD c
            IF tm.c IS NULL OR tm.c NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
         AFTER FIELD yy
            IF tm.yy IS NULL OR tm.yy = 0 THEN
               NEXT FIELD yy
            END IF
 
         BEFORE FIELD bm
            IF tm.rtype='1' THEN
               LET tm.bm = 0 DISPLAY '' TO bm
            END IF
 
         AFTER FIELD bm
           IF NOT cl_null(tm.bm) THEN
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.yy
              IF g_azm.azm02 = 1 THEN
                 IF tm.bm > 12 OR tm.bm < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD bm
                 END IF
              ELSE
                 IF tm.bm > 13 OR tm.bm < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD bm
                 END IF
              END IF
           END IF
           IF tm.bm IS NULL THEN NEXT FIELD bm END IF
  
         AFTER FIELD em
           IF NOT cl_null(tm.em) THEN
              SELECT azm02 INTO g_azm.azm02 FROM azm_file
                WHERE azm01 = tm.yy
              IF g_azm.azm02 = 1 THEN
                 IF tm.em > 12 OR tm.em < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD em
                 END IF
              ELSE
                 IF tm.em > 13 OR tm.em < 1 THEN
                    CALL cl_err('','agl-020',0)
                    NEXT FIELD em
                 END IF
              END IF
           END IF
           IF tm.em IS NULL THEN NEXT FIELD em END IF
           IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
        AFTER FIELD kind
           IF tm.kind NOT MATCHES '[12]' THEN NEXT FIELD kind END IF
 
#FUN-AB0020 --------------------Begin----------------------------
      AFTER FIELD afc01
        IF NOT cl_null(tm.afc01) THEN
           SELECT azf01 FROM azf_file
            WHERE azf01 = tm.afc01  AND azf02 = '2'
          IF SQLCA.sqlcode THEN
             CALL cl_err3("sel","azf_file",tm.afc01,"","agl-005","","",0)
             NEXT FIELD afc01
          ELSE
             SELECT azfacti INTO l_azfacti FROM azf_file
              WHERE azf01 = tm.afc01 AND azf02 = '2'
             IF l_azfacti = 'N' THEN
                CALL cl_err(tm.afc01,'agl1002',0)
             END IF
          END IF
       END IF       
#FUN-AB0020 --------------------End------------------------------ 
         
        AFTER FIELD d
           IF tm.d IS NULL OR tm.d NOT MATCHES'[123]'  THEN
              NEXT FIELD d
           END IF
 
        AFTER FIELD f
           IF tm.f IS NULL OR tm.f < 0  THEN
              LET tm.f = 0
              DISPLAY BY NAME tm.f
              NEXT FIELD f
           END IF
 
        AFTER FIELD h
           IF tm.h NOT MATCHES "[YN]" THEN NEXT FIELD h END IF
 
        AFTER FIELD s
           IF cl_null(tm.s) OR tm.s NOT MATCHES "[YN]" THEN NEXT FIELD c END IF
 
        AFTER FIELD o
           IF tm.o IS NULL OR tm.o NOT MATCHES'[YN]' THEN NEXT FIELD o END IF
           IF tm.o = 'N' THEN 
              LET tm.p = g_aaa03 
              LET tm.q = 1
              DISPLAY g_aaa03 TO p
              DISPLAY BY NAME tm.q
           END IF
 
        BEFORE FIELD p
           IF tm.o = 'N' THEN NEXT FIELD more END IF
 
        AFTER FIELD p
           SELECT azi01 FROM azi_file WHERE azi01 = tm.p
           IF SQLCA.sqlcode THEN
              CALL cl_err3("sel","azi_file",tm.p,'',"agl-109","","sel azi:",0)   #No.FUN-660123 #No.FUN-830139
              NEXT FIELD p 
           END IF
 
        BEFORE FIELD q
           IF tm.o = 'N' THEN NEXT FIELD o END IF
 
        AFTER FIELD more
           IF tm.more = 'Y'
              THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies)
                        RETURNING g_pdate,g_towhom,g_rlang,
                                  g_bgjob,g_time,g_prtway,g_copies
           END IF
 
        AFTER INPUT 
           IF INT_FLAG THEN EXIT INPUT END IF
           IF tm.yy IS NULL THEN 
              LET l_sw = 0 
              DISPLAY BY NAME tm.yy 
              CALL cl_err('',9033,0)
           END IF
           IF tm.bm IS NULL THEN 
              LET l_sw = 0 
              DISPLAY BY NAME tm.bm 
           END IF
           IF tm.em IS NULL THEN 
              LET l_sw = 0 
              DISPLAY BY NAME tm.em 
           END IF
           IF l_sw = 0 THEN 
              LET l_sw = 1 
              NEXT FIELD a
              CALL cl_err('',9033,0)
           END IF
           IF tm.d = '1' THEN LET g_unit = 1 END IF
           IF tm.d = '2' THEN LET g_unit = 1000 END IF
           IF tm.d = '3' THEN LET g_unit = 1000000 END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG 
           CALL cl_cmdask()    # Command execution
        ON ACTION CONTROLP
           IF INFIELD(a) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_mai'
              LET g_qryparam.default1 = tm.a
              LET g_qryparam.where = " mai03 NOT IN ('5','6')"  #No.TQC-C50042   Add
              CALL cl_create_qry() RETURNING tm.a
              DISPLAY BY NAME tm.a
              NEXT FIELD a
           END IF
           IF INFIELD(b) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_aaa'
              LET g_qryparam.default1 = tm.b
              CALL cl_create_qry() RETURNING tm.b 
              DISPLAY BY NAME tm.b
              NEXT FIELD b
           END IF
           IF INFIELD(p) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azi'
              LET g_qryparam.default1 = tm.p
              CALL cl_create_qry() RETURNING tm.p
              DISPLAY BY NAME tm.p
              NEXT FIELD p
           END IF
           IF INFIELD(abe01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_abe'
              LET g_qryparam.default1 = tm.abe01
              CALL cl_create_qry() RETURNING tm.abe01
              DISPLAY BY NAME tm.abe01
              NEXT FIELD abe01
           END IF

#FUN-AB0020 --------------Begin--------------------
           IF INFIELD(afc01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = 'q_azf'    
              LET g_qryparam.default1 = tm.afc01
              LET g_qryparam.arg1 = '2'        
              CALL cl_create_qry() RETURNING tm.afc01
              DISPLAY BY NAME tm.afc01
              NEXT FIELD afc01
           END IF
#FUN-AB0020 ---------------End---------------------        
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW g198_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
                WHERE zz01='aglg198'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg198','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",tm.b CLIPPED,"'" ,         #No.FUN-740020 
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.rtype CLIPPED,"'",
                            " '",tm.a CLIPPED,"'",
                            " '",tm.b CLIPPED,"'",   #TQC-630157
                            " '",tm.abe01 CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.bm CLIPPED,"'",
                            " '",tm.em CLIPPED,"'",
                            " '",tm.kind CLIPPED,"'",   #TQC-630157
                            " '",tm.afc01 CLIPPED,"'",   #FUN-AB0020                           
                            " '",tm.c CLIPPED,"'",
                            " '",tm.d CLIPPED,"'",
                            " '",tm.f CLIPPED,"'",
                            " '",tm.h CLIPPED,"'",
                            " '",tm.o CLIPPED,"'",
                            " '",tm.p CLIPPED,"'",
                            " '",tm.q CLIPPED,"'",
                            " '",tm.r CLIPPED,"'",   #TQC-630157
                            " '",tm.s CLIPPED,"'",   #TQC-630157
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('aglg198',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g198_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g198()
      ERROR ""
   END WHILE
   CLOSE WINDOW g198_w
END FUNCTION
 
FUNCTION g198()
   DEFINE l_name           LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098 VARCHAR(20)
   DEFINE l_name1          LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098 VARCHAR(20)   
   DEFINE l_sql            STRING    # RDSQL STATEMENT #MOD-580151   
   DEFINE l_chr            LIKE type_file.chr1         #No.FUN-680098 VARCHAR(1)  
   DEFINE l_tmp            LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE l_leng,l_leng2   LIKE type_file.num5         #No.FUN-680098 smallint
   DEFINE l_abe03          LIKE abe_file.abe03
   DEFINE l_gem02          LIKE gem_file.gem02
   DEFINE l_dept           LIKE gem_file.gem01
   DEFINE l_total          LIKE type_file.chr20        #No.FUN-680098 VARCHAR(18)  
   DEFINE l_tot1,l_tot2,l_tot3,l_tot4,l_tot5    LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE l_tot6,l_tot7,l_tot8,l_tot9,l_tot10   LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE g_sumtotal       LIKE type_file.num20_6      #No.FUN-680098 dec(20,6) 
   DEFINE g_sum            LIKE bxi_file.bxi01         #No.FUN-680098 VARCHAR(15)   
   DEFINE g_sum1,g_sum2,g_sum3,g_sum4,g_sum5    LIKE bxi_file.bxi01         #No.FUN-680098 VARCHAR(15) 
   DEFINE g_sum6,g_sum7,g_sum8,g_sum9,g_sum10   LIKE bxi_file.bxi01         #No.FUN-680098 VARCHAR(15)
   define sr2 RECORD 
              l_str1     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6)
              l_str2     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str3     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str4     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str5     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str6     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str7     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str8     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str9     LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
              l_str10    LIKE type_file.num20_6      #No.FUN-680098 dec(20,6) 
             END RECORD 
   DEFINE sr  RECORD
              no        LIKE type_file.num5,         #No.FUN-680098 smallint
              maj02     LIKE maj_file.maj02,         #No.FUN-680098 dec(9,2)
              maj03     LIKE maj_file.maj03,         #No.FUN-680098 VARCHAR(1)
              maj04     LIKE maj_file.maj04,         #No.FUN-680098 smallint 
              maj05     LIKE maj_file.maj05,         #No.FUN-680098 smallint
              maj07     LIKE maj_file.maj07,         #No.FUN-680098 VARCHAR(1) 
              maj20     LIKE maj_file.maj20,         #No.FUN-680098 VARCHAR(30)
              maj20e    LIKE maj_file.maj20e,        #No.FUN-680098 VARCHAR(30)
              bal1      LIKE type_file.num20_6,      #No.FUN-680098 dec(20,6)
              per1      LIKE con_file.con06,         #基準百分比 #No.FUN-680098 dec(9,5)
              bal2      LIKE type_file.num20_6,      #差異       #No.FUN-680098  dec(20,6)
              per2      LIKE con_file.con06          #差異百分比 #No.FUN-680098 dec(9,5)
              END RECORD
  DEFINE sr3 RECORD  #新版寫法，部門要拆開，不要一次把十個部門寫入一個字串裡
             l_dept1   LIKE gem_file.gem02,
             l_dept2   LIKE gem_file.gem02,
             l_dept3   LIKE gem_file.gem02,
             l_dept4   LIKE gem_file.gem02,
             l_dept5   LIKE gem_file.gem02,
             l_dept6   LIKE gem_file.gem02,
             l_dept7   LIKE gem_file.gem02,
             l_dept8   LIKE gem_file.gem02,
             l_dept9   LIKE gem_file.gem02,
             l_dept10  LIKE gem_file.gem02
             END RECORD
  DEFINE sr4 RECORD
             l_tot1     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
             l_tot2     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot3     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot4     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot5     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot6     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot7     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot8     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot9     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
             l_tot10    LIKE type_file.num20_6 #No.FUN-680098 dec(20,6) 
             END RECORD
   DEFINE l_str,l_str1,l_str2,l_str3,l_str4,l_str5 LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(300)
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10      LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(300)
   DEFINE l_no,l_cn,l_cnt,l_i                      LIKE type_file.num5      #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1  LIKE type_file.chr1000      #No.FUN-680098 VARCHAR(400) 
   DEFINE l_amt         LIKE type_file.num20_6      #No.FUN-680098 dec(20,6) 
   DEFINE l_rep_cnt     LIKE type_file.num5,        #No.FUN-680098 smallint 
          l_channel     base.Channel,
          l_channel1    base.Channel,
          l_xml_str     STRING,
          l_row_cnt     LIKE type_file.num5        #No.FUN-680098   smallint
   DEFINE l_group,i     LIKE type_file.num5        #FUN-7C0015 add
 
   CALL g_zaa_dyn.clear()           #TQC-5B0170
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   #------------------------------ CR (2) ------------------------------#
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B90027--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
      EXIT PROGRAM
   END IF
 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep1:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B90027--add--
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
      EXIT PROGRAM
   END IF
 
   LET g_pageno = 0
   LET g_sum = 0
   LET g_sumtotal = 0
   SELECT aaf03 INTO g_company FROM aaf_file 
    WHERE aaf01 = tm.b AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg198'
   SELECT azi05 INTO g_azi05 FROM azi_file where azi01=tm.p  #FUN-560242
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 239 END IF
   FOR g_i = 1 TO g_len LET g_dash3[g_i,g_i] = '=' END FOR
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1' LET g_msg=" maj23[1,1]='1'"
        WHEN tm.rtype='2' LET g_msg=" maj23[1,1]='2'"
        OTHERWISE         LET g_msg=" 1=1"
   END CASE
 
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE g198_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      CALL cl_gre_drop_temptable(l_table||"|"||l_table1)            #NO.FUN-B90027
      EXIT PROGRAM 
   END IF
   DECLARE g198_c CURSOR FOR g198_p
 
   LET g_mm = tm.em
   FOR g_i = 1 TO 100
       LET g_tot1[g_i] = 0 
       LET g_tot2[g_i] = 0 
   END FOR
   LET g_no = 1
   FOR g_no = 1 TO 300 INITIALIZE g_dept[g_no].* TO NULL END FOR
 
#將部門填入array------------------------------------
   LET g_buf = ''
   IF g_abe01 = ' ' THEN                   #--- 部門
      LET g_no = 1
      LET g_dept[g_no].gem01 = tm.abe01
      LET g_dept[g_no].gem05 = g_gem05
      SELECT gem02 INTO g_dept[g_no].gem02 FROM gem_file
       WHERE gem01=g_dept[g_no].gem01                       
   ELSE                                    #--- 族群
      LET g_no = 0
      DECLARE g198_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file 
	WHERE abe01=tm.abe01 AND gem01=abe03
        ORDER BY 1
      FOREACH g198_bom INTO l_abe03,l_chr
         IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
         LET g_no = g_no + 1
         LET g_dept[g_no].gem01 = l_abe03
         LET g_dept[g_no].gem05 = l_chr
         SELECT gem02 INTO g_dept[g_no].gem02 FROM gem_file 
          WHERE gem01=g_dept[g_no].gem01
      END FOREACH
   END IF
  #寫入橫向抬頭-部門名稱
   LET i = 0
   FOR l_group = 1 TO ((10-(g_no MOD 10))+g_no)/10
      EXECUTE insert_prep1 USING
         l_group          ,g_dept[i+1].gem02,g_dept[i+2].gem02,
         g_dept[i+3].gem02,g_dept[i+4].gem02,g_dept[i+5].gem02,
         g_dept[i+6].gem02,g_dept[i+7].gem02,g_dept[i+8].gem02,
         g_dept[i+9].gem02,g_dept[i+10].gem02
      LET i = i + 10
   END FOR
 
#---------98-06-18 Modify控制一次印十個部門
   LET l_cnt=(10-(g_no MOD 10))+g_no     ###一行 10 個
   LET l_rep_cnt = 0                     #MOD-570001
   LET l_group = 1                       #FUN-7C0015 add
   FOR l_i = 10 TO l_cnt STEP 10
       CALL g_x.clear()
       INITIALIZE sr3.* TO NULL
       INITIALIZE sr4.* TO NULL
 
       LET g_cn = 0 
       LET g_basetot1 = 0 LET g_basetot2 = 0 LET g_basetot3 = 0 
       LET g_basetot4 = 0 LET g_basetot5 = 0 LET g_basetot6 = 0 
       LET g_basetot7 = 0 LET g_basetot8 = 0 LET g_basetot9 = 0 
       LET g_basetot10 = 0
       DELETE FROM g198_file
       LET m_dept = ''
       IF l_i <= g_no THEN
          LET l_no = l_i - 10
          FOR l_cn = 1 TO 10 
              LET g_i = 1
              FOR g_i = 1 TO 100
                  LET g_tot1[g_i] = 0 
                  LET g_tot2[g_i] = 0 
              END FOR
              LET g_buf = ''
              LET l_dept = g_dept[l_no+l_cn].gem01
              LET l_chr  = g_dept[l_no+l_cn].gem05
              LET l_gem02 = ''
              SELECT gem02 INTO l_gem02 FROM gem_file 
               WHERE gem01=l_dept 
              LET l_leng2 = 18 - l_leng2
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02 CLIPPED
                  LET l_gem02 = l_gem02 CLIPPED   #MOD-550140
                  LET l_leng2 = LENGTH(l_gem02)   #MOD-550140
              ELSE 
                 LET m_dept = m_dept CLIPPED, l_leng2+1 SPACES,l_gem02 CLIPPED
                  LET l_gem02 = l_gem02 CLIPPED   #MOD-550140
                  LET l_leng2 = LENGTH(l_gem02)   #MOD-550140
              END IF
            #新版寫法，部門要拆開，不要一次把十個部門寫入一個字串裡
             CASE l_cn
                  WHEN 1 LET sr3.l_dept1  = l_gem02
                  WHEN 2 LET sr3.l_dept2  = l_gem02
                  WHEN 3 LET sr3.l_dept3  = l_gem02
                  WHEN 4 LET sr3.l_dept4  = l_gem02
                  WHEN 5 LET sr3.l_dept5  = l_gem02
                  WHEN 6 LET sr3.l_dept6  = l_gem02
                  WHEN 7 LET sr3.l_dept7  = l_gem02
                  WHEN 8 LET sr3.l_dept8  = l_gem02
                  WHEN 9 LET sr3.l_dept9  = l_gem02
                  WHEN 10 LET sr3.l_dept10  = l_gem02
             END CASE
              IF tm.s = 'Y' THEN
                 CALL g198_bom(l_dept,l_chr)
              ENd IF
 
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
 
              LET l_leng=LENGTH(g_buf)
              LET g_buf=g_buf[1,l_leng-1] CLIPPED
              CALL g198_process(l_cn)
              LET g_cn = l_cn
          END FOR
       ELSE
          LET l_no = (l_i - 10)
          FOR l_cn = 1 TO (g_no - (l_i - 10))
              LET g_i = 1
              FOR g_i = 1 TO 100
                  LET g_tot1[g_i] = 0 
                  LET g_tot2[g_i] = 0 
              END FOR
              LET g_buf = ''
              LET l_dept = g_dept[l_no+l_cn].gem01
              LET l_chr  = g_dept[l_no+l_cn].gem05
              LET l_gem02 = ''
              SELECT gem02 INTO l_gem02 FROM gem_file 
               WHERE gem01=l_dept 
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02 CLIPPED   
                  LET l_leng2 = LENGTH(l_gem02)   #MOD-550140
                  LET l_leng2 = 18 - l_leng2   #MOD-550140
              ELSE 
                 LET m_dept = m_dept CLIPPED, l_leng2+1 SPACES,l_gem02 CLIPPED
                  LET l_leng2 = LENGTH(l_gem02)   #MOD-550140
                  LET l_leng2 = 18 - l_leng2   #MOD-550140
              END IF
            #新版寫法，部門要拆開，不要一次把十個部門寫入一個字串裡
             CASE l_cn
                  WHEN 1 LET sr3.l_dept1  = l_gem02
                  WHEN 2 LET sr3.l_dept2  = l_gem02
                  WHEN 3 LET sr3.l_dept3  = l_gem02
                  WHEN 4 LET sr3.l_dept4  = l_gem02
                  WHEN 5 LET sr3.l_dept5  = l_gem02
                  WHEN 6 LET sr3.l_dept6  = l_gem02
                  WHEN 7 LET sr3.l_dept7  = l_gem02
                  WHEN 8 LET sr3.l_dept8  = l_gem02
                  WHEN 9 LET sr3.l_dept9  = l_gem02
                  WHEN 10 LET sr3.l_dept10  = l_gem02
             END CASE
              IF tm.s = 'Y' THEN
                 CALL g198_bom(l_dept,l_chr)
              ENd IF
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
 
              LET l_leng=LENGTH(g_buf)
              LET g_buf=g_buf[1,l_leng-1] CLIPPED
              CALL g198_process(l_cn)
              LET g_cn = l_cn
          END FOR
       END IF
       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM g198_file ORDER BY maj02,no
       IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
       LET l_tot1 = 0   LET l_tot2 = 0   LET l_tot3 = 0
       LET l_tot4 = 0   LET l_tot5 = 0   LET l_tot6 = 0
       LET l_tot7 = 0   LET l_tot8 = 0   LET l_tot9 = 0
       LET l_tot10= 0   LET l_total= 0
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
 
         IF sr.maj07='2' THEN 
            LET sr.bal1=sr.bal1*-1  LET sr.bal2=sr.bal2*-1  
         END IF
 
         LET l_amt = sr.bal1 - sr.bal2           #差異值 = 實際 - 預算
         IF sr.bal2 != 0 THEN
            LET sr.per2 = l_amt / sr.bal2 * 100  #差異％ = 差異 / 預算
         END IF                    
 
         IF sr.no = 1 THEN
            IF g_basetot1!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot1) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 2 THEN
            IF g_basetot2!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot2) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 3 THEN
            IF g_basetot3!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot3) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 4 THEN
            IF g_basetot4!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot4) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 5 THEN
            IF g_basetot5!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot5) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 6 THEN
            IF g_basetot6!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot6) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 7 THEN
            IF g_basetot7!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot7) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 8 THEN
            IF g_basetot8!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot8) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 9 THEN
            IF g_basetot9!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot9) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF sr.no = 10 THEN
            IF g_basetot10!=0 THEN
               LET sr.per1 = (sr.bal1 / g_basetot10) * 100
            ELSE
               LET sr.per1 = 0                             
            END IF
         END IF
         IF tm.d MATCHES '[23]' THEN          #換算金額單位
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
               LET sr.bal2 = sr.bal2 / g_unit    #差異值
            END IF
         END IF
 
         IF sr.no = 1 THEN
            IF tm.kind='1' THEN
               LET l_str1 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot1 = sr.bal1
               LET sr4.l_tot1 = sr.bal1   #FUN-560242 
               LET g_sum1 = g_sum1 + l_tot1  #算總計
            ELSE
               LET l_str1 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot1 = sr.bal2 
               LET sr4.l_tot1 = sr.bal2   #FUN-560242
               LET g_sum1 = g_sum1 + l_tot1  #算總計
            END IF
         END IF
         IF sr.no = 2 THEN
            IF tm.kind='1' THEN
               LET l_str2 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot2 = sr.bal1
               LET sr4.l_tot2 = sr.bal1  #FUN-560242 
               LET g_sum2 = g_sum2 + l_tot2 
            ELSE
               LET l_str2 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot2 = sr.bal2 
               LET sr4.l_tot2 = sr.bal2  #FUN-560242
               LET g_sum2 = g_sum2 + l_tot2 
            END IF
         END IF
         IF sr.no = 3 THEN
            IF tm.kind='1' THEN
               LET l_str3 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot3 = sr.bal1
               LET sr4.l_tot3 = sr.bal1  #FUN-560242 
               LET g_sum3 = g_sum3 + l_tot3  #算總計
            ELSE
               LET l_str3 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot3 = sr.bal2 
               LET sr4.l_tot3 = sr.bal2  #FUN-560242
               LET g_sum3 = g_sum3 + l_tot3  #算總計
            END IF
         END IF
         IF sr.no = 4 THEN
            IF tm.kind='1' THEN
               LET l_str4 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot4 = sr.bal1
               LET sr4.l_tot4 = sr.bal1  #FUN-56024 
               LET g_sum4 = g_sum4 + l_tot4  #算總計
            ELSE
               LET l_str4 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot4 = sr.bal2 
               LET sr4.l_tot4 = sr.bal2  #FUN-56024
               LET g_sum4 = g_sum4 + l_tot4  #算總計
            END IF
         END IF
         IF sr.no = 5 THEN
            IF tm.kind='1' THEN
               LET l_str5 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot5 = sr.bal1
               LET sr4.l_tot5 = sr.bal1  #FUN-56024
               LET g_sum5 = g_sum5 + l_tot5   #算總計
            ELSE
               LET l_str5 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot5 = sr.bal2 
               LET sr4.l_tot5 = sr.bal2  #FUN-56024
               LET g_sum5 = g_sum5 + l_tot5   #算總計
            END IF
         END IF
         IF sr.no = 6 THEN
            IF tm.kind='1' THEN
               LET l_str6 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot6 = sr.bal1
               LET sr4.l_tot6 = sr.bal1  #FUN-560242 
               LET g_sum6 = g_sum6 + l_tot6  #算總計
            ELSE
               LET l_str6 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot6 = sr.bal2 
               LET sr4.l_tot6 = sr.bal2  #FUN-560242
               LET g_sum6 = g_sum6 + l_tot6  #算總計
            END IF
         END IF
         IF sr.no = 7 THEN
            IF tm.kind='1' THEN
               LET l_str7 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot7 = sr.bal1
               LET sr4.l_tot7 = sr.bal1  #FUN-560242 
               LET g_sum7 = g_sum7 + l_tot7  #算總計
            ELSE
               LET l_str7 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot7 = sr.bal2 
               LET sr4.l_tot7 = sr.bal2  #FUN-560242
               LET g_sum7 = g_sum7 + l_tot7  #算總計
            END IF
         END IF
         IF sr.no = 8 THEN
            IF tm.kind='1' THEN
               LET l_str8 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot8 = sr.bal1
               LET sr4.l_tot8 = sr.bal1  #FUN-560242 
               LET g_sum8 = g_sum8 + l_tot8  #算總計
            ELSE
               LET l_str8 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot8 = sr.bal2 
               LET sr4.l_tot8 = sr.bal2  #FUN-560242
               LET g_sum8 = g_sum8 + l_tot8  #算總計
            END IF
         END IF
         IF sr.no = 9 THEN
            IF tm.kind='1' THEN
               LET l_str9 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot9 = sr.bal1
               LET sr4.l_tot9 = sr.bal1  #FUN-56024 
               LET g_sum9 = g_sum9 + l_tot9  #算總計
            ELSE
               LET l_str9 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot9 = sr.bal2 
               LET sr4.l_tot9 = sr.bal2  #FUN-56024
               LET g_sum9 = g_sum9 + l_tot9  #算總計
            END IF
         END IF
         IF sr.no = 10 THEN
            IF tm.kind='1' THEN
               LET l_str10 = sr.bal1 USING '--,---,---,---,--&'
               LET l_tot10 = sr.bal1
               LET sr4.l_tot10 = sr.bal1  #FUN-560242 
               LET g_sum10 = g_sum10 + l_tot10  #算總計
            ELSE
               LET l_str10 = sr.bal2 USING '--,---,---,---,--&'
               LET l_tot10 = sr.bal2 
               LET sr4.l_tot10 = sr.bal2  #FUN-560242
               LET g_sum10 = g_sum10 + l_tot10  #算總計
            END IF
         END IF
         IF sr.no = g_cn THEN
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[0125]" AND 
               (l_str1[1,18]='                 0' OR cl_null(l_str1[1,18])) AND
               (l_str2[1,18]='                 0' OR cl_null(l_str2[1,18])) AND
               (l_str3[1,18]='                 0' OR cl_null(l_str3[1,18])) AND
               (l_str4[1,18]='                 0' OR cl_null(l_str4[1,18])) AND
               (l_str5[1,18]='                 0' OR cl_null(l_str5[1,18])) AND
               (l_str6[1,18]='                 0' OR cl_null(l_str6[1,18])) AND
               (l_str7[1,18]='                 0' OR cl_null(l_str7[1,18])) AND
               (l_str8[1,18]='                 0' OR cl_null(l_str8[1,18])) AND
               (l_str9[1,18]='                 0' OR cl_null(l_str9[1,18])) AND
               (l_str10[1,18]='                 0' OR cl_null(l_str10[1,18])) THEN
               CONTINUE FOREACH                              #餘額為 0 者不列印
            END IF
            LET l_str = l_str1 CLIPPED,' ',l_str2 CLIPPED,' ',l_str3 CLIPPED,' ',
                        l_str4 CLIPPED,' ',l_str5 CLIPPED,' ',l_str6 CLIPPED,' ',	
                        l_str7 CLIPPED,' ',l_str8 CLIPPED,' ',l_str9 CLIPPED,' ',
                        l_str10 CLIPPED
            LET sr2.l_str1 = l_str1 
            LET sr2.l_str2 = l_str2 
            LET sr2.l_str3 = l_str3 
            LET sr2.l_str4 = l_str4 
            LET sr2.l_str5 = l_str5 
            LET sr2.l_str6 = l_str6 
            LET sr2.l_str7 = l_str7 
            LET sr2.l_str8 = l_str8 
            LET sr2.l_str9 = l_str9 
            LET sr2.l_str10= l_str10 
        
            IF l_tot1 IS null  THEN LET l_tot1 = 0  END IF  
            IF l_tot2 IS null  THEN LET l_tot2 = 0  END IF  
            IF l_tot3 IS null  THEN LET l_tot3 = 0  END IF  
            IF l_tot4 IS null  THEN LET l_tot4 = 0  END IF  
            IF l_tot5 IS null  THEN LET l_tot5 = 0  END IF  
            IF l_tot6 IS null  THEN LET l_tot6 = 0  END IF  
            IF l_tot7 IS null  THEN LET l_tot7 = 0  END IF  
            IF l_tot8 IS null  THEN LET l_tot8 = 0  END IF  
            IF l_tot9 IS null  THEN LET l_tot9 = 0  END IF  
            IF l_tot10 IS null THEN LET l_tot10 = 0 END IF 
            LET l_total = (l_tot1+l_tot2+l_tot3+l_tot4+l_tot5+l_tot6+l_tot7+l_tot8+l_tot9+l_tot10)  USING '--,---,---,---,--&'
            LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
            LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
            LET l_str7 = '' LET l_str8 = '' LET l_str9 = '' LET l_str10 = ''
           IF tm.h = 'Y' THEN
              LET sr.maj20 = sr.maj20e
           END IF
           LET sr.maj20 = sr.maj05 SPACES,sr.maj20
 
          #-MOD-B70110-mark-
          #IF sr4.l_tot1<0 THEN LET sr4.l_tot1=sr4.l_tot1*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot2<0 THEN LET sr4.l_tot2=sr4.l_tot2*-1 END IF #CHI-A30009 add
          #IF sr4.l_tot3<0 THEN LET sr4.l_tot3=sr4.l_tot3*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot4<0 THEN LET sr4.l_tot4=sr4.l_tot4*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot5<0 THEN LET sr4.l_tot5=sr4.l_tot5*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot6<0 THEN LET sr4.l_tot6=sr4.l_tot6*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot7<0 THEN LET sr4.l_tot7=sr4.l_tot7*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot8<0 THEN LET sr4.l_tot8=sr4.l_tot8*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot9<0 THEN LET sr4.l_tot9=sr4.l_tot9*-1 END IF #TQC-A40138 add
          #IF sr4.l_tot10<0 THEN LET sr4.l_tot10=sr4.l_tot10*-1 END IF #TQC-A40138 add
          #-MOD-B70110-end-

           ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
           IF sr.maj04 = 0 THEN
              EXECUTE insert_prep USING
                 l_group,'2',sr.maj20,sr.maj20e,sr.maj02,sr.maj03,
                 sr4.l_tot1,sr4.l_tot2,sr4.l_tot3,sr4.l_tot4,sr4.l_tot5,
                 sr4.l_tot6,sr4.l_tot7,sr4.l_tot8,sr4.l_tot9,sr4.l_tot10
           ELSE
              EXECUTE insert_prep USING
                 l_group,'2',sr.maj20,sr.maj20e,sr.maj02,sr.maj03,
                 sr4.l_tot1,sr4.l_tot2,sr4.l_tot3,sr4.l_tot4,sr4.l_tot5,
                 sr4.l_tot6,sr4.l_tot7,sr4.l_tot8,sr4.l_tot9,sr4.l_tot10
              #空行的部份,以寫入同樣的maj20資料列進Temptable,
              #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,
              #讓空行的這筆資料排在正常的資料前面印出
              FOR i = 1 TO sr.maj04
                 EXECUTE insert_prep USING
                    l_group,'1',sr.maj20,sr.maj20e,sr.maj02,'',
                    '0','0','0','0','0',
                    '0','0','0','0','0'
              END FOR
           END IF
         END IF
       END FOREACH
 
    LET l_group = l_group + 1   #FUN-7C0015 add
  END FOR
 
  ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
###GENGRE###  LET g_sql = "SELECT A.*,B.groupno,B.dept_01,B.dept_02,B.dept_03,B.dept_04,B.dept_05,",
###GENGRE###              "           B.dept_06,B.dept_07,B.dept_08,B.dept_09,B.dept_10 ", 
###GENGRE###              "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A",
###GENGRE###              "      ,",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
###GENGRE###              " WHERE A.groupno=B.groupno"
  #p1~p7
###GENGRE###  LET g_str = tm.a,";",tm.yy,";",tm.bm,";",tm.em,";",tm.d,";",
###GENGRE###              tm.p,";",g_azi05
###GENGRE###  CALL cl_prt_cs3('aglg198','aglg198',g_sql,g_str)
    CALL aglg198_grdata()    ###GENGRE###
END FUNCTION
 
FUNCTION g198_process(l_cn)
   DEFINE l_sql,l_sql1   STRING   #MOD-580151   
   DEFINE l_cn           LIKE type_file.num5         #No.FUN-680098 smallint 
   DEFINE amt1,amt2,amt  LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE maj            RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2  LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE l_amt          LIKE type_file.num20_6      #No.FUN-680098 dec(20,6)
   DEFINE m_per1,m_per2  LIKE con_file.con06         #No.FUN-680098 dec(9,5)           
 
   FOREACH g198_c INTO maj.*
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      CASE maj.maj06
        WHEN 1
          LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",   
                      " AND aao04 < '",tm.bm,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                     " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 2
          LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                      " AND aao04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 3
         LET l_sql = "SELECT SUM(aao05-aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",   
                      " AND aao04 <= '",tm.em,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 4
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                      " AND aao04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 5
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                      " AND aao04 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 6
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                     " AND aao04 < '",tm.bm,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 7
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",   
                      " AND aao04 < '",tm.bm,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 8
          LET l_sql = "SELECT SUM(aao05) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                      " AND aao04 <= '",tm.em,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
        WHEN 9
          LET l_sql = "SELECT SUM(aao06) FROM aao_file,aag_file",
                      "  WHERE aao00= '",tm.b,"' AND aao01 BETWEEN ? AND ? ",
                      " AND aao03 = '",tm.yy,"'",
                      " AND aag00 = '",tm.b,"' ",    
                      " AND aao04 <= '",tm.em,"' ",
                      " AND aao01 = aag01 AND aag07 IN ('2','3')",
                      " AND aao02 IN (",g_buf CLIPPED,")"  
                   
      END CASE 
      IF cl_null(maj.maj06) THEN
         LET l_sql = ''
         CONTINUE FOREACH
      END IF
      PREPARE g198_sum FROM l_sql
      DECLARE g198_sumc CURSOR FOR g198_sum
      #----------- sql for sum(afc06) ----------------------------------------
      CASE maj.maj06
         WHEN 1
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                      "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041
                       "     AND afc05 < '",tm.bm,"' ",
                       "     AND afbacti = 'Y' "    
         WHEN 2
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "     AND afbacti = 'Y' "    
         WHEN 3
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 <= '",tm.em,"' ",
                       "     AND afbacti = 'Y' "    
         WHEN 4
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                      "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "     AND afbacti = 'Y' "    
         WHEN 5
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "     AND afbacti = 'Y' "    
         WHEN 6
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 < '",tm.bm,"' ",
                       "     AND afbacti = 'Y' "    
         WHEN 7
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 < '",tm.bm,"' ",
                       "     AND afbacti = 'Y' "    
         WHEN 8
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 <= '",tm.em,"' ",
                       "     AND afbacti = 'Y' "    
         WHEN 9
          #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
           LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                       "   FROM afc_file,afb_file",
                       "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                       "     AND afc03=afb03 AND afc04=afb04 ",
                       "     AND afc041=afb041 AND afc042=afb042 ",                #No.FUN-810069 
                       "     AND afc00='",tm.b,"' ",                               #No.FUN-830139
                       "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                       "     AND afb041 IN (",g_buf CLIPPED,")",                   #No.TQC-840049 afb04->afb041 
                       "     AND afc05 <= '",tm.em,"' ",
                       "     AND afbacti = 'Y' "    

      END CASE
#FUN-AB0020 ---------------------Begin---------------------------
      IF NOT cl_null(tm.afc01) THEN
         LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
      END IF
#FUN-AB0020 ---------------------End-----------------------------       
      IF cl_null(maj.maj06) THEN
         LET l_sql1 = ''
         CONTINUE FOREACH
      END IF
      PREPARE g198_sum1 FROM l_sql1
      DECLARE g198_sumc1 CURSOR FOR g198_sum1
 
      LET amt1 = 0 LET amt2 = 0 LET amt  = 0
      IF NOT cl_null(maj.maj21) THEN
         OPEN g198_sumc USING maj.maj21,maj.maj22
         FETCH g198_sumc INTO amt1   
         IF cl_null(amt1) THEN LET amt1 = 0 END IF
         #CHI-A50013 add --start--
        #IF maj.maj09='-' THEN      #MOD-B70110 mark
        #   LET amt1 = amt1 * -1    #MOD-B70110 mark
        #END IF                     #MOD-B70110 mark
         #CHI-A50013 add --end--
         OPEN g198_sumc1 USING maj.maj21,maj.maj22
         FETCH g198_sumc1 INTO amt2
         IF cl_null(amt2) THEN LET amt2 = 0 END IF
      END IF
      IF tm.o = 'Y' THEN                 #匯率的轉換
         LET amt1 = amt1 * tm.q          #科目餘額
         LET amt2 = amt2 * tm.q          #科目預算
      END IF
      IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
         FOR i = 1 TO 100 
             IF maj.maj09 = '-' THEN
                LET g_tot1[i]=g_tot1[i]-amt1     #科目餘額
                LET g_tot2[i]=g_tot2[i]-amt2     #科目預算
             ELSE
                LET g_tot1[i]=g_tot1[i]+amt1     #科目餘額
                LET g_tot2[i]=g_tot2[i]+amt2     #科目預算
             END IF
         END FOR
         LET k=maj.maj08  
         LET m_bal1=g_tot1[k]
         LET m_bal2=g_tot2[k]
         FOR i = 1 TO maj.maj08 
             LET g_tot1[i]=0 LET g_tot2[i]=0 
         END FOR
      ELSE 
         IF maj.maj03 = '5' THEN
            LET m_bal1 = amt1
            LET m_bal2 = amt2
         ELSE
            LET m_bal1=NULL  LET m_bal2=NULL
         END IF   #MOD-810183
      END IF
      IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
         IF l_cn = 1  THEN LET g_basetot1= m_bal1  END IF
         IF l_cn = 2  THEN LET g_basetot2= m_bal1  END IF
         IF l_cn = 3  THEN LET g_basetot3= m_bal1  END IF
         IF l_cn = 4  THEN LET g_basetot4= m_bal1  END IF
         IF l_cn = 5  THEN LET g_basetot5= m_bal1  END IF
         IF l_cn = 6  THEN LET g_basetot6= m_bal1  END IF
         IF l_cn = 7  THEN LET g_basetot7= m_bal1  END IF
         IF l_cn = 8  THEN LET g_basetot8= m_bal1  END IF
         IF l_cn = 9  THEN LET g_basetot9= m_bal1  END IF
         IF l_cn = 10 THEN LET g_basetot10= m_bal1 END IF
         LET g_basetot1= m_bal1
         IF g_basetot1 = 0 THEN LET g_basetot1 = NULL END IF
         IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF
      END IF
      IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
      IF tm.f > 0 AND maj.maj08 < tm.f THEN
         CONTINUE FOREACH                              #最小階數起列印
      END IF
      INSERT INTO g198_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                   maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                   m_bal1,0,m_bal2,0)
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","g198_file",l_cn,maj.maj02,STATUS,"","ins g198_file",1)   #No.FUN-660123
         EXIT FOREACH 
      END IF
   END FOREACH
END FUNCTION

{ 
REPORT g198_rep(sr,sr2,sr3,sr4)  #FUN-560242
   DEFINE l_last_sw   LIKE type_file.chr1    #No.FUN-680098   VARCHAR(I)
   DEFINE l_unit      LIKE zaa_file.zaa08    #No.FUN-680098   VARCHAR(6)  
   define sr2 RECORD 
              l_str1     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str2     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str3     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str4     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str5     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str6     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str7     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str8     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str9     LIKE type_file.num20_6,#No.FUN-680098 dec(20,6)
              l_str10    LIKE type_file.num20_6 #No.FUN-680098 dec(20,6)
             END RECORD 
   DEFINE g_sum1       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum2       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum3       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum4       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum5       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum6       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum7       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum8       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum9       LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum10      LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sum        LIKE type_file.chr20   #No.FUN-680098    VARCHAR(11)
   DEFINE g_sumtotal   LIKE type_file.num20_6 #No.FUN-680098    dec(20,6)	
   DEFINE per1         LIKE fid_file.fid03    #No.FUN-680098    dec(8,3)   
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE sr  RECORD
              maj02     LIKE maj_file.maj02,    #No.FUN-680098  dec(9,2)  
              maj03     LIKE maj_file.maj03,    #No.FUN-680098  VARCHAR(01)   
              maj04     LIKE maj_file.maj04,    #No.FUN-680098  smallint   
              maj05     LIKE maj_file.maj05,    #No.FUN-680098  smallint  
              maj07     LIKE maj_file.maj07,    #No.FUN-680098  VARCHAR(1)  
              maj20     LIKE maj_file.maj20,    #No.FUN-680098  VARCHAR(30)  
              maj20e    LIKE maj_file.maj20e,   #No.FUN-680098  VARCHAR(30)   
              str       LIKE type_file.chr1000, #No.FUN-680098  VARCHAR(300)
              l_total   LIKE type_file.chr20    #No.FUN-680098  VARCHAR(18)
              END RECORD
   DEFINE sr3 RECORD  #新版寫法，部門要拆開，不要一次把十個部門寫入一個字串裡
              l_dept1   LIKE gem_file.gem02,
              l_dept2   LIKE gem_file.gem02,
              l_dept3   LIKE gem_file.gem02,
              l_dept4   LIKE gem_file.gem02,
              l_dept5   LIKE gem_file.gem02,
              l_dept6   LIKE gem_file.gem02,
              l_dept7   LIKE gem_file.gem02,
              l_dept8   LIKE gem_file.gem02,
              l_dept9   LIKE gem_file.gem02,
              l_dept10  LIKE gem_file.gem02
              END RECORD
   DEFINE sr4 RECORD
              l_tot1     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6)
              l_tot2     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot3     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot4     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot5     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot6     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot7     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot8     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot9     LIKE type_file.num20_6, #No.FUN-680098 dec(20,6) 
              l_tot10    LIKE type_file.num20_6  #No.FUN-680098 dec(20,6) 
              END RECORD
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.maj02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
      LET g_pageno = g_pageno + 1
      PRINT g_head CLIPPED, g_pageno USING '<<<'
      #金額單位之列印
      CASE tm.d
           WHEN '1'  LET l_unit = g_x[16]
           WHEN '2'  LET l_unit = g_x[17]
           WHEN '3'  LET l_unit = g_x[18]
           OTHERWISE LET l_unit = ' '
      END CASE
      LET g_x[1] = g_mai02
      PRINT g_x[14] CLIPPED,tm.a,
            COLUMN (g_len-FGL_WIDTH(g_x[1]))/2,g_x[1] CLIPPED,
            COLUMN g_c[38],g_x[19] CLIPPED,tm.p,
            COLUMN g_c[39],g_x[15] CLIPPED,l_unit
         PRINT
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[13])-10)/2,g_x[13] CLIPPED,
            tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&'
      PRINT g_dash
      LET g_zaa[32].zaa08 = sr3.l_dept1 CLIPPED
      LET g_zaa[33].zaa08 = sr3.l_dept2 CLIPPED
      LET g_zaa[34].zaa08 = sr3.l_dept3 CLIPPED
      LET g_zaa[35].zaa08 = sr3.l_dept4 CLIPPED
      LET g_zaa[36].zaa08 = sr3.l_dept5 CLIPPED
      LET g_zaa[37].zaa08 = sr3.l_dept6 CLIPPED
      LET g_zaa[38].zaa08 = sr3.l_dept7 CLIPPED
      LET g_zaa[39].zaa08 = sr3.l_dept8 CLIPPED
      LET g_zaa[40].zaa08 = sr3.l_dept9 CLIPPED
      LET g_zaa[41].zaa08 = sr3.l_dept10 CLIPPED
 
      CALL cl_prt_pos_dyn()                        #TQC-5B0170
 
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],
            g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      IF tm.h='Y' THEN LET sr.maj20=sr.maj20e END IF
      CASE WHEN sr.maj03 = '9' 
             SKIP TO TOP OF PAGE
           WHEN sr.maj03 = '3' 
             PRINT COLUMN g_c[32],g_dash2[1,g_w[32]],
                   COLUMN g_c[33],g_dash2[1,g_w[33]],
                   COLUMN g_c[34],g_dash2[1,g_w[34]],
                   COLUMN g_c[35],g_dash2[1,g_w[35]],
                   COLUMN g_c[36],g_dash2[1,g_w[36]],
                   COLUMN g_c[37],g_dash2[1,g_w[37]],
                   COLUMN g_c[38],g_dash2[1,g_w[38]],
                   COLUMN g_c[39],g_dash2[1,g_w[39]],
                   COLUMN g_c[40],g_dash2[1,g_w[40]],
                   COLUMN g_c[41],g_dash2[1,g_w[41]],
                   COLUMN g_c[42],g_dash2[1,g_w[42]]
           WHEN sr.maj03 = '4' 
             PRINT g_dash2
           OTHERWISE 
             FOR i = 1 TO sr.maj04 PRINT END FOR
             PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,
                   COLUMN g_c[32],cl_numfor(sr4.l_tot1,32,g_azi05) CLIPPED,
                   COLUMN g_c[33],cl_numfor(sr4.l_tot2,33,g_azi05) CLIPPED,
                   COLUMN g_c[34],cl_numfor(sr4.l_tot3,34,g_azi05) CLIPPED,
                   COLUMN g_c[35],cl_numfor(sr4.l_tot4,35,g_azi05) CLIPPED,
                   COLUMN g_c[36],cl_numfor(sr4.l_tot5,36,g_azi05) CLIPPED,
                   COLUMN g_c[37],cl_numfor(sr4.l_tot6,37,g_azi05) CLIPPED,
                   COLUMN g_c[38],cl_numfor(sr4.l_tot7,38,g_azi05) CLIPPED,
                   COLUMN g_c[39],cl_numfor(sr4.l_tot8,39,g_azi05) CLIPPED,
                   COLUMN g_c[40],cl_numfor(sr4.l_tot9,40,g_azi05) CLIPPED,
                   COLUMN g_c[41],cl_numfor(sr4.l_tot10,41,g_azi05) CLIPPED;
             IF sr.maj03 <> 'H' THEN PRINT COLUMN g_c[42] ,sr.l_total ELSE PRINT END IF  #FUN-560242            
      END CASE
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash  #FUN-560242
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT

}
 
FUNCTION g198_bom(l_dept,l_sw)
    DEFINE l_dept  LIKE abd_file.abd01        #No.FUN-680098 VARCHAR(6) 
    DEFINE l_sw    LIKE type_file.chr1        #No.FUN-680098 VARCHAR(1) 
    DEFINE l_abd02 LIKE abd_file.abd02        #No.FUN-680098 VARCHAR(6) 
    DEFINE l_cnt1  LIKE type_file.num5        #No.FUN-680098 smallint
    DEFINE l_cnt2  LIKE type_file.num5        #No.FUN-680098 smallint
    DEFINE l_arr   DYNAMIC ARRAY OF RECORD
                    gem01 LIKE gem_file.gem01,
                    gem05 LIKE gem_file.gem05
                   END RECORD
 
### 98/03/06 REWRITE BY CONNIE,遞迴有誤,故採用陣列作法.....
    LET l_cnt1 = 1
    DECLARE a_curs CURSOR FOR 
     SELECT abd02,gem05 FROM abd_file,gem_file
      WHERE abd01 = l_dept
        AND abd02 = gem01
    FOREACH a_curs INTO l_arr[l_cnt1].*
       LET l_cnt1 = l_cnt1 + 1
    END FOREACH 
 
    FOR l_cnt2 = 1 TO l_cnt1 - 1
        IF l_arr[l_cnt2].gem01 IS NOT NULL THEN 
           CALL g198_bom(l_arr[l_cnt2].*)
        END IF
    END FOR 
    IF l_sw = 'Y' THEN 
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼


###GENGRE###START
FUNCTION aglg198_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE sr2      sr2_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg198")
        IF handler IS NOT NULL THEN
            START REPORT aglg198_rep TO XML HANDLER handler
#           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED          #FUN-B90027  MARK
            #FUN-B90027----add----str--------
            LET l_sql = "SELECT A.*,B.groupno,B.dept_01,B.dept_02,B.dept_03,B.dept_04,B.dept_05,",
              "           B.dept_06,B.dept_07,B.dept_08,B.dept_09,B.dept_10 ",
              "  FROM ",g_cr_db_str CLIPPED,l_table CLIPPED," A",
              "      ,",g_cr_db_str CLIPPED,l_table1 CLIPPED," B",
              " WHERE A.groupno=B.groupno"
            #FUN-B90027----add----str--------
          
            DECLARE aglg198_datacur1 CURSOR FROM l_sql
            FOREACH aglg198_datacur1 INTO sr1.*,sr2.*                                 #FUN-B90027 add sr2.*
                OUTPUT TO REPORT aglg198_rep(sr1.*,sr2.*)                             #FUN-B90027 add sr2.*
            END FOREACH
            FINISH REPORT aglg198_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg198_rep(sr1,sr2)
    DEFINE sr1 sr1_t
    DEFINE sr2 sr2_t                               #FUN-B90027
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B90027----add----str----------
    DEFINE l_tot01  LIKE type_file.num20_6
    DEFINE l_tot02  LIKE type_file.num20_6 
    DEFINE l_tot03  LIKE type_file.num20_6  
    DEFINE l_tot04  LIKE type_file.num20_6   
    DEFINE l_tot05  LIKE type_file.num20_6    
    DEFINE l_tot06  LIKE type_file.num20_6     
    DEFINE l_tot07  LIKE type_file.num20_6      
    DEFINE l_tot08  LIKE type_file.num20_6       
    DEFINE l_tot09  LIKE type_file.num20_6
    DEFINE l_tot10  LIKE type_file.num20_6 
    DEFINE l_sum_tot  LIKE type_file.num20_6
    DEFINE l_sum_tot_fmt STRING         
    DEFINE l_tm_yy  STRING
    DEFINE l_tm_bm  STRING
    DEFINE l_tm_em  STRING
    DEFINE l_period1  STRING                 
    DEFINE l_period2  STRING                  
    DEFINE l_unit    STRING          
    #FUN-B90027----add-end-------------
    ORDER EXTERNAL BY sr1.maj20
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name   #FUN-B90027  add g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.maj20

        
        ON EVERY ROW

            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            #FUN-B90027----add----str-------------
            IF cl_null(sr1.tot01) THEN
               LET l_tot01 = 0
            ELSE
               LET l_tot01 = sr1.tot01
            END IF
            PRINTX l_tot01

            IF cl_null(sr1.tot02) THEN
               LET l_tot02 = 0
            ELSE
               LET l_tot02 = sr1.tot02
            END IF
            PRINTX l_tot02

            IF cl_null(sr1.tot03) THEN
               LET l_tot03 = 0
            ELSE
               LET l_tot03 = sr1.tot03
            END IF
            PRINTX l_tot03

            IF cl_null(sr1.tot04) THEN
               LET l_tot04 = 0
            ELSE
               LET l_tot04 = sr1.tot04
            END IF
            PRINTX l_tot04

            IF cl_null(sr1.tot05) THEN
               LET l_tot05 = 0
            ELSE
               LET l_tot05 = sr1.tot05
            END IF
            PRINTX l_tot05

            IF cl_null(sr1.tot06) THEN
               LET l_tot06 = 0
            ELSE
               LET l_tot06 = sr1.tot06
            END IF
            PRINTX l_tot06

            IF cl_null(sr1.tot07) THEN
               LET l_tot07 = 0
            ELSE
               LET l_tot07 = sr1.tot07
            END IF
            PRINTX l_tot07

            IF cl_null(sr1.tot08) THEN
               LET l_tot08 = 0
            ELSE
               LET l_tot08 = sr1.tot08
            END IF
            PRINTX l_tot08

            IF cl_null(sr1.tot09) THEN
               LET l_tot09 = 0
            ELSE
               LET l_tot09 = sr1.tot09
            END IF
            PRINTX l_tot09

            IF cl_null(sr1.tot10) THEN
               LET l_tot10 = 0
            ELSE
               LET l_tot10 = sr1.tot10
            END IF
            PRINTX l_tot10


            IF sr1.maj03 != '5' THEN
               LET l_sum_tot = l_tot01 + l_tot02+ l_tot03+ l_tot04+ l_tot05+ l_tot06+ l_tot07+ l_tot08+ l_tot09+ l_tot10
            ELSE
               LET l_sum_tot = 0
            END IF
            PRINTX l_sum_tot

            LET l_sum_tot_fmt = cl_gr_numfmt("type_file","num20_6",g_azi05)
            PRINTX l_sum_tot_fmt

            LET l_tm_yy = tm.yy
            LET l_tm_yy = l_tm_yy.trim()
            
            LET l_tm_bm = tm.bm
            LET l_tm_bm = l_tm_bm.trim()

            LET l_tm_em = tm.em
            LET l_tm_em = l_tm_em.trim() 

            IF tm.bm < 10 THEN
               LET l_period1 = l_tm_yy,"/0",l_tm_bm
            ELSE
               LET l_period1 = l_tm_yy,"/",l_tm_bm
            END IF       
            PRINTX l_period1        

            IF tm.em < 10 THEN
               LET l_period2 = l_tm_yy,"/0",l_tm_em
            ELSE
               LET l_period2 = l_tm_yy,"/",l_tm_em
            END IF  
            PRINTX l_period2

            LET l_unit = cl_gr_getmsg("gre-208",g_lang,tm.d)
            PRINTX l_unit
           
        #FUN-B90027----add-str---------------

            PRINTX sr1.*
            PRINTX sr2.*                                   #FUN-B90027

        AFTER GROUP OF sr1.maj20

        
        ON LAST ROW

END REPORT
###GENGRE###END
