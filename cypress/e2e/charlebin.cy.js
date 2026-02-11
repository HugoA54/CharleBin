describe('Scenario nominal PrivateBin', () => {
  it('Test création et lecture', () => {
    const msg = "test " + Date.now();
    const mdp = "123456";

    cy.visit('http://localhost:8080');

    cy.get('#message').type(msg);
    cy.get('#passwordinput:visible').type(mdp);
    
    cy.get('#burnafterreading').uncheck({ force: true });

    cy.get('#sendbutton').click();
    
    cy.url().should('include', '?');

    cy.url().then((url) => {
      cy.visit(url);

      cy.get('#passworddecrypt').type(mdp, { force: true });
      cy.get('#passworddecrypt').type('{enter}', { force: true });

      cy.contains(msg).should('be.visible');
    });
  });
});