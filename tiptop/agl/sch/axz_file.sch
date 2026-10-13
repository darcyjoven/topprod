/*
================================================================================
檔案代號:axz_file
檔案名稱:合并报表公司基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axz_file
(
axz01       varchar2(10) NOT NULL,   /*公司编号                               */
axz02       varchar2(80),            /*名称                                   */
axz03       varchar2(20),            /*来源营运中心                           */
axz04       varchar2(1),             /*使用tiptop否(y/n)                      */
axz05       varchar2(5),             /*帐套                                   */
axz06       varchar2(4),             /*记帐币种                               */
axz07       varchar2(4),             /*功能币种                               */
axz08       varchar2(10),            /*关系人编号                             */
axzconf     varchar2(1),             /*审核否                                 */
axzpost     varchar2(1),             /*更新否                                 */
axzacti     varchar2(1),             /*有效否                                 */
axzuser     varchar2(10),            /*资料所有者                             */
axzgrup     varchar2(10),            /*资料所有群                             */
axzmodu     varchar2(10),            /*资料更改者                             */
axzdate     date,                    /*最近更改日                             */
axzorig     varchar2(10),            /*资料建立部门                           */
axzoriu     varchar2(10),            /*资料建立者                             */
axz09       varchar2(6),             /*上市(柜)公司代号                       */
axz10       varchar2(1) DEFAULT 'N' NOT NULL /*部门管理*/
);

alter table axz_file add  constraint axz_pk primary key  (axz01) enable validate;
grant select on axz_file to tiptopgp;
grant update on axz_file to tiptopgp;
grant delete on axz_file to tiptopgp;
grant insert on axz_file to tiptopgp;
grant index on axz_file to public;
grant select on axz_file to ods;
