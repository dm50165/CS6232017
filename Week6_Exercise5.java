
public class Week6 {
	/**Exercise 5:
     What are the properties of the BCNF decomposition algorithm?
     Apply the decomposition algorithm on Stock.**/

	/**A = ‘prod_id’; B = ‘dep_id’; C = ‘pname’; D = ‘quantity’

			R = {A, B, C, D};
			S = R //Intialization S
	        T = {AB->CD, A->C};

			While S has a relation T that is not in BCNF do:
			   Pick a FD : A->C that holds in T and violates BCNF //pick FD: A->C which violates BCNF
			   Add the relation AC to S
			   Update T = T - C
			Return S**/
	        //return S as all relations are in BCNF
			// thus R is decomposed into set of relations:R1 = {A,C}; R2 = {A,B,D};
}
