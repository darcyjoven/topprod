/*
================================================================================
檔案代號:cnd_file
檔案名稱:ACO-开账资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cnd_file
(
cnd01       varchar2(40) NOT NULL,   /*商品编号                               */
cnd02       varchar2(20) NOT NULL,   /*手册编号                               */
cnd03       number(5) NOT NULL,      /*开帐年份                               */
cnd04       number(5) NOT NULL,      /*开帐月份                               */
cnd05       varchar2(1) NOT NULL,    /*用途                                   */
cnd06       varchar2(1) NOT NULL,    /*类型                                   */
cnd07       varchar2(10) NOT NULL,   /*客户/供应商编号                        */
cnd08       varchar2(4),             /*合同单位                               */
cnd09       number(15,3),            /*数量                                   */
cnd10       number(15,3),            /*已结转未交货                           */
cnd11       number(15,3),            /*未结转已交货                           */
cnd12       number(15,3),            /*已结转未收货                           */
cnd13       number(15,3),            /*未结转已收货                           */
cndconf     varchar2(1),             /*审核否                                 */
cndacti     varchar2(1),             /*资料有效码                             */
cnduser     varchar2(10),            /*资料所有者                             */
cndgrup     varchar2(10),            /*资料所有部门                           */
cndmodu     varchar2(10),            /*资料更改者                             */
cnddate     date,                    /*最近更改日                             */
cndplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cndlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cndoriu     varchar2(10),            /*资料建立者                             */
cndorig     varchar2(10)             /*资料建立部门                           */
);

alter table cnd_file add  constraint cnd_pk primary key  (cnd01,cnd02,cnd03,cnd04,cnd05,cnd06,cnd07) enable validate;
grant select on cnd_file to tiptopgp;
grant update on cnd_file to tiptopgp;
grant delete on cnd_file to tiptopgp;
grant insert on cnd_file to tiptopgp;
grant index on cnd_file to public;
grant select on cnd_file to ods;
