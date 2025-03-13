# Prog. Version..:
#
# Pattern name...: cgapr142.4gl
# Descriptions...: 购货发票打印
# Date & Author..: 16/08/24 By huanglf
#HFBG-16030001
#Modify..........: No.MOD181129    18/11/29 By lixwz rvw_file取值换位apa_file,apb_file 

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD                               
              wc      LIKE type_file.chr1000,      
              more    LIKE type_file.chr1          
              END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("cgap")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="rvv06.rvv_file.rvv06,",
             "pmc17.pmc_file.pmc17,",
             "rvw18.rvw_file.rvw18,",  #add by liyjf161109
             "pma02.pma_file.pma02,",
             "nmt02.nmt_file.nmt02,",
             "rvw02.rvw_file.rvw02,",
             
             "rvw01.rvw_file.rvw01,",
             "pmc081.pmc_file.pmc081,",
             "pmc24.pmc_file.pmc24,",
             "pmc52.pmc_file.pmc52,",
             "rvw11.rvw_file.rvw11,",

             "rvw12.rvw_file.rvw12,",
             "num1.type_file.num5,",
             "ima01.ima_file.ima01,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             
             "ima25.ima_file.ima25,",
             "rvw10.rvw_file.rvw10,",
             "rvw17.rvw_file.rvw17,",
             "rvv38t.rvv_file.rvv38t,",
             "rvw05f.rvw_file.rvw05,",
             
             "rvw06f.rvw_file.rvw06,",
             "sum1.rvw_file.rvw05,",
             "rvw08.rvw_file.rvw08,",
             "rvwuser.rvw_file.rvwuser,",
             "gen02.gen_file.gen02,",
             
             "rvworig.rvw_file.rvworig,",
             "gem02.gem_file.gem02,",
             "rvwdate.rvw_file.rvwdate,",
             "azi02.azi_file.azi02,",
             "rvw04.rvw_file.rvw04,",

             "sum2.rvw_file.rvw05,", 
             "rvw05.rvw_file.rvw05,",
             "rvw06.rvw_file.rvw06"
	        #darcy: 取aapt110汇总金额,而不是直接汇总gapi140,因为aapt110会修改发票税额
           #--add by lifang 200422 begin#
            ,",apa34.apa_file.apa34,",
             "apa34f.apa_file.apa34f,",
             "apa32f.apa_file.apa32f,",
             "imaud02.ima_file.imaud02" 
           #--add by lifang 200422 end#                       

   LET  l_table = cl_prt_temptable('cgapr142',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"    #add ??? by lifang 200422     #darcy: add ? 20220316                 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
 
   INITIALIZE tm.* TO NULL         
   LET g_pdate = ARG_VAL(1)       
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)
   
   IF cl_null(tm.wc)
      THEN CALL cgapr142_tm(0,0)          
      ELSE
           CALL cgapr142()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cgapr142_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cgapr142_w AT p_row,p_col WITH FORM "cgap/42f/cgapr142"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON rvw01,rvw02
     
         BEFORE CONSTRUCT
             CALL cl_qbe_init() 
 
       ON ACTION locale 
          CALL cl_show_fld_cont()                    
         LET g_action_choice = "locale"
         EXIT CONSTRUCT
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION controlp
           CASE
              WHEN INFIELD(rvw01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "cq_rvw01"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rvw01
                 NEXT FIELD rvw01
                OTHERWISE
                 EXIT CASE
           END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
         
 
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cgapr142_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
  #UI
   INPUT BY NAME tm.more  WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW cgapr142_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cgapr142'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cgapr142','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc,'\\\"', "'")
         LET l_cmd = l_cmd CLIPPED,        
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cgapr142',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cgapr142_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cgapr142()
   ERROR ""
END WHILE
   CLOSE WINDOW cgapr142_w
END FUNCTION


FUNCTION cgapr142()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     string,       #No.FUN-680137 VARCHAR(3000)  #darcy:2024/07/19 add
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_zo041   LIKE zo_file.zo041,   #FUN-810029 add
          l_zo042   LIKE zo_file.zo042,
          l_zo05    LIKE zo_file.zo05,     #FUN-810029 add
          l_zo09    LIKE zo_file.zo09,     #FUN-810029 add
          sr        RECORD
                    rvv06   like   rvv_file.rvv06,         #送货厂商编号   
                    pmc17   like   pmc_file.pmc17,         #付款方式  
                    rvw18   like   rvw_file.rvw18,   #add by liyjf161109
                    pma02   like   pma_file.pma02,         #付款方式说明
                    nmt02   like   nmt_file.nmt02,         #银行名称
                    rvw02   like   rvw_file.rvw02,         #发票日期 
                                             
                    rvw01   like   rvw_file.rvw01,         #发票号码   
                    pmc081  like   pmc_file.pmc081,        #供应商全名   
                    pmc24   like   pmc_file.pmc24,         #税号  
                    pmc52   like   pmc_file.pmc52,         #发票地址  
                    rvw11   like   rvw_file.rvw11,         #币种  
                                             
                    rvw12   like   rvw_file.rvw12,         #汇率   
                    num1    like   type_file.num5,         #序号
                    ima01   like   ima_file.ima01,         #料件编号 
                    ima02   like   ima_file.ima02,         #料件名称
                    ima021  like   ima_file.ima021,        #料件规格
                                             
                    ima25   like   ima_file.ima25,         #单位   
                    rvw10   like   rvw_file.rvw10,         #数量  
                    rvw17   like   rvw_file.rvw17,         #原币税前单价  
                    rvv38t  like   rvv_file.rvv38t,        #含税单价   
                    rvw05f  like   rvw_file.rvw05,         #税前金额   
                                             
                    rvw06f  like   rvw_file.rvw06,         #税额  
                    sum1    like   rvw_file.rvw05,         #价税合计   
                    rvw08   like   rvw_file.rvw08,         #入库\退货单号   
                    rvwuser like   rvw_file.rvwuser,       #资料所有者   
                    gen02   like   gen_file.gen02,         #人员名称  
                                             
                    rvworig like   rvw_file.rvworig,       #部门编号   
                    gem02   like   gem_file.gem02,         #部门名称   
                    rvwdate like   rvw_file.rvwdate,       #审核日期   
                    azi02   LIKE   azi_file.azi02,
                    rvw04   LIKE   rvw_file.rvw04,

                    sum2    LIKE   rvw_file.rvw05,         #本币金额合计 #add by huanglf160923
                    rvw05   like   rvw_file.rvw05,         #本币税前金额 #add by huanglf160923  
                    rvw06   like   rvw_file.rvw06          #本币税额    #add by huanglf160923
                  #--add by lifang 200422 begin#
                   ,apa34   LIKE   apa_file.apa34,
                    apa34f  LIKE   apa_file.apa34f,
                    apa32f  LIKE   apa_file.apa32f,
                    imaud02 LIKE   ima_file.imaud02   
                  #--add by lifang 200422 end# 
                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5 
   DEFINE l_num     LIKE type_file.num5   
   DEFINE l_rvw01_t   LIKE rvw_file.rvw01
   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   DEFINE l_pmf02        LIKE pmf_file.pmf02
   DEFINE l_pmF03        LIKE pmf_file.pmf03
  #--add by lifang 200422 begin#
   DEFINE l_sum          LIKE apa_file.apa34,
          l_sumf         LIKE apa_file.apa34f,
          l_sum_taxf     LIKE apa_file.apa32f 
  #--add by lifang 200422 end#
  #--add by lifang 200601 begin#
   DEFINE l_apa00 LIKE apa_file.apa00
         ,l_apb29 LIKE apb_file.apb29
         ,l_apa00_1 LIKE type_file.chr1
  #--add by lifang 200601 end#
  #darcy:2024/09/05 add s---
  define l_imaud33   like ima_file.imaud33
  define l_imaud34   like ima_file.imaud34
  #darcy:2024/09/05 add e---

   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cgapr142' 
 
     LET tm.wc = tm.wc CLIPPED 
     #--add by lifang 200422 begin#
     LET l_sum = 0
     LET l_sumf = 0
     LET l_sum_taxf = 0
     #--add by lifang 200422 end# 
LET l_sql=#"select rvv06,pmc17,rvw18,'','',rvw02,rvw01,pmc081,pmc24,pmc52,rvw11,",  #add rvw18 by liyjf161109 
          #"select rvv06,pmc17,apa01 rvw18,'','',rvw02,rvw01,pmc081,pmc24,pmc52,apa13 rvw11,",  #add rvw18 by liyjf161109   #No.MOD181129 mod #markdarcy:2022/09/08
          "select rvv06,apa11,apa01 rvw18,'','',rvw02,rvw01,pmc081,pmc24,pmc52,apa13 rvw11,",  #add rvw18 by liyjf161109   #No.MOD181129 mod #add darcy:2022/09/08
                 #"rvw12,'',ima01,",
                 "apa14 rvw12,'',ima01,",   #No.MOD181129 mod
                 "CASE ima01[1,4] WHEN 'MISC' THEN rvv031 ELSE ima02 END CASE,",  #add by guanyao160826
                 #"ima021,ima25,rvw10,rvw17,rvv38t,rvw05f,",
                 "ima021,ima44,apb09 rvw10,apb23 rvw17,rvv38t,rvw05f,",  #No.MOD181129 mod #darcy:2023/04/25 mod ima25->ima44
                 #"rvw06f,'',rvw08,rvwuser,gen02,rvworig,gem02,rvwdate,'',rvw04,'',rvw05,rvw06",
               #darcy: mod 20220316 s---
               # rvw05,rvw06 直接取gapi140 ,不再关联aapt110
                              # "rvw06f,'',apb21 rvw08,apauser rvwuser,gen02,apaorig rvworig,gem02,apadate rvwdate,'',apa16 rvw04,'',apb24 rvw05,apb10 rvw06", #No.MOD181129 mod     mark by zhangsba190530
                 "rvw06f,'',apb21 rvw08,apauser rvwuser,gen02,apaorig rvworig,gem02,apadate rvwdate,'',apa16 rvw04,'',rvw05,rvw06", #No.MOD181129 mod     #add by zhangsba190530
               #darcy: mod 20220316 e---
               # " ,0,0,0,apa00,apb29,imaud02",   #add by lifang 200601 #mark by liy210831 #顺序错误
                " ,0,0,0,imaud02,apa00,apb29 ", #add by liy210831 
          " from rvw_file,rvv_file,pmc_file,ima_file,gen_file,gem_file",
          ",apa_file,apb_file",         #No.MOD181129 add
          " where ",tm.wc ,
          " and rvw08 = rvv01 and rvw09 = rvv02",
          " and rvv06 = pmc01",
          " and rvv31 = ima01",
          " and gen01 = rvwuser",
          " and gem01 = rvworig",
          " and apa01 = apb01 and apa08 = rvw01 and apb21 =rvw08 and apb22 =rvw09", #No.MOD181129 add
          "   order by rvw01,apb02 "   #add by lifang 200424 apb02 

     PREPARE cgapr142_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cgapr142_curs1 CURSOR FOR cgapr142_prepare1
 LET l_num = 1  
     FOREACH cgapr142_curs1 INTO sr.*
                                ,l_apa00,l_apb29   #add by lifang 200601
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      #darcy:2024/09/05 add s---
      let l_imaud33 = ''
      let l_imaud34 = ''
      select imaud33,imaud34 into l_imaud33,l_imaud34 from ima_file where ima01 = sr.ima01
      if not cl_null(l_imaud33) then let sr.ima021 = sfmt("%1 申请类型：%2",sr.ima021,l_imaud33) end if
      if not cl_null(l_imaud34) then let sr.ima021 = sfmt("%1 用途：%2",sr.ima021,l_imaud34) end if
      #darcy:2024/09/05 add e---
     IF l_rvw01_t IS NULL THEN 
       LET sr.num1 = l_num
       LET l_num = l_num + 1 
     
     ELSE   
       IF l_rvw01_t  = sr.rvw01 THEN 
          LET sr.num1 = l_num
          LET l_num = l_num +  1
       ELSE 
          LET l_num = 1
          LET sr.num1 = l_num
          LET l_num = l_num + 1
       END IF 
     END IF
       LET l_rvw01_t = sr.rvw01
       SELECT pmf02,pmf03 INTO l_pmf02,l_pmf03 FROM pmf_file WHERE pmf01 = sr.rvv06
       SELECT nmt02 INTO sr.nmt02 FROM nmt_file WHERE nmt01 = l_pmf02
       SELECT pma02 INTO sr.pma02 FROM pma_file WHERE pma01 = sr.pmc17 
       SELECT azi02 INTO sr.azi02 FROM azi_file WHERE azi01 = sr.rvw11
       LET sr.sum1 =  sr.rvw05f + sr.rvw06f
      #LET sr.sum2 =  sr.rvw05 +  sr.rvw06 mark by zhangsba190531
      #  LET sr.sum2 =cl_digcut(sr.sum1*sr.rvw12,2)  #add by zhangsba190531 #mark by darcy 220228
      #darcy: mod 20220316 s---
      # aapt110 金额允许 和gapi140 金额不一致
      # 之前调整为汇率相乘计算的时候，是需要和aapt110保持一致。
      #LET sr.sum2 =cl_digcut(sr.rvw10*sr.rvw17*sr.rvw12*(100+sr.rvw04)/100,2)  #add by zhangsba190531 #add by darcy 220228
      #darcy: mod 20220316 e---

      #darcy: add 20220316 s---
      # aapt110 金额允许 和gapi140 金额不一致
      # 之前调整为汇率相乘计算的时候，是需要和aapt110保持一致。
      LET sr.sum2 =  sr.rvw05 +  sr.rvw06
      #darcy: add 20220316 e---

       #--add by lifang 200422 begin#
       LET l_sum = l_sum+sr.sum2
       LET l_sumf = l_sumf+sr.sum1
       LET l_sum_taxf = l_sum_taxf+sr.rvw06f
       LET sr.apa34 =0
       LET sr.apa34f =0
      #SELECT apa34,apa34f,apa32f INTO sr.apa34,sr.apa34f,sr.apa32f   #mark by zhangsba200529
       SELECT (apa31+apa32),(apa31f+apa32f),apa32f INTO sr.apa34,sr.apa34f,sr.apa32f  #add by zhangsba200529  取110单据的税前加税额
         FROM apa_file
       WHERE apa01 = sr.rvw18
     #--mark by lifang 200601 begin#
     # #add by zhangsba200530-s 增加负数显示
     # IF sr.rvw06f < 0 THEN 
     #  	LET  sr.apa32f = sr.apa32f * -1 
     # END IF
     # IF sr.sum1 < 0 THEN 
     #  	LET  sr.apa34f = sr.apa34f * -1 
     # END IF
     # IF sr.sum2 < 0 THEN 
     #  	LET  sr.apa34 = sr.apa34 * -1 
     # END IF
     # #add by zhangsba200529-e
     #--mark by lifang 200601 end#
     #--add by lifang 200601 begin#
       LET l_apa00_1=l_apa00[1,1]
      IF l_apa00_1 ='2' THEN 
         LET sr.apa34=sr.apa34*(-1)
         LET sr.apa34f=sr.apa34f*(-1)
         LET sr.apa32f=sr.apa32f*(-1)
      END IF
      IF l_apa00_1 ='1' AND l_apb29='3' THEN  
      END IF 
     #--add by lifang 200601 end# 
       IF cl_null(sr.apa34) OR sr.apa34 =0 THEN 
          LET sr.apa34 = l_sum
       END IF 
       IF cl_null(sr.apa34f) OR sr.apa34f =0 THEN
          LET sr.apa34f = l_sumf
       END IF
       IF cl_null(sr.apa32f) OR sr.apa32f =0 THEN
           LET sr.apa32f = l_sum_taxf
       END IF  
       #--add by lifang 200422 end# 
       EXECUTE insert_prep USING sr.*
     END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,'rvw01')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc

     CALL cl_prt_cs3('cgapr142','cgapr142',g_sql,g_str)

END FUNCTION
