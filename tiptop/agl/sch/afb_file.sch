/*
================================================================================
檔案代號:afb_file
檔案名稱:会计科目预算单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afb_file
(
afb00       varchar2(5) NOT NULL,    /*帐套编号                               */
afb01       varchar2(10) NOT NULL,   /*预算项目                               */
afb02       varchar2(24) NOT NULL,   /*科目编号                               */
afb03       number(5) NOT NULL,      /*会计年度                               */
afb04       varchar2(30) NOT NULL,   /*WBS编码                                */
afb05       varchar2(1),             /*以何為單位維護之                       */
afb06       varchar2(1),             /*各期预算分配方式                       */
afb07       varchar2(1),             /*凭证录入时预算超限控制方式             */
afb08       varchar2(1),             /*凭证打印时预算超限处理方式             */
afb09       varchar2(1),             /*本预算上期未消耗预算可否递             */
afb10       number(20,6),            /*年度预算                               */
afb11       number(20,6),            /*第一季预算                             */
afb12       number(20,6),            /*第二季预算                             */
afb13       number(20,6),            /*第三季预算                             */
afb14       number(20,6),            /*第四季预算                             */
afb15       varchar2(1),             /*预算种类                               */
afbacti     varchar2(1),             /*资料有效码                             */
afbuser     varchar2(10),            /*资料所有者                             */
afbgrup     varchar2(10),            /*资料所有群                             */
afbmodu     varchar2(10),            /*资料更改者                             */
afbdate     date,                    /*最近更改日                             */
afb16       varchar2(10),            /*核算项类型                             */
                                     /*#FUN-5C0015                            */
afb17       varchar2(10),            /*核算项部门                             */
                                     /*#FUN-5C0015                            */
afb041      varchar2(10) DEFAULT ' ' NOT NULL, /*部门编号*/
afb042      varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
afb18       varchar2(1),             /*是否做总额控制                         */
afb19       varchar2(1),             /*来源预算否                             */
afboriu     varchar2(10),            /*资料建立者                             */
afborig     varchar2(10)             /*资料建立部门                           */
);

alter table afb_file add  constraint afb_pk primary key  (afb00,afb01,afb02,afb03,afb04,afb041,afb042) enable validate;
grant select on afb_file to tiptopgp;
grant update on afb_file to tiptopgp;
grant delete on afb_file to tiptopgp;
grant insert on afb_file to tiptopgp;
grant index on afb_file to public;
grant select on afb_file to ods;
