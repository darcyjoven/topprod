# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglr192.4gl
# Descriptions...: 多部門財務報表
# Date & Author..: 96/10/17 By Danny
# Modify.........: No.MOD-4C0156 04/12/24 By Kitty 帳別無法開窗 
# Modify.........: No.MOD-530366 05/03/26 By Echo 金額單位只能選千及百萬,不能選元,選元無法確定 
# Modify.........: No.MOD-540022 05/04/11 By Nicola 基準比印不出
# Modify.........: No.FUN-570021 05/07/04 By Sarah 改成新版寫法,處理無法轉Excel的問題
# Modify.........: No.TQC-630238 06/03/28 By Smapmin 增加afbacti='Y'的判斷
# Modify.........: No.TQC-630157 06/04/04 By Smapmin 新增是否列印下層部門的選項
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660141 06/07/07 By xumin  帳別權限修改 
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680098 06/08/31 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6C0012 07/01/12 By Judy 報表調整
# Modify.........: No.FUN-6C0068 07/01/17 By rainy 報表結構加檢查使用者及部門設限
# Modify.........: No.FUN-6B0021 07/03/15 By jamie 族群欄位開窗查詢
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/10 By mike    會計科目加帳套
# Modify.........: No.FUN-740020 07/04/12 By dxfwo   會計科目加帳套
# Modify.........: No.TQC-760073 07/06/12 By johnray 調整欄位輸入順序
# Modify.........: NO.FUN-810069 08/02/29 By destiny 預算編號改為預算項目
# Modify.........: No.FUN-830139 08/04/07 By bnlent 去掉預算項目字段
# Modify.........: No.MOD-850160 08/05/19 By Sarah r192_file裡的maj02改成LIKE maj_file.maj02
# Modify.........: No.MOD-850272 08/05/27 By Sarah 未考量maj03='5'的情況,須將m_bal1=amt1,m_bal2=amt2
# Modify.........: No.MOD-870314 08/07/31 By Sarah 當sr.maj07='2'時,sr.bal2不需乘上-1
# Modify.........: No.FUN-830053 08/03/24 By johnray 結構報表改CR  
#                                08/09/11 By Cockroach CR21-->31
# Modify.........: No.MOD-8C0187 08/12/22 By Sarah 實際金額應抓afc07(已消耗預算)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0057 09/12/08 By wujie 報表數據傳錯，報表編號開窗按選擇的類型來區分
# Modify.........: No:MOD-9C0100 09/12/24 By sabrina 無法顯示出預算金額
# Modify.........: No:FUN-9C0155 09/12/29 By Huangrh #CALL cl_dynamic_locale()  remark
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A30049 10/03/11 By lutingting GP5.2使用環境變數改為以FGL_GETENV引用
# Modify.........: No:CHI-A50008 10/05/10 By Summer 轉撥前營業毛利預算金額,應為營業收入-營業成本
# Modify.........: No:MOD-A50038 10/08/03 By sabrina 將l_base1~l_base6欄位放大成number(20,6)
# Modify.........: No:CHI-A70046 10/08/11 By Summer 百分比需依金額單位顯示
# Modify.........: No:CHI-A70050 10/10/26 By sabrina 計算合計階段需增加maj09的控制 
# Modify.........: No:FUN-AB0020 10/11/08 By lixh1   添加預算項目(afc01)欄位 
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No:CHI-B60055 11/06/15 By Sarah 預算金額應含追加和挪用部份
# Modify.........: No:MOD-B60232 11/06/27 By Sarah g_buf與l_sql宣告改用STRING
# Modify.........: No.FUN-B80057 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No.MOD-BC0217 11/12/22 By Polly 修正ON ACTION CONTROLP組mai03時的條件
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C50042 12/05/07 By zhangweib 修改開窗q_mai去除報表性質為5\6的資料

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              rtype   LIKE type_file.chr1,              #No.FUN-680098 VARCHAR(1)
              a       LIKE maj_file.maj01,              #報表結構編號  #No.FUN-680098 VARCHAR(6) 
              b       LIKE aaa_file.aaa01,              #帳別編號      #No.FUN-670039
              abe01   LIKE abe_file.abe01,              #列印族群/部門 #No.FUN-680098 VARCHAR(6) 
              yy      LIKE type_file.num5,              #輸入年度      #No.FUN-680098 smallint 
              bm      LIKE type_file.num5,              #Begin 期別    #No.FUN-680098 smallint
              em      LIKE type_file.num5,              # End  期別    #No.FUN-680098 smallint
              afc01   LIKE afc_file.afc01,              #預算項目       #FUN-AB0020
              c       LIKE type_file.chr1,              #異動額及餘額為0者是否列印 #No.FUN-680098char(1) 
              d       LIKE type_file.chr1,              #金額單位      #No.FUN-680098 VARCHAR(1) 
              f       LIKE type_file.num5,              #列印最小階數  #No.FUN-680098 smallint
              h       LIKE type_file.chr4,              #額外說明類別  #No.FUN-680098 VARCHAR(4) 
              o       LIKE type_file.chr1,              #轉換幣別否    #No.FUN-680098 VARCHAR(1) 
              p       LIKE azi_file.azi01,              #幣別
              q       LIKE azj_file.azj03,              #匯率
              r       LIKE azi_file.azi01,              #幣別
              s       LIKE type_file.chr1,              #列印下層部門   #TQC-630157 #No.FUN-680098
              more    LIKE type_file.chr1               #Input more condition(Y/N)   #No.FUN-680098
              END RECORD,
          m_abd02    LIKE abd_file.abd02,       #No.FUN-680098  VARCHAR(6) 
          i,j,k,g_mm LIKE type_file.num5,       #No.FUN-680098  smallint
          g_unit     LIKE type_file.num10,      #金額單位基數   #No.FUN-680098 integer
          g_dash3    LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(400) 
          g_buf      STRING,                    #MOD-B60232 mod #LIKE type_file.chr1000,    #No.FUN-680098  char(400) 
          g_cn       LIKE type_file.num5,       #No.FUN-680098  smallint
          g_gem05    LIKE gem_file.gem05,
          m_dept     LIKE type_file.chr1000,    #No.FUN-680098  VARCHAR(300) 
          g_mai02    LIKE mai_file.mai02,
          g_mai03    LIKE mai_file.mai03,
          g_abe01    LIKE abe_file.abe01,
          g_tot1     ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6)
          g_tot2     ARRAY[100] OF LIKE type_file.num20_6,     #No.FUN-680098 dec(20,6) 
          g_basetot1 LIKE type_file.num20_6,                   #No.FUN-680098 dec(20,6) 
          g_basetot2 LIKE type_file.num20_6,                   #No.FUN-680098 dec(20,6) 
          g_basetot3 LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
          g_basetot4 LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
          g_basetot5 LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
          g_basetot6 LIKE type_file.num20_6,#No.FUN-680098 dec(20,6) 
          g_no       LIKE type_file.num5,   #No.FUN-680098 smallint
          g_dept     DYNAMIC ARRAY OF RECORD 
                 gem01 LIKE gem_file.gem01, #部門編號
                 gem05 LIKE gem_file.gem05  #是否為會計部門
                 END RECORD
DEFINE   g_aaa03         LIKE aaa_file.aaa03   
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose    #No.FUN-680098  SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000  #No.FUN-680098  VARCHAR(72)
DEFINE g_sql      STRING                                                                                                            
DEFINE l_table    STRING                  #MOD-9A0192 mod chr20->STRING
DEFINE g_str      STRING                                                                                                            
 
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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114 #FUN-BB0047 mark
 
 
   LET g_pdate = ARG_VAL(2)                 #Get arguments from command line
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.rtype  = ARG_VAL(8)
   LET tm.a  = ARG_VAL(9)
   LET tm.b  = ARG_VAL(10)   #TQC-630157
   LET tm.abe01 = ARG_VAL(11)
   LET tm.yy = ARG_VAL(12)
   LET tm.bm = ARG_VAL(13)
   LET tm.em = ARG_VAL(14)
   LET tm.afc01 = ARG_VAL(15)     #FUN-AB0020
   LET tm.c  = ARG_VAL(16)
   LET tm.d  = ARG_VAL(17)
   LET tm.f  = ARG_VAL(18)
   LET tm.h  = ARG_VAL(19)
   LET tm.o  = ARG_VAL(20)
   LET tm.p  = ARG_VAL(21)
   LET tm.q  = ARG_VAL(22)
   LET tm.r  = ARG_VAL(23)   #TQC-630157
   LET tm.s  = ARG_VAL(24)   #TQC-630157
   LET g_rep_user = ARG_VAL(25)
   LET g_rep_clas = ARG_VAL(26)
   LET g_template = ARG_VAL(27)
 
   LET g_sql = "maj02.maj_file.maj02,",                                                                                             
               "maj03.maj_file.maj03,",                                                                                             
               "maj04.maj_file.maj04,",                                                                                             
               "maj05.maj_file.maj05,",                                                                                             
               "maj07.maj_file.maj07,",                                                                                             
               "maj20.maj_file.maj20,",                                                                                             
               "maj20e.maj_file.maj20e,",                                                                                           
               "page.type_file.num5,",                                                                                              
               "line.type_file.num5,",                                                                                              
               "l_dept1.gem_file.gem02,",                                                                                           
               "l_dept2.gem_file.gem02,",                                                                                           
               "l_dept3.gem_file.gem02,",                                                                                           
               "l_dept4.gem_file.gem02,",                                                                                           
               "l_dept5.gem_file.gem02,",                                                                                           
               "l_dept6.gem_file.gem02,",                                                                                           
               "l_amount1.aah_file.aah04,",                                                                                         
              #"l_base1.con_file.con06,",       #MOD-A50038 mark                                                                                         
               "l_base1.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff1.type_file.num20_6,",                                                                                        
               "l_per1.con_file.con06,",                                                                                            
               "l_amount2.aah_file.aah04,",                                                                                         
              #"l_base2.con_file.con06,",       #MOD-A50038 mark 
               "l_base2.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff2.type_file.num20_6,",                                                                                        
               "l_per2.con_file.con06,",                                                                                            
               "l_amount3.aah_file.aah04,",                                                                                         
              #"l_base3.con_file.con06,",       #MOD-A50038 mark                                                                                        
               "l_base3.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff3.type_file.num20_6,",                                                                                        
               "l_per3.con_file.con06,",                                                                                            
               "l_amount4.aah_file.aah04,",                                                                                         
              #"l_base4.con_file.con06,",       #MOD-A50038 mark                                                                                      
               "l_base4.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff4.type_file.num20_6,",                                                                                        
               "l_per4.con_file.con06,",                                                                                            
               "l_amount5.aah_file.aah04,",                                                                                         
              #"l_base5.con_file.con06,",       #MOD-A50038 mark                                                                                     
               "l_base5.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff5.type_file.num20_6,",                                                                                        
               "l_per5.con_file.con06,",                                                                                            
               "l_amount6.aah_file.aah04,",                                                                                         
              #"l_base6.con_file.con06,",       #MOD-A50038 mark                                                                                     
               "l_base6.type_file.num20_6,",    #MOD-A50038 add 
               "l_diff6.type_file.num20_6,",                                                                                        
               "l_per6.con_file.con06"                                                                                              
   LET l_table = cl_prt_temptable('aglr192',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
 
   DROP TABLE r192_file
   CREATE TEMP TABLE r192_file(
        no LIKE type_file.num5,  
     maj02 LIKE maj_file.maj02,    #MOD-850160 mod
     maj03 LIKE maj_file.maj03,
     maj04 LIKE maj_file.maj04,
     maj05 LIKE maj_file.maj05,
     maj07 LIKE maj_file.maj07,
     maj20 LIKE maj_file.maj20,
     maj20e LIKE maj_file.maj20e,
     bal1  LIKE type_file.num20_6,
     per1  LIKE con_file.con06,
     bal2  LIKE type_file.num20_6,
     per2  LIKE con_file.con06)
   IF cl_null(tm.b) THEN LET tm.b = g_aaz.aaz64 END IF    #No.FUN-740020 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL r192_tm()                        # Input print condition
   ELSE
      CALL r192()         
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
FUNCTION r192_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098 smallint
          l_sw           LIKE type_file.chr1,         #重要欄位是否空白 #No.FUN-680098 VARCHAR(1)
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098    VARCHAR(400)
   DEFINE li_chk_bookno  LIKE type_file.num5          #No.FUN-670005    #No.FUN-680098 smallint
   DEFINE li_result      LIKE type_file.num5          #No.FUN-6C0068
   DEFINE l_azfacti      LIKE azf_file.azfacti        #FUN-AB0020
   CALL s_dsmark(tm.b)       #No.FUN-740020 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 11
   END IF
   OPEN WINDOW r192_w AT p_row,p_col
        WITH FORM "agl/42f/aglr192" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
   CALL  s_shwact(0,0,tm.b)            #No.FUN-740020 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   #使用預設帳別之幣別
   IF tm.b IS NULL OR tm.b = ' 'THEN      #No.FUN-740020                                                                            
    LET tm.b = g_aza.aza81                #No.FUN-740020                                                                            
   END IF                                 #No.FUN-740020
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.b  #No.FUN-740020 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.b,"",SQLCA.sqlcode,"","sel aaa:",0)  # NO.FUN-660123 #No.FUN-740020 
   END IF
   LET tm.c = 'N'
   LET tm.d = '2'
   LET tm.f = 0
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
    INPUT BY NAME tm.rtype,tm.b,tm.a,tm.abe01,tm.yy,tm.bm,tm.em,
                  tm.afc01,        #FUN-AB0020
                  tm.f,tm.d,tm.c,tm.h,tm.s,tm.o,tm.r,   #TQC-630157 #No.FUN-830139 del tm.budget
                  tm.p,tm.q,tm.more WITHOUT DEFAULTS  
         BEFORE INPUT
             CALL cl_qbe_init()
 
       ON ACTION locale
          CALL cl_dynamic_locale()                  #No:FUN-9C0155 remark
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
      AFTER FIELD a
         IF tm.a IS NULL THEN NEXT FIELD a END IF
         CALL s_chkmai(tm.a,'RGL') RETURNING li_result
         IF NOT li_result THEN
           CALL cl_err(tm.a,g_errno,1)
           NEXT FIELD a
         END IF
         SELECT mai02,mai03 INTO g_mai02,g_mai03 FROM mai_file
                WHERE mai01 = tm.a AND maiacti IN ('Y','y')
                  AND mai00 = tm.b  #No.FUN-740020    
         IF STATUS THEN 
            CALL cl_err3("sel","mai_file",tm.a,"",STATUS,"","sel mai:",0)  # NO.FUN-660123
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
         #No.FUN-670005--begin
             CALL s_check_bookno(tm.b,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                NEXT FIELD b
             END IF 
             #No.FUN-670005--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.b AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#           CALL cl_err('sel aaa:',STATUS,0) # NO.FUN-660123
            CALL cl_err3("sel","aaa_file",tm.b,"",STATUS,"","sel aaa:",0)  # NO.FUN-660123
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
          IF tm.d IS NULL THEN   #MOD-530366
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
            CALL cl_err3("sel","azi_file",tm.p,"","agl-109","","sel azi:",0)  # NO.FUN-660123
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION CONTROLP
         IF INFIELD(a) THEN
    CALL cl_init_qry_var()
    LET g_qryparam.form = 'q_mai'
    LET g_qryparam.default1 = tm.a
  #-----------------------MOD-BC0217-------------start
   #IF tm.rtype ='1' THEN
   #   LET g_qryparam.where = " mai03 ='2' "
   #ELSE
   #   LET g_qryparam.where = " mai03 ='3' "
   #END IF
    CASE
       WHEN tm.rtype = '1'
          LET g_qryparam.where = " mai03 ='2' "
       WHEN tm.rtype = '2'
          LET g_qryparam.where = " mai03 ='3' "
      #No.TQC-C50042   ---start---   Add
       OTHERWISE
          LET g_qryparam.where = " mai03 NOT IN ('5','6') "
      #No.TQC-C50042   ---end---     Add
       END CASE
   #-----------------------MOD-BC0217---------------end

    CALL cl_create_qry() RETURNING tm.a
            DISPLAY BY NAME tm.a
            NEXT FIELD a
         END IF
         IF  INFIELD(b) THEN
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r192_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='aglr192'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('aglr192','9031',1)   
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",tm.b CLIPPED,"'" , #No.FUN-740020 
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
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
                         " '",tm.afc01 CLIPPED,"'",      #FUN-AB0020                   
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
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('aglr192',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r192_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r192()
   ERROR ""
END WHILE
   CLOSE WINDOW r192_w
END FUNCTION
 
FUNCTION r192()
   DEFINE l_name    LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098  VARCHAR(20)  
   DEFINE l_name1   LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
   DEFINE l_sql     STRING                      #MOD-B60232 mod   #LIKE type_file.chr1000      # RDSQL STATEMENT        #No.FUN-680098  char(1000)
   DEFINE l_chr     LIKE type_file.chr1         #No.FUN-680098    VARCHAR(1)
   DEFINE l_tmp     LIKE type_file.num20_6      #No.FUN-680098    dec(20,6)       
   DEFINE l_leng,l_leng2   LIKE type_file.num5     #No.FUN-680098 smallint
   DEFINE l_abe03   LIKE abe_file.abe03
   DEFINE l_gem02   LIKE gem_file.gem02
   DEFINE l_dept    LIKE gem_file.gem01
   DEFINE sr  RECORD
              no        LIKE type_file.num5,       #No.FUN-680098   SMALLINT
              maj02     LIKE maj_file.maj02,       #No.FUN-680098   dec(9,4)
              maj03     LIKE maj_file.maj03,       #No.FUN-680098   VARCHAR(1)
              maj04     LIKE maj_file.maj04,       #No.FUN-680098   smallint
              maj05     LIKE maj_file.maj05,       #No.FUN-680098   smallint
              maj07     LIKE maj_file.maj07,       #No.FUN-680098   VARCHAR(1)
              maj20     LIKE maj_file.maj20,       #No.FUN-680098   VARCHAR(30) 
              maj20e    LIKE maj_file.maj20e,      #No.FUN-680098   VARCHAR(50) 
              bal1      LIKE type_file.num20_6,    #實際        #No.FUN-680098 DEC(20,6)
              per1      LIKE con_file.con06,       #基準百分比  #No.FUN-680098 DEC(9,5)
              bal2      LIKE type_file.num20_6,    #差異        #No.FUN-680098 DEC(20,6)
              per2      LIKE con_file.con06        #差異百分比  #No.FUN-680098 DEC(9,5)
              END RECORD
   DEFINE sr2 RECORD  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              l_dept1   LIKE gem_file.gem02,
              l_dept2   LIKE gem_file.gem02,
              l_dept3   LIKE gem_file.gem02,
              l_dept4   LIKE gem_file.gem02,
              l_dept5   LIKE gem_file.gem02,
              l_dept6   LIKE gem_file.gem02
              END RECORD
   DEFINE sr3 RECORD  #新版寫法，所有金額、百分比要拆開，不要把所有的數值寫入一>
              l_amount1   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base1     LIKE con_file.con06,      # 基準比 #No.FUN-680098dec(9,5)      #MOD-A50038 mark 
              l_base1     LIKE type_file.num20_6,   # 基準比 #No.FUN-680098dec(9,5)      #MOD-A50038 add 
              l_diff1     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per1      LIKE con_file.con06,      #百分比  #No.FUN-680098dec(9,5)
              l_amount2   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base2     LIKE con_file.con06,      #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 mark   
              l_base2     LIKE type_file.num20_6,   #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 add 
              l_diff2     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per2      LIKE con_file.con06,      #百分比  #No.FUN-680098dec(9,5)
              l_amount3   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base3     LIKE con_file.con06,      #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 mark
              l_base3     LIKE type_file.num20_6,   #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 add
              l_diff3     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per3      LIKE con_file.con06,      #百分比  #No.FUN-680098dec(9,5)
              l_amount4   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base4     LIKE con_file.con06,      #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 mark
              l_base4     LIKE type_file.num20_6,   #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 add
              l_diff4     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per4      LIKE con_file.con06,      #百分比  #No.FUN-680098dec(9,5)
              l_amount5   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base5     LIKE con_file.con06,      #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 mark
              l_base5     LIKE type_file.num20_6,   #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 add
              l_diff5     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per5      LIKE con_file.con06,      # 百分比 #No.FUN-680098dec(9,5)
              l_amount6   LIKE aah_file.aah04,      #金    額#No.FUN-680098dec(20,6)
             #l_base6     LIKE con_file.con06,      #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 mark
              l_base6     LIKE type_file.num20_6,   #基準比  #No.FUN-680098dec(9,5)      #MOD-A50038 add
              l_diff6     LIKE type_file.num20_6,   #差    異#No.FUN-680098dec(20,6)
              l_per6      LIKE con_file.con06       #百分比  #No.FUN-680098dec(9,5)
              END RECORD
 
   DEFINE l_str,l_str1,l_str2,l_str3,l_str4,l_str5,l_str6  LIKE type_file.chr1000#No.FUN-680098 VARCHAR(300)
   DEFINE l_no,l_cn,l_cnt,l_i LIKE type_file.num5    #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1  LIKE type_file.chr1000       #No.FUN-680098 VARCHAR(400)
   DEFINE l_amt         LIKE type_file.num20_6       #No.FUN-680098 dec(20,6)
   DEFINE l_rep_cnt     LIKE type_file.num5,         #No.FUN-680098 smallint
          l_channel     base.Channel,
          l_channel1    base.Channel,
          l_xml_str     STRING,
          l_row_cnt     LIKE type_file.num5         #FUN-570021  #No.FUN-680098 SMALLINT
  
   LET g_pageno = 0
   SELECT aaf03 INTO g_company FROM aaf_file WHERE aaf01 = tm.b
      AND aaf02 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglr192'
   SELECT azi05 INTO g_azi05 FROM azi_file where azi01=tm.p  #FUN-570021
   CALL cl_del_data(l_table)                                                                                                        
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                                          
               "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",                                                                          
               "        ?,?,?,?,?, ?,?,?,?)"                                                                                        
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80057--add--
      EXIT PROGRAM                                                                             
   END IF                                                                                                                           
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 223 END IF
   FOR g_i = 1 TO g_len LET g_dash3[g_i,g_i] = '=' END FOR
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
 
   CASE WHEN tm.rtype='0' LET g_msg=" 1=1"
        WHEN tm.rtype='1'
        #  LET g_msg=" substr(maj23,1,1)='1'"
           LET g_msg=" maj23[1,1]='1'"   #FUN-B40029   
        WHEN tm.rtype='2'
        #     LET g_msg=" substr(maj23,1,1)='2'"
              LET g_msg=" maj23[1,1]='2'"   #FUN-B40029
        OTHERWISE LET g_msg=" 1=1"
   END CASE
   LET l_sql = "SELECT * FROM maj_file",
               " WHERE maj01 = '",tm.a,"'",
               "   AND ",g_msg CLIPPED,
               " ORDER BY maj02"
   PREPARE r192_p FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
      EXIT PROGRAM 
   END IF
   DECLARE r192_c CURSOR FOR r192_p
 
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
   ELSE                                    #--- 族群
      LET g_no = 0
      DECLARE r192_bom CURSOR FOR
       SELECT abe03,gem05 FROM abe_file,gem_file 
      WHERE abe01=tm.abe01 AND gem01=abe03
        ORDER BY 1
      FOREACH r192_bom INTO l_abe03,l_chr
          IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
          LET g_no = g_no + 1
          LET g_dept[g_no].gem01 = l_abe03
          LET g_dept[g_no].gem05 = l_chr
      END FOREACH
   END IF
#控制一次印六個部門---------------------------------
   LET l_cnt=(6-(g_no MOD 6))+g_no     ###一行 6 個
   LET l_rep_cnt = 0   #FUN-570021
   FOR l_i = 6 TO l_cnt STEP 6
        CALL g_x.clear()
        INITIALIZE sr2.* TO NULL
        INITIALIZE sr3.* TO NULL
 
       LET g_cn = 0 
       LET g_basetot1 = 0 LET g_basetot2 = 0 LET g_basetot3 = 0 
       LET g_basetot4 = 0 LET g_basetot5 = 0 LET g_basetot6 = 0 
       DELETE FROM r192_file
       LET m_dept = ''
       IF l_i <= g_no THEN
          LET l_no = l_i - 6
          FOR l_cn = 1 TO 6 
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
              LET l_leng2 = LENGTH(l_gem02)
              LET l_leng2 = 28 - l_leng2
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02
              ELSE 
                 LET m_dept = m_dept CLIPPED,24 SPACES,l_leng2 SPACES,
                              l_gem02
              END IF
#START FUN-570021  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1 LET sr2.l_dept1  = l_gem02
                   WHEN 2 LET sr2.l_dept2  = l_gem02
                   WHEN 3 LET sr2.l_dept3  = l_gem02
                   WHEN 4 LET sr2.l_dept4  = l_gem02
                   WHEN 5 LET sr2.l_dept5  = l_gem02
                   WHEN 6 LET sr2.l_dept6  = l_gem02
              END CASE
              IF tm.s = 'Y' THEN
                 CALL r192_bom(l_dept,l_chr)
              END IF
 
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
             #LET l_leng=LENGTH(g_buf)                        #MOD-B60232 mark
             #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B60232 mark
              LET l_leng= g_buf.getlength()                   #MOD-B60232
              LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B60232
              CALL r192_process(l_cn)
              LET g_cn = l_cn
          END FOR
       ELSE
          LET l_no = (l_i - 6)
          FOR l_cn = 1 TO (g_no - (l_i - 6))
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
              LET l_leng2 = LENGTH(l_gem02)
              LET l_leng2 = 28 - l_leng2
              IF l_cn = 1 THEN
                 LET m_dept = l_gem02
              ELSE 
                 LET m_dept = m_dept CLIPPED,24 SPACES,l_leng2 SPACES,
                              l_gem02
              END IF
#START FUN-570021  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              CASE l_cn
                   WHEN 1 LET sr2.l_dept1  = l_gem02
                   WHEN 2 LET sr2.l_dept2  = l_gem02
                   WHEN 3 LET sr2.l_dept3  = l_gem02
                   WHEN 4 LET sr2.l_dept4  = l_gem02
                   WHEN 5 LET sr2.l_dept5  = l_gem02
                   WHEN 6 LET sr2.l_dept6  = l_gem02
              END CASE
              IF tm.s = 'Y' THEN
                 CALL r192_bom(l_dept,l_chr)
              END IF
              IF g_buf IS NULL THEN LET g_buf="'",l_dept CLIPPED,"'," END IF
             #LET l_leng=LENGTH(g_buf)                        #MOD-B60232 mark
             #LET g_buf=g_buf[1,l_leng-1] CLIPPED             #MOD-B60232 mark
              LET l_leng= g_buf.getlength()                   #MOD-B60232
              LET g_buf = g_buf.substring(1,l_leng-1) CLIPPED #MOD-B60232
              CALL r192_process(l_cn)
              LET g_cn = l_cn
          END FOR
       END IF
       DECLARE tmp_curs CURSOR FOR
          SELECT * FROM r192_file ORDER BY maj02,no
       IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOR END IF
       FOREACH tmp_curs INTO sr.*
         IF STATUS THEN CALL cl_err('tmp_curs',STATUS,1) EXIT FOREACH END IF
 
         IF sr.maj07='2' THEN 
            LET sr.bal1=sr.bal1*-1
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
            IF g_unit!=0 THEN
               LET sr.bal1 = sr.bal1 / g_unit    #實際
               LET sr.bal2 = sr.bal2 / g_unit    #差異值
            END IF
         LET l_amt = sr.bal1 - sr.bal2           #差異值 = 實際 - 預算 (需以換算過單位的結果呈現) #CHI-A70046 add
 
         IF sr.no = 1 THEN
            LET l_str1 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount1 = sr.bal1
            LET sr3.l_base1 = sr.bal2
            LET sr3.l_diff1 = l_amt
            LET sr3.l_per1  = sr.per2
         END IF
         IF sr.no = 2 THEN
            LET l_str2 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount2 = sr.bal1
            LET sr3.l_base2 = sr.bal2
            LET sr3.l_diff2 = l_amt
            LET sr3.l_per2  = sr.per2
         END IF
         IF sr.no = 3 THEN
            LET l_str3 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount3 = sr.bal1
            LET sr3.l_base3 = sr.bal2
            LET sr3.l_diff3 = l_amt
            LET sr3.l_per3  = sr.per2
         END IF
         IF sr.no = 4 THEN
            LET l_str4 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount4 = sr.bal1
            LET sr3.l_base4 = sr.bal2
            LET sr3.l_diff4 = l_amt
            LET sr3.l_per4  = sr.per2
         END IF
         IF sr.no = 5 THEN
            LET l_str5 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount5 = sr.bal1
            LET sr3.l_base5 = sr.bal2
            LET sr3.l_diff5 = l_amt
            LET sr3.l_per5  = sr.per2
         END IF
         IF sr.no = 6 THEN
            LET l_str6 = sr.bal1 USING '--,---,---,---,--&',' ',
                         sr.per1 USING '---&.&&',' ',
                         sr.bal2 USING '--,---,---,---,--&',' ',
                         sr.per2 USING '---&.&&'
            LET sr3.l_amount6 = sr.bal1
            LET sr3.l_base6 = sr.bal2
            LET sr3.l_diff6 = l_amt
            LET sr3.l_per6  = sr.per2
         END IF
         IF sr.no = g_cn THEN
            IF (tm.c='N' OR sr.maj03='2') AND
               sr.maj03 MATCHES "[012]" AND 
               (l_str1[1,18]='                 0' OR cl_null(l_str1[1,18])) AND
               (l_str2[1,18]='                 0' OR cl_null(l_str2[1,18])) AND
               (l_str3[1,18]='                 0' OR cl_null(l_str3[1,18])) AND
               (l_str4[1,18]='                 0' OR cl_null(l_str4[1,18])) AND
               (l_str5[1,18]='                 0' OR cl_null(l_str5[1,18])) AND
               (l_str6[1,18]='                 0' OR cl_null(l_str6[1,18])) THEN
               CONTINUE FOREACH                              #餘額為 0 者不列印
            END IF
            LET l_str = l_str1 CLIPPED,' ',l_str2 CLIPPED,' ',l_str3 CLIPPED,' ',
                        l_str4 CLIPPED,' ',l_str5 CLIPPED,' ',l_str6 CLIPPED
            LET l_str1 = '' LET l_str2 = '' LET l_str3 = ''
            LET l_str4 = '' LET l_str5 = '' LET l_str6 = ''
           IF sr3.l_amount1 IS NULL THEN LET sr3.l_amount1 = 0 END IF
           IF sr3.l_base1   IS NULL THEN LET sr3.l_base1   = 0 END IF
           IF sr3.l_diff1   IS NULL THEN LET sr3.l_diff1   = 0 END IF
           IF sr3.l_per1    IS NULL THEN LET sr3.l_per1    = 0 END IF
           IF sr3.l_amount2 IS NULL THEN LET sr3.l_amount2 = 0 END IF
           IF sr3.l_base2   IS NULL THEN LET sr3.l_base2   = 0 END IF
           IF sr3.l_diff2   IS NULL THEN LET sr3.l_diff2   = 0 END IF
           IF sr3.l_per2    IS NULL THEN LET sr3.l_per2    = 0 END IF
           IF sr3.l_amount3 IS NULL THEN LET sr3.l_amount3 = 0 END IF
           IF sr3.l_base3   IS NULL THEN LET sr3.l_base3   = 0 END IF
           IF sr3.l_diff3   IS NULL THEN LET sr3.l_diff3   = 0 END IF
           IF sr3.l_per3    IS NULL THEN LET sr3.l_per3    = 0 END IF
           IF sr3.l_amount4 IS NULL THEN LET sr3.l_amount4 = 0 END IF
           IF sr3.l_base4   IS NULL THEN LET sr3.l_base4   = 0 END IF
           IF sr3.l_diff4   IS NULL THEN LET sr3.l_diff4   = 0 END IF
           IF sr3.l_per4    IS NULL THEN LET sr3.l_per4    = 0 END IF
           IF sr3.l_amount5 IS NULL THEN LET sr3.l_amount5 = 0 END IF
           IF sr3.l_base5   IS NULL THEN LET sr3.l_base5   = 0 END IF
           IF sr3.l_diff5   IS NULL THEN LET sr3.l_diff5   = 0 END IF
           IF sr3.l_per5    IS NULL THEN LET sr3.l_per5    = 0 END IF
           IF sr3.l_amount6 IS NULL THEN LET sr3.l_amount6 = 0 END IF
           IF sr3.l_base6   IS NULL THEN LET sr3.l_base6   = 0 END IF
           IF sr3.l_diff6   IS NULL THEN LET sr3.l_diff6   = 0 END IF
           IF sr3.l_per6    IS NULL THEN LET sr3.l_per6    = 0 END IF
           #CHI-A50008 add --start--
           IF sr3.l_base1<0 THEN LET sr3.l_base1=sr3.l_base1*-1 END IF
           IF sr3.l_base2<0 THEN LET sr3.l_base2=sr3.l_base2*-1 END IF
           IF sr3.l_base3<0 THEN LET sr3.l_base3=sr3.l_base3*-1 END IF
           IF sr3.l_base4<0 THEN LET sr3.l_base4=sr3.l_base4*-1 END IF
           IF sr3.l_base5<0 THEN LET sr3.l_base5=sr3.l_base5*-1 END IF
           IF sr3.l_base6<0 THEN LET sr3.l_base6=sr3.l_base6*-1 END IF
           #CHI-A50008 add --end--
           IF sr.maj04 = 0 THEN                                                                                                     
              EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,                                                        
                                        sr.maj07,sr.maj20,sr.maj20e,l_i,'2',sr2.*,sr3.*                                             
              IF STATUS THEN                                                                                                        
                 CALL cl_err("execute insert_prep:",STATUS,1)                                                                       
                 EXIT FOR                                                                                                           
              END IF                                                                                                                
           ELSE                                                                                                                     
              EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,                                                        
                                        sr.maj07,sr.maj20,sr.maj20e,l_i,'2',sr2.*,sr3.*                                             
              IF STATUS THEN                                                                                                        
                 CALL cl_err("execute insert_prep:",STATUS,1)                                                                       
                 EXIT FOR                                                                                                           
              END IF                                                                                                                
              #空行的部份,以寫入同樣的maj20資料列進Temptable,                                                                       
              #但line=1來區別(line=2表示是非空行的資料),再用排序的方式,                                                             
              #讓空行的這筆資料排在正常的資料前面印出                                                                               
              FOR i = 1 TO sr.maj04                                                                                                 
                 EXECUTE insert_prep USING sr.maj02,sr.maj03,sr.maj04,sr.maj05,   
                                           sr.maj07,sr.maj20,sr.maj20e,l_i,'1',sr2.*,sr3.*                                          
                 IF STATUS THEN                                                                                                     
                    CALL cl_err("execute insert_prep:",STATUS,1)                                                                    
                    EXIT FOR                                                                                                        
                 END IF                                                                                                             
              END FOR                                                                                                               
           END IF                                                                                                                   
 
         END IF
    END FOREACH
 
        IF os.Path.chrwx(l_name1 CLIPPED || ".xml" ,511) THEN END IF #No.FUN-9C0009
  
        IF l_rep_cnt = 0 THEN
            LET l_name = l_name1
            LET l_rep_cnt = 1
        ELSE
               LEt l_row_cnt = 0
               LET l_channel = base.Channel.create()
               LET l_cmd = "unset LANG; wc -l ", l_name1 CLIPPED,".xml | awk '{ print $1 }'"
               CALL l_channel.openPipe(l_cmd, "r")
               WHILE l_channel.read(l_row_cnt)
               END WHILE
               CALL l_channel.close()
               IF l_row_cnt > 1 THEN
                    LET l_cmd1='cat ',l_name1 CLIPPED,'.xml >>',l_name CLIPPED,'.xml'  
                    RUN l_cmd1                                                        
                    LET l_rep_cnt = l_rep_cnt + 1
               END IF
        END IF
   END FOR
   LET g_xml_rep = l_name CLIPPED,".xml"
  
   LET l_i = 1
   LET l_channel = base.Channel.create()
   LET l_channel1 = base.Channel.create()
   LET l_str2 = g_xml_rep CLIPPED,"1.xml"
   CALL l_channel.openFile(g_xml_rep CLIPPED, "r")
   CALL l_channel.setDelimiter("\n")
   CALL l_channel1.openFile(l_str2 CLIPPED, "a" )
   CALL l_channel1.setDelimiter("")
   LET l_xml_str=l_channel.readLine()
   WHILE l_xml_str IS NOT NULL
      IF (l_xml_str.getIndexOf("</Report>",1)) > 0 AND (l_i <> l_rep_cnt) THEN
         LET l_xml_str = l_channel.readLine()
         LET l_xml_str = l_channel.readLine()
         LET l_i = l_i + 1
      ELSE
         CALL l_channel1.write(l_xml_str)
         LET l_xml_str = l_channel.readLine()
      END IF
   END WHILE
   CALL l_channel.close()
   CALL l_channel1.close()
  LET l_cmd = "cp $TEMPDIR/",l_str2 CLIPPED," $TEMPDIR/",g_xml_rep CLIPPED  #FUN-A30049 #10/05/10為過單暫時將A30049修改內容恢復 
  # LET l_cmd = "cp ",os.Path.join(FGL_GETENV("TEMPDIR"),l_str2 CLIPPED),       #FUN-A30049
  #             " ",os.Path.join(FGL_GETENV("TEMPDIR"),g_xml_rep CLIPPED)       #FUN-A30049
   RUN l_cmd
   IF os.Path.chrwx(g_xml_rep CLIPPED,511) THEN END IF   #No.FUN-9C0009
   LET l_cmd = 'rm -f ',l_str2 CLIPPED
   RUN l_cmd
   LET g_str = g_aaz.aaz77,";",g_mai02,";",tm.a,";",tm.p,";",tm.yy USING '<<<<',";",                                                
               tm.bm USING'&&',";",tm.em USING'&&',";",tm.d,";",tm.h,";",g_azi05                                                    
   LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   CALL cl_prt_cs3('aglr192','aglr192',g_sql,g_str)                                                                                 
END FUNCTION
 
FUNCTION r192_process(l_cn)
   DEFINE l_sql,l_sql1   STRING                  #MOD-B60232 mod   #LIKE type_file.chr1000   #No.FUN-680098   char(1000)
   DEFINE l_cn           LIKE type_file.num5     #No.FUN-680098   smallint
   DEFINE amt1,amt2,amt  LIKE type_file.num20_6  #No.FUN-680098   DEC(20,6)
   DEFINE maj            RECORD LIKE maj_file.*
   DEFINE m_bal1,m_bal2  LIKE type_file.num20_6  #No.FUN-680098    DEC(20,6)
   DEFINE l_amt          LIKE type_file.num20_6  #No.FUN-680098    DEC(20,6)
   DEFINE m_per1,m_per2  LIKE con_file.con06     #No.FUN-680098    dec(9,5)      
 
    LET l_sql = "SELECT SUM(afc07) FROM afc_file,afb_file",
                "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                "     AND afc03=afb03 AND afc04=afb04 ",
                "     AND afc041=afb041 AND afb042=afc042 ",             #No.FUN-810069
                "     AND afc00='",tm.b,"' ",                            #No.FUN-830139
                "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                "     AND afb041 IN (",g_buf CLIPPED,")",                #MOD-9C0100 afb04 modify afb041
                "     AND afc05 BETWEEN '",tm.bm,"' AND '",g_mm,"'",
                "     AND afbacti = 'Y' "    #TQC-630238

#FUN-AB0020 ---------------------Begin---------------------------
    IF NOT cl_null(tm.afc01) THEN
       LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
    END IF
#FUN-AB0020 ---------------------End-----------------------------                  
    PREPARE r192_sum FROM l_sql
    DECLARE r192_sumc CURSOR FOR r192_sum
    IF STATUS THEN CALL cl_err('sum prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
   #LET l_sql1 ="SELECT SUM(afc06) ",                                                 #CHI-B60055 mark
    LET l_sql1 ="SELECT SUM(COALESCE(afc06,0)+COALESCE(afc08,0)+COALESCE(afc09,0))",  #CHI-B60055
                "   FROM afc_file,afb_file",
                "   WHERE afc00=afb00 AND afc01=afb01 AND afc02=afb02", 
                "     AND afc03=afb03 AND afc04=afb04 ",
                "     AND afc041=afb041 AND afb042=afc042 ",             #No.FUN-810069
                "     AND afc00='",tm.b,"' ",                            #No.FUN-830139
                "     AND afc02 BETWEEN ? AND ? AND afc03='",tm.yy,"'",
                "     AND afb041 IN (",g_buf CLIPPED,")",                #MOD-9C0100 afb04 modify afb041 
                "     AND afc05 BETWEEN '",tm.bm,"' AND '",g_mm,"'",
                "     AND afbacti = 'Y' "    #TQC-630238
#FUN-AB0020 ---------------------Begin---------------------------
    IF NOT cl_null(tm.afc01) THEN
       LET l_sql = l_sql," AND afc01 = '",tm.afc01,"'"
    END IF
#FUN-AB0020 ---------------------End-----------------------------                 
    PREPARE r192_sum1 FROM l_sql1
    DECLARE r192_sumc1 CURSOR FOR r192_sum1
    IF STATUS THEN CALL cl_err('sum1 prepare',STATUS,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
       EXIT PROGRAM 
    END IF
    FOREACH r192_c INTO maj.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET amt1 = 0 LET amt2 = 0 LET amt  = 0
        IF NOT cl_null(maj.maj21) THEN
           OPEN r192_sumc USING maj.maj21,maj.maj22
           FETCH r192_sumc INTO amt1   
           IF cl_null(amt1) THEN LET amt1 = 0 END IF
           OPEN r192_sumc1 USING maj.maj21,maj.maj22
           FETCH r192_sumc1 INTO amt2
           IF cl_null(amt2) THEN LET amt2 = 0 END IF
        END IF
        IF tm.o = 'Y' THEN                 #匯率的轉換
           LET amt1 = amt1 * tm.q          #科目餘額
           LET amt2 = amt2 * tm.q          #科目預算
        END IF
       #CHI-A70050---mark---start---
       ##CHI-A50008 add --start--
       #IF maj.maj09='-' THEN
       #   LET amt2=amt2*-1
       #END IF
       ##CHI-A50008 add --end--
       #CHI-A70050---mark---end---
        IF maj.maj03 MATCHES "[012]" AND maj.maj08 > 0 THEN   #合計階數處理
           FOR i = 1 TO 100 
              #CHI-A70050---modify---start---
              #LET g_tot1[i]=g_tot1[i]+amt1     #科目餘額
              #LET g_tot2[i]=g_tot2[i]+amt2     #科目預算
               IF maj.maj09 = '-' THEN
                  LET g_tot1[i]=g_tot1[i]-amt1     #科目餘額
                  LET g_tot2[i]=g_tot2[i]-amt2     #科目預算
               ELSE
                  LET g_tot1[i]=g_tot1[i]+amt1     #科目餘額
                  LET g_tot2[i]=g_tot2[i]+amt2     #科目預算
               END IF
              #CHI-A70050---modify---end---
           END FOR
           LET k=maj.maj08  
           LET m_bal1=g_tot1[k]
           LET m_bal2=g_tot2[k]
          #CHI-A70050---add---start---
           IF maj.maj07 = '1' AND maj.maj09 = '-' THEN
              LET m_bal1 = m_bal1 *-1
              LET m_bal2 = m_bal2 *-1
           END IF
          #CHI-A70050---add---end---
           FOR i = 1 TO maj.maj08 
               LET g_tot1[i]=0 LET g_tot2[i]=0 
           END FOR
        ELSE 
           IF maj.maj03 = '5' THEN
              LET m_bal1 = amt1  LET m_bal2 = amt2
           ELSE
              LET m_bal1 = NULL  LET m_bal2 = NULL
           END IF
        END IF
        IF maj.maj11 = 'Y' THEN                  # 百分比基準科目
           IF l_cn = 1 THEN LET g_basetot1= m_bal1 END IF
           IF l_cn = 2 THEN LET g_basetot2= m_bal1 END IF
           IF l_cn = 3 THEN LET g_basetot3= m_bal1 END IF
           IF l_cn = 4 THEN LET g_basetot4= m_bal1 END IF
           IF l_cn = 5 THEN LET g_basetot5= m_bal1 END IF
           IF l_cn = 6 THEN LET g_basetot6= m_bal1 END IF
           #IF maj.maj07='2' THEN LET g_basetot1=g_basetot1*-1 END IF #CHI-A50008 mark
        END IF
        IF maj.maj03='0' THEN CONTINUE FOREACH END IF #本行不印出
        IF tm.f > 0 AND maj.maj08 < tm.f THEN
           CONTINUE FOREACH                              #最小階數起列印
        END IF
        INSERT INTO r192_file VALUES(l_cn,maj.maj02,maj.maj03,maj.maj04,
                                     maj.maj05,maj.maj07,maj.maj20,maj.maj20e,
                                     m_bal1,0,m_bal2,0)
        IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err3("ins","r192_file",l_cn,maj.maj02,SQLCA.sqlcode,"","ins r192_file",1)   #No.FUN-660123
           EXIT FOREACH
        END IF
    END FOREACH
END FUNCTION
 
REPORT r192_rep(sr,sr2,sr3)
   DEFINE l_last_sw    LIKE type_file.chr1   #No.FUN-680098  VARCHAR(1)
   DEFINE l_unit       LIKE zaa_file.zaa08   #No.FUN-680098  VARCHAR(4)
   DEFINE per1         LIKE fid_file.fid03   #No.FUN-680098  dec(8,3)
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE sr  RECORD
              maj02     LIKE maj_file.maj02,     #No.FUN-680098 dec(9,2)
              maj03     LIKE type_file.chr1,     #No.FUN-680098  VARCHAR(1)
              maj04     LIKE maj_file.maj04,     #No.FUN-680098 smallint
              maj05     LIKE maj_file.maj05,     #No.FUN-680098 smallint
              maj07     LIKE maj_file.maj07,     #No.FUN-680098  VARCHAR(1)
              maj20     LIKE maj_file.maj20,     #No.FUN-680098  VARCHAR(30)
              maj20e    LIKE maj_file.maj20e,    #No.FUN-680098  VARCHAR(30)
              str       LIKE type_file.chr1000  #No.FUN-680098   VARCHAR(300)
              END RECORD
   DEFINE sr2 RECORD  #新版寫法，部門要拆開，不要一次把六個部門寫入一個字串裡
              l_dept1   LIKE gem_file.gem02,
              l_dept2   LIKE gem_file.gem02,
              l_dept3   LIKE gem_file.gem02,
              l_dept4   LIKE gem_file.gem02,
              l_dept5   LIKE gem_file.gem02,
              l_dept6   LIKE gem_file.gem02
              END RECORD
   DEFINE sr3 RECORD  #新版寫法，所有金額、百分比要拆開，不要把所有的數值寫入一>
              l_amount1  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base1    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base1    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff1    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per1     LIKE con_file.con06,     #百分比      #No.FUN-680098 dec(9.5)  
              l_amount2  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base2    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base2    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff2    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per2     LIKE con_file.con06,     #百分比      #No.FUN-680098 dec(9.5)  
              l_amount3  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base3    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base3    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff3    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per3     LIKE con_file.con06,     #百分比      #No.FUN-680098 dec(9.5)  
              l_amount4  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base4    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base4    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff4    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per4     LIKE con_file.con06,     #百分比      #No.FUN-680098 dec(9.5)  
              l_amount5  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base5    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base5    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff5    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per5     LIKE con_file.con06,     #百分比      #No.FUN-680098 dec(9.5)  
              l_amount6  LIKE aah_file.aah04,     #金    額    #No.FUN-680098 dec(20,6)
             #l_base6    LIKE con_file.con06,     #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 mark   
              l_base6    LIKE type_file.num20_6,  #基準比      #No.FUN-680098 dec(9.5)     #MOD-A50038 add 
              l_diff6    LIKE type_file.num20_6,  #差    異    #No.FUN-680098 dec(20,6)
              l_per6     LIKE con_file.con06      #百分比      #No.FUN-680098 dec(9.5)  
              END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.maj02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      LET g_pageno = g_pageno +1
      LET pageno_total = PAGENO USING '<<<',"/pageno"   
 
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
            COLUMN g_c[44],g_x[19] CLIPPED,tm.p,
            COLUMN g_c[45],g_x[15] CLIPPED,l_unit      #FUN-570021
      PRINT COLUMN (g_len-FGL_WIDTH(g_x[13])-10)/2,g_x[13] CLIPPED,
            tm.yy USING '<<<<','/',tm.bm USING'&&','-',tm.em USING'&&'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash
      PRINT COLUMN g_c[32]+(g_w[32]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept1 CLIPPED,
            COLUMN g_c[36]+(g_w[36]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept2 CLIPPED,
            COLUMN g_c[40]+(g_w[40]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept3 CLIPPED,
            COLUMN g_c[44]+(g_w[44]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept4 CLIPPED,
            COLUMN g_c[48]+(g_w[48]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept5 CLIPPED,
            COLUMN g_c[52]+(g_w[52]-FGL_WIDTH(sr2.l_dept1))/2,sr2.l_dept6 CLIPPED
      PRINT g_dash2
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],
            g_x[45],g_x[46],g_x[47],g_x[48],g_x[49],g_x[50],g_x[51],
            g_x[52],g_x[53],g_x[54],g_x[55]
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
                   COLUMN g_c[42],g_dash2[1,g_w[42]],
                   COLUMN g_c[43],g_dash2[1,g_w[43]],
                   COLUMN g_c[44],g_dash2[1,g_w[44]],
                   COLUMN g_c[45],g_dash2[1,g_w[45]],
                   COLUMN g_c[46],g_dash2[1,g_w[46]],
                   COLUMN g_c[47],g_dash2[1,g_w[47]],
                   COLUMN g_c[48],g_dash2[1,g_w[48]],
                   COLUMN g_c[49],g_dash2[1,g_w[49]],
                   COLUMN g_c[50],g_dash2[1,g_w[50]],
                   COLUMN g_c[51],g_dash2[1,g_w[51]],
                   COLUMN g_c[52],g_dash2[1,g_w[52]],
                   COLUMN g_c[53],g_dash2[1,g_w[53]],
                   COLUMN g_c[54],g_dash2[1,g_w[54]],
                   COLUMN g_c[55],g_dash2[1,g_w[55]]
            WHEN sr.maj03 = '4' 
             PRINT g_dash2
           OTHERWISE 
             FOR i = 1 TO sr.maj04 PRINT END FOR
               PRINT sr.maj05 SPACES,sr.maj20 CLIPPED,
                     COLUMN g_c[32],cl_numfor(sr3.l_amount1,32,g_azi05) CLIPPED,
                     COLUMN g_c[33],sr3.l_base1 USING '---&.&&' CLIPPED,
                     COLUMN g_c[34],cl_numfor(sr3.l_diff1,34,g_azi05) CLIPPED,
                     COLUMN g_c[35],sr3.l_per1 USING '---&.&&' CLIPPED,
                     COLUMN g_c[36],cl_numfor(sr3.l_amount2,36,g_azi05) CLIPPED,
                     COLUMN g_c[37],sr3.l_base2 USING '---&.&&' CLIPPED,
                     COLUMN g_c[38],cl_numfor(sr3.l_diff2,38,g_azi05) CLIPPED,
                     COLUMN g_c[39],sr3.l_per2 USING '---&.&&' CLIPPED,
                     COLUMN g_c[40],cl_numfor(sr3.l_amount3,40,g_azi05) CLIPPED,
                     COLUMN g_c[41],sr3.l_base3 USING '---&.&&' CLIPPED,
                     COLUMN g_c[42],cl_numfor(sr3.l_diff3,42,g_azi05) CLIPPED,
                     COLUMN g_c[43],sr3.l_per3 USING '---&.&&' CLIPPED,
                     COLUMN g_c[44],cl_numfor(sr3.l_amount4,44,g_azi05) CLIPPED,
                     COLUMN g_c[45],sr3.l_base4 USING '---&.&&' CLIPPED,
                     COLUMN g_c[46],cl_numfor(sr3.l_diff4,46,g_azi05) CLIPPED,
                     COLUMN g_c[47],sr3.l_per4 USING '---&.&&' CLIPPED,
                     COLUMN g_c[48],cl_numfor(sr3.l_amount5,48,g_azi05) CLIPPED,
                     COLUMN g_c[49],sr3.l_base5 USING '---&.&&' CLIPPED,
                     COLUMN g_c[50],cl_numfor(sr3.l_diff5,50,g_azi05) CLIPPED,
                     COLUMN g_c[51],sr3.l_per5 USING '---&.&&' CLIPPED,
                     COLUMN g_c[52],cl_numfor(sr3.l_amount6,52,g_azi05) CLIPPED,
                     COLUMN g_c[53],sr3.l_base6 USING '---&.&&' CLIPPED,
                     COLUMN g_c[54],cl_numfor(sr3.l_diff6,54,g_azi05) CLIPPED,
                     COLUMN g_c[55],sr3.l_per6 USING '---&.&&' CLIPPED
      END CASE
 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash   #FUN-570021
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
END REPORT
 
FUNCTION r192_bom(l_dept,l_sw)
    DEFINE l_dept  LIKE abd_file.abd01    #No.FUN-680098 VARCHAR(6)
    DEFINE l_sw    LIKE type_file.chr1    #No.FUN-680098 VARCHAR(1)
    DEFINE l_abd02  LIKE abd_file.abd02   #No.FUN-680098 VARCHAR(6) 
    DEFINE l_cnt1,l_cnt2 LIKE type_file.num5       #No.FUN-680098 SMALLINT
    DEFINE l_arr DYNAMIC ARRAY OF RECORD
             gem01 LIKE gem_file.gem01,
             gem05 LIKE gem_file.gem05
           END RECORD
 
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
           CALL r192_bom(l_arr[l_cnt2].*)
        END IF
    END FOR 
    IF l_sw = 'Y' THEN 
       LET g_buf=g_buf CLIPPED,"'",l_dept CLIPPED,"',"
    END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼
