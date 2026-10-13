/*
================================================================================
檔案代號:cei_file
檔案名稱:料件归并关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cei_file
(
cei01       varchar2(1) DEFAULT ' ' NOT NULL, /*料件类型*/
cei02       number(5) DEFAULT '0' NOT NULL, /*流水号*/
cei03       varchar2(40),            /*厂内料号                               */
cei04       varchar2(40),            /*海关商品编号                           */
cei05       varchar2(4),             /*币种                                   */
cei06       number(20,6),            /*归并前单价                             */
cei07       varchar2(4),             /*企业使用单位                           */
cei08       varchar2(4),             /*申报计量单位                           */
cei09       varchar2(4),             /*法定计量单位                           */
cei10       number(15,6),            /*法定计量单位转换比率                   */
cei11       varchar2(10),            /*归并后序号                             */
cei12       varchar2(120),           /*归并后品名                             */
cei13       varchar2(120),           /*归并后规格                             */
cei14       number(20,6),            /*归并后单价                             */
cei15       varchar2(1),             /*确认状态                               */
cei16       varchar2(20),            /*合同申请单号                           */
cei17       varchar2(4),             /*第二法定单位                           */
cei18       number(15,6),            /*第二法定单位转换率                     */
cei19       number(15,6),            /*申报单位转换率                         */
cei20       varchar2(40),            /*归并后货号                             */
cei21       varchar2(255),           /*备注说明                               */
cei22       varchar2(4),             /*归并后币种                             */
ceiacti     varchar2(1),             /*资料有效码                             */
ceidate     date,                    /*最近更改日                             */
ceigrup     varchar2(10),            /*资料所有部门                           */
ceimodu     varchar2(10),            /*资料更改者                             */
ceiuser     varchar2(10),            /*资料所有者                             */
ceiorig     varchar2(10),            /*资料建立部门                           */
ceioriu     varchar2(10)             /*资料建立者                             */
);

create        index cei_01 on cei_file (cei02,cei03);
alter table cei_file add  constraint cei_pk primary key  (cei01,cei02) enable validate;
grant select on cei_file to tiptopgp;
grant update on cei_file to tiptopgp;
grant delete on cei_file to tiptopgp;
grant insert on cei_file to tiptopgp;
grant index on cei_file to public;
grant select on cei_file to ods;
