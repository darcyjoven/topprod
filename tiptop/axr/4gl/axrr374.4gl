# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axrr374.4gl
# Descriptions...: 銷貨發票差異表
# Date & Author..: 95/10/06 by Nick
# Modify.........: No.FUN-4C0100 04/12/28 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-540057 05/05/10 By jackie 發票號碼CHAR（10）改為CHAR（16）
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大
# Modify.........: No.FUN-580121 05/08/22 by saki 報表背景執行功能
# Modify.........: No.TQC-5B0127 05/11/14 By Mandy 立帳匯率與發票匯率呈現不完全
# Modify.........: No.MOD-610061 06/01/16 By Smapmin where 條件remark
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.FUN-750112 07/06/27 By Jackho CR報表修改
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-870151 08/08/15 By xiaofeizhu  匯率調整為用azi07取位
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0043 09/10/14 By sabrina 當報表無資料時，改變顯示的訊息
# Modify.........: No:FUN-9A0018 09/10/29 By mike 将tm.a,tm.b,tm.c三个栏位,改成一个QBE"发票别"(oma05),可开窗挑选要列印出的发票别资料
# Modify.........: No:CHI-A70006 10/07/12 By Summer 增加aza63判斷使用s_azmm 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm RECORD
            #wc         VARCHAR(1000),
             wc         LIKE type_file.chr1000,        #No.FUN-680123 #TQC-840066
            #a,b,c      VARCHAR(1),
            #a,b,c      LIKE type_file.chr1,           #No.FUN-680123  #FUN-9A0018   
            #yy,mm      INTEGER,
             yy,mm      LIKE type_file.num10,          #No.FUN-680123
            #bdate      DATE,
             bdate      LIKE type_file.dat,            #No.FUN-680123
            #edate      DATE,
             edate      LIKE type_file.dat,            #No.FUN-680123
            #more       VARCHAR(1)         # FUN-580121 Input more condition(Y/N)
             more       LIKE type_file.chr1            #No.FUN-680123
          END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680123
DEFINE   i               LIKE type_file.num5          #No.FUN-680123
DEFINE   l_table    STRING                       ### FUN-750112 ###
DEFINE   g_str      STRING                       ### FUN-750112 ###
DEFINE   g_sql      STRING                       ### FUN-750112 ###
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A70006 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A70006 add
DEFINE g_flag        LIKE type_file.chr1       #CHI-A70006 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   #No.FUN-580121 --start--
   LET g_pdate = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_lang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.a = ARG_VAL(8)                  #No.FUN-580121 #FUN-9A0018  
  #LET tm.b = ARG_VAL(9)                  #No.FUN-580121 #FUN-9A0018  
  #LET tm.c = ARG_VAL(10)                 #No.FUN-580121 #FUN-9A0018  
   LET tm.yy = ARG_VAL(11)                #No.FUN-580121
   LET tm.mm = ARG_VAL(12)                #No.FUN-580121
   LET tm.bdate = ARG_VAL(13)             #No.FUN-580121
   LET tm.edate = ARG_VAL(14)             #No.FUN-580121
   LET g_rep_user = ARG_VAL(15)           #No.FUN-570264
   LET g_rep_clas = ARG_VAL(16)           #No.FUN-570264
   LET g_template = ARG_VAL(17)           #No.FUN-570264
   LET g_rpt_name = ARG_VAL(18)  #No.FUN-7C0078
   #No.FUN-580121 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
#--------------------No.FUN-750112--begin----CR(1)----------------#
    LET g_sql = "flag.type_file.chr1,",
                "oma01.oma_file.oma01,",
                "oma02.oma_file.oma02,",
                "oma10.oma_file.oma10,",
                "oma09.oma_file.oma09,",
                "oma23.oma_file.oma23,",
                "oma24.oma_file.oma24,",
                "oma54.oma_file.oma54,",
                "oma56.oma_file.oma56,",
                "oma58.oma_file.oma58,",
                "oma59.oma_file.oma59,",
                "diff.oma_file.oma56,",
                "azi03.azi_file.azi03,",
                "azi04.azi_file.azi04,",
                "azi05.azi_file.azi05,",
                "azi07.azi_file.azi07"     #No.FUN-870151
    LET l_table = cl_prt_temptable('axrr374',g_sql) CLIPPED 
    IF l_table = -1 THEN EXIT PROGRAM END IF               
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)"    #No.FUN-870151 add "?"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
    END IF       
                
   #no.5196   #No.FUN-680123
#   DROP TABLE curr_tmp
#   CREATE TEMP TABLE curr_tmp
#     flag LIKE type_file.chr1,                      
#     amt1 LIKE type_file.num20_6,            
#     amt2 LIKE type_file.num20_6,      
#     amt3 LIKE type_file.chr1,                  
#     amt4 LIKE type_file.chr1)   
   #no.5196(end)   #No.FUN-680123 end
#--------------------No.FUN-750112--end------CR (1) ------------#                 
   #No.FUN-580121 --start--
   IF cl_null(g_bgjob) OR g_bgjob = "N" THEN
      CALL axrr374_tm(0,0)             # Input print condition
   ELSE          
      CALL axrr374()                   # Read data and create out-file
   END IF        
   #No.FUN-580121 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN         
 
FUNCTION axrr374_tm(p_row,p_col)
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123
          l_cmd          LIKE type_file.chr1000       #No.FUN-680123
 
   IF p_row = 0 THEN LET p_row = 5 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 7 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 15
   END IF
 
   OPEN WINDOW axrr374_w AT p_row,p_col
        WITH FORM "axr/42f/axrr374"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
   #No.FUN-580121 --start--
   INITIALIZE tm.* TO NULL
   LET tm.yy   = YEAR(TODAY)
   LET tm.mm   = MONTH(TODAY)
   LET tm.more = "N"
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #No.FUN-580121 ---end---
 
WHILE TRUE
  #FUN-9A0018   ---start                                                                                                            
   CONSTRUCT BY NAME tm.wc ON oma05                                                                                                 
      BEFORE CONSTRUCT                                                                                                              
         CALL cl_qbe_init()                                                                                                         
                                                                                                                                    
      ON ACTION CONTROLP                                                                                                            
         CASE                                                                                                                       
            WHEN INFIELD(oma05)                                                                                                     
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_oma05"                                                                                    
                 LET g_qryparam.state = "c"                                                                                         
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO oma05                                                                               
                 NEXT FIELD oma05                                                                                                   
            OTHERWISE EXIT CASE                                                                                                     
          END CASE                                                                                                                  
      ON ACTION locale                                                                                                              
         CALL cl_show_fld_cont()                                                                                                    
         LET g_action_choice = "locale"                                                                                             
         EXIT CONSTRUCT                                                                                                             
                                                                                                                                    
      ON IDLE g_idle_seconds                                                                                                        
         CALL cl_on_idle()                                                                                                          
         CONTINUE CONSTRUCT    
                                                                                                                                     
      ON ACTION about                                                                                                               
         CALL cl_about()                                                                                                            
                                                                                                                                    
      ON ACTION help                                                                                                                
         CALL cl_show_help()                                                                                                        
                                                                                                                                    
      ON ACTION controlg                                                                                                            
         CALL cl_cmdask()                                                                                                           
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr374_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time                                                                                
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
   IF tm.wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF                                                            
  #FUN-9A0018   ---end  
   INPUT BY NAME tm.yy,tm.mm,tm.more WITHOUT DEFAULTS  #No.FUN-580121 #FUN-9A0018 del tm.a,b,c 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
 
      #No.FUN-580121 --start--
      AFTER FIELD more
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      #No.FUN-580121 ---end---
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
     ON ACTION locale
         #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
         EXIT INPUT
 
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
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr374_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   #CALL s_azm(tm.yy,tm.mm) RETURNING i,tm.bdate,tm.edate #CHI-A70006 mark
   #CHI-A70006 add --start--
    CALL s_get_bookno(tm.yy)
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(tm.yy,tm.mm,g_plant,g_bookno1) RETURNING i,tm.bdate,tm.edate
   ELSE
      CALL s_azm(tm.yy,tm.mm) RETURNING i,tm.bdate,tm.edate
   END IF
   #CHI-A70006 add --end--
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr374'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr374','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",                #No.FUN-580121
                        #" '",tm.a CLIPPED,"'",                 #No.FUN-580121 #FUN-9A0018   
                        #" '",tm.b CLIPPED,"'",                 #No.FUN-580121 #FUN-9A0018   
                        #" '",tm.c CLIPPED,"'",                 #No.FUN-580121 #FUN-9A0018   
                         " '",tm.yy,"'",                        #No.FUN-580121
                         " '",tm.mm,"'",                        #No.FUN-580121
                         " '",tm.bdate,"'",                     #No.FUN-580121
                         " '",tm.edate,"'",                     #No.FUN-580121
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr374',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr374_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr374()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr374_w
END FUNCTION
 
FUNCTION axrr374()
   DEFINE
   	 #l_name    VARCHAR(20),        # External(Disk) file name
          l_name    LIKE type_file.chr20,          #No.FUN-680123
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,       #No.FUN-680123
          l_sql2    STRING,                        #FUN-9A0043 add
          l_cnt     LIKE type_file.num5,           #FUN-9A0043 add
         #l_za05    VARCHAR(40),
          l_za05    LIKE type_file.chr1000,        #No.FUN-680123
          sr        RECORD
                    flag      LIKE type_file.chr1,  	# 1.上月立帳 2.本月立帳        #No.FUN-680123
                   #oma00     VARCHAR(02),
                    oma00     LIKE aba_file.aba18,         #No.FUN-680123
                   #oma02     DATE,
                    oma02     LIKE type_file.dat,            #No.FUN-680123
                   #oma09     DATE,
                    oma09     LIKE type_file.dat,            #No.FUN-680123
                   #oma10     VARCHAR(16),  #MOD-540057
                    oma10     LIKE oea_file.oea01,          #No.FUN-680123 
                   #oma16     VARCHAR(16),  #No.FUN-550071
                    oma16     LIKE oea_file.oea01,         #No.FUN-680123
                   #oma03     VARCHAR(06),
                    oma03     LIKE aab_file.aab02,         #No.FUN-680123
                   #oma032    VARCHAR(08),
                    oma032    LIKE type_file.chr8,           #No.FUN-680123
                   #oma01     VARCHAR(16),  #No.FUN-550071
                    oma01     LIKE oea_file.oea01,         #No.FUN-680123
                   #oma23     VARCHAR(4),
                    oma23     LIKE apo_file.apo02,         #No.FUN-680123
                    oma24     LIKE oma_file.oma24,#TQC-5B0127
                   #oma52     DEC(20,6),
                    oma52     LIKE type_file.num20_6,        #No.FUN-680123
                   #oma53     DEC(20,6),
                    oma53     LIKE type_file.num20_6,        #No.FUN-680123
                   #oma54     DEC(20,6),
                    oma54     LIKE type_file.num20_6,        #No.FUN-680123
                   #oma56     DEC(20,6),
                    oma56     LIKE type_file.num20_6,        #No.FUN-680123
                    oma58     LIKE oma_file.oma58,#TQC-5B0127
                   #oma59     DEC(20,6),
                    oma59     LIKE type_file.num20_6,        #No.FUN-680123
                   #diff      DEC(20,6)
                    diff      LIKE type_file.num20_6         #No.FUN-680123
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #No.FUN-750112  --Begin
     CALL cl_del_data(l_table)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     #No.FUN-750112  --End
 
     IF cl_null(tm.wc) THEN
         LET tm.wc = ' 1=1'
     END IF
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
     #no.5196
#    DELETE FROM curr_tmp;             #FUN-750112 mark
     #no.5196
 
     LET l_sql = " SELECT '',oma00,oma02,oma09,oma10,oma16,oma03,oma032,oma01,",
                 "        oma23,oma24,oma52,oma53,oma54,oma56,oma58,oma59,0 ",
                 "   FROM oma_file ",
                 "  WHERE oma09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "    AND oma10 IS NOT NULL ",
                #"    AND (oma05 = '",tm.a,"' OR oma05 ='",tm.b,"'", #FUN-9A0018     
                #"     OR oma05 ='",tm.c,"')", #FUN-9A0018     
                 "    AND oma00 MATCHES '1*' ",
                 "    AND oma56!=oma59 ",
                 "    AND omavoid='N' ",
                 "    AND ",tm.wc CLIPPED
     display l_sql
     PREPARE axrr374_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
         EXIT PROGRAM
            
     END IF
 
   #FUN-9A0043---add---start---
     LET l_sql2 = " SELECT COUNT(*) ",
                  "   FROM oma_file ",
                  "  WHERE oma09 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                  "    AND oma10 IS NOT NULL ",
                 #"    AND (oma05 = '",tm.a,"' OR oma05 ='",tm.b,"'", #FUN-9A0018     
                 #"     OR oma05 ='",tm.c,"')", #FUN-9A0018     
                  "    AND oma00 MATCHES '1*' ",
                  "    AND oma56!=oma59 ",
                  "    AND omavoid='N' ",
                  "    AND ",tm.wc CLIPPED
     PREPARE axrr374_prepare2 FROM l_sql2
     EXECUTE axrr374_prepare2 INTO l_cnt
   #FUN-9A0043---add---end---
 
     DECLARE axrr374_curs1 CURSOR FOR axrr374_prepare1
 
{
     DECLARE axrr374_curs1 CURSOR FOR
                SELECT '',oma00,oma02,oma09,oma10,oma16,oma03,oma032,oma01,
                       oma23,oma24,oma52,oma53,oma54,oma56,oma58,oma59,0
                  FROM oma_file
                 WHERE oma09 BETWEEN tm.bdate AND tm.edate
                   AND oma10 IS NOT NULL
                   AND (oma05 = tm.a OR oma05 = tm.b OR oma05 = tm.c)
                   AND oma00 MATCHES "1*"
                   AND oma56!=oma59
                   AND omavoid='N'
}
 
#     CALL cl_outnam('axrr374') RETURNING l_name       #FUN-750112 mark
#     START REPORT axrr374_rep TO l_name               #FUN-750112 mark
 
     LET g_pageno = 0
     FOREACH axrr374_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       IF sr.oma02 < tm.bdate
          THEN LET sr.flag='1'
          ELSE LET sr.flag='2'
       END IF
       LET sr.diff=sr.oma56-sr.oma59
#--------------------No.FUN-750112---begin---CR(3)----------------#
      #SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05                #No.FUN-870151   Mark
       SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07  #No.FUN-870151   Add                                                                             
          FROM azi_file                                                                                                               
          WHERE azi01=sr.oma23
       EXECUTE insert_prep USING sr.flag,sr.oma01,sr.oma02,sr.oma10,sr.oma09,sr.oma23,
                                 sr.oma24,sr.oma54,sr.oma56,sr.oma58,sr.oma59,sr.diff,
                                 t_azi03,t_azi04,t_azi05,t_azi07                        #No.FUN-870151 Add t_azi07 
       #no.5196
#        INSERT INTO curr_tmp VALUES(sr.oma23,sr.flag,sr.oma54,sr.oma56,sr.oma59,sr.diff)
       #no.5196(end)
#       OUTPUT TO REPORT axrr374_rep(sr.*)
#--------------------No.FUN-750112---end-----CR(3)----------------#
     END FOREACH
 
   #FUN-9A0043---add---start---
     IF l_cnt = 0 THEN
        CALL cl_err('','axr-054',1)
        RETURN
     END IF
   #FUN-9A0043---add---end---
#--------------------No.FUN-750112---begin---CR(4)----------------#
#     FINISH REPORT axrr374_rep
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
    #LET g_str = g_azi04,";",g_azi05,";",tm.a,";",tm.b,";",tm.c,";",tm.yy,";",tm.mm #FUN-9A0018     
     LET g_str = g_azi04,";",g_azi05,";",'',";",'',";",'',";",tm.yy,";",tm.mm #FUN-9A0018
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('axrr374','axrr374',l_sql,g_str)
#--------------------No.FUN-750112---end-----CR(4)----------------#
END FUNCTION
 
#REPORT axrr374_rep(sr)
#   DEFINE l_amt1,l_amt2,l_amt3,l_amt4   LIKE type_file.num20_6       #No.FUN-680123
#   DEFINE 
#   	 #l_last_sw    VARCHAR(1),
#   	  l_last_sw    LIKE type_file.chr1,           #No.FUN-680123
#         #l_curr       VARCHAR(4),
#          g_head1          STRING,
#         #tot1,tot2,tot3,mmm1,mmm2,mmm3 DEC(20,6),
#          tot1,tot2,tot3,mmm1,mmm2,mmm3 LIKE type_file.num20_6,        #No.FUN-680123
#          sr        RECORD
#                    flag      LIKE type_file.chr1,  	# 1.上月立帳 2.本月立帳        #No.FUN-680123
#                   #oma00     VARCHAR(02),
#                    oma00     LIKE aba_file.aba18,         #No.FUN-680123
#                   #oma02     DATE,
#                    oma02     LIKE type_file.dat,            #No.FUN-680123
#                   #oma09     DATE,
#                    oma09     LIKE type_file.dat,            #No.FUN-680123
#                   #oma10     VARCHAR(16),
#                    oma10     LIKE oea_file.oea01,         #No.FUN-680123
#                   #oma16     VARCHAR(16),  #No.FUN-550071
#                    oma16     LIKE oea_file.oea01,         #No.FUN-680123
#                   #oma03     VARCHAR(06),
#                    oma03     LIKE aab_file.aab02,         #No.FUN-680123
#                   #oma032    VARCHAR(08),
#                    oma032    LIKE type_file.chr8,           #No.FUN-680123
#                   #oma01     VARCHAR(16),  #No.FUN-550071
#                    oma01     LIKE oea_file.oea01,         #No.FUN-680123
#                   #oma23     VARCHAR(4),
#                    oma24     LIKE oma_file.oma24,#TQC-5B0127
#                   #oma52     DEC(20,6),
#                    oma52     LIKE type_file.num20_6,        #No.FUN-680123 
#                   #oma53     DEC(20,6),
#                    oma53     LIKE type_file.num20_6,        #No.FUN-680123
#                   #oma54     DEC(20,6),
#                    oma54     LIKE type_file.num20_6,        #No.FUN-680123
#                   #oma56     DEC(20,6),
#                    oma56     LIKE type_file.num20_6,        #No.FUN-680123
#                    oma58     LIKE oma_file.oma58,#TQC-5B0127
#                   #oma59     DEC(20,6),
#                    oma59     LIKE type_file.num20_6,        #No.FUN-680123
#                   #diff      DEC(20,6)
#                    diff      LIKE type_file.num20_6         #No.FUN-680123
#                    END RECORD
#
#  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
#  ORDER BY sr.flag,sr.oma23,sr.oma02, sr.oma01
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      LET g_head1 = g_x[11] CLIPPED,' ',tm.a,' ',tm.b,' ',tm.c
#      PRINT g_head1
#      LET g_head1 = g_x[12] CLIPPED,' ',tm.yy USING '&&&&','/',tm.mm USING '&&'
#      PRINT g_head1
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],
#            g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
#
#   ON EVERY ROW
#     SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05
#       FROM azi_file
#      WHERE azi01=sr.oma23
#     PRINT COLUMN g_c[31] ,sr.oma01,
#           COLUMN g_c[32],sr.oma02,
#           COLUMN g_c[33],sr.oma10,
#           COLUMN g_c[34],sr.oma09,
#           COLUMN g_c[35],sr.oma23,
#           COLUMN g_c[36],cl_numfor(sr.oma24,36,t_azi04),  #TQC-5B0127
#           COLUMN g_c[37],cl_numfor(sr.oma54,37,t_azi04),
#           COLUMN g_c[38],cl_numfor(sr.oma56,38,g_azi04),
#           COLUMN g_c[39],cl_numfor(sr.oma58,39,t_azi04),  #TQC-5B0127
#           COLUMN g_c[40],cl_numfor(sr.oma59,40,t_azi04),
#           COLUMN g_c[41],cl_numfor(sr.diff,41,t_azi04)
#
#   AFTER GROUP OF sr.flag
#         #no.5196
#         DECLARE curr_temp1 CURSOR FOR
#          SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) FROM curr_tmp
#           WHERE flag=sr.flag
#           GROUP BY curr
# 
#         PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
#               COLUMN g_c[38],g_dash2[1,g_w[38]],
#               COLUMN g_c[40],g_dash2[1,g_w[40]],
#               COLUMN g_c[41],g_dash2[1,g_w[41]]
#         FOREACH curr_temp1 INTO  l_curr,l_amt1,l_amt2,l_amt3,l_amt4
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         IF sr.flag='1' THEN
#               PRINT COLUMN g_c[32],g_x[13] CLIPPED;
#               PRINT COLUMN g_c[35],l_curr CLIPPED;
#         ELSE
#               PRINT COLUMN g_c[32],g_x[14] CLIPPED;
#               PRINT COLUMN g_c[35],l_curr CLIPPED;
#         END IF
#         PRINT COLUMN g_c[37],cl_numfor(l_amt1,37,t_azi05),
#               COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi05),
#               COLUMN g_c[40],cl_numfor(l_amt3,40,t_azi05),
#               COLUMN g_c[41],cl_numfor(l_amt4,41,t_azi05)
#         END FOREACH
#         #no.5196(end)
#   ON LAST ROW
#         #no.5196
#         DECLARE curr_temp2 CURSOR FOR
#          SELECT curr,SUM(amt1),SUM(amt2),SUM(amt3),SUM(amt4) FROM curr_tmp
#           GROUP BY curr
# 
#         PRINT COLUMN g_c[37],g_dash2[1,g_w[37]],
#               COLUMN g_c[38],g_dash2[1,g_w[38]],
#               COLUMN g_c[40],g_dash2[1,g_w[40]],
#               COLUMN g_c[41],g_dash2[1,g_w[41]]
#         FOREACH curr_temp2 INTO l_curr,l_amt1,l_amt2,l_amt3,l_amt4
#             SELECT azi05 into t_azi05
#               FROM azi_file
#               WHERE azi01=l_curr
#         PRINT COLUMN g_c[32],g_x[15] CLIPPED,
#               COLUMN g_c[35],l_curr CLIPPED,
#               COLUMN g_c[37],cl_numfor(l_amt1,37,t_azi05),
#               COLUMN g_c[38],cl_numfor(l_amt2,38,g_azi05),
#               COLUMN g_c[40],cl_numfor(l_amt3,40,t_azi05),
#               COLUMN g_c[41],cl_numfor(l_amt4,41,t_azi05)
#         END FOREACH
#
#   PAGE TRAILER
#      PRINT g_dash[1,g_len]
#END REPORT
