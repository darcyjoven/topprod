# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: abmp6041.4gl (copy from abmp604.4gl)
# Descriptions...: 低阶码依发料文件计算作业(for oracle)
# Note...........: 本作业将工单发料档(sfe_file)内所有参考到的料件依其所在最高阶数(低阶码)更新至料件主档内
# Input parameter: 
# Return code....: 
# Date & Author..: 06/06/28 by kim
# Modify.........: No:FUN-670034 06/07/12 By Sarah 原本计算后异动低阶码写入ima16,改成写入ima80
# Modify.........: No:FUN-680008 06/08/09 By kim 修改计算逻辑,并加入程序批注
# Modify.........: No.FUN-680096 06/08/29 By cheunl  字段型态定义，改为LIKE
# Modify.........: No.CHI-6A0038 06/10/23 By kim 将程序中有"SET LOCK MODE"程序拿掉
# Modify.........: No:FUN-6A0060 06/10/26 By king l_time转g_time
# Modify.........: No:FUN-710028 07/01/23 By hellen 错误讯息汇总显示修改
# Modify.........: No:TQC-790077 07/09/17 By Carrier '显示运行过程'='N'时,程序当出
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的错误汇总的修改
# Modify.........: No.FUN-980069 09/08/21 By mike 将年度字段default ccz01月份字段default ccz02
# Modify.........: No:TQC-9B0041 09/11/11 By jan 还远程式
# Modify.........: No.MOD-9A0178 09/11/28 By mike 该程序无法使用背景作业执行   
# Modify.........: No:MOD-B30219 11/03/16 By Pengu 重工工单有发其他非生产料号时，发料低阶码计算会异常
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting    1、离开MAIN时没有cl_used(1)和cl_used(2) 
# Modify.........: NO:MOD-C30550 12/03/12 By tanxc 調整SQL寫法
# Modify.........: NO:TQC-C70192 12/07/30 By suncx 針對Oracle的優化

DATABASE ds

GLOBALS "../../config/top.global"

    DEFINE tm RECORD
             yy         LIKE type_file.num5,    #No.FUN-680096 SMALLINT
             mm         LIKE type_file.num5,    #No.FUN-680096 SMALLINT
             max_level  LIKE type_file.num5,    #No.FUN-680096 SMALLINT
             sw         LIKE type_file.chr1     #No.FUN-680096 CHAR(1)
          END RECORD, 
          g_bma01         LIKE bma_file.bma01,  #产品结构单头
          g_sma18         LIKE sma_file.sma18,  #低阶码是否需重新计算
          g_ans           LIKE type_file.chr1,  #No.FUN-680096 CHAR(1)
          g_date          LIKE type_file.dat,   #No.FUN-680096 DATE
          g_argv1         LIKE type_file.chr1,  #No.FUN-680096 CHAR(1)
#         g_argv2         CHAR(01),
          p_row,p_col     LIKE type_file.num5   #No.FUN-680096 SMALLINT

DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680096 CHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680096 CHAR(72)
DEFINE   l_flag          LIKE type_file.chr1,   #No.FUN-680096 CHAR(1)
         g_change_lang   LIKE type_file.chr1    #是否有做语言切换  #No.FUN-680096 CHAR(1) 
DEFINE   g_sfb01         LIKE sfb_file.sfb01
DEFINE   g_sfb05         LIKE sfb_file.sfb05
DEFINE   g_dt1,g_dt2     LIKE type_file.dat     #No.FUN-680096 DATE
DEFINE   g_err DYNAMIC ARRAY OF RECORD #FUN-680008
            sfb01        LIKE sfb_file.sfb01,
            sfb05        LIKE sfb_file.sfb05
         END RECORD
DEFINE   g_giveup        LIKE type_file.num5    #No.FUN-680096 SMALLINT #FUN-680008
DEFINE   infor           STRING
DEFINE   g_where,g_sql         STRING
DEFINE  l_begin,l_tot_begin      DATETIME HOUR TO SECOND
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				     # Supress DEL key function

   #No:FUN-610104 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.max_level = ARG_VAL(2)
   LET tm.sw = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET tm.yy=ARG_VAL(5)
   LET tm.mm=ARG_VAL(6)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No:FUN-610104 ---end---

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #FUN-B30211   

   IF s_shut(0) THEN EXIT PROGRAM END IF 

   LET g_date  = TODAY  
   WHILE TRUE
      #No:FUN-610104 --mark--
      LET g_success = 'Y'
      
      IF g_bgjob = "N" THEN    #No:FUN-610104
         CALL p6041_tm()        #No:FUN-610104
         IF cl_sure(21,21) THEN
            CALL cl_wait()
           # CALL p6041_cur()
             CALL g_err.clear() #FUN-680008
             CALL p6041_ctable()
            BEGIN WORK #CHI-6A0038
            CALL p6041_t()
            CALL p6041_out() #FUN-680008
            CALL s_showmsg()   #No.FUN-710028
            IF g_success = 'Y' THEN
               COMMIT WORK #CHI-6A0038
               CALL cl_end2(1) RETURNING l_flag        #批次作业正确结束
            ELSE
               ROLLBACK WORK #CHI-6A0038
               CALL cl_end2(2) RETURNING l_flag        #批次作业失败
            END IF 
             CALL p6041_dtable()
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
         END IF
       CLOSE WINDOW p6041_w
      #No:FUN-610104 --start--
      ELSE
         #CALL p6041_cur()
         CALL p6041_ctable()

        BEGIN WORK #MOD-9A0178       
         CALL p6041_t()
         CALL p6041_out() #FUN-680008
        #MOD-9A0178   ---START                                                                                                      
         CALL s_showmsg()                                                                                                           
         IF g_success = 'Y' THEN           
           # COMMIT WOKR                                                                                                             
         ELSE                                                                                                                       
            ROLLBACK WORK                                                                                                           
         END IF                                                                                                                     
         CALL p6041_dtable()
        #MOD-9A0178    ---END   
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
      #No:FUN-610104 ---end---
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
END MAIN

FUNCTION p6041_tm()
   DEFINE   lc_cmd   LIKE type_file.chr1000 #No.FUN-680096 CHAR(1000)

   LET p_row = 5 LET p_col = 25

   OPEN WINDOW p6041_w AT p_row,p_col WITH FORM "abm/42f/abmp604" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
   CLEAR FORM

   INITIALIZE tm.* TO NULL
   LET tm.yy= g_ccz.ccz01  #FUN-980069 YEAR(g_today)-->g_ccz.ccz01
   LET tm.mm= g_ccz.ccz02  #FUN-980069 Month(g_today)-->g_ccz.ccz02
   LET tm.max_level=20
   LET tm.sw = 'Y'
   LET g_bgjob = "N"
   WHILE TRUE         
      INPUT BY NAME tm.yy,tm.mm,tm.max_level,
                    tm.sw,g_bgjob WITHOUT DEFAULTS

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
         #No:FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No:FUN-580031 ---end---

         #No:FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No:FUN-580031 ---end---

         #No:FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 ---end---

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
         CLOSE WINDOW p6041_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
         EXIT PROGRAM
      END IF
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "abmp6041"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('abmp6041','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ' '",
                         " '",tm.max_level CLIPPED,"'",
                         " '",tm.sw CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",tm.yy CLIPPED,"'",
                         " '",tm.mm CLIPPED,"'"
                         
            CALL cl_cmdat('abmp6041',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p6041_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
      #No:FUN-610104 ---end---
END FUNCTION

FUNCTION p6041_t()
   DEFINE  l_sql      STRING,
           l_where    STRING, #CHI-6A0038
           l_success  LIKE type_file.chr1      #No.FUN-680096 CHAR(1)

    IF g_bgjob = "N" THEN
       CALL cl_wait()
    END IF

    LET g_dt1=MDY(tm.mm,1,tm.yy)
    LET g_dt2=p6041_GETLASTDAY(g_dt1)

   #CHI-6A0038...............begin
   #更新ima_file前先檢查有無被lock table
   #MOD-C30550--mark--begin--
   #LET l_where="(SELECT DISTINCT sfb05 FROM sfb_file,sfe_file ",
   #            " WHERE sfb01=sfe01 ",
   #            "   AND sfe04 BETWEEN '",g_dt1,"' AND '",g_dt2,"')",
   #            " OR ima01 in (SELECT DISTINCT sfe07 FROM sfb_file,sfe_file ",
   #            " WHERE sfb01=sfe01 AND sfe04 BETWEEN '",
   #            g_dt1,"' AND '",g_dt2,"')"
   #MOD-C30550--mark--end--

   #MOD-C30550 -- begin --
   DROP TABLE locktemp
   LET l_where="SELECT DISTINCT sfb05 as ima01 FROM sfb_file,sfe_file ",
               " WHERE sfb01=sfe01 ",
               "   AND sfe04 BETWEEN '",g_dt1,"' AND '",g_dt2,"' ",
               " UNION ",
               " SELECT DISTINCT sfe07 as ima01 FROM sfb_file,sfe_file,ima_file ",
               " WHERE sfb01=sfe01 AND sfe07=ima01",
               "   AND sfe04 BETWEEN '", g_dt1,"' AND '",g_dt2,"' ",
               " INTO TEMP locktemp "
   PREPARE p6041_locktemp_cur FROM l_where
   EXECUTE p6041_locktemp_cur
   LET l_where = "(SELECT ima01 FROM locktemp ) "
   #MOD-C30550 -- end --

   LET l_sql="SELECT ima01 FROM ima_file WHERE ima01 in",
             l_where ," FOR UPDATE"
   LET l_sql=cl_forupd_sql(l_sql)

   PREPARE p6041_lock_c_pre FROM l_sql
   DECLARE p6041_lock_c CURSOR FOR p6041_lock_c_pre
   OPEN p6041_lock_c
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file","","",SQLCA.sqlcode,"","",1)
      LET g_success='N'
      RETURN
   END IF
   CLOSE p6041_lock_c
   #CHI-6A0038...............end

    #将本次要更新的料号的发料低阶码设为0
   #LET l_sql="UPDATE ima_file SET ima16=0,ima146='Y' WHERE ima01 in ",   #FUN-670034 mark
    LET l_sql="UPDATE ima_file SET ima80=0 WHERE ima01 in ",              #FUN-670034
               l_where #CHI-6A0038
    PREPARE p6041_t_c_pre FROM l_sql
    EXECUTE p6041_t_c_pre
    IF SQLCA.sqlcode THEN
       LET g_success='N'
    END IF
    LET g_where=l_where
    #------------------- 主程开始 ---------------------------
    #CALL p6041_bom_c() #FUN-680008
     CALL p6041()
   #SET LOCK MODE TO WAIT #CHI-6A0038
   #CHI-6A0038......................mark begin
   #UPDATE sma_file SET sma18='N' WHERE sma00='0' 
   #IF SQLCA.sqlcode THEN 
   #   CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","sma_file end",1)  # TQC-660046
   #   LET g_success = "N"
   #END IF
   #CHI-6A0038......................mark end
END FUNCTION

FUNCTION p6041_GETLASTDAY(p_date)
DEFINE p_date LIKE type_file.dat     #No.FUN-680096 DATE
  IF p_date IS NULL OR p_date=0 THEN
     RETURN 0
  END IF
  IF MONTH(p_date)=12 THEN
     RETURN MDY(1,1,YEAR(p_date)+1)-1
  ELSE
     RETURN MDY(MONTH(p_date)+1,1,YEAR(p_date))-1
  END IF
END FUNCTION

FUNCTION p6041_log(l_input)

DEFINE l_cmd,l_input  STRING

   #如果当前是有界面，则将执行过程显示在界面上
   LET infor = infor,l_input
   IF g_bgjob = 'N' AND tm.sw = 'Y' THEN
      MESSAGE infor
      CALL ui.Interface.refresh()
   END IF

END FUNCTION
	
FUNCTION p6041()
DEFINE 
  l_time                                  VARCHAR(8),
  l_sql                                   VARCHAR(2000),            
  l_cnt,l_cnt2,l_cnt3,l_cnt_remain,l_max_level   INTEGER, 
  l_level,l_unlock_time,l_n                   SMALLINT,
  l_start,l_end                           DATE,
  l_cmd                                   STRING,
  l_base_parent,l_base_child              LIKE ima_file.ima01,
  l_yy,l_mm                               INTEGER,
  l_curdate                               STRING,
  l_ty                                    CHAR(4),
  l_tm                                    CHAR(2)

   #显示执行过程
     
    #BEGIN WORK

     #填充单头临时表
     LET g_sql="INSERT INTO tmp_ima SELECT ima01 FROM ima_file ",
               "WHERE ima01 in ",g_where
    PREPARE p6041_ins FROM g_sql
    EXECUTE p6041_ins
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('IMA_FILE -> TMP_IMA :',SQLCA.sqlcode,1) 
     END IF
     
   
     #计算笔数并提示执行过程
     #计算笔数并显示执行过程
     SELECT COUNT(*) INTO l_cnt FROM tmp_ima
     CALL p6041_log("单头临时表:"||l_cnt||'笔,完毕! 用时:'||TIME(CURRENT)-l_begin||'\n从sfe_file中取得父子关系...')
     LET l_begin = TIME(CURRENT)
     LET l_sql = "INSERT INTO tmp_child SELECT DISTINCT sfb05 parent, sfe07 child ",
                 "       FROM sfe_file, sfb_file ",
                 " WHERE sfb01=sfe01 ",
                 "   AND sfe04 BETWEEN '",g_dt1,"' AND '",g_dt2,"'",
                 "   AND sfb87='Y'",
                 "   AND sfbacti='Y'",
                 "   AND sfb05<>sfe07 ",
                 "   ORDER BY sfb05"                
     PREPARE p6041_sfe FROM l_sql
     EXECUTE p6041_sfe 
     IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
        CALL cl_err('SFE_FILE -> TMP_CHILD :',SQLCA.sqlcode,1) 
     END IF

     #这一步是安全性防范措施
     #因为虽然理论上不会出现在BOM或工单中存在IMA中不存在的料，但如果万一数据中有紊乱，这种状况可能会造成死循环，所以要提前剔除
     DELETE FROM tmp_child WHERE NOT EXISTS
       ( SELECT 1 FROM tmp_ima WHERE t_ima01 = parent )
     LET l_cnt3 = SQLCA.SQLERRD[3]
     SELECT COUNT(*) INTO l_cnt2 FROM tmp_child  #add by yf2002 090803
     CALL p6041_log(l_cnt2-l_cnt||'笔,完毕! 用时:'||TIME(CURRENT)-l_begin||'\n剔除'||l_cnt3||'笔无对应有效料件的关系')
     LET l_begin = TIME(CURRENT)
     #COMMIT WOKR
   ---------------------------------------------------------
   #将死循环先剔除
   #BEGIN WORK
   LET l_sql="SELECT DISTINCT X1||Y1 FROM  ",                                
   					"( ",                                                               
   					"  SELECT * FROM " ,                                                
   					"  (SELECT PARENT x1,CHILD y1 FROM tmp_child ), ",      
   					"  (SELECT PARENT x2,CHILD y2 FROM tmp_child ) ",       
   					"  WHERE x1=y2 AND y1=x2  ", 
   					") ",                       
   					"UNION ",                                                           
  					"SELECT DISTINCT X2||Y2 FROM  ",                                
   					"( ",                                                               
   					"  SELECT * FROM ",                                                 
   					"  (SELECT PARENT x1,CHILD y1 FROM tmp_child ), ",      
   					"  (SELECT PARENT x2,CHILD y2 FROM tmp_child ) ",       
   					"  WHERE x1=y2 AND y1=x2  ", 
 					") "                                                                                                              
   LET l_sql="DELETE FROM tmp_child WHERE parent||child IN ( ",l_sql," ) "  
   #add by yf2002 090702 end
    
        PREPARE del_tmp_child_1 FROM l_sql
        EXECUTE del_tmp_child_1
        LET l_cnt = SQLCA.SQLERRD[3]
        CALL p6041_log('\n剔除'||l_cnt||'笔死循环关系')     
   #ADD BY HUJIE 20090627  --End-- 
   #COMMIT WOKR
   ---------------------------------------------------------
   
#add by yf2002 090803 begin
     #从0阶料开始展
     LET l_level = 0
     #计算笔数并提示执行过程     
     #CALL p6041_log(l_cnt2-l_cnt||'笔,完毕! 用时:'||TIME(CURRENT)-l_begin||'\n开始展第'||l_level||'阶料...')
     CALL p6041_log('\n开始展第'||l_level||'阶料...')
     LET l_begin = TIME(CURRENT)
#add by yf2002 090803 end

     #-----------FOR DEBUG----------------------------------------------

     
     INSERT INTO debug_ima SELECT -1,t_ima01 FROM tmp_ima
     INSERT INTO debug_child SELECT -1,parent,child FROM tmp_child

     #------------------------------------------------------------------
        
     #开始主循环
     #循环内容，剥离顶层料件（即只存在于单头而不存在于单身的料件）
     #被剥离出来的料件被暂存与sub_ima中，并会被从tmp_ima,tmp_child中删除
     #当某次剥离出来发现结果集为空时，说明已经没有顶层料件，此时如果tmp_ima中为空，则表示低阶码运算结束
     #否则说明有循环存在,tmp_ima中为涉及循环的料件
     
     LET l_unlock_time = 0    #如果当下面l_cnt = 0 但 tmp_ima数量 <> 0的时候，如果l_unlock_time = 0，表示正常展阶，>0均表示在解套
     WHILE TRUE

        #找出有单头无单身的料件
        SELECT count(*) INTO l_cnt_remain FROM tmp_ima
        INSERT INTO sub_ima SELECT t_ima01 AS s_ima01 FROM tmp_ima
          WHERE NOT EXISTS ( SELECT 1 FROM tmp_child WHERE child = t_ima01 )
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('INSERT INTO sub_ima:',SQLCA.sqlcode,1) 
        END IF
 
        SELECT COUNT(*) INTO l_cnt FROM sub_ima
        CALL p6041_log(l_cnt||'笔')
        #如果当前没有了则要判断是出现循环还是全部执行完毕       
         IF l_cnt =0 THEN
         	  #如果最后tmp_ima中没有剩余料件，则表示所有料件低阶码已经全部计算完毕
            IF l_cnt_remain = 0 THEN
               LET g_success = 'Y'
            ELSE
               LET g_success = 'N'
               DECLARE sfb_cur CURSOR FOR 
                SELECT DISTINCT sfb01,sfb05 FROM tmp_ima,sfb_file 
                 WHERE sfb05=t_ima01
                 LET l_n=1
               FOREACH sfb_cur INTO g_err[l_n].sfb01,g_err[l_n].sfb05
                 LET l_n=g_err.getlength()+1
               END FOREACH
            END IF
            EXIT WHILE
         END IF

        #更新这些料号的低阶码
        UPDATE ima_file set ima80 = l_level
          WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE ima01 = s_ima01 ) 
            AND ima80 <l_level
        IF ( SQLCA.sqlcode ) AND ( g_bgjob <> 'Y' ) THEN
           CALL cl_err('update_ima:',SQLCA.sqlcode,1) 
        END IF

        #把这些料号从基准表中剔除掉，同时从关系表中剔除掉以其为父料件的关系记录
        DELETE FROM tmp_ima WHERE EXISTS (SELECT 1 FROM sub_ima WHERE s_ima01 = t_ima01)
        DELETE FROM tmp_child WHERE EXISTS ( SELECT 1 FROM sub_ima WHERE s_ima01 = parent )

        #清空sub_ima
        LET l_sql= "DELETE FROM sub_ima" 
        PREPARE del_sub_ima FROM l_sql
        EXECUTE del_sub_ima

        #低阶码循环累加
        LET l_level=l_level+1 

        CALL p6041_log(',完毕! 用时:'||TIME(CURRENT)-l_begin||'\n开始展第'||l_level||'阶料...')
        LET l_begin = TIME(CURRENT)

     END WHILE

END FUNCTION

FUNCTION p6041_ctable()
  
   LET l_tot_begin = TIME(CURRENT)
   CALL p6041_log('开始时间 : '||l_tot_begin||'\n准备临时表(TMP_IMA,TMP_CHILD)...')
   
   #创建临时表
     DROP TABLE tmp_ima
      CREATE TEMP TABLE tmp_ima(
                                t_ima01 LIKE ima_file.ima01);
     CREATE UNIQUE INDEX tmp_ima_01 ON tmp_ima(t_ima01);
     DROP TABLE tmp_child
     CREATE TEMP TABLE tmp_child(
                                 parent LIKE sfb_file.sfb05,
                                 child  LIKE sfe_file.sfe07)
     CREATE UNIQUE INDEX tmp_child_01 ON tmp_child(parent,child)
     CREATE INDEX tmp_child_02 ON tmp_child(child)
     DROP TABLE sub_ima
     CREATE TEMP TABLE sub_ima(
                               s_ima01 LIKE ima_file.ima01);
     CREATE UNIQUE INDEX sub_ima_01 ON sub_ima(s_ima01)
     
     #显示执行过程
     LET l_begin = TIME(CURRENT)
     CALL p6041_log('完毕! 用时:'||l_begin - l_tot_begin||'\n从ima_file中取得需料件清单...')
 
END FUNCTION

FUNCTION p6041_dtable()
  DEFINE l_sql STRING

     CALL p6041_log(',完毕! 用时:'||TIME(CURRENT)-l_begin||'\n删除临时表...')
     LET l_begin = TIME(CURRENT)   
     #清空并删除临时表，先TRUNCATE再DROP比直接DROP要更快
     LET l_sql= "TRUNCATE TABLE sub_ima"
     PREPARE del_sub_ima1 FROM l_sql
     EXECUTE del_sub_ima1
     DROP TABLE sub_ima1

     LET l_sql= "TRUNCATE TABLE tmp_ima"
     PREPARE del_tmp_ima FROM l_sql
     EXECUTE del_tmp_ima
     DROP TABLE tmp_ima

     LET l_sql= "TRUNCATE TABLE tmp_child"
     PREPARE del_tmp_child FROM l_sql
     EXECUTE del_tmp_child
     DROP TABLE tmp_child
     CALL p6041_log('完毕！用时:'||TIME(CURRENT) - l_begin||'\n本次执行总耗时:'||TIME(CURRENT) - l_tot_begin) 
     
END FUNCTION
#FUN-680008...............begin #将超过20阶的工单打印出来
FUNCTION p6041_out()
  DEFINE l_name      LIKE type_file.chr20   #No.FUN-680096 CHAR(20)
  DEFINE l_i         LIKE type_file.num10   #No.FUN-680096 INTEGER
  DEFINE l_str       STRING
  DEFINE sr RECORD
               sfb01 LIKE sfb_file.sfb01,
               sfb05 LIKE sfb_file.sfb05,
               ima02 LIKE ima_file.ima02,
               ima021 LIKE ima_file.ima021
            END RECORD

   IF g_err.getlength()=0 THEN
      RETURN
   END IF
   CALL cl_wait()
   CALL cl_outnam('abmp6041') RETURNING l_name
   LET l_str=tm.max_level
   LET l_str=l_str.trim()
   LET g_x[1]=g_x[1]," (",l_str,")"
   START REPORT p6041_rep TO l_name

   FOR l_i=1 TO g_err.getlength()
      LET sr.sfb01=g_err[l_i].sfb01
      LET sr.sfb05=g_err[l_i].sfb05
      SELECT ima02,ima021 INTO sr.ima02,sr.ima021 
                          FROM ima_file
                         WHERE ima01=sr.sfb05
      IF SQLCA.sqlcode THEN
         LET sr.ima02=NULL
         LET sr.ima021=NULL
      END IF 
      OUTPUT TO REPORT p6041_rep(sr.*)
   END FOR
   
   FINISH REPORT p6041_rep

   ERROR ""
   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT p6041_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-680096 CHAR(1)
        sr RECORD
              sfb01 LIKE sfb_file.sfb01,
              sfb05 LIKE sfb_file.sfb05,
              ima02 LIKE ima_file.ima02,
              ima021 LIKE ima_file.ima021
           END RECORD

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
   ORDER BY sr.sfb01
   
    FORMAT
        PAGE HEADER
            PRINT 
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.sfb01,
                  COLUMN g_c[32],sr.sfb05,
                  COLUMN g_c[33],sr.ima02,
                  COLUMN g_c[34],sr.ima021

        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

#TQC-C70192
