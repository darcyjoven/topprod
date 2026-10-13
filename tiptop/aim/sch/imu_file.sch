/*
================================================================================
檔案代號:imu_file
檔案名稱:品名种类档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imu_file
(
imu01       varchar2(4) NOT NULL,    /*品名种类编号                           */
                                     /*品名種類編號                           */
imu02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
imu11       number(5),               /*第一段位数                             */
                                     /*第一段位數                             */
imu12       varchar2(10),            /*第一段细部品名码                       */
                                     /*第一段細部品名碼(空白表示隨機輸入)     */
imu21       number(5),               /*第二段位数                             */
                                     /*第二段位數                             */
imu22       varchar2(10),            /*第二段细部品名码                       */
                                     /*第二段細部品名碼(空白表示隨機輸入)     */
imu31       number(5),               /*第三段位数                             */
                                     /*第三段位數                             */
imu32       varchar2(10),            /*第三段细部品名码                       */
                                     /*第三段細部品名碼(空白表示隨機輸入)     */
imu41       number(5),               /*第四段位数                             */
                                     /*第四段位數                             */
imu42       varchar2(10),            /*第四段细部品名码                       */
                                     /*第四段細部品名碼(空白表示隨機輸入)     */
imu51       number(5),               /*第五段位数                             */
                                     /*第五段位數                             */
imu52       varchar2(10),            /*第五段细部品名码                       */
                                     /*第五段細部品名碼(空白表示隨機輸入)     */
imu61       number(5),               /*第六段位数                             */
                                     /*第六段位數                             */
imu62       varchar2(10),            /*第六段细部品名码                       */
                                     /*第六段細部品名碼(空白表示隨機輸入)     */
imuacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
imuuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
imugrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
imumodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
imudate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
imuoriu     varchar2(10),            /*资料建立者                             */
imuorig     varchar2(10)             /*资料建立部门                           */
);

alter table imu_file add  constraint imu_pk primary key  (imu01) enable validate;
grant select on imu_file to tiptopgp;
grant update on imu_file to tiptopgp;
grant delete on imu_file to tiptopgp;
grant insert on imu_file to tiptopgp;
grant index on imu_file to public;
grant select on imu_file to ods;
