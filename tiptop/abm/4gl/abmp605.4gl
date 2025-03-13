# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abmp605.4gl 
# Descriptions...: 低阶码更新巨集作业(针对于abmp603的优化程序) FUN-BA0119 
# Date & Author..: 12/05/03 By SunLM  将原来先运算第一遍不考虑取替代的运算,第二遍才考虑取替代的逻辑变为1次完成

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
          yy         INTEGER,
          mm         INTEGER,
          max_level  SMALLINT,
          sw         VARCHAR(01)           
          END RECORD,
       g_bma01       LIKE bma_file.bma01,  #产品结构单头
       g_sma18       LIKE sma_file.sma18,  #低阶码是否需重新计算
       g_ans         VARCHAR(01),
       g_date        DATE,      
       g_argv1       VARCHAR(01),
       p_row,p_col   SMALLINT
DEFINE g_chr         VARCHAR(1)
DEFINE g_cnt         INTEGER   
DEFINE g_msg         VARCHAR(72)
DEFINE l_flag        VARCHAR(1),
       g_change_lang VARCHAR(01)           #是否有做语言切换      

MAIN    #FUN-BA0119 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                    # Supress DEL key function

   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy = ARG_VAL(1)
   LET tm.mm = ARG_VAL(2)
   LET tm.max_level = ARG_VAL(3)
   LET tm.sw = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   IF s_shut(0) THEN EXIT PROGRAM END IF
   LET g_date  = TODAY  
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p603_tm()
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            CALL p603_t()
            IF g_success = 'Y' THEN
               CALL cl_end2(1) RETURNING l_flag        #批次作业正确结束
            ELSE
               CALL cl_end2(2) RETURNING l_flag        #批次作业失败
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         END IF
      ELSE
         CALL p603_t()
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   DROP TABLE ima16_tmp
   DROP TABLE bmb_tmp
   DROP TABLE ima16_tmp_s
   DROP TABLE ima16_tmp_f
   CLOSE WINDOW p603_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION p603_tm()
DEFINE   lc_cmd   VARCHAR(1000)    #No:FUN-610104

   LET p_row = 5 LET p_col = 25
   OPEN WINDOW p603_w AT p_row,p_col WITH FORM "abm/42f/abmp605" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
   CALL cl_ui_init()
   CLEAR FORM

   INITIALIZE tm.* TO NULL    
   LET tm.yy=YEAR(CURRENT)
   LET tm.mm=MONTH(CURRENT)-1
   LET tm.max_level=20   #No.B476 add
   LET tm.sw = 'Y'       #NO.FUN-5C0001 
   LET g_bgjob = "N"     #No:FUN-610104
   DISPLAY BY NAME tm.*

   WHILE TRUE            #No:FUN-610104
      INPUT BY NAME tm.max_level,tm.sw,g_bgjob WITHOUT DEFAULTS  

         BEFORE INPUT
            CALL cl_qbe_init()

         AFTER FIELD max_level 
            IF cl_null(tm.max_level) OR tm.max_level <=0 THEN
               NEXT FIELD max_level
            END IF
            
         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET tm.sw = "N"
               DISPLAY BY NAME tm.sw
               CALL cl_set_comp_entry("sw",FALSE)
            ELSE
               CALL cl_set_comp_entry("sw",TRUE)
            END IF
                
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
      
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
      
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      
         ON ACTION exit                            #加离开功能
            LET INT_FLAG = 1
            EXIT INPUT

        ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT

        ON ACTION qbe_select
           CALL cl_qbe_select()

        ON ACTION qbe_save
           CALL cl_qbe_save()
     END INPUT 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF

     #--->确定执行低阶码计算
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p603_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     SELECT sma18 INTO g_sma18 FROM sma_file WHERE sma00='0'     
     IF SQLCA.sqlcode THEN 
        CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","sma_file",1) # TQC-660046
        LET g_success = 'N'
        EXIT WHILE
     END IF

     #-->不须再执行重新计算再次确定是否执行
     IF g_sma18='N' THEN  
        IF NOT cl_confirm('mfg2712') THEN
           LET INT_FLAG = 1
        ELSE
           LET INT_FLAG = 0
           LET g_ans = 'Y'
        END IF

        IF INT_FLAG THEN 
           LET INT_FLAG = 0 
           LET g_ans = 'N'
        END IF
        IF g_ans MATCHES "[Nn]" THEN
           CONTINUE WHILE
        END IF
     END IF

     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "abmp605"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err3('sel','zz_file','abmp605','',SQLCA.sqlcode,'','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.max_level CLIPPED,"'",
                        " '",tm.sw CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('abmp605',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p603_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     EXIT WHILE
  END WHILE
END FUNCTION
   
FUNCTION p603_t()
DEFINE l_sql  STRING
DEFINE l_cmd  VARCHAR(200)

   #将ima_file的ima01和ima16备份至临时表进行运算,防止锁ima_file
   #虽然会占用一些表空间,但这样的执行效率是很高的
   #生成备份表
   DROP TABLE ima16_tmp
   CREATE TEMP TABLE ima16_tmp(
    ima01 LIKE ima_file.ima01,
    ima16 LIKE ima_file.ima16,
    flag  LIKE type_file.chr1)
    
   CREATE INDEX ima16_tmp01 on ima16_tmp(ima01)

   INSERT INTO ima16_tmp SELECT ima01,ima16,'N' 
      FROM ima_file 
      WHERE imaacti='Y' and ima1010='1'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('ins','ima16_tmp','ima01','ima16',SQLCA.sqlcode,'','INSERT INTO ima16_tmp',1)
   END IF
   UPDATE ima16_tmp SET ima16=99 WHERE 1=1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('upd','ima16_tmp','ima16=99','',SQLCA.sqlcode,'','UPDATE ima16_tmp',1)
   END IF
   
   #建立bmb临时表,存放bmb关系和bmd关系
   #未考虑工单中用了取替代关系,但用完之后取替代被删除的情况
   DROP TABLE bmb_tmp
   CREATE TEMP TABLE bmb_tmp(
    bmb01 LIKE bmb_file.bmb01,
    bmb03 LIKE bmb_file.bmb03,
    bmb04 LIKE bmb_file.bmb04,
    bmb05 LIKE bmb_file.bmb04)
   
   CREATE INDEX bmb_tmp_01 on bmb_tmp(bmb01,bmb03,bmb04,bmb05)
   
   #bmb 插值
   LET l_sql = " INSERT INTO bmb_tmp ",
               " SELECT bmb01,bmb03,bmb04,bmb05 ",
               " FROM bma_file,bmb_file ",
               " WHERE bma01=bmb01 ",
               "   AND bma10='2' and bma05 is not null"
   PREPARE abmp605_bmb_ins_pr FROM l_sql
   EXECUTE abmp605_bmb_ins_pr
   IF SQLCA.sqlcode THEN
      CALL cl_err3('INS','bmb_tmp','','',SQLCA.sqlcode,'','INSERT bmb_tmp FROM BMB',1)
   END IF   
   
   #bmd插值
   #取替代 <>ALL
   LET l_sql = " INSERT INTO bmb_tmp ",
               " SELECT bmd08,bmd04,bmd05,bmd06 ",
               " FROM bmd_file ",
               " WHERE bmdacti='Y' ",
               "   AND bmd08 <> 'ALL'"
   PREPARE abmp605_bmd_ins_pr1 FROM l_sql
   EXECUTE abmp605_bmd_ins_pr1
   IF SQLCA.sqlcode THEN
      CALL cl_err3('INS','bmb_tmp','','',SQLCA.sqlcode,'','INSERT bmb_tmp FROM BMD ALL',1)
   END IF   
   #取替代 =ALL
   LET l_sql= " INSERT INTO bmb_tmp ",
              " SELECT  bmb01,bmd04,bmd05,bmd06 ",
              " FROM  bmb_file ,bmd_file,bma_file  ",
              " WHERE  bma01=bmb01 ",
              "   AND  bma10='2' and bma05 is not null",
              "   AND  bmd01=bmb03 and bmdacti='Y' and bmd08='ALL'"
   PREPARE abmp605_bmd_ins_pr2 FROM l_sql
   EXECUTE abmp605_bmd_ins_pr2   
   IF SQLCA.sqlcode THEN
      CALL cl_err3('INS','bmb_tmp','','',SQLCA.sqlcode,'','INSERT bmb_tmp FROM BMD <>ALL',1)
   END IF   
   
   #建立2个临时表,用来循环调用
   DROP TABLE ima16_tmp_f
   #作为每次进入循环时的初始料件表,在每次循环结束时用ima16_tmp_s刷新
   CREATE TEMP TABLE ima16_tmp_f(   
   ima01_f LIKE bmb_file.bmb01)
   
   CREATE INDEX ima16_tmp_f01 on ima16_tmp_f(ima01_f)
   #依据ima16_tmp_f,和bmb_file中主元件关系,存储剥离ima16_tmp_f中最低阶料后的下阶料
   DROP TABLE ima16_tmp_s  
   CREATE TEMP TABLE ima16_tmp_s(
   ima01_s  LIKE  bmb_file.bmb01)
   
   CREATE INDEX ima16_tmp_s01 on ima16_tmp_s(ima01_s)
   
   #SQL语句声明:
   #1.原始料低阶码计算语句
   LET l_sql = " INSERT INTO ima16_tmp_s",  #维护非0阶料到ima16_tmp_s中,方法是:依画面查询条件,并与ima01内联,取所有元件料bmb03
               " SELECT bmb03 from bmb_tmp,ima16_tmp_f A,ima16_tmp_f B",
               "  WHERE bmb03=A.ima01_f and bmb01=B.ima01_f",
               "    AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               "    AND (bmb05  >'",g_today,"' OR bmb05 IS NULL)",
               "  GROUP BY bmb03"
   PREPARE p603_ima16_tmp_s_ins FROM l_sql  
   LET l_sql = " SELECT COUNT(*) FROM (",   #"子"的数量
               " SELECT bmb03 from bmb_tmp,ima16_tmp_f A,ima16_tmp_f B",
               "  WHERE bmb03=A.ima01_f and bmb01=B.ima01_f",
               "    AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               "    AND (bmb05  >'",g_today,"' OR bmb05 IS NULL)",
               "  GROUP BY bmb03)"
   PREPARE p603_ima16_tmp_s_cnt FROM l_sql
   LET l_sql = " UPDATE ima16_tmp SET ima16=? ",  #筛选0阶料,并更ima16_tmp低阶码,不是任何人的子,所以是0阶料
               " WHERE exists(",
               #" SELECT ima01_f FROM ima16_tmp_f,ima16_tmp_s",
               #" WHERE ima01_f=ima01_s(+) and ima01_s is null and ima01=ima01_f",
               " SELECT ima01_f FROM ima16_tmp_f LEFT OUTER JOIN ima16_tmp_s ON ima01_f=ima01_s",
               " AND ima01_s is NULL WHERE ima01=ima01_f ",
               " )"
   PREPARE p603_ima16_tmp_upd0 FROM l_sql  
   LET l_sql = " UPDATE ima16_tmp SET ima16=? ",  #更新下阶料(ima16_tmp_s中的料)的低阶码至ima16_tmp
               " WHERE exists(",
               " select ima01_s FROM ima16_tmp_s",
               " WHERE ima01_s=ima16_tmp.ima01",
               " )"
   PREPARE p603_ima16_tmp_upd FROM l_sql
   LET l_sql = " INSERT INTO ima16_tmp_f ",       #刷新父表,将子表(剥离当前阶料后的下阶料)存入父表,以供继续维护下阶料之用
               " SELECT * FROM ima16_tmp_s"
   PREPARE p603_ima16_tmp_f_ins FROM l_sql
   
   #更新低阶码
   LET l_sql = "UPDATE ima16_tmp SET ima16= ? WHERE ima01 = ?"
   PREPARE p603_upd_ima1_pre FROM l_sql
   LET l_sql = "UPDATE ima_file SET ima16= ? WHERE ima01 = ?"
   PREPARE p603_upd_ima2_pre FROM l_sql   

   #主逻辑开始
   CALL p603()
   #主逻辑

END FUNCTION

FUNCTION p603()
DEFINE l_sql         STRING
DEFINE l_cnt         INT
DEFINE i             SMALLINT
DEFINE l_i           SMALLINT
DEFINE l_bmd01       LIKE bmd_file.bmd01
DEFINE l_bmd04       LIKE bmd_file.bmd04
DEFINE l_bmd01_level SMALLINT
DEFINE l_bmd04_level SMALLINT
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_ima16       LIKE ima_file.ima16
DEFINE l_cmd         VARCHAR(200)
DEFINE l_ima01_rep   LIKE ima_file.ima01
DEFINE l_ima16_rep   LIKE ima_file.ima16
DEFINE l_upd_cnt     INT
DEFINE l_upd_cnt1    INT
DEFINE l_ima01_lock  LIKE ima_file.ima01

   #主逻辑1,低阶码运算---begin---------------------------
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      MESSAGE "使用临时表计算原始料的低阶码,保存计算结果至临时表中"
      CALL ui.Interface.refresh()
   END IF

   #父料件档初值(复制ima16_tmp中所有料)
   INSERT INTO ima16_tmp_f SELECT ima01 from ima16_tmp where 1=1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('ins','ima16_tmp_f','ima01','',SQLCA.sqlcode,'','INSERT INTO ima16_tmp_f',1)
   END IF
   #计算原始料件的低阶码
   FOR i=0 to tm.max_level
      EXECUTE p603_ima16_tmp_s_cnt INTO l_cnt  #获取子的笔数
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt > 0 THEN 
         EXECUTE p603_ima16_tmp_s_ins          #筛选"子",并插入到子表中
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p603_ima16_tmp_s_ins',SQLCA.SQLCODE,1)
         END IF
         IF i=0 THEN
            EXECUTE p603_ima16_tmp_upd0 USING i    #更新低阶码,更新不是任何人子的父
            LET l_i = i+1
            EXECUTE p603_ima16_tmp_upd USING l_i   #更新第一阶
         ELSE 
            LET l_i = i+1
            EXECUTE p603_ima16_tmp_upd USING l_i   #更新第2阶及以上
         END IF
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p603_ima16_tmp_upd',SQLCA.SQLCODE,1)
         END IF
         DELETE FROM ima16_tmp_f where 1=1     #删除父
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('del_ima16_tmp_f',SQLCA.SQLCODE,1)
         END IF
         EXECUTE p603_ima16_tmp_f_ins          #将子存入父
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p603_ima16_tmp_f_ins',SQLCA.SQLCODE,1)
         END IF
         DELETE FROM ima16_tmp_s where 1=1     #删除子
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('del_ima16_tmp_s',SQLCA.SQLCODE,1)
         END IF
      ELSE
         EXIT FOR
      END IF
      DISPLAY  "for i = 0 TO tm.max_level: STEP",i," finished"  # for test
      IF tm.sw ='Y' AND g_bgjob = "N" THEN
         MESSAGE "循环剥离低阶码","for i = 0 TO tm.max_level: STEP",i," finished"
         CALL ui.Interface.refresh()
      END IF
   END FOR
   IF g_success = 'N' THEN
      CALL cl_err('主逻辑1 SQL错误','',1)      
      RETURN
   ELSE
   	                          
   END IF
   #主逻辑1,低阶码运算---end---------------------------

   #------------主逻辑2--------begin-----------------------------------
   #从ima16_tmp更新低阶码至ima_file
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      MESSAGE "主逻辑2:从临时表更新低阶码至用户表"
      CALL ui.Interface.refresh()
   END IF

   LET l_sql = " SELECT ima01,ima16 FROM ima16_tmp ",
               " WHERE flag = 'N'",
               " ORDER by ima01"
   PREPARE p603_upd_ima_pre FROM l_sql
   DECLARE p603_upd_ima_curs CURSOR FOR p603_upd_ima_pre
   
   LET l_sql = " SELECT COUNT(*) FROM ima16_tmp ",
               " WHERE flag = 'N'",
               " ORDER by ima01"
   PREPARE p603_upd_imacnt_pre FROM l_sql
   
   #判断ima_file有无被锁,若被锁,则退出,若未被锁,则将ima_file锁住,直至低阶码更新完毕
   LET l_sql="SELECT ima01 FROM ima_file ",
             " WHERE ima01=?",
             " FOR UPDATE "
   LET l_sql = cl_forupd_sql(l_sql)
   PREPARE p603_lock_pre FROM l_sql
   DECLARE p603_lock_curs CURSOR FOR p603_lock_pre 

   BEGIN WORK
   FOR l_upd_cnt = 1 to 20 
      EXECUTE p603_upd_imacnt_pre into l_upd_cnt1
      IF l_upd_cnt1 >0 THEN 
         MESSAGE "update ima16 ,FOREACH ",l_upd_cnt,":",l_upd_cnt1
      ELSE
         EXIT FOR
      END IF
      FOREACH p603_upd_ima_curs INTO l_ima01,l_ima16
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('FOREACH p603_upd_ima_curs',SQLCA.sqlcode,0)
         END IF
         OPEN p603_lock_curs USING l_ima01
         FETCH p603_lock_curs 
            INTO l_ima01_lock
           #USING l_ima01 
         IF SQLCA.sqlcode THEN
            CALL cl_err("OPEN p603_lock_curs",SQLCA.sqlcode,0)
         ELSE
            EXECUTE p603_upd_ima2_pre USING l_ima16,l_ima01
            IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
               #LET g_success = 'N'
               CALL cl_err('EXECUTE p603_upd_ima2_pre',SQLCA.sqlcode,0)
            ELSE 
               UPDATE ima16_tmp SET flag='Y' 
                  WHERE ima01 = l_ima01 
               CLOSE p603_lock_curs 
            END IF
         END IF  
      END FOREACH
   END FOR

   IF g_success = 'N' THEN
      ROLLBACK WORK                                  
      CALL cl_err('主逻辑2 SQL错误','',1)             
      RETURN
   ELSE
      COMMIT WORK                                    
   END IF
   #------------主逻辑2--------end-------------------------------------
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      MESSAGE "运行完毕"
      CALL ui.Interface.refresh()
   END IF

END FUNCTION
