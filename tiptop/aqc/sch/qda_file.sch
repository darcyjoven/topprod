/*
================================================================================
檔案代號:qda_file
檔案名稱:控制图控制作业因数表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qda_file
(
qda01       number(10) NOT NULL,     /*样本数                                 */
                                     /*樣本數                                 */
qda021      number(5,3),             /*Xbar控制界限因数 A                     */
                                     /*Xbar管制界限因數 A                     */
qda022      number(5,3),             /*Xbar控制界限因数 A1                    */
                                     /*Xbar管制界限因數 A1                    */
qda023      number(5,3),             /*Xbar控制界限因数 A2                    */
                                     /*Xbar管制界限因數 A2                    */
qda031      number(5,3),             /*标准差控制界限因数 b                   */
                                     /*標準差管制界限因數 b                   */
qda032      number(5,3),             /*标准差控制界限因数 B1                  */
                                     /*標準差管制界限因數 B1                  */
qda033      number(5,3),             /*标准差控制界限因数 B2                  */
                                     /*標準差管制界限因數 B2                  */
qda034      number(5,3),             /*标准差控制界限因数 B3                  */
                                     /*標準差管制界限因數 B3                  */
qda035      number(5,3),             /*标准差控制界限因数 B4                  */
                                     /*標準差管制界限因數 B4                  */
qda041      number(5,3),             /*R控制界限因数 d2                       */
                                     /*R管制界限因數 d2                       */
qda042      number(5,3),             /*R控制界限因数 d3                       */
                                     /*R管制界限因數 d3                       */
qda043      number(5,3),             /*R控制界限因数 D1                       */
                                     /*R管制界限因數 D1                       */
qda044      number(5,3),             /*R控制界限因数 D2                       */
                                     /*R管制界限因數 D2                       */
qda045      number(5,3),             /*R控制界限因数 D3                       */
                                     /*R管制界限因數 D3                       */
qda046      number(5,3)              /*R控制界限因数 D4                       */
                                     /*R管制界限因數 D4                       */
);

alter table qda_file add  constraint qda_pk primary key  (qda01) enable validate;
grant select on qda_file to tiptopgp;
grant update on qda_file to tiptopgp;
grant delete on qda_file to tiptopgp;
grant insert on qda_file to tiptopgp;
grant index on qda_file to public;
grant select on qda_file to ods;
