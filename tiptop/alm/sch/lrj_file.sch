/*
================================================================================
檔案代號:lrj_file
檔案名稱:换券单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrj_file
(
lrj00       varchar2(10),            /*制订营运中心                           */
lrj01       varchar2(20) DEFAULT ' ' NOT NULL, /*换券单编号*/
lrj02       varchar2(30),            /*卡号                                   */
lrj03       varchar2(20),            /*卡种编号                               */
lrj04       varchar2(20),            /*会员编号                               */
lrj05       varchar2(20),            /*方案编号                               */
lrj06       number(20) DEFAULT '0' NOT NULL, /*可兑换积分*/
lrj07       number(20) DEFAULT '0' NOT NULL, /*兑换积分*/
lrj08       number(20) DEFAULT '0' NOT NULL, /*返券金额*/
lrj09       number(20) DEFAULT '0' NOT NULL, /*剩余积分*/
lrj10       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lrj11       varchar2(10),            /*审核人                                 */
lrj12       date,                    /*审核日期                               */
lrjacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrjcrat     date,                    /*资料创建日                             */
lrjdate     date,                    /*最近更改日                             */
lrjgrup     varchar2(10),            /*资料所有群                             */
lrjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrjmodu     varchar2(10),            /*资料更改者                             */
lrjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrjuser     varchar2(10),            /*资料所有者                             */
lrjoriu     varchar2(10),            /*资料建立者                             */
lrjorig     varchar2(10),            /*资料建立部门                           */
lrj13       number(20) DEFAULT '0' NOT NULL, /*实发券金额*/
lrj14       varchar2(1) DEFAULT '0' NOT NULL, /*兑换来源*/
                                     /*0.积分换券, 1.累计消费额换券           */
lrj15       number(20,6) DEFAULT '0' NOT NULL, /*累计消费额*/
lrj16       varchar2(20),            /*销售/杂发单号                          */
lrj17       number(5) DEFAULT '0' NOT NULL
);

alter table lrj_file add  constraint lrj_pk primary key  (lrj01) enable validate;
grant select on lrj_file to tiptopgp;
grant update on lrj_file to tiptopgp;
grant delete on lrj_file to tiptopgp;
grant insert on lrj_file to tiptopgp;
grant index on lrj_file to public;
grant select on lrj_file to ods;
