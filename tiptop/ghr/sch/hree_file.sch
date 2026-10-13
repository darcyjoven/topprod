/*
================================================================================
檔案代號:hree_file
檔案名稱:薪资科目同会计科目关联表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hree_file
(
hree01      varchar2(20) NOT NULL,   /*成本中心编码                           */
hree02      varchar2(20) NOT NULL,   /*薪资计算项                             */
hree03      varchar2(20) NOT NULL,   /*会计科目                               */
hree04      varchar2(1),             /*借贷别                                 */
hreeacti    varchar2(1),             /*资料有效码                             */
hreeuser    varchar2(20),            /*资料所有者                             */
hreegrup    varchar2(20),            /*资料所有部门                           */
hreeoriu    varchar2(20),            /*资料建立者                             */
hreeorig    varchar2(20),            /*资料建立部门                           */
hreemodu    varchar2(20),            /*资料修改者                             */
hreedate    date,                    /*最近修改日                             */
hreeud01    varchar2(255),
hreeud02    varchar2(40),
hreeud03    varchar2(40),
hreeud04    varchar2(40),
hreeud05    varchar2(20),
hreeud06    varchar2(20),
hreeud07    number(15,3),
hreeud08    number(15,3),
hreeud09    number(15,3),
hreeud10    number(5),
hreeud11    number(5),
hreeud12    number(5),
hreeud13    date,
hreeud14    date,
hreeud15    date
);

alter table hree_file add  constraint hree_pk primary key  (hree01,hree02,hree03) enable validate;
grant select on hree_file to tiptopgp;
grant update on hree_file to tiptopgp;
grant delete on hree_file to tiptopgp;
grant insert on hree_file to tiptopgp;
grant index on hree_file to public;
grant select on hree_file to ods;
