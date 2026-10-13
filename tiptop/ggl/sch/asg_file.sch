/*
================================================================================
檔案代號:asg_file
檔案名稱:合并报表公司基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asg_file
(
asg01       varchar2(10) DEFAULT ' ' NOT NULL, /*公司代码*/
asg02       varchar2(80),            /*名称                                   */
asg03       varchar2(20),            /*来源营运中心                           */
asg04       varchar2(1) DEFAULT 'Y' NOT NULL, /*使用TIPTOP否*/
asg05       varchar2(5),             /*帐别                                   */
asg06       varchar2(4),             /*记账币种                               */
asg07       varchar2(4),             /*功能币种                               */
asg08       varchar2(10),            /*关系人编号                             */
asg09       varchar2(6),             /*上市(柜)公司代号                       */
asgacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
asgconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
asgdate     date,                    /*最近更改日                             */
asggrup     varchar2(10),            /*资料所有群                             */
asgmodu     varchar2(10),            /*资料更改者                             */
asgorig     varchar2(10),            /*资料建立部门                           */
asgoriu     varchar2(10),            /*资料建立者                             */
asgpost     varchar2(1) DEFAULT ' ' NOT NULL, /*过帐码*/
asguser     varchar2(10)             /*资料所有者                             */
);

alter table asg_file add  constraint asg_pk primary key  (asg01) enable validate;
grant select on asg_file to tiptopgp;
grant update on asg_file to tiptopgp;
grant delete on asg_file to tiptopgp;
grant insert on asg_file to tiptopgp;
grant index on asg_file to public;
grant select on asg_file to ods;
