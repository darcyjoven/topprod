/*
================================================================================
檔案代號:vam_file
檔案名稱:aps品項途程
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vam_file
(
vam01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vam02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vam03       number(9),               /*工艺路线序号                           */
vam04       number(18,8),            /*理想周期时间因子                       */
vam05       date,                    /*生效日                                 */
vam06       date,                    /*失效日                                 */
vam07       number(1),               /*是否为替代工艺路线                     */
vam08       varchar2(60),            /*APS保留字段文字                        */
vam09       varchar2(60),            /*APS保留字段文字                        */
vam10       varchar2(60),            /*APS保留字段文字                        */
vam11       number(9),               /*APS保留字段数值                        */
vam12       number(18,8),            /*APS保留字段浮点数                      */
vam13       number(18,8),            /*APS保留字段浮点数                      */
vam14       date,                    /*APS保留字段日期                        */
vam15       date,                    /*APS保留字段日期                        */
vamlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vamplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
vam16       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
vam17       varchar2(10)             /*下工艺段号                             */
);

alter table vam_file add  constraint vam_pk primary key  (vamlegal,vamplant,vam01,vam02) enable validate;
grant select on vam_file to tiptopgp;
grant update on vam_file to tiptopgp;
grant delete on vam_file to tiptopgp;
grant insert on vam_file to tiptopgp;
grant index on vam_file to public;
grant select on vam_file to ods;
