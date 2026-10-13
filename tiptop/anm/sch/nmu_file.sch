/*
================================================================================
檔案代號:nmu_file
檔案名稱:银行对账交易明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table nmu_file
(
nmu01       date NOT NULL,           /*交易日期                               */
nmu02       varchar2(8),             /*交易时间                               */
nmu03       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
nmu04       varchar2(20),            /*开户银行编号                           */
nmu05       varchar2(30),            /*银行帐号                               */
nmu06       varchar2(30),            /*对方帐号                               */
nmu07       varchar2(30),            /*母/子公司帐号                          */
nmu08       varchar2(4),             /*币种                                   */
nmu09       number(5),               /*收付别                                 */
                                     /*收付別：                               */
                                     /*1  為收方                              */
                                     /*-1 為付方                              */
                                     /*0  為其它                              */
nmu10       number(20,6),            /*交易金额                               */
nmu11       number(20,6),            /*余额                                   */
nmu12       varchar2(255),           /*业务摘要                               */
nmu13       varchar2(80) NOT NULL,   /*用途                                   */
nmu14       varchar2(30),            /*业务参考号                             */
nmu15       varchar2(8),             /*交易类型                               */
nmu16       varchar2(10) NOT NULL,   /*业务流水号                             */
nmu17       varchar2(20) DEFAULT ' ' NOT NULL, /*付方分行代码*/
nmu18       varchar2(20) DEFAULT ' ' NOT NULL, /*接口银行编号*/
nmu19       varchar2(80),            /*对方帐号名称                           */
nmu20       varchar2(80),            /*对方开户行名称                         */
nmu21       varchar2(80),            /*母/子公司户名                          */
nmu22       varchar2(1),             /*信息标志                               */
nmulegal    varchar2(10) NOT NULL,   /*所属法人                               */
nmu23       varchar2(20) DEFAULT ' ' NOT NULL, /*流水号*/
nmu24       varchar2(1),             /*对账码 Y.已对账 N.未对帐               */
nmuud01     varchar2(255),           /*自订字段-Textedit                      */
nmuud02     varchar2(40),            /*自订字段-文字                          */
nmuud03     varchar2(40),            /*自订字段-文字                          */
nmuud04     varchar2(40),            /*自订字段-文字                          */
nmuud05     varchar2(40),            /*自订字段-文字                          */
nmuud06     varchar2(40),            /*自订字段-文字                          */
nmuud07     number(15,3),            /*自订字段-数值                          */
nmuud08     number(15,3),            /*自订字段-数值                          */
nmuud09     number(15,3),            /*自订字段-数值                          */
nmuud10     number(10),              /*自订字段-整数                          */
nmuud11     number(10),              /*自订字段-整数                          */
nmuud12     number(10),              /*自订字段-整数                          */
nmuud13     date,                    /*自订字段-日期                          */
nmuud14     date,                    /*自订字段-日期                          */
nmuud15     date                     /*自订字段-日期                          */
);

alter table nmu_file add  constraint nmu_pk primary key  (nmu18,nmu17,nmu01,nmu03,nmu16,nmu13,nmu23) enable validate;
grant select on nmu_file to tiptopgp;
grant update on nmu_file to tiptopgp;
grant delete on nmu_file to tiptopgp;
grant insert on nmu_file to tiptopgp;
grant index on nmu_file to public;
grant select on nmu_file to ods;
