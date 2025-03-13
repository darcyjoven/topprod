# Prog. Version..: '5.03.07-13.04.22(00010)'     #
#
# Pattern name...: abmp604.4gl
# Descriptions...: 低階碼依發料檔計算作業
# Input parameter: 
# Return code....: 
# Date & Author..: 13/05/06 By fengrui
# Modify.........: No.MOD-D90020 By SunLM  背景作業的時候，需要加上g_success='Y'

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE tm RECORD
          yy         LIKE type_file.num5,
          mm         LIKE type_file.num5,
          max_level  LIKE type_file.num5,
          sw         LIKE type_file.chr1            
          END RECORD, 
       g_bma01       LIKE bma_file.bma01,  #产品结构单头
       g_sma18       LIKE sma_file.sma18,  #低阶码是否需重新计算
       g_ans         LIKE type_file.chr1, 
       g_date        LIKE type_file.dat,   
       g_argv1       LIKE type_file.chr1, 
       p_row,p_col   LIKE type_file.num5
DEFINE g_chr         LIKE type_file.chr1
DEFINE g_cnt         LIKE type_file.num10 
DEFINE g_msg         LIKE type_file.chr1000
DEFINE l_flag        LIKE type_file.chr1,
       g_change_lang LIKE type_file.chr1           #是否有做语言切换
DEFINE g_dt1,g_dt2   LIKE type_file.dat  

DEFINE l_cby      DYNAMIC ARRAY OF LIKE type_file.num5
DEFINE g_cka00         LIKE cka_file.cka00    #FUN-C80092
DEFINE l_msg           STRING                 #FUN-C80092

MAIN
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
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM 
   END IF
   LET g_date  = TODAY  
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p604_tm()
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
   #FUN-C80092 -------------Begin---------------
            LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";","tm.max_level = '",tm.max_level,"'",";",
                        "tm.sw = '",tm.sw,"'",";","g_bgjob = '",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
                 RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
            CALL p604_t()
            IF g_success = 'Y' THEN
               CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
               CALL cl_end2(1) RETURNING l_flag        #批次作业正确结束
            ELSE
               CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
               CALL cl_end2(2) RETURNING l_flag        #批次作业失败
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET g_success = 'Y' #MOD-D90020 add
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy = '",tm.yy,"'",";","tm.mm = '",tm.mm,"'",";","tm.max_level = '",tm.max_level,"'",";",
                     "tm.sw = '",tm.sw,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         CALL p604_t()
   #FUN-C80092 -----Begin-----
         IF g_success = 'Y' THEN
            CALL s_log_upd(g_cka00,'Y')     
         ELSE
            CALL s_log_upd(g_cka00,'N')    
         END IF
   #FUN-C80092 -----End-------
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   DROP TABLE ima80_tmp
   DROP TABLE bmb_tmp
   DROP TABLE ima80_tmp_s
   DROP TABLE ima80_tmp_f
   CLOSE WINDOW p604_w
END MAIN

FUNCTION p604_tm()
DEFINE   lc_cmd   VARCHAR(1000)   

   LET p_row = 5 LET p_col = 25
   OPEN WINDOW p604_w AT p_row,p_col WITH FORM "abm/42f/abmp604" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
   CLEAR FORM

   INITIALIZE tm.* TO NULL    
   LET tm.yy=YEAR(CURRENT)
   LET tm.mm=MONTH(CURRENT)-1
   LET tm.max_level=20   
   LET tm.sw = 'Y'      
   LET g_bgjob = "N"     


   WHILE TRUE        
      INPUT BY NAME tm.yy,tm.mm,tm.max_level,tm.sw,g_bgjob WITHOUT DEFAULTS  

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
      
         ON ACTION about        
            CALL cl_about()     
      
         ON ACTION help          
            CALL cl_show_help()  
      
         ON ACTION controlg      
            CALL cl_cmdask()    
      
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
        CLOSE WINDOW p604_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     SELECT sma18 INTO g_sma18 FROM sma_file WHERE sma00='0'     
     IF SQLCA.sqlcode THEN 
        CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","sma_file",1) 
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
         WHERE zz01 = "abmp604"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err3('sel','zz_file','abmp604','',SQLCA.sqlcode,'','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.yy CLIPPED,"'",
                        " '",tm.mm CLIPPED,"'",
                        " '",tm.max_level CLIPPED,"'",
                        " '",tm.sw CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('abmp604',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p604_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        EXIT PROGRAM
     END IF
     EXIT WHILE
  END WHILE
END FUNCTION
   
FUNCTION p604_t()
DEFINE l_sql  STRING
DEFINE l_cmd  VARCHAR(200)
DEFINE l_bmb01  LIKE bmb_file.bmb01   #Add by zm 130702
DEFINE l_bmb03  LIKE bmb_file.bmb03   #Add by zm 130702
DEFINE l_sfv01  LIKE sfv_file.sfv01   #Add by zm 130702

    CALL s_azm(tm.yy,tm.mm) RETURNING g_chr,g_dt1,g_dt2

   #将ima_file的ima01和ima80备份至临时表进行运算,防止锁ima_file
   #虽然会占用一些表空间,但这样的执行效率是很高的
   #生成备份表
   DROP TABLE ima80_tmp
   CREATE TEMP TABLE ima80_tmp
   (ima01 LIKE ima_file.ima01,
    ima80 LIKE ima_file.ima80,
    flag  LIKE type_file.chr1)
   CREATE INDEX ima80_tmp01 on ima80_tmp(ima01)

   INSERT INTO ima80_tmp SELECT ima01,ima80,'N' 
      FROM ima_file 
      WHERE imaacti='Y' and ima1010='1'
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('ins','ima80_tmp','ima01','ima80',SQLCA.sqlcode,'','INSERT INTO ima80_tmp',1)
   END IF
   UPDATE ima80_tmp SET ima80=0 WHERE 1=1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('upd','ima80_tmp','ima80=0','',SQLCA.sqlcode,'','UPDATE ima80_tmp',1)
   END IF
   
   #建立bmb临时表,存放bmb关系和bmd关系
   #未考虑工单中用了取替代关系,但用完之后取替代被删除的情况
   DROP TABLE bmb_tmp
   CREATE TEMP TABLE bmb_tmp
   (bmb01 LIKE bmb_file.bmb01,
    bmb03 LIKE bmb_file.bmb03)
   CREATE INDEX bmb_tmp_01 on bmb_tmp(bmb01,bmb03)
   
   #bmb 插值
  #FREE--mark--str--
  # LET l_sql = " INSERT INTO bmb_tmp ",
  #             " SELECT DISTINCT sfb05,sfe07 FROM sfb_file,sfe_file ",
  #             "  WHERE sfb01=sfe01 AND sfb05<>sfe07  ",
  #             "    AND sfb87='Y' AND sfbacti='Y' ",
  #             "    AND sfe04 BETWEEN '",g_dt1,"' AND '",g_dt2,"'  ", 
  #             "  ORDER BY sfb05,sfe07 "
  #FREE--mark--end-- 

  #FREE--add--str--
   LET l_sql = " INSERT INTO bmb_tmp ", 
               " SELECT DISTINCT sfb05,sfe07 FROM sfb_file a,sfe_file  ",
               "  WHERE sfb01=sfe01 AND sfb05<>sfe07  ",
               "    AND sfb87='Y' AND sfbacti='Y' ",
               "    AND EXISTS  ",
               "      (SELECT sfb01 FROM sfb_file,sfe_file ",
               "        WHERE sfb01=sfe01 AND sfb05<>sfe07  ",
               "          AND sfb87='Y' AND sfbacti='Y' ",
               "          AND sfb01= a.sfb01 ",
               "          AND sfe04 BETWEEN '",g_dt1,"' AND '",g_dt2,"'  )  ",
               "  ORDER BY sfb05,sfe07 "
  #FREE--add--end--
            
   PREPARE p604_bmb_ins_pr FROM l_sql
   EXECUTE p604_bmb_ins_pr
   IF SQLCA.sqlcode THEN
      CALL cl_err3('INS','bmb_tmp','','',SQLCA.sqlcode,'','INSERT bmb_tmp FROM BMB',1)
   END IF   
   
   #Add by zm 130702 考虑联产品,自动架虚似上下阶,使主产品和联产品保持同阶
   IF g_sma.sma104 = 'Y' THEN
      DECLARE p604_cur99 CURSOR FOR
      SELECT bmb01,bmb03,sfv01 FROM bmb_tmp,sfu_file,sfv_file
       WHERE sfu01=sfv01 
         AND bmb03=sfv04
         AND sfu02 BETWEEN g_dt1 AND g_dt2
         AND sfupost='Y' AND sfv16='Y'
       ORDER BY sfv01,sfv04
      FOREACH p604_cur99 INTO l_bmb01,l_bmb03,l_sfv01
         LET l_sql = "INSERT INTO bmb_tmp ",
                     "SELECT '",l_bmb01,"',sfv04 FROM sfu_file,sfv_file ",
                     " WHERE sfu01 = sfv01 ",
                     "   AND sfv01 = '",l_sfv01,"' ",
                     "   AND sfu02 BETWEEN '",g_dt1,"' AND '",g_dt2,"'  ",
                     "   AND sfv04 NOT IN(SELECT bmb03 FROM bmb_tmp WHERE bmb01='",l_bmb01,"' ) "
         PREPARE p604_pre FROM l_sql
         EXECUTE p604_pre 
         MESSAGE l_sfv01
      END FOREACH
   END IF
   #End by zm 130702

   #建立2个临时表,用来循环调用
   DROP TABLE ima80_tmp_f
   CREATE TEMP TABLE ima80_tmp_f        #作为每次进入循环时的初始料件表,在每次循环结束时用ima80_tmp_s刷新
   (ima01_f   LIKE ima_file.ima01)
   CREATE INDEX ima80_tmp_f01 on ima80_tmp_f(ima01_f)
   DROP TABLE ima80_tmp_s               #依据ima80_tmp_f,和bmb_file中主元件关系,存储剥离ima80_tmp_f中最低阶料后的下阶料
   CREATE TEMP TABLE ima80_tmp_s
   (ima01_s   LIKE ima_file.ima01)
   CREATE INDEX ima80_tmp_s01 on ima80_tmp_s(ima01_s)
   
   #SQL语句声明:
   #1.原始料低阶码计算语句
   LET l_sql = " INSERT INTO ima80_tmp_s",  #维护非0阶料到ima80_tmp_s中,方法是:依画面查询条件,并与ima01内联,取所有元件料bmb03
               " SELECT bmb03 from bmb_tmp,ima80_tmp_f A,ima80_tmp_f B",
               "  WHERE bmb03=A.ima01_f and bmb01=B.ima01_f",
               "  GROUP BY bmb03"
   PREPARE p604_ima80_tmp_s_ins FROM l_sql  
   LET l_sql = " SELECT COUNT(*) FROM (",   #"子"的数量
               " SELECT bmb03 from bmb_tmp,ima80_tmp_f A,ima80_tmp_f B",
               "  WHERE bmb03=A.ima01_f and bmb01=B.ima01_f",
               "  GROUP BY bmb03)"
   PREPARE p604_ima80_tmp_s_cnt FROM l_sql
   LET l_sql = " UPDATE ima80_tmp SET ima80=? ",  #筛选0阶料,并更ima80_tmp低阶码,不是任何人的子,所以是0阶料
               " WHERE exists(",
               " SELECT ima01_f FROM ima80_tmp_f LEFT OUTER JOIN ima80_tmp_s ON ima01_f=ima01_s ",
               " WHERE ima01_s is null and ima01=ima01_f",
               " )"
   PREPARE p604_ima80_tmp_upd0 FROM l_sql  
   LET l_sql = " UPDATE ima80_tmp SET ima80=? ",  #更新下阶料(ima80_tmp_s中的料)的低阶码至ima80_tmp
               " WHERE exists(",
               " select ima01_s FROM ima80_tmp_s",
               " WHERE ima01_s=ima80_tmp.ima01",
               " )"
   PREPARE p604_ima80_tmp_upd FROM l_sql
   LET l_sql = " INSERT INTO ima80_tmp_f ",       #刷新父表,将子表(剥离当前阶料后的下阶料)存入父表,以供继续维护下阶料之用
               " SELECT * FROM ima80_tmp_s"
   PREPARE p604_ima80_tmp_f_ins FROM l_sql
   
   #更新低阶码
   LET l_sql = "UPDATE ima80_tmp SET ima80= ? WHERE ima01 = ?"
   PREPARE p604_upd_ima1_pre FROM l_sql
   LET l_sql = "UPDATE ima_file SET ima80= ? ,imadate ='", g_today,"' WHERE ima01 = ?"
   PREPARE p604_upd_ima2_pre FROM l_sql   

   CALL p604()

END FUNCTION

FUNCTION p604()
DEFINE l_sql         STRING
DEFINE l_cnt         INT
DEFINE i             SMALLINT
DEFINE l_i           SMALLINT
DEFINE l_bmd01       LIKE bmd_file.bmd01
DEFINE l_bmd04       LIKE bmd_file.bmd04
DEFINE l_bmd01_level SMALLINT
DEFINE l_bmd04_level SMALLINT
DEFINE l_ima01       LIKE ima_file.ima01
DEFINE l_ima80       LIKE ima_file.ima80
DEFINE l_cmd         VARCHAR(200)
DEFINE l_ima01_rep   LIKE ima_file.ima01
DEFINE l_ima80_rep   LIKE ima_file.ima80
DEFINE l_upd_cnt     INT
DEFINE l_upd_cnt1    INT
DEFINE l_ima01_lock  LIKE ima_file.ima01

   #主逻辑1,低阶码运算---begin---------------------------
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      #MESSAGE "使用临时表计算原始料的低阶码,保存计算结果至临时表中"
      CALL ui.Interface.refresh()
   END IF

   #父料件档初值(复制ima80_tmp中所有料)
   INSERT INTO ima80_tmp_f SELECT ima01 from ima80_tmp where 1=1
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3('ins','ima80_tmp_f','ima01','',SQLCA.sqlcode,'','INSERT INTO ima80_tmp_f',1)
   END IF
   #计算原始料件的低阶码
   FOR i=0 to tm.max_level
      EXECUTE p604_ima80_tmp_s_cnt INTO l_cnt  #获取子的笔数
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt > 0 THEN 
         EXECUTE p604_ima80_tmp_s_ins          #筛选"子",并插入到子表中
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p604_ima80_tmp_s_ins',SQLCA.SQLCODE,1)
         END IF
         IF i=0 THEN 
            EXECUTE p604_ima80_tmp_upd0 USING i    #更新低阶码,更新不是任何人子的父
            LET l_i = i+1
            EXECUTE p604_ima80_tmp_upd USING l_i   #更新第一阶
         ELSE 
            LET l_i = i+1
            EXECUTE p604_ima80_tmp_upd USING l_i   #更新第2阶及以上
         END IF
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p604_ima80_tmp_upd',SQLCA.SQLCODE,1)
         END IF
         DELETE FROM ima80_tmp_f where 1=1     #删除父
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('del_ima80_tmp_f',SQLCA.SQLCODE,1)
         END IF
         EXECUTE p604_ima80_tmp_f_ins          #将子存入父
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('p604_ima80_tmp_f_ins',SQLCA.SQLCODE,1)
         END IF
         DELETE FROM ima80_tmp_s where 1=1     #删除子
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('del_ima80_tmp_s',SQLCA.SQLCODE,1)
         END IF
      ELSE
         EXIT FOR
      END IF
      IF tm.sw ='Y' AND g_bgjob = "N" THEN
         #MESSAGE "循环剥离低阶码","for i = 0 TO tm.max_level: STEP",i," finished"
         CALL ui.Interface.refresh()
      END IF
   END FOR
   IF g_success = 'N' THEN
      RETURN
   END IF
   #主逻辑1,低阶码运算---end---------------------------

   #------------主逻辑2--------begin-----------------------------------
   #从ima80_tmp更新低阶码至ima_file
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      #MESSAGE "主逻辑2:从临时表更新低阶码至用户表"
      CALL ui.Interface.refresh()
   END IF

   LET l_sql = " SELECT ima01,ima80 FROM ima80_tmp ",
               " WHERE flag = 'N'",
               " ORDER by ima01"
   PREPARE p604_upd_ima_pre FROM l_sql
   DECLARE p604_upd_ima_curs CURSOR FOR p604_upd_ima_pre
   
   LET l_sql = " SELECT COUNT(*) FROM ima80_tmp ",
               " WHERE flag = 'N'",
               " ORDER by ima01"
   PREPARE p604_upd_imacnt_pre FROM l_sql
   
   #判断ima_file有无被锁,若被锁,则退出,若未被锁,则将ima_file锁住,直至低阶码更新完毕
   LET l_sql="SELECT ima01 FROM ima_file ",
             " WHERE ima01=?",
             " FOR UPDATE "
   LET l_sql=cl_forupd_sql(l_sql)
   PREPARE p604_lock_pre FROM l_sql
   DECLARE p604_lock_curs CURSOR FOR p604_lock_pre 

   LET l_cby[1]=1

   BEGIN WORK
   FOR l_upd_cnt = 1 to 20 
      EXECUTE p604_upd_imacnt_pre into l_upd_cnt1
      IF l_upd_cnt1 >0 THEN 
         MESSAGE "update ima80 ,FOREACH ",l_upd_cnt,":",l_upd_cnt1
      ELSE
         EXIT FOR
      END IF
      FOREACH p604_upd_ima_curs INTO l_ima01,l_ima80
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err('FOREACH p604_upd_ima_curs',SQLCA.sqlcode,0)
         END IF
         OPEN p604_lock_curs USING l_ima01
         FETCH p604_lock_curs 
            INTO l_ima01_lock
         IF SQLCA.sqlcode THEN
            CALL cl_err("OPEN p604_lock_curs",SQLCA.sqlcode,0)
         ELSE
            EXECUTE p604_upd_ima2_pre USING l_ima80,l_ima01
            IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('EXECUTE p604_upd_ima2_pre',SQLCA.sqlcode,0)
            ELSE 
               UPDATE ima80_tmp SET flag='Y' 
                  WHERE ima01 = l_ima01 
               CLOSE p604_lock_curs 
               IF ( l_cby[1] MOD 1000 ) = 0  THEN
                  IF tm.sw ='Y' AND g_bgjob = "N" THEN
                     MESSAGE l_ima01
                     #MESSAGE "主逻辑2:从临时表更新低阶码至用户表,更新第",l_cby[1],"千笔资料:",l_ima01
                     CALL ui.Interface.refresh()
                  END  IF

               END IF
               LET l_cby[1]=l_cby[1]+1
            END IF
         END IF  
      END FOREACH
   END FOR

   IF g_success = 'N' THEN
      ROLLBACK WORK                                  # for test
      #CALL cl_err('主逻辑2 SQL错误','',1)             # for test
      RETURN
   ELSE
      COMMIT WORK                                     # for test
   END IF
   #------------主逻辑2--------end-------------------------------------
   IF tm.sw ='Y' AND g_bgjob = "N" THEN
      #MESSAGE "运行完毕"
      CALL ui.Interface.refresh()
   END IF
END FUNCTION
#FUN-D10080
