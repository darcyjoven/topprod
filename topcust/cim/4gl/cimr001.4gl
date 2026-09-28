# Prog. Version..:
#
# Pattern name...: cimr001.4gl
# Descriptions...: 产品入库单打印
# Date & Author..: 16/03/03 By yaolf
#HFBG-16030001
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
 
   IF (NOT cl_setup("CIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
   LET g_sql="ina00.ina_file.ina00,",
             "ina04.ina_file.ina04,",
             "gem02.gem_file.gem02,",
             "ina02.ina_file.ina02,",
             "ina01.ina_file.ina01,",
             "inb03.inb_file.inb03,",
             
             "inb04.inb_file.inb04,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021,",
             "inb08.inb_file.inb08,",
             "inb16.inb_file.inb16,",
             
             "inb09.inb_file.inb09,",
             "inb05.inb_file.inb05,",
             "inb06.inb_file.inb06,",
             "inb07.inb_file.inb07,",     #add by jixf 160803
             "ina07.ina_file.ina07,",
             "inb15.inb_file.inb15,",
             "azf03.azf_file.azf03,",
             "inbud02.inb_file.inbud02,",
             "title.type_file.chr30"
          
             

   LET  l_table = cl_prt_temptable('cimr001',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"       #mod by jixf 160803 add?                 
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
   LET tm.more = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12) 
   
   IF cl_null(tm.wc)
      THEN CALL cimr001_tm(0,0)          
      ELSE
           CALL cimr001()                
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cimr001_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cimr001_w AT p_row,p_col WITH FORM "cim/42f/cimr001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
  
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON ina01,ina02
                              
     
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
              WHEN INFIELD(ina01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ina"  #No.TQC-5B0095
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ina01
                 NEXT FIELD ina01
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
      LET INT_FLAG = 0 CLOSE WINDOW cimr001_w 
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
      LET INT_FLAG = 0 CLOSE WINDOW cimr001_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='cimr001'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('cimr001','9031',1)
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
                         " '",tm.more CLIPPED,"'"  ,            #MOD-650024 mark
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('cimr001',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW cimr001_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL cimr001()
   ERROR ""
END WHILE
   CLOSE WINDOW cimr001_w
END FUNCTION


FUNCTION cimr001()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0094
          l_sql     LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(3000)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_oea03   LIKE oea_file.oea03, 
          l_sfb05   LIKE sfb_file.sfb05,
          l_s    LIKE type_file.chr1,
          sr        RECORD
                    ina00    LIKE ina_file.ina00,     #类型
                    ina04    LIKE ina_file.ina04,     #部门编号
                    gem02    LIKE gem_file.gem02,     #部门名称
                    ina02    LIKE ina_file.ina02,     #日期
                    ina01    LIKE ina_file.ina01,     #单据编号
                    inb03    LIKE inb_file.inb03,     #项次
                    
                    inb04    LIKE inb_file.inb04,     #物料料号
                    ima02    LIKE ima_file.ima02,     #物料名称
                    ima021   LIKE ima_file.ima021,    #规格型号
                    inb08    LIKE inb_file.inb08,     #单位
                    inb16    LIKE inb_file.inb16,     #申请数量
                    
                    inb09    LIKE inb_file.inb09,     #实发数量
                    inb05    LIKE inb_file.inb05,     #发货仓库
                    inb06    LIKE inb_file.inb06,     #发货库位
                    inb07    LIKE inb_file.inb07,     #批号
                    ina07    LIKE ina_file.ina07,     #备注
                    inb15    LIKE inb_file.inb15,     #理由码
                    azf03    LIKE azf_file.azf03,     #理由码说明
                    inbud02  LIKE inb_file.inbud02,     #理由码
                    title    LIKE type_file.chr30

                    END RECORD
   DEFINE l_cnt     LIKE type_file.num5            

   DEFINE l_price LIKE ogb_file.ogb13

   DEFINE l_img_blob     LIKE type_file.blob
   LOCATE l_img_blob IN MEMORY             
 

     CALL cl_del_data(l_table) 
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01='cimr001' 
 
     LET tm.wc = tm.wc CLIPPED 
     LET tm.more = tm.more CLIPPED
     
    LET l_sql="select ina00,ina04,'',ina02,ina01,inb03,inb04,ima02,ima021,inb08,inb16,inb09,inb05,inb06,inb07,ina07,inb15,'',inbud02,''",  #mod by jixf 160803 add inb07
           " from inb_file left join ima_file on inb04 = ima01,ina_file ",
           " where ",tm.wc ,
           "   AND ina01=inb01"
     PREPARE cimr001_prepare1 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
        EXIT PROGRAM 
     END IF
     DECLARE cimr001_curs1 CURSOR FOR cimr001_prepare1
     

     FOREACH cimr001_curs1 INTO sr.*

     LET tm.more = sr.ina00
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
     #MOD-zhangxk170705  add --begin--
     #IF tm.more = '1' THEN LET sr.title = '杂发单' END IF
     IF tm.more = '1' THEN LET sr.title = '仓库杂项发料单' END IF
     IF tm.more = '2' THEN LET sr.title = 'WIP杂项发料单' END IF
     #IF tm.more = '3' THEN LET sr.title = '入库单' END IF
     IF tm.more = '3' THEN LET sr.title = '仓库杂项收料单' END IF
     IF tm.more = '4' THEN LET sr.title = 'WIP杂项收料单' END IF
     #IF tm.more = '5' THEN LET sr.title = '库存杂项报废单' END IF
     IF tm.more = '5' THEN LET sr.title = '库存仓库报废单' END IF   
     IF tm.more = '6' THEN LET sr.title = 'WIP库存报废单' END IF   
     #MOD-zhangxk170705  add  --end--
     SELECT azf03 INTO sr.azf03 FROM azf_file WHERE azf01 = sr.inb15 
     SELECT gem02 INTO sr.gem02 FROM gem_file WHERE gem01 = sr.ina04
     EXECUTE insert_prep USING sr.*
     END FOREACH
     
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN
        CALL cl_wcchp(tm.wc,',ina01,ina02')
             RETURNING tm.wc
     END IF
     LET g_str = tm.wc
     #FUN-zhangxk170707  --begin--
     LET tm.more = sr.ina00
     IF tm.more = '1' THEN
     CALL cl_prt_cs3('cimr001','cimr001',g_sql,g_str)
     END IF 
     IF tm.more = '2' THEN
     CALL cl_prt_cs3('cimr001','cimr001',g_sql,g_str)
     END IF 
     LET l_name = "cimr001_2"
     IF tm.more = '3' THEN
     CALL cl_prt_cs3('cimr001',l_name,g_sql,g_str)
     END IF 
     IF tm.more = '4' THEN
     CALL cl_prt_cs3('cimr001',l_name,g_sql,g_str)
     END IF 
     IF tm.more = '5' THEN
#     CALL cl_prt_cs3('cimr001',l_name,g_sql,g_str)
      CALL cl_prt_cs3('cimr001','cimr001',g_sql,g_str) 
    END IF 
     LET l_name = "cimr001_3"
     IF tm.more = '6' THEN
    # CALL cl_prt_cs3('cimr001',l_name,g_sql,g_str)
     CALL cl_prt_cs3('cimr001','cimr001',g_sql,g_str)
      END IF 
     #FUN-zhangxk170707  --end--


END FUNCTION
